# frozen_string_literal: true

module RSMP
  module Website
    module Compliance
      # Merges accumulated per-version state with newly observed run cells.
      class TargetVersions
        def initialize(previous:, runs:)
          @previous = previous
          @runs = runs
        end

        def to_a
          merged_versions.values.sort_by { |version| [version['core'].to_s, sxls_sort_value(version)] }.reverse
        end

        private

        def merged_versions
          merged = Array(@previous).to_h do |version|
            normalized = normalize_version(version)
            # Rebuild records represented by stored runs, including timestamps
            # previously inherited from the whole workflow.
            %w[latest_run latest_passing_run].each do |field|
              record = normalized[field]
              key = [record&.values_at('run_id', 'run_attempt'), version_key(normalized)]
              normalized[field] = nil if record&.fetch('status', nil) == 'missing' || observed_records.key?(key)
            end
            [version_key(normalized), normalized]
          end
          @runs.each { |run| merge_run_versions(merged, run) }
          merged.each_value do |version|
            version['latest_run'] ||= version['latest_passing_run']
            version['last_status'] = version.dig('latest_run', 'status')
          end
          merged.reject! { |_key, version| version['latest_run'].nil? }
          merged
        end

        def merge_run_versions(merged, run)
          run.fetch('cells', []).each do |cell|
            next if cell['status'] == 'missing'

            key = version_key(cell)
            merged[key] = merge_version(merged[key], run, cell)
          end
        end

        def observed_records
          @observed_records ||= @runs.each_with_object({}) do |run, records|
            Array(run['cells']).each do |cell|
              records[[run.values_at('run_id', 'run_attempt'), version_key(cell)]] = true
            end
          end
        end

        def merge_version(previous, run, cell)
          candidate = cell_run_summary(run, cell)
          latest = latest_record([previous&.fetch('latest_run', nil), candidate])
          version_fields(cell).merge(
            'last_status' => latest['status'],
            'latest_run' => latest,
            'latest_passing_run' => latest_passing_run(previous, candidate)
          )
        end

        def latest_passing_run(previous, candidate)
          latest_record([
            previous&.fetch('latest_passing_run', nil),
            candidate['status'] == 'passed' ? candidate : nil
          ])
        end

        def latest_record(records)
          records.compact.each_with_index.max_by do |record, index|
            [record['completed_at'] || '', record['run_attempt'].to_i, index]
          end&.first
        end

        def version_fields(cell)
          fields = { 'core' => cell['core'] }
          sxls = normalize_sxls(cell['sxls'])
          fields['sxls'] = sxls unless sxls.empty?
          fields
        end

        def cell_run_summary(run, cell)
          run.slice('run_id', 'run_attempt', 'run_url', 'event', 'completed_at').merge(
            cell.slice('completed_at', 'status', 'test_count', 'passed_count', 'skipped_count',
                       'failed_count', 'errored_count', 'log_artifact', 'report_artifact').compact
          )
        end

        def version_key(version)
          [version['core'], sxls_sort_value(version)]
        end

        def normalize_version(version)
          version.merge('sxls' => normalize_sxls(version['sxls']))
        end

        def sxls_sort_value(version)
          normalize_sxls(version['sxls']).map { |name, value| "#{name}:#{value}" }.join(',')
        end

        def normalize_sxls(sxls)
          sxls.to_h.transform_keys(&:to_s).transform_values(&:to_s).sort.to_h
        end
      end
    end
  end
end
