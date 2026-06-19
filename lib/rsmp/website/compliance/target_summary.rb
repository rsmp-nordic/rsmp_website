# frozen_string_literal: true

require 'time'
require_relative 'target_versions'

module RSMP
  module Website
    module Compliance
      # Merges previous target state with newly observed runs.
      class TargetSummary
        SECONDS_PER_DAY = 24 * 60 * 60

        def initialize(target:, previous:, runs:, now: Time.now.utc)
          @target = target
          @previous = previous
          @runs = runs
          @now = now
        end

        def to_h
          @target.merge(
            'latest_run' => latest_run,
            'latest_passing_run' => latest_passing_run,
            'best_run' => best_run,
            'last_30_days' => last_month_stats,
            'passed_versions' => passed_versions,
            'versions' => versions,
            'core_versions' => core_versions,
            'sxl_versions' => sxl_versions,
            'recent_runs' => recent_runs
          )
        end

        private

        def latest_run
          compact_run(latest_record([@previous['latest_run'], *@runs]))
        end

        def latest_passing_run
          compact_run(latest_passing_run_record)
        end

        def new_passing_runs
          @runs.select { |run| run['status'] == 'passed' }
        end

        def best_run
          compact_run(latest_passing_run_record || best_partial_run([@previous['best_run'], *@runs].compact))
        end

        def latest_passing_run_record
          @latest_passing_run_record ||= latest_record([@previous['latest_passing_run'], *new_passing_runs])
        end

        def recent_runs
          @recent_runs ||= sort_runs(recent_run_values.select { |run| within_last_month?(run['completed_at']) })
        end

        def recent_run_values
          merged = Array(@previous['recent_runs']).to_h { |run| [run_key(run), run] }
          @runs.each { |run| merged[run_key(run)] = compact_run(run) }
          merged.values
        end

        def compact_run(run)
          return nil unless run

          compact = run.slice('target_id', 'run_id', 'run_attempt', 'run_url', 'event', 'completed_at', 'status',
                              'passed_cells', 'total_cells')
          version_summary = run_version_summary(run)
          compact['version_summary'] = version_summary if version_summary
          compact
        end

        def versions
          @versions ||= TargetVersions.new(previous: @previous['versions'], runs: @runs).to_a.map do |version|
            version.merge('last_30_days' => version_last_month_stats(version))
          end
        end

        def passed_versions
          versions.select { |version| version['latest_passing_run'] }.map { |version| version.slice('core', 'sxls') }
        end

        def core_versions
          @core_versions ||= begin
            merged = Array(@previous['core_versions']).to_h { |core| [core['core'].to_s, core] }
            versions.each { |version| merge_core_version(merged, version) }
            @runs.each { |run| merge_run_core_versions(merged, run) }
            merged.values.map { |core| core.merge('last_30_days' => core_last_month_stats(core)) }
                  .sort_by { |core| version_sort_key(core['core']) }
                  .reverse
          end
        end

        def sxl_versions
          @sxl_versions ||= begin
            merged = Array(@previous['sxl_versions']).to_h { |sxl| [sxl_key(sxl), sxl] }
            versions.each { |version| merge_sxl_versions(merged, version) }
            @runs.each { |run| merge_run_sxl_versions(merged, run) }
            merged.values.map { |sxl| sxl.merge('last_30_days' => sxl_last_month_stats(sxl)) }
                  .sort_by { |sxl| [sxl['name'].to_s, version_sort_key(sxl['version'])] }
                  .reverse
          end
        end

        def last_month_stats
          total = recent_runs.sum { |run| run['total_cells'].to_i }
          passed = recent_runs.sum { |run| run['passed_cells'].to_i }
          { 'passed_cells' => passed, 'total_cells' => total, 'pass_percentage' => pass_percentage(passed, total) }
        end

        def version_last_month_stats(version)
          cells = recent_full_runs.flat_map { |run| Array(run['cells']) }.select { |cell| version_cell?(version, cell) }
          total = cells.size
          passed = cells.count { |cell| cell['status'] == 'passed' }
          { 'passed_runs' => passed, 'total_runs' => total, 'pass_percentage' => pass_percentage(passed, total) }
        end

        def core_last_month_stats(core)
          cells = recent_full_runs.flat_map { |run| Array(run['cells']) }.select { |cell| core_cell?(core, cell) }
          total = cells.size
          passed = cells.count { |cell| cell['status'] == 'passed' }
          { 'passed_runs' => passed, 'total_runs' => total, 'pass_percentage' => pass_percentage(passed, total) }
        end

        def sxl_last_month_stats(sxl)
          cells = recent_full_runs.flat_map { |run| Array(run['cells']) }.select { |cell| sxl_cell?(sxl, cell) }
          total = cells.size
          passed = cells.count { |cell| cell['status'] == 'passed' }
          { 'passed_runs' => passed, 'total_runs' => total, 'pass_percentage' => pass_percentage(passed, total) }
        end

        def recent_full_runs
          @recent_full_runs ||= @runs.select { |run| within_last_month?(run['completed_at']) }
        end

        def version_cell?(version, cell)
          version['core'] == cell['core'] && normalize_sxls(version['sxls']) == normalize_sxls(cell['sxls'])
        end

        def core_cell?(core, cell)
          core['core'].to_s == cell['core'].to_s
        end

        def sxl_cell?(sxl, cell)
          normalize_sxls(cell['sxls'])[sxl['name'].to_s] == sxl['version'].to_s
        end

        def merge_core_version(merged, version)
          core = version['core'].to_s
          return if core.empty?

          merged[core] = merge_axis_version(merged[core], { 'core' => core }, version)
        end

        def merge_run_core_versions(merged, run)
          Array(run['cells']).group_by { |cell| cell['core'].to_s }.each do |core, cells|
            next if core.empty?

            merged[core] = merge_axis_run(merged[core], { 'core' => core }, run, cells)
          end
        end

        def merge_sxl_versions(merged, version)
          normalize_sxls(version['sxls']).each do |name, value|
            key = [name, value]
            merged[key] = merge_axis_version(merged[key], { 'name' => name, 'version' => value }, version)
          end
        end

        def merge_run_sxl_versions(merged, run)
          sxl_cells(run).each do |key, cells|
            name, version = key
            merged[key] = merge_axis_run(merged[key], { 'name' => name, 'version' => version }, run, cells)
          end
        end

        def sxl_cells(run)
          Array(run['cells']).each_with_object({}) do |cell, grouped|
            normalize_sxls(cell['sxls']).each do |name, version|
              key = [name, version]
              grouped[key] ||= []
              grouped[key] << cell
            end
          end
        end

        def merge_axis_version(previous, fields, version)
          latest = latest_record([previous&.fetch('latest_run', nil), version['latest_run']])
          latest_pass = latest_record([previous&.fetch('latest_passing_run', nil), version['latest_passing_run']])
          axis_version(fields, latest, latest_pass)
        end

        def merge_axis_run(previous, fields, run, cells)
          latest = cell_group_run_summary(run, cells)
          previous_pass = previous&.fetch('latest_passing_run', nil)
          latest_pass = if latest['status'] == 'passed'
                          latest
                        elsif same_run?(previous_pass, latest)
                          nil
                        else
                          previous_pass
                        end
          latest = latest_record([previous&.fetch('latest_run', nil), latest])
          axis_version(fields, latest, latest_pass)
        end

        def same_run?(left, right)
          return false unless left && right

          left['run_id'] == right['run_id'] && left['run_attempt'] == right['run_attempt']
        end

        def axis_version(fields, latest, latest_pass)
          fields.merge(
            'last_status' => latest&.fetch('status', nil),
            'latest_run' => latest,
            'latest_passing_run' => latest_pass
          )
        end

        def cell_group_run_summary(run, cells)
          run.slice('run_id', 'run_attempt', 'run_url', 'event', 'completed_at').merge(
            'status' => cells.all? { |cell| cell['status'] == 'passed' } ? 'passed' : 'failed',
            'test_count' => cells.sum { |cell| cell['test_count'].to_i },
            'failed_count' => cells.sum { |cell| cell['failed_count'].to_i },
            'errored_count' => cells.sum { |cell| cell['errored_count'].to_i }
          )
        end

        def sxl_key(sxl)
          [sxl['name'].to_s, sxl['version'].to_s]
        end

        def version_sort_key(version)
          version.to_s.split('.').map { |part| part.to_i }
        end

        def normalize_sxls(sxls)
          sxls.to_h.transform_keys(&:to_s).transform_values(&:to_s).sort.to_h
        end

        def run_version_summary(run)
          return run['version_summary'] if run['version_summary']

          cells = Array(run['cells'])
          return nil if cells.empty?

          { 'core' => version_counts(cells), 'sxls' => sxl_version_counts(cells) }
        end

        def version_counts(cells)
          statuses = cells.each_with_object({}) do |cell, versions|
            version = cell['core'].to_s
            next if version.empty?

            versions[version] = version_passed?(versions[version], cell)
          end
          version_count_summary(statuses)
        end

        def sxl_version_counts(cells)
          statuses = cells.each_with_object({}) do |cell, sxls|
            normalize_sxls(cell['sxls']).each do |name, version|
              sxls[name] ||= {}
              sxls[name][version] = version_passed?(sxls[name][version], cell)
            end
          end
          statuses.sort.map do |name, versions|
            { 'name' => name }.merge(version_count_summary(versions))
          end
        end

        def version_passed?(previous, cell)
          status = cell['status'] == 'passed'
          previous.nil? ? status : previous && status
        end

        def version_count_summary(statuses)
          total = statuses.size
          passed = statuses.count { |_version, status| status }
          { 'passed_versions' => passed, 'total_versions' => total }
        end

        def pass_percentage(passed, total)
          return nil unless total.positive?

          ((passed.to_f / total) * 100).round(1)
        end

        def latest_record(records)
          records.compact.each_with_index.max_by do |record, index|
            [record['completed_at'] || '', record['run_attempt'].to_i, index]
          end&.first
        end

        def best_partial_run(runs)
          runs.max_by { |run| [pass_ratio(run), run['completed_at'] || ''] }
        end

        def pass_ratio(run)
          total = run['total_cells'].to_i
          total.positive? ? run['passed_cells'].to_f / total : 0.0
        end

        def sort_runs(runs)
          runs.sort_by { |run| [run['completed_at'] || '', run['run_attempt'].to_i] }.reverse
        end

        def within_last_month?(time)
          parsed = parse_time(time)
          parsed && parsed >= @now - (30 * SECONDS_PER_DAY)
        end

        def run_key(run)
          [run['run_id'], run['run_attempt']]
        end

        def parse_time(value)
          return nil unless value

          Time.parse(value).utc
        rescue ArgumentError
          nil
        end
      end
    end
  end
end
