require 'json'
require 'tmpdir'
require_relative '../../lib/rsmp/website/compliance/collector'

module ComplianceFixtures
  ROOT = File.expand_path('../fixtures/compliance', __dir__)
  API = 'https://api.github.com'
  REPO = 'example/devices'

  module_function

  def read(name)
    JSON.parse(File.read(File.join(ROOT, "#{name}.json")))
  end

  def report(id: 42, attempt: 1, sxl: '1.2.1', status: 'passed', at: '2026-06-17T00:00:00Z')
    read('report').tap do |report|
      report['run']['id'] = id
      report['run']['attempt'] = attempt
      report['matrix']['sxls']['tlc'] = sxl
      report['summary']['status'] = status
      report['summary']['failed_count'] = status == 'passed' ? 0 : 1
      report['generated_at'] = at
    end
  end

  def response(body, code: 200, location: nil)
    klass = Net::HTTPResponse::CODE_TO_OBJ.fetch(code.to_s)
    klass.new('1.1', code.to_s, 'Fixture response').tap do |response|
      response.define_singleton_method(:body) { body }
      response['Location'] = location if location
    end
  end

  def json_response(value)
    response(JSON.generate(value))
  end

  def archive(files)
    Dir.mktmpdir('compliance-fixture') do |dir|
      files.each { |name, contents| File.write(File.join(dir, name), contents) }
      path = File.join(dir, 'report.zip')
      raise 'Could not create fixture ZIP' unless system('zip', '-q', path, *files.keys, chdir: dir)

      File.binread(path)
    end
  end

  # Replace only the HTTP transport. Parsing, filtering, redirects, and ZIP
  # extraction still use the real client. Unexpected requests fail locally.
  class GitHub < RSMP::Website::Compliance::GitHubClient
    attr_reader :requests, :delays, :warnings

    def initialize(responses)
      super(repo: REPO, token: 'fixture-token')
      @responses = responses
      @requests = []
      @delays = []
      @warnings = []
    end

    private

    def perform_get(uri)
      @requests << request(uri)
      response = @responses.fetch(uri.to_s)
      return response unless response.is_a?(Array)

      raise "No more fixture responses for #{uri.host}" if response.empty?

      response.shift
    end

    def sleep(delay)
      @delays << delay
    end

    def warn(message)
      @warnings << message
    end
  end

  class Reports
    attr_accessor :reports

    def initialize(reports)
      @reports = reports
    end

    def reports_since(since:, known_artifact_ids: [])
      @reports.reject { |report| known_artifact_ids.include?(report['report_artifact_id']) }
    end
  end
end
