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
            [version_key(normalized), normalized]
          end
          @runs.each { |run| merge_run_versions(merged, run) }
          merged
        end

        def merge_run_versions(merged, run)
          run.fetch('cells', []).each do |cell|
            key = version_key(cell)
            merged[key] = merge_version(merged[key], run, cell)
          end
        end

        def merge_version(previous, run, cell)
          latest = cell_run_summary(run, cell)
          version_fields(cell).merge(
            'last_status' => latest['status'],
            'latest_run' => latest,
            'latest_passing_run' => latest_passing_run(previous, latest)
          )
        end

        def latest_passing_run(previous, latest)
          latest['status'] == 'passed' ? latest : previous&.fetch('latest_passing_run', nil)
        end

        def version_fields(cell)
          fields = { 'core' => cell['core'] }
          sxls = normalize_sxls(cell['sxls'])
          fields['sxls'] = sxls unless sxls.empty?
          fields
        end

        def cell_run_summary(run, cell)
          run.slice('run_id', 'run_attempt', 'run_url', 'event', 'completed_at').merge(
            cell.slice('status', 'test_count', 'failed_count', 'errored_count', 'log_artifact', 'report_artifact')
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
