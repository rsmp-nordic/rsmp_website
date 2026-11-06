require_relative 'support/compliance_fixtures'

describe RSMP::Website::Compliance::Collector do
  it 'does not double-count overlapping reports or lose history when no new reports arrive' do
    reports = [
      ComplianceFixtures.report(id: 42, status: 'failed', at: '2026-06-17T00:00:00Z'),
      ComplianceFixtures.report(id: 41, at: '2026-06-16T00:00:00Z')
    ]
    source = ComplianceFixtures::Reports.new(reports)
    Dir.mktmpdir do |dir|
      options = {
        github: source, website_dir: File.join(dir, 'website'), data_dir: File.join(dir, 'data'),
        source_repo: 'example/devices', now: Time.utc(2026, 6, 18)
      }
      first = subject.new(**options).collect
      source.reports = reports.reverse
      second = subject.new(**options).collect
      source.reports = []
      third = subject.new(**options).collect

      expect(second).to be == first
      expect(third).to be == first
      target = third.fetch('targets').first
      expect(target['last_30_days']).to be == { 'passed_cells' => 1, 'total_cells' => 2, 'pass_percentage' => 50.0 }
      expect(target['versions'].first['last_30_days'])
        .to be == { 'passed_runs' => 1, 'total_runs' => 2, 'pass_percentage' => 50.0 }
      expect(Dir[File.join(dir, 'data/runs/demo/*.json')].map { |path| File.basename(path) }.sort)
        .to be == ['41-1.json', '42-1.json']
      expect(JSON.parse(File.read(File.join(dir, 'data/summary.json')))).to be == third
      expect(JSON.parse(File.read(File.join(dir, 'website/_data/compliance/summary.json')))).to be == third
    end
  end

  it 'retains separate rerun attempts without duplicating either on recollection' do
    first_attempt = ComplianceFixtures.report(attempt: 1)
    second_attempt = ComplianceFixtures.report(attempt: 2, status: 'failed', at: '2026-06-17T01:00:00Z')
    source = ComplianceFixtures::Reports.new([first_attempt])
    Dir.mktmpdir do |dir|
      options = {
        github: source, website_dir: File.join(dir, 'website'), data_dir: File.join(dir, 'data'),
        source_repo: 'example/devices', now: Time.utc(2026, 6, 18)
      }
      subject.new(**options).collect
      source.reports = [second_attempt]
      second = subject.new(**options).collect
      repeated = subject.new(**options).collect

      expect(repeated).to be == second
      target = second.fetch('targets').first
      expect(target.dig('latest_run', 'run_attempt')).to be == 2
      expect(target.dig('latest_passing_run', 'run_attempt')).to be == 1
      expect(target['last_30_days']).to be == { 'passed_cells' => 1, 'total_cells' => 2, 'pass_percentage' => 50.0 }
      expect(Dir[File.join(dir, 'data/runs/demo/*.json')].map { |path| File.basename(path) }.sort)
        .to be == ['42-1.json', '42-2.json']
    end
  end

  it 'ages results out of the 30-day statistics even without new reports' do
    source = ComplianceFixtures::Reports.new([
      ComplianceFixtures.report(id: 40, status: 'failed', at: '2026-05-18T07:59:59Z'),
      ComplianceFixtures.report(id: 41, at: '2026-05-18T08:00:00Z'),
      ComplianceFixtures.report(id: 42, status: 'failed', at: '2026-06-17T08:00:00Z')
    ])
    Dir.mktmpdir do |dir|
      options = {
        github: source, website_dir: File.join(dir, 'website'), data_dir: File.join(dir, 'data'),
        source_repo: 'example/devices', now: Time.utc(2026, 6, 17, 8)
      }
      first = subject.new(**options).collect.fetch('targets').first
      expect(first['recent_runs'].map { |run| run['run_id'] }).to be == [42, 41]
      expect(first['versions'].first['last_30_days'])
        .to be == { 'passed_runs' => 1, 'total_runs' => 2, 'pass_percentage' => 50.0 }

      source.reports = []
      next_day = subject.new(**options.merge(now: Time.utc(2026, 6, 18, 8))).collect.fetch('targets').first
      expect(next_day['recent_runs'].map { |run| run['run_id'] }).to be == [42]
      expect(next_day['last_30_days']).to be == { 'passed_cells' => 0, 'total_cells' => 1, 'pass_percentage' => 0.0 }
      expect(next_day['versions'].first['last_30_days'])
        .to be == { 'passed_runs' => 0, 'total_runs' => 1, 'pass_percentage' => 0.0 }
      expect(next_day.dig('latest_passing_run', 'run_id')).to be == 41
    end
  end

  it 'initializes empty storage when there are no reports' do
    Dir.mktmpdir do |dir|
      now = Time.utc(2026, 6, 18)
      summary = subject.new(
        github: ComplianceFixtures::Reports.new([]), website_dir: File.join(dir, 'website'),
        data_dir: File.join(dir, 'data'), source_repo: 'example/devices', now: now
      ).collect

      expect(summary).to be == { 'generated_at' => now.iso8601, 'targets' => [] }
      expect(JSON.parse(File.read(File.join(dir, 'data/summary.json')))).to be == summary
      expect(JSON.parse(File.read(File.join(dir, 'website/_data/compliance/summary.json')))).to be == summary
    end
  end
end
