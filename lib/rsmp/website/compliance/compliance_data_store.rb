# frozen_string_literal: true

require 'fileutils'
require 'json'

module RSMP
  module Website
    module Compliance
      # Reads and writes the generated compliance data branch contents.
      class ComplianceDataStore
        def initialize(data_dir)
          @data_dir = data_dir
        end

        def read_summary
          return empty_summary unless File.exist?(summary_path)

          JSON.parse(File.read(summary_path))
        rescue JSON::ParserError
          empty_summary
        end

        def read_runs_by_target
          Dir[File.join(runs_path, '*', '*.json')].each_with_object({}) do |path, runs|
            run = read_json(path)
            next unless run

            target_id = File.basename(File.dirname(path))
            runs[target_id] ||= []
            runs[target_id] << run
          end
        end

        def write_summary(summary)
          ensure_dirs
          File.write(summary_path, pretty_json(summary))
        end

        def write_run(target_id, run)
          FileUtils.mkdir_p(run_target_dir(target_id))
          File.write(run_path(target_id, run), pretty_json(run))
        end

        private

        def empty_summary
          { 'generated_at' => nil, 'targets' => [] }
        end

        def read_json(path)
          JSON.parse(File.read(path))
        rescue JSON::ParserError
          nil
        end

        def pretty_json(data)
          "#{JSON.pretty_generate(data)}\n"
        end

        def ensure_dirs
          FileUtils.mkdir_p(runs_path)
        end

        def summary_path
          File.join(@data_dir, 'summary.json')
        end

        def runs_path
          File.join(@data_dir, 'runs')
        end

        def run_target_dir(target_id)
          File.join(@data_dir, 'runs', target_id.to_s)
        end

        def run_path(target_id, run)
          File.join(run_target_dir(target_id), "#{run.fetch('run_id')}-#{run.fetch('run_attempt')}.json")
        end
      end
    end
  end
end
