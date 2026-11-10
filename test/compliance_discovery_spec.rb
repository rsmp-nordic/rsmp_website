require_relative 'support/compliance_fixtures'

describe RSMP::Website::Compliance::GitHubClient do
  it 'finds recent reruns on older pages even when an entire page predates the cutoff' do
    base = "#{ComplianceFixtures::API}/repos/example/devices/actions/workflows/7/runs"
    old = {
      'created_at' => '2026-06-01T00:00:00Z', 'updated_at' => '2026-06-01T01:00:00Z',
      'status' => 'completed', 'event' => 'schedule', 'head_branch' => 'main'
    }
    rerun = old.merge('id' => 42, 'run_attempt' => 2, 'updated_at' => '2026-06-17T00:00:00Z')
    client = ComplianceFixtures::GitHub.new(
      "#{base}?per_page=100&page=1" => ComplianceFixtures.json_response(
        'workflow_runs' => (100..199).map { |id| old.merge('id' => id) }
      ),
      "#{base}?per_page=100&page=2" => ComplianceFixtures.json_response('workflow_runs' => [rerun])
    )

    expect(client.send(:workflow_runs, 7, since: Time.utc(2026, 6, 17))).to be == [rerun]
    expect(client.requests.size).to be == 2
  end

  it 'keeps event, completion, and branch filtering while allowing pull requests on other branches' do
    run = {
      'created_at' => '2026-06-17T00:00:00Z', 'status' => 'completed',
      'event' => 'schedule', 'head_branch' => 'main'
    }
    runs = [
      run.merge('id' => 1),
      run.merge('id' => 2, 'head_branch' => 'feature'),
      run.merge('id' => 3, 'event' => 'pull_request', 'head_branch' => 'feature'),
      run.merge('id' => 4, 'event' => 'push'),
      run.merge('id' => 5, 'status' => 'in_progress'),
      run.merge('id' => 6, 'created_at' => '2026-06-16T23:59:59Z')
    ]
    [%w[schedule], %w[schedule pull_request]].each do |events|
      client = subject.new(repo: 'example/devices', token: nil, events: events)
      client.define_singleton_method(:get_json) { |*_args| { 'workflow_runs' => runs } }

      expected = events.include?('pull_request') ? [1, 3] : [1]
      expect(client.send(:workflow_runs, 7, since: Time.utc(2026, 6, 17)).map { |item| item['id'] })
        .to be == expected
    end
  end

  it 'stops at an empty page after exactly 100 workflow runs' do
    run = {
      'created_at' => '2026-06-17T00:00:00Z', 'status' => 'completed',
      'event' => 'schedule', 'head_branch' => 'main'
    }
    runs = (1..100).map { |id| run.merge('id' => id) }
    client = subject.new(repo: 'example/devices', token: nil)
    pages = []
    client.define_singleton_method(:get_json) do |_path, params|
      pages << params.fetch('page')
      { 'workflow_runs' => params['page'] == '1' ? runs : [] }
    end

    expect(client.send(:workflow_runs, 7, since: Time.utc(2026, 6, 17))).to be == runs
    expect(pages).to be == %w[1 2]
  end
end
