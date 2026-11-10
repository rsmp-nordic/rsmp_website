require_relative 'support/compliance_fixtures'

describe RSMP::Website::Compliance::GitHubClient do
  it 'collects and persists reports through discovery, redirects, and ZIP extraction' do
    first = ComplianceFixtures.report
    second = ComplianceFixtures.report(sxl: '1.0.15', status: 'failed')
    second['workflow'].merge!('name' => 'Recorded name', 'file' => 'recorded.yaml')
    api = ComplianceFixtures::API
    base = "#{api}/repos/example/devices"
    storage = 'https://artifacts.example.test/report.zip'
    client = ComplianceFixtures::GitHub.new(
      "#{base}/actions/workflows?per_page=100" => ComplianceFixtures.json_response(ComplianceFixtures.read('workflows')),
      "#{base}/actions/workflows/7/runs?per_page=100&page=1" =>
        ComplianceFixtures.json_response(ComplianceFixtures.read('workflow_runs')),
      "#{base}/actions/runs/42/artifacts?per_page=100&page=1" => ComplianceFixtures.json_response(ComplianceFixtures.read('artifacts')),
      "#{base}/actions/artifacts/101/zip" => ComplianceFixtures.response('', code: 302, location: storage),
      storage => ComplianceFixtures.response(ComplianceFixtures.archive('report.json' => JSON.generate(first), 'notes.txt' => 'Ignored')),
      "#{base}/actions/artifacts/103/zip" => ComplianceFixtures.response(ComplianceFixtures.archive('report.json' => JSON.generate(second)))
    )

    # Check the cutoff inclusively and preserve metadata already in reports.
    reports = client.reports_since(since: Time.utc(2026, 6, 17))
    expect(reports).to be == [
      first.merge('workflow' => first['workflow'].merge('name' => 'Device tests', 'file' => 'device.yaml'),
                  'report_artifact_id' => 101),
      second.merge('report_artifact_id' => 103)
    ]
    expect(client.requests.size).to be == 6
    storage_request = client.requests.find { |request| request.uri.host == 'artifacts.example.test' }
    expect(storage_request['Authorization']).to be == nil
    expect(client.requests.first['Authorization']).to be == 'Bearer fixture-token'

    Dir.mktmpdir do |dir|
      data_dir = File.join(dir, 'data')
      website_dir = File.join(dir, 'website')
      summary = RSMP::Website::Compliance::Collector.new(
        github: client, website_dir: website_dir, data_dir: data_dir,
        source_repo: 'example/devices', now: Time.utc(2026, 6, 18)
      ).collect
      target = summary.fetch('targets').first
      expect(target['workflow_file']).to be == 'device.yaml'
      expect(target['versions'].map { |version| [version.dig('sxls', 'tlc'), version['last_status']] }.sort)
        .to be == [['1.0.15', 'failed'], ['1.2.1', 'passed']]
      expect(target['latest_run'].slice('status', 'passed_cells', 'total_cells'))
        .to be == { 'status' => 'failed', 'passed_cells' => 1, 'total_cells' => 2 }
      expect(JSON.parse(File.read(File.join(website_dir, '_data/compliance/summary.json')))).to be == summary
      stored = JSON.parse(File.read(File.join(data_dir, 'runs/demo/42-1.json')))
      expect(stored['cells'].map { |cell| cell.dig('sxls', 'tlc') }.sort).to be == ['1.0.15', '1.2.1']
    end
  end

  it 'raises on API errors without overwriting previously collected data' do
    client = ComplianceFixtures::GitHub.new(
      'https://api.github.com/repos/example/devices/actions/workflows?per_page=100' =>
        ComplianceFixtures.response('rate limited', code: 403)
    )
    Dir.mktmpdir do |dir|
      path = File.join(dir, 'summary.json')
      saved = JSON.generate('generated_at' => nil, 'targets' => [])
      File.write(path, saved)
      collector = RSMP::Website::Compliance::Collector.new(
        github: client, website_dir: File.join(dir, 'website'), data_dir: dir, source_repo: 'example/devices'
      )

      expect { collector.collect }.to raise_exception(RuntimeError, message: be == 'GitHub API failed: 403 rate limited')
      expect(File.read(path)).to be == saved
      expect(File.exist?(File.join(dir, 'website/_data/compliance/summary.json'))).to be == false
    end
  end

  it 'rejects malformed API JSON' do
    client = ComplianceFixtures::GitHub.new(
      'https://api.github.com/repos/example/devices/actions/workflows?per_page=100' => ComplianceFixtures.response('{invalid')
    )

    expect { client.reports_since(since: Time.utc(2026, 6, 17)) }.to raise_exception(JSON::ParserError)
  end

  it 'stops redirect loops when downloading an artifact' do
    url = 'https://api.github.com/repos/example/devices/actions/artifacts/101/zip'
    client = ComplianceFixtures::GitHub.new(url => ComplianceFixtures.response('', code: 302, location: url))

    expect { client.send(:download_report_artifact, { 'id' => 101 }) }
      .to raise_exception(RuntimeError, message: be == 'Too many redirects while downloading artifact')
    expect(client.requests.size).to be == 5
  end

  it 'rejects malformed reports inside an otherwise valid ZIP' do
    url = 'https://api.github.com/repos/example/devices/actions/artifacts/101/zip'
    client = ComplianceFixtures::GitHub.new(
      url => ComplianceFixtures.response(ComplianceFixtures.archive('report.json' => '{invalid'))
    )

    expect { client.send(:download_report_artifact, { 'id' => 101 }) }.to raise_exception(JSON::ParserError)
  end
end
