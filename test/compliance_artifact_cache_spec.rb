require_relative 'support/compliance_fixtures'

module ComplianceArtifactCacheFixtures
  module_function

  def client(ids, downloads = {})
    base = "#{ComplianceFixtures::API}/repos/example/devices"
    responses = {
      "#{base}/actions/workflows?per_page=100" => ComplianceFixtures.json_response(ComplianceFixtures.read('workflows')),
      "#{base}/actions/workflows/7/runs?event=schedule&status=completed&per_page=100&branch=main" =>
        ComplianceFixtures.json_response(ComplianceFixtures.read('workflow_runs')),
      "#{base}/actions/runs/42/artifacts?per_page=100&page=1" => ComplianceFixtures.json_response(
        'artifacts' => ids.map { |id| { 'id' => id, 'name' => "compliance-result-#{id}", 'expired' => false } }
      )
    }
    downloads.each do |id, report|
      responses["#{base}/actions/artifacts/#{id}/zip"] = if report.is_a?(Net::HTTPResponse)
        report
      else
        ComplianceFixtures.response(ComplianceFixtures.archive('report.json' => JSON.generate(report)))
      end
    end
    # Missing download responses deliberately fail if a cached artifact is fetched.
    ComplianceFixtures::GitHub.new(responses)
  end

  def collect(dir, client, **options)
    RSMP::Website::Compliance::Collector.new(
      github: client, website_dir: File.join(dir, 'website'), data_dir: File.join(dir, 'data'),
      source_repo: 'example/devices', now: Time.utc(2026, 6, 18), **options
    ).collect
  end

  def record_path(dir, attempt = 1)
    File.join(dir, "data/runs/demo/42-#{attempt}.json")
  end
end

describe RSMP::Website::Compliance::Collector do
  it 'uses persisted artifact IDs across fresh collectors and retains pairs when another report arrives' do
    fixtures = ComplianceArtifactCacheFixtures
    first = ComplianceFixtures.report
    second = ComplianceFixtures.report(sxl: '1.0.15', status: 'failed', at: '2026-06-17T01:00:00Z')
    Dir.mktmpdir do |dir|
      fixtures.collect(dir, fixtures.client([101], 101 => first))
      stored = JSON.parse(File.read(fixtures.record_path(dir)))
      expect(stored['cells'].first['report_artifact_id']).to be == 101

      client = fixtures.client([101, 103], 103 => second)
      summary = fixtures.collect(dir, client)
      expect(client.requests.count { |request| request.uri.path.end_with?('/zip') }).to be == 1
      stored = JSON.parse(File.read(fixtures.record_path(dir)))
      expect(stored['cells'].map { |cell| cell['report_artifact_id'] }.sort).to be == [101, 103]
      expect(stored.slice('status', 'passed_cells', 'total_cells'))
        .to be == { 'status' => 'failed', 'passed_cells' => 1, 'total_cells' => 2 }
      expect(stored['cells'].find { |cell| cell['report_artifact_id'] == 101 }['completed_at'])
        .to be == first['generated_at']
      target = summary.fetch('targets').first
      expect(target['last_30_days']).to be == { 'passed_cells' => 1, 'total_cells' => 2, 'pass_percentage' => 50.0 }
      expect(target['core_versions'].first.dig('latest_run', 'status')).to be == 'failed'

      saved = File.read(fixtures.record_path(dir))
      expect(fixtures.collect(dir, fixtures.client([101, 103]))).to be == summary
      expect(File.read(fixtures.record_path(dir))).to be == saved

      rerun = ComplianceFixtures.report(attempt: 2, at: '2026-06-17T02:00:00Z')
      summary = fixtures.collect(dir, fixtures.client([101, 103, 104], 104 => rerun))
      expect(File.read(fixtures.record_path(dir))).to be == saved
      expect(JSON.parse(File.read(fixtures.record_path(dir, 2)))['cells'].first['report_artifact_id']).to be == 104
      expect(summary.fetch('targets').first['last_30_days'])
        .to be == { 'passed_cells' => 2, 'total_cells' => 3, 'pass_percentage' => 66.7 }
    end
  end

  it 'backfills IDs into legacy records without double counting and bypasses the cache with full collection' do
    fixtures = ComplianceArtifactCacheFixtures
    report = ComplianceFixtures.report
    Dir.mktmpdir do |dir|
      fixtures.collect(dir, ComplianceFixtures::Reports.new([report]))
      expect(JSON.parse(File.read(fixtures.record_path(dir)))['cells'].first.key?('report_artifact_id')).to be == false
      summary = fixtures.collect(dir, fixtures.client([101], 101 => report))
      stored = JSON.parse(File.read(fixtures.record_path(dir)))
      expect(stored['total_cells']).to be == 1
      expect(stored['cells'].first['report_artifact_id']).to be == 101
      expect(fixtures.collect(dir, fixtures.client([101]))).to be == summary

      client = fixtures.client([101], 101 => report)
      expect(fixtures.collect(dir, client, full: true)).to be == summary
      expect(client.requests.count { |request| request.uri.path.end_with?('/zip') }).to be == 1
    end
  end

  it 'does not remember failed downloads and retries them on the next collection' do
    fixtures = ComplianceArtifactCacheFixtures
    first = ComplianceFixtures.report
    second = ComplianceFixtures.report(sxl: '1.0.15')
    Dir.mktmpdir do |dir|
      fixtures.collect(dir, fixtures.client([101], 101 => first))
      saved = File.read(fixtures.record_path(dir))
      summary_path = File.join(dir, 'data/summary.json')
      saved_summary = File.read(summary_path)
      client = fixtures.client([101, 103], 103 => ComplianceFixtures.response('ServerBusy', code: 503))
      expect { fixtures.collect(dir, client) }
        .to raise_exception(RuntimeError, message: be == 'GitHub API failed: 503 ServerBusy')
      expect(File.read(fixtures.record_path(dir))).to be == saved
      expect(File.read(summary_path)).to be == saved_summary

      fixtures.collect(dir, fixtures.client([101, 103], 103 => second))
      stored = JSON.parse(File.read(fixtures.record_path(dir)))
      expect(stored['cells'].map { |cell| cell['report_artifact_id'] }.sort).to be == [101, 103]
    end
  end
end
