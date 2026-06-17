# frozen_string_literal: true

require 'json'
require 'net/http'
require 'tmpdir'
require 'time'
require 'uri'

module RSMP
  module Website
    module Compliance
      # Reads completed workflow runs and compliance artifacts from GitHub Actions.
      class GitHubClient
        DEFAULT_EVENTS = %w[schedule].freeze

        def initialize(repo:, token:, events: DEFAULT_EVENTS)
          @repo = repo
          @token = token
          @events = events
        end

        def reports_since(since:)
          workflows.flat_map { |workflow| reports_for_workflow(workflow, since: since) }
        end

        private

        def workflows
          response = get_json("/repos/#{@repo}/actions/workflows", 'per_page' => '100')
          Array(response['workflows']).select { |workflow| workflow['state'] == 'active' }
        end

        def reports_for_workflow(workflow, since:)
          @events.flat_map { |event| workflow_runs(workflow.fetch('id'), event: event, since: since) }
                 .flat_map { |run| reports_for_run(run.fetch('id'), workflow) }
        end

        def reports_for_run(run_id, workflow = nil)
          report_artifacts(run_id).flat_map { |artifact| download_report_artifact(artifact) }
                                  .map { |report| enrich_workflow_metadata(report, workflow) }
        end

        def enrich_workflow_metadata(report, workflow)
          return report unless workflow

          report['workflow'] ||= {}
          report['workflow']['name'] ||= workflow['name']
          report['workflow']['file'] ||= File.basename(workflow['path'].to_s)
          report
        end

        def report_artifacts(run_id)
          run_artifacts(run_id).select { |artifact| report_artifact?(artifact) }
        end

        def report_artifact?(artifact)
          artifact['name'].start_with?('compliance-result-', 'compliance-')
        end

        def workflow_runs(workflow, event:, since:)
          response = get_json(workflow_runs_path(workflow), workflow_run_params(event))
          Array(response['workflow_runs']).select { |run| parse_time(run.fetch('created_at')) >= since }
        end

        def workflow_runs_path(workflow)
          "/repos/#{@repo}/actions/workflows/#{workflow}/runs"
        end

        def workflow_run_params(event)
          params = { 'event' => event, 'status' => 'completed', 'per_page' => '100' }
          params['branch'] = 'main' unless event == 'pull_request'
          params
        end

        def run_artifacts(run_id)
          response = get_json("/repos/#{@repo}/actions/runs/#{run_id}/artifacts", 'per_page' => '100')
          Array(response['artifacts']).reject { |artifact| artifact['expired'] }
        end

        def download_report_artifact(artifact)
          Dir.mktmpdir('compliance-artifact') do |dir|
            download_zip(artifact.fetch('id'), File.join(dir, 'artifact.zip'))
            unzip_reports(dir)
          end
        end

        def download_zip(artifact_id, zip_path)
          path = "/repos/#{@repo}/actions/artifacts/#{artifact_id}/zip"
          File.binwrite(zip_path, download_binary(api_uri(path)))
        end

        def unzip_reports(dir)
          zip_path = File.join(dir, 'artifact.zip')
          system('unzip', '-q', '-o', zip_path, '-d', dir) || raise("Could not unzip #{zip_path}")
          Dir[File.join(dir, '*.json')].map { |path| JSON.parse(File.read(path)) }
        end

        def get_json(path, params = {})
          response = perform_get(api_uri(path, params))
          raise_for_response(response)
          JSON.parse(response.body)
        end

        def api_uri(path, params = {})
          URI("https://api.github.com#{path}").tap do |uri|
            uri.query = URI.encode_www_form(params) unless params.empty?
          end
        end

        def perform_get(uri)
          Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
            http.request(request(uri))
          end
        end

        def download_binary(uri, limit = 5)
          raise 'Too many redirects while downloading artifact' if limit <= 0

          response = perform_get(uri)
          return download_binary(URI(response['location']), limit - 1) if response.is_a?(Net::HTTPRedirection)

          raise_for_response(response)
          response.body
        end

def request(uri)
  Net::HTTP::Get.new(uri).tap do |request|
    next unless github_api_uri?(uri)

    request['Accept'] = 'application/vnd.github+json'
    request['Authorization'] = "Bearer #{@token}" if @token && @token != ''
    request['X-GitHub-Api-Version'] = '2022-11-28'
  end
end

def github_api_uri?(uri)
  uri.hostname == 'api.github.com'
end

        def raise_for_response(response)
          return if response.is_a?(Net::HTTPSuccess)

          raise "GitHub API failed: #{response.code} #{response.body}"
        end

        def parse_time(value)
          Time.parse(value).utc
        end
      end
    end
  end
end
