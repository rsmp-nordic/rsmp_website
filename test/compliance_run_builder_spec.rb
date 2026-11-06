require_relative 'support/compliance_fixtures'

describe RSMP::Website::Compliance::RunBuilder do
  let(:expected) do
    [
      { 'core' => '3.2.2', 'sxls' => { 'tlc' => '1.0.15' } },
      { 'core' => '3.2.2', 'sxls' => { 'tlc' => '1.2.1' } },
      { 'core' => '3.2.1', 'sxls' => { 'tlc' => '1.2.1' } }
    ]
  end
  let(:target) { { 'id' => 'demo', 'expected_cells' => expected } }

  it 'marks absent pairs as missing rather than claiming the received passes are a complete success' do
    report = ComplianceFixtures.report
    run = subject.new(target, [report]).runs.first

    expect(run.slice('status', 'passed_cells', 'total_cells'))
      .to be == { 'status' => 'failed', 'passed_cells' => 1, 'total_cells' => 3 }
    expect(run['cells'][0]).to be == expected[0].merge('status' => 'missing')
    expect(run['cells'][1]['status']).to be == 'passed'
    expect(run['cells'][2]).to be == expected[2].merge('status' => 'missing')
    expect(report['matrix']).to be == { 'core' => '3.2.2', 'sxls' => { 'tlc' => '1.2.1' } }
    expect(expected.all? { |pair| !pair.key?('status') }).to be == true
  end

  it 'passes when every expected pair has a passing report regardless of report order' do
    reports = expected.map do |pair|
      ComplianceFixtures.report.tap { |report| report['matrix'] = pair }
    end
    run = subject.new(target, reports.reverse).runs.first

    expect(run.slice('status', 'passed_cells', 'total_cells'))
      .to be == { 'status' => 'passed', 'passed_cells' => 3, 'total_cells' => 3 }
    expect(run['cells'].map { |cell| cell.slice('core', 'sxls') }).to be == expected
  end

  it 'does not fill missing pairs using reports from a different run or attempt' do
    reports = [
      ComplianceFixtures.report(id: 41, sxl: '1.0.15'),
      ComplianceFixtures.report(id: 42, attempt: 1, sxl: '1.0.15'),
      ComplianceFixtures.report(id: 42, attempt: 2)
    ]
    runs = subject.new(target, reports).runs

    expect(runs.map { |run| [run['run_id'], run['run_attempt']] }.sort).to be == [[41, 1], [42, 1], [42, 2]]
    expect(runs.all? { |run| run['status'] == 'failed' && run['passed_cells'] == 1 && run['total_cells'] == 3 }).to be == true
    expect(runs.all? { |run| run['cells'].count { |cell| cell['status'] == 'missing' } == 2 }).to be == true
  end
end
