require_relative 'support/compliance_fixtures'

describe RSMP::Website::Compliance::Summary do
  it 'rebuilds legacy axis results from stored runs instead of treating a passing pair as a passing workflow' do
    reports = [ComplianceFixtures.report, ComplianceFixtures.report(sxl: '1.0.15', status: 'failed')]
    target = reports.first.fetch('target')
    runs = RSMP::Website::Compliance::RunBuilder.new(target, reports).runs
    previous = subject.new(targets: [target], reports: reports, now: Time.utc(2026, 6, 18)).to_h
    core = previous['targets'].first['core_versions'].first
    # Simulate the old summary format, whose Latest Pass was one successful pair.
    core['latest_passing_run'] = previous['targets'].first['versions'].find do |pair|
      pair['last_status'] == 'passed'
    end['latest_passing_run']
    core['last_30_days'] = { 'passed_runs' => 1, 'total_runs' => 2, 'pass_percentage' => 50.0 }

    2.times do
      previous = subject.new(
        targets: [], runs_by_target: { 'demo' => runs }, previous_summary: previous, now: Time.utc(2026, 6, 18)
      ).to_h
      core = previous['targets'].first['core_versions'].first
      expect(core['latest_passing_run']).to be == nil
      expect(core['last_30_days'].except('passed_pairs', 'total_pairs')).to be == { 'passed_runs' => 0, 'total_runs' => 1, 'pass_percentage' => 0.0 }
      expect(core['latest_run'].slice('passed_cells', 'total_cells')).to be == { 'passed_cells' => 1, 'total_cells' => 2 }
    end
  end

  it 'counts rerun attempts separately, ignores missing reports, and ages out workflow statistics' do
    reports = [
      ComplianceFixtures.report(at: '2026-05-19T00:00:00Z'),
      ComplianceFixtures.report(sxl: '1.0.15', at: '2026-05-19T00:00:00Z'),
      ComplianceFixtures.report(attempt: 2, status: 'failed', at: '2026-06-17T00:00:00Z')
    ]
    target = reports.first.fetch('target')
    runs = RSMP::Website::Compliance::RunBuilder.new(target, reports).runs
    runs.first['cells'] << { 'core' => '3.2.2', 'sxls' => { 'tlc' => '1.0.14' }, 'status' => 'missing' }
    runs << {
      'run_id' => 43, 'run_attempt' => 1, 'completed_at' => '2026-06-17T01:00:00Z',
      'cells' => [{ 'core' => '3.2.2', 'sxls' => { 'tlc' => '1.0.14' }, 'status' => 'missing' }]
    }
    [Time.utc(2026, 6, 18), Time.utc(2026, 6, 18, 0, 0, 1)].each_with_index do |now, index|
      summary = subject.new(targets: [target], runs_by_target: { 'demo' => runs }, now: now).to_h
      core = summary['targets'].first['core_versions'].first
      expect(core['last_30_days'].except('passed_pairs', 'total_pairs')).to be == {
        'passed_runs' => 1 - index, 'total_runs' => 2 - index, 'pass_percentage' => index.zero? ? 50.0 : 0.0
      }
      expect(core.dig('latest_run', 'run_id')).to be == 42
      expect(core.dig('latest_run', 'run_attempt')).to be == 2
      expect(core.dig('latest_run', 'total_cells')).to be == 1
      expect(core.dig('latest_run', 'untested_pairs').map { |pair| pair.dig('sxls', 'tlc') })
        .to be == (index.zero? ? ['1.0.15'] : [])
      expect(core['last_30_days'].slice('passed_pairs', 'total_pairs')).to be == {
        'passed_pairs' => index.zero? ? 2 : 0, 'total_pairs' => index.zero? ? 3 : 1
      }
      expect(core.dig('latest_passing_run', 'run_attempt')).to be == 1
      expect(core.dig('latest_passing_run', 'total_cells')).to be == 2
      expect(core.dig('latest_passing_run', 'untested_pairs')).to be == []
    end
  end

  it 'does not present partial test totals when a legacy report has unknown skip counts' do
    modern = ComplianceFixtures.report
    modern['summary'].merge!('test_count' => 100, 'passed_count' => 90, 'skipped_count' => 10)
    legacy = ComplianceFixtures.report(sxl: '1.0.15')
    summary = subject.new(
      targets: [modern.fetch('target')], reports: [modern, legacy], now: Time.utc(2026, 6, 18)
    ).to_h
    core = summary['targets'].first['core_versions'].first
    expect(core['latest_run'].slice('passed_cells', 'total_cells', 'status'))
      .to be == { 'passed_cells' => 2, 'total_cells' => 2, 'status' => 'passed' }
    expect(core['latest_run'].key?('test_count')).to be == false
    expect(core['latest_run'].key?('passed_count')).to be == false
  end
end
