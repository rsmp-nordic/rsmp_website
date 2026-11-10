# encoding: UTF-8

require 'jekyll'
require 'nokogiri'
require_relative 'support/compliance_fixtures'

module ComplianceRenderingSpec
  module_function

  def report(core: '3.2.2', sxl: '1.2.1', status: 'passed', id: 42, at: '2026-06-17T00:00:00Z')
    ComplianceFixtures.report(id: id, sxl: sxl, status: status, at: at).tap do |report|
      report['matrix']['core'] = core
      report['run']['url'] = "https://github.com/example/devices/actions/runs/#{id}"
    end
  end

  def target(reports)
    RSMP::Website::Compliance::Summary.new(
      targets: [reports.first.fetch('target')], reports: reports, now: Time.utc(2026, 6, 18)
    ).to_h.fetch('targets').first
  end

  def render(target)
    Dir.mktmpdir('compliance-rendering') do |dir|
      site = Jekyll::Site.new(Jekyll.configuration(
        'config' => [], 'source' => File.expand_path('..', __dir__),
        'destination' => dir, 'quiet' => true, 'plugins' => []
      ))
      template = site.liquid_renderer.file(__FILE__).parse(
        '{% include compliance_table.html targets=targets name_heading="Device" %}'
      )
      Nokogiri::HTML.fragment(template.render!({ 'targets' => [target] }, registers: { site: site }))
    end
  end

  def overview_cell(document, heading, version)
    section = document.css('h3').find { |node| node.text == heading }
    table = section.at_xpath('following-sibling::table[1]')
    column = table.css('thead th').map { |node| node.text.strip }.index(version)
    raise "Missing column #{version}" unless column

    table.at_css('tbody tr').css('td')[column]
  end

  def detail_cell(document, version)
    table = document.at_css('h4#compliance-demo + table')
    row = table.css('tr').find { |node| node.at_css('td')&.text&.strip == version }
    row.css('td').last
  end
end

describe 'Compliance table rendering' do
  it 'shows passing tests out of tests that ran, excluding skips but including errors' do
    [
      [{ 'test_count' => 133, 'skipped_count' => 0, 'failed_count' => 1, 'errored_count' => 0 }, '132/133 tests passed'],
      [{ 'test_count' => 133, 'passed_count' => 118, 'skipped_count' => 14,
         'failed_count' => 1, 'errored_count' => 0 }, '118/119 tests passed'],
      [{ 'test_count' => 133, 'passed_count' => 0, 'skipped_count' => 132,
         'failed_count' => 0, 'errored_count' => 1 }, '0/1 tests passed'],
      [{ 'test_count' => 133, 'passed_count' => 133, 'failed_count' => 0, 'errored_count' => 0 }, 'All 133 tests passed'],
      [{ 'test_count' => 130, 'passed_count' => 120, 'skipped_count' => 10 }, 'All 120 tests passed'],
      [{ 'test_count' => 130, 'skipped_count' => 10 }, 'All 120 tests passed'],
      [{ 'test_count' => 130, 'passed_count' => 0, 'skipped_count' => 130 }, 'No tests ran'],
      [{ 'test_count' => 144, 'failed_count' => 28, 'status' => 'failed' }, 'Not all tests passed'],
      [{ 'test_count' => 144, 'failed_count' => 0, 'status' => 'passed' }, 'Passed']
    ].each do |counts, expected|
      report = ComplianceRenderingSpec.report
      report['summary'].merge!(counts)
      document = ComplianceRenderingSpec.render(ComplianceRenderingSpec.target([report]))
      rows = document.css('h4#compliance-demo + table tr').select { |row| row.at_css('td') }
      expect(rows.size).to be == 2
      rows.each do |row|
        latest_run = row.css('td')[3].children.reverse.take_while { |node| node.name != 'br' }.reverse.map(&:text).join.strip.gsub(/\s+/, ' ')
        expect(latest_run).to be == expected
      end
    end
  end

  [
    ['Core', '3.2.2', 'core 3.2.2', { sxl: '1.0.15' }],
    ['Traffic Light Controller SXL', '1.2.1', 'tlc 1.2.1', { core: '3.3.0' }]
  ].each do |heading, version, detail_label, other_pair|
    it "lists #{heading} pairs tested and not tested in Latest Run and Latest Pass" do
      old_pair = heading == 'Core' ? { sxl: '1.0.7' } : { core: '3.1.2' }
      target = ComplianceRenderingSpec.target([
        ComplianceRenderingSpec.report(id: 39, **old_pair, at: '2026-05-01T00:00:00Z'),
        ComplianceRenderingSpec.report(id: 40, at: '2026-06-16T00:00:00Z'),
        ComplianceRenderingSpec.report(id: 40, **other_pair, status: 'failed', at: '2026-06-16T01:00:00Z'),
        ComplianceRenderingSpec.report(id: 41, **other_pair, status: 'failed', at: '2026-06-16T02:00:00Z'),
        ComplianceRenderingSpec.report(id: 42, at: '2026-06-17T00:00:00Z'),
        ComplianceRenderingSpec.report(id: 43, status: 'failed', at: '2026-06-17T01:00:00Z')
      ])
      document = ComplianceRenderingSpec.render(target)
      row = ComplianceRenderingSpec.detail_cell(document, detail_label).parent
      expect(row.css('td')[1].text.strip.gsub(/\s+/, ' ')).to be == '25.0% 1/4 runs passed 2/5 pairs passed'
      tested = heading == 'Core' ? 'SXL: tlc 1.2.1' : 'Core: 3.2.2'
      untested = heading == 'Core' ? 'SXL: tlc 1.0.15' : 'Core: 3.3.0'
      latest_pass, latest_run = row.css('td')[2..3]
      expect(latest_pass.at_css('.compliance-pair-count').text.strip).to be == '1 pair passed'
      expect(latest_pass.at_css('.compliance-pair-count')['title']).to be == "#{tested} — passed"
      expect(latest_run.at_css('.compliance-pair-count').text.strip).to be == '0/1 pair passed'
      expect(latest_run.at_css('.compliance-pair-count')['title']).to be == "#{tested} — failed"
      [latest_pass, latest_run].each do |cell|
        expect(cell.at_css('.compliance-untested-pairs').text.strip).to be == '1 pair not tested'
        expect(cell.at_css('.compliance-untested-pairs')['title'])
          .to be == "#{untested}. Tested within 30 days, but not in this run."
      end
    end

    it "retains the #{heading} grace mark even when no whole workflow passed" do
      target = ComplianceRenderingSpec.target([
        ComplianceRenderingSpec.report(id: 40, at: '2026-06-16T00:00:00Z'),
        ComplianceRenderingSpec.report(id: 40, **other_pair, status: 'failed', at: '2026-06-16T01:00:00Z'),
        ComplianceRenderingSpec.report(id: 41, status: 'failed', at: '2026-06-17T00:00:00Z'),
        ComplianceRenderingSpec.report(id: 41, **other_pair, at: '2026-06-17T01:00:00Z')
      ])
      document = ComplianceRenderingSpec.render(target)
      detail = ComplianceRenderingSpec.detail_cell(document, detail_label)
      overview = ComplianceRenderingSpec.overview_cell(document, heading, version)
      expect(detail.parent.css('td')[2].text.strip).to be == ''
      expect(detail.parent.css('td')[1].text.strip.gsub(/\s+/, ' ')).to be == '0.0% 0/2 runs passed 2/4 pairs passed'
      expect(detail.text.strip).to be == '(√)'
      expect(overview.text.strip).to be == '(√)'
      expect(overview.at_css('a')['href']).to be == 'https://github.com/example/devices/actions/runs/41'
    end

    it "summarizes complete workflow runs for #{heading}, while retaining pair-level status" do
      reports = [
        ComplianceRenderingSpec.report(id: 40, at: '2026-06-16T00:00:00Z'),
        ComplianceRenderingSpec.report(id: 40, **other_pair, at: '2026-06-16T01:00:00Z'),
        # An unrelated pair must not make this row's otherwise successful run fail.
        ComplianceRenderingSpec.report(id: 40, core: '9.0.0', sxl: '9.0.0', status: 'failed', at: '2026-06-16T02:00:00Z'),
        ComplianceRenderingSpec.report(id: 41, **other_pair, status: 'failed', at: '2026-06-17T01:00:00Z'),
        ComplianceRenderingSpec.report(id: 41, at: '2026-06-17T02:00:00Z')
      ]
      reports.each do |report|
        failed = report['summary']['status'] == 'failed'
        report['summary'].merge!(
          'test_count' => 110, 'skipped_count' => 10, 'passed_count' => failed ? 90 : 100,
          'failed_count' => failed ? 9 : 0, 'errored_count' => failed ? 1 : 0
        )
      end
      partner = heading == 'Core' ? 'SXL' : 'Core'
      [reports, reports.reverse].each do |ordered|
        target = ComplianceRenderingSpec.target(ordered)
        axis = heading == 'Core' ? target['core_versions'].find { |v| v['core'] == version } : target['sxl_versions'].find { |v| v['version'] == version }
        expect(axis['latest_run'].slice('run_id', 'status', 'passed_cells', 'total_cells', 'passed_count', 'test_count', 'skipped_count', 'failed_count', 'errored_count'))
          .to be == { 'run_id' => 41, 'status' => 'failed', 'passed_cells' => 1, 'total_cells' => 2,
                      'passed_count' => 190, 'test_count' => 220, 'skipped_count' => 20, 'failed_count' => 9, 'errored_count' => 1 }
        expect(axis.dig('latest_passing_run', 'run_id')).to be == 40
        expect(axis.dig('latest_passing_run', 'total_cells')).to be == 2
        expect(axis['last_30_days'].except('passed_pairs', 'total_pairs')).to be == { 'passed_runs' => 1, 'total_runs' => 2, 'pass_percentage' => 50.0 }
        expect(axis['last_30_days'].slice('passed_pairs', 'total_pairs')).to be == { 'passed_pairs' => 3, 'total_pairs' => 4 }

        document = ComplianceRenderingSpec.render(target)
        row = ComplianceRenderingSpec.detail_cell(document, detail_label).parent
        expect(row.css('td')[3].text.strip.gsub(/\s+/, ' '))
          .to be == "2026-06-17 02:00 UTC 1/2 pairs passed 190/200 tests passed"
        expect(row.css('td')[3].at_css('a')['href']).to be == 'https://github.com/example/devices/actions/runs/41'
        expected_results = heading == 'Core' ? 'SXL: tlc 1.0.15 — failed; tlc 1.2.1 — passed' : 'Core: 3.2.2 — passed; 3.3.0 — failed'
        expect(row.css('td')[3].at_css('.compliance-pair-count')['title']).to be == expected_results
        expect(row.css('td')[3].at_css('.compliance-untested-pairs')).to be == nil
        expect(row.css('td')[2].text.strip.gsub(/\s+/, ' '))
          .to be == "2026-06-16 02:00 UTC All 2 pairs passed"
        expect(row.css('td')[2].at_css('a')['href']).to be == 'https://github.com/example/devices/actions/runs/40'
        expect(row.css('td').last.text.strip).to be == '(√)'
        expect(ComplianceRenderingSpec.overview_cell(document, heading, version).at_css('a')['title'])
          .to be == 'All recently tested pairings passed within 30 days; some latest results failed. Latest passing pair: 2026-06-17 02:00 UTC'
      end

      # A curated success counts once and becomes Latest Pass, without hiding
      # the unresolved pair from the earlier full run in either status table.
      reports << ComplianceRenderingSpec.report(id: 42, at: '2026-06-17T03:00:00Z')
      target = ComplianceRenderingSpec.target(reports)
      axis = heading == 'Core' ? target['core_versions'].find { |v| v['core'] == version } : target['sxl_versions'].find { |v| v['version'] == version }
      expect(axis.dig('latest_passing_run', 'run_id')).to be == 42
      expect(axis.dig('latest_passing_run', 'total_cells')).to be == 1
      expect(axis['last_30_days'].except('passed_pairs', 'total_pairs')).to be == { 'passed_runs' => 2, 'total_runs' => 3, 'pass_percentage' => 66.7 }
      expect(axis['last_30_days'].slice('passed_pairs', 'total_pairs')).to be == { 'passed_pairs' => 4, 'total_pairs' => 5 }
      document = ComplianceRenderingSpec.render(target)
      expect(ComplianceRenderingSpec.overview_cell(document, heading, version).text.strip).to be == '(√)'
      expect(ComplianceRenderingSpec.detail_cell(document, detail_label).text.strip).to be == '(√)'
    end

    it "withholds the #{heading} checkmark when another pairing has never passed" do
      reports = [
        ComplianceRenderingSpec.report(**other_pair, status: 'failed'),
        ComplianceRenderingSpec.report(at: '2026-06-17T01:00:00Z')
      ]
      reports.permutation.each do |ordered|
        document = ComplianceRenderingSpec.render(ComplianceRenderingSpec.target(ordered))
        overview = ComplianceRenderingSpec.overview_cell(document, heading, version)

        expect(overview.text.strip).to be == ''
        expect(ComplianceRenderingSpec.detail_cell(document, detail_label).text.strip).to be == ''
        expect(overview.at_css('a')).to be == nil
      end
    end

    it "keeps the #{heading} grace mark until every pairing's latest result passes" do
      reports = [
        ComplianceRenderingSpec.report(id: 40, **other_pair, at: '2026-06-16T00:00:00Z'),
        ComplianceRenderingSpec.report(id: 41, **other_pair, status: 'failed'),
        ComplianceRenderingSpec.report(id: 42, at: '2026-06-17T01:00:00Z')
      ]
      [reports, reports.reverse].each do |ordered|
        target = ComplianceRenderingSpec.target(ordered)
        document = ComplianceRenderingSpec.render(target)
        overview = ComplianceRenderingSpec.overview_cell(document, heading, version)
        expect(overview.text.strip).to be == '(√)'
        expect(ComplianceRenderingSpec.detail_cell(document, detail_label).text.strip).to be == '(√)'
        expect(overview.at_css('a')['href']).to be == 'https://github.com/example/devices/actions/runs/42'
        axis = heading == 'Core' ? target['core_versions'].first : target['sxl_versions'].first
        expect(axis['last_status']).to be == 'passed'
        expect(axis['last_30_days'].except('passed_pairs', 'total_pairs')).to be == {
          'passed_runs' => 2, 'total_runs' => 3, 'pass_percentage' => 66.7
        }
      end

      reports << ComplianceRenderingSpec.report(id: 43, **other_pair, at: '2026-06-17T02:00:00Z')
      document = ComplianceRenderingSpec.render(ComplianceRenderingSpec.target(reports))
      expect(ComplianceRenderingSpec.overview_cell(document, heading, version).text.strip).to be == '√'
      expect(ComplianceRenderingSpec.detail_cell(document, detail_label).text.strip).to be == '√'
    end

    it "uses the individual pairing time for the #{heading} 30-day cutoff" do
      ['2026-05-18T23:59:59Z', '2026-05-19T00:00:00Z'].each_with_index do |at, index|
        target = ComplianceRenderingSpec.target([
          ComplianceRenderingSpec.report(id: 42, at: at),
          ComplianceRenderingSpec.report(id: 41, status: 'failed', at: '2026-05-19T00:30:00Z'),
          ComplianceRenderingSpec.report(id: 42, **other_pair, at: '2026-05-19T01:00:00Z')
        ])
        document = ComplianceRenderingSpec.render(target)
        expected = index.zero? ? '' : '(√)'

        expect(ComplianceRenderingSpec.overview_cell(document, heading, version).text.strip).to be == expected
        expect(ComplianceRenderingSpec.detail_cell(document, detail_label).text.strip).to be == expected
        axis = heading == 'Core' ? target['core_versions'].first : target['sxl_versions'].first
        expect(axis['last_30_days'].except('passed_pairs', 'total_pairs')).to be == {
          'passed_runs' => 1, 'total_runs' => 2, 'pass_percentage' => 50.0
        }
      end
    end
  end

  it 'orders pair results across overlapping workflows and refreshes cached workflow timestamps' do
    reports = [
      ComplianceRenderingSpec.report(id: 41, at: '2026-06-17T01:00:00Z'),
      ComplianceRenderingSpec.report(id: 41, core: '3.3.0', sxl: '1.0.15', at: '2026-06-17T03:00:00Z'),
      ComplianceRenderingSpec.report(id: 42, status: 'failed', at: '2026-06-17T02:00:00Z')
    ]
    target = reports.first.fetch('target')
    runs = RSMP::Website::Compliance::RunBuilder.new(target, reports).runs
    legacy_runs = Marshal.load(Marshal.dump(runs))
    legacy_runs.each { |run| run['cells'].each { |cell| cell.delete('completed_at') } }
    previous = RSMP::Website::Compliance::Summary.new(
      targets: [target], runs_by_target: { 'demo' => legacy_runs }, now: Time.utc(2026, 6, 18)
    ).to_h

    2.times do
      previous = RSMP::Website::Compliance::Summary.new(
        targets: [target], runs_by_target: { 'demo' => runs }, previous_summary: previous,
        now: Time.utc(2026, 6, 18)
      ).to_h
      summary = previous['targets'].first
      core = summary['core_versions'].find { |item| item['core'] == '3.2.2' }
      sxl = summary['sxl_versions'].find { |item| item['version'] == '1.2.1' }
      pair = summary['versions'].find { |item| item['core'] == '3.2.2' }
      [core, sxl].each do |item|
        expect(item['last_status']).to be == 'passed'
        expect(item.dig('latest_run', 'completed_at')).to be == '2026-06-17T03:00:00Z'
        expect(item.dig('latest_passing_run', 'run_id')).to be == 41
      end
      [pair].each do |item|
        expect(item['last_status']).to be == 'failed'
        expect(item.dig('latest_run', 'completed_at')).to be == '2026-06-17T02:00:00Z'
        expect(item.dig('latest_passing_run', 'completed_at')).to be == '2026-06-17T01:00:00Z'
      end
      document = ComplianceRenderingSpec.render(summary)
      overview = ComplianceRenderingSpec.overview_cell(document, 'Core', '3.2.2')
      expect(overview.text.strip).to be == '(√)'
      expect(overview.at_css('a')['href']).to be == 'https://github.com/example/devices/actions/runs/41'
    end
  end

  it 'withholds both Core marks when the most recent pairing has never passed' do
    target = ComplianceRenderingSpec.target([
      ComplianceRenderingSpec.report(sxl: '1.2.1'),
      ComplianceRenderingSpec.report(sxl: '1.0.15', status: 'failed', at: '2026-06-17T01:00:00Z')
    ])
    document = ComplianceRenderingSpec.render(target)
    overview = ComplianceRenderingSpec.overview_cell(document, 'Core', '3.2.2')
    detail = ComplianceRenderingSpec.detail_cell(document, 'core 3.2.2')

    expect(overview.text.strip).to be == ''
    expect(overview.text.strip).to be == detail.text.strip
    expect(overview.at_css('a')).to be == nil

    target['versions'].reverse!
    reordered = ComplianceRenderingSpec.render(target)
    expect(ComplianceRenderingSpec.overview_cell(reordered, 'Core', '3.2.2').text.strip).to be == ''
  end

  it 'withholds both SXL marks when the most recent pairing has never passed' do
    target = ComplianceRenderingSpec.target([
      ComplianceRenderingSpec.report(core: '3.3.0'),
      ComplianceRenderingSpec.report(core: '3.2.2', status: 'failed', at: '2026-06-17T01:00:00Z')
    ])
    document = ComplianceRenderingSpec.render(target)
    overview = ComplianceRenderingSpec.overview_cell(document, 'Traffic Light Controller SXL', '1.2.1')
    detail = ComplianceRenderingSpec.detail_cell(document, 'tlc 1.2.1')

    expect(overview.text.strip).to be == ''
    expect(overview.text.strip).to be == detail.text.strip
    expect(overview.at_css('a')).to be == nil
  end

  it 'does not let an old pair hide a recent pass with a different SXL' do
    target = ComplianceRenderingSpec.target([
      ComplianceRenderingSpec.report(id: 41, sxl: '1.2.1', status: 'failed', at: '2026-05-01T00:00:00Z'),
      ComplianceRenderingSpec.report(id: 42, sxl: '1.0.15')
    ])
    document = ComplianceRenderingSpec.render(target)
    core = ComplianceRenderingSpec.overview_cell(document, 'Core', '3.2.2')

    expect(core.text.strip).to be == '√'
    expect(core.at_css('a')&.[]('href')).to be == 'https://github.com/example/devices/actions/runs/42'
    expect(ComplianceRenderingSpec.overview_cell(document, 'Traffic Light Controller SXL', '1.2.1').text.strip).to be == ''
  end

  it 'shows no checkmarks when all results have aged out, even if they passed' do
    document = ComplianceRenderingSpec.render(ComplianceRenderingSpec.target([
      ComplianceRenderingSpec.report(at: '2026-05-18T23:59:59Z')
    ]))

    expect(ComplianceRenderingSpec.overview_cell(document, 'Core', '3.2.2').text.strip).to be == ''
    expect(ComplianceRenderingSpec.overview_cell(document, 'Traffic Light Controller SXL', '1.2.1').text.strip).to be == ''
    expect(ComplianceRenderingSpec.detail_cell(document, 'core 3.2.2').text.strip).to be == ''
    expect(ComplianceRenderingSpec.detail_cell(document, 'tlc 1.2.1').text.strip).to be == ''
  end

  it 'keeps other SXL types out of the TLC overview' do
    vms = ComplianceRenderingSpec.report(status: 'failed')
    vms['matrix']['sxls'] = { 'vms' => '1.2.1' }
    other_vms = ComplianceRenderingSpec.report
    other_vms['matrix']['sxls'] = { 'vms' => '9.0.0' }
    document = ComplianceRenderingSpec.render(ComplianceRenderingSpec.target([
      ComplianceRenderingSpec.report, vms, other_vms
    ]))
    tlc = ComplianceRenderingSpec.overview_cell(document, 'Traffic Light Controller SXL', '1.2.1')

    expect(tlc.text.strip).to be == '√'
    expect(tlc.ancestors('table').first.css('thead th').map { |node| node.text.strip }).to be == ['Device', '1.2.1']
  end
end
