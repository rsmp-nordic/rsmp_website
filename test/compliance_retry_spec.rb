require_relative 'support/compliance_fixtures'

describe RSMP::Website::Compliance::GitHubClient do
  it 'recovers from a storage 503 after a redirect and extracts the report' do
    api = 'https://api.github.com/repos/example/devices/actions/artifacts/101/zip'
    storage = 'https://artifacts.example.test/report.zip?signature=private'
    report = ComplianceFixtures.report
    client = ComplianceFixtures::GitHub.new(
      api => ComplianceFixtures.response('', code: 302, location: storage),
      storage => [
        ComplianceFixtures.response('<Error><Code>ServerBusy</Code></Error>', code: 503),
        ComplianceFixtures.response(ComplianceFixtures.archive('report.json' => JSON.generate(report)))
      ]
    )

    expect(client.send(:download_report_artifact, { 'id' => 101 })).to be == [report]
    expect(client.delays).to be == [5]
    expect(client.requests.map { |request| request.uri.to_s }).to be == [api, storage, storage]
    expect(client.requests.drop(1).map { |request| request['Authorization'] }).to be == [nil, nil]
    expect(client.warnings).to be == ['HTTP 503 from artifacts.example.test; retry 1/3 in 5s']
  end

  it 'backs off for temporary API errors and succeeds on the final attempt' do
    [429, 500, 502, 503, 504].each do |code|
      client = ComplianceFixtures::GitHub.new(
        'https://api.github.com/example' => [
          *Array.new(3) { ComplianceFixtures.response('busy', code: code) },
          ComplianceFixtures.json_response('ok' => true)
        ]
      )

      expect(client.send(:get_json, '/example')).to be == { 'ok' => true }
      expect(client.delays).to be == [5, 10, 20]
      expect(client.requests.size).to be == 4
    end
  end

  it 'uses Retry-After seconds or dates and falls back for invalid or past values' do
    [
      ['30', 30..30],
      [(Time.now.utc + 30).httpdate, 28..30],
      ['Sun, 06 Nov 1994 08:49:37 GMT', 5..5],
      ['invalid', 5..5]
    ].each do |header, expected_delay|
      busy = ComplianceFixtures.response('busy', code: 503)
      busy['Retry-After'] = header
      client = ComplianceFixtures::GitHub.new(
        'https://api.github.com/example' => [busy, ComplianceFixtures.json_response('ok' => true)]
      )

      expect(client.send(:get_json, '/example')).to be == { 'ok' => true }
      expect(client.delays.size).to be == 1
      expect(expected_delay.cover?(client.delays.first)).to be == true
    end
  end

  it 'fails instead of retrying too early when Retry-After exceeds the wait limit' do
    busy = ComplianceFixtures.response('busy', code: 503)
    busy['Retry-After'] = '120'
    client = ComplianceFixtures::GitHub.new('https://api.github.com/example' => busy)

    expect { client.send(:get_json, '/example') }
      .to raise_exception(RuntimeError, message: be == 'GitHub API failed: 503 busy')
    expect(client.requests.size).to be == 1
    expect(client.delays).to be == []
  end

  it 'leaves saved data untouched when retries are exhausted or an error is permanent' do
    [503, 403, 404].each do |code|
      client = ComplianceFixtures::GitHub.new(
        'https://api.github.com/repos/example/devices/actions/workflows?per_page=100' =>
          ComplianceFixtures.response('unavailable', code: code)
      )
      Dir.mktmpdir do |dir|
        data_path = File.join(dir, 'summary.json')
        website_dir = File.join(dir, 'website')
        website_path = File.join(website_dir, '_data/compliance/summary.json')
        FileUtils.mkdir_p(File.dirname(website_path))
        saved = JSON.generate('generated_at' => nil, 'targets' => [])
        File.write(data_path, saved)
        File.write(website_path, saved)
        collector = RSMP::Website::Compliance::Collector.new(
          github: client, website_dir: website_dir, data_dir: dir, source_repo: 'example/devices'
        )

        expect { collector.collect }
          .to raise_exception(RuntimeError, message: be == "GitHub API failed: #{code} unavailable")
        expect(File.read(data_path)).to be == saved
        expect(File.read(website_path)).to be == saved
        expect(client.requests.size).to be == (code == 503 ? 4 : 1)
        expect(client.delays).to be == (code == 503 ? [5, 10, 20] : [])
      end
    end
  end
end
