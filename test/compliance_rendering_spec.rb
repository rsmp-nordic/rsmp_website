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
      targets = target.is_a?(Array) ? target : [target]
      Nokogiri::HTML.fragment(template.render!({ 'targets' => targets }, registers: { site: site }))
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
    rows = document.css('.compliance-axis-details tr[data-version]')
    row = rows.find { |node| node.at_css('td')&.text&.strip == version }
    row.css('td').last
  end
end

describe 'Compliance table rendering' do
  it 'shows Latest Pass counts without skips and omits percentages and panel explanations' do
    [
      [{ 'test_count' => 50, 'passed_count' => 45, 'skipped_count' => 5 }, '45 tests passed'],
      [{ 'test_count' => 50, 'skipped_count' => 5 }, '45 tests passed'],
      [{ 'test_count' => 2, 'passed_count' => 1, 'skipped_count' => 1 }, '1 test passed'],
      [{ 'test_count' => 50 }, nil]
    ].each do |counts, expected|
      report = ComplianceRenderingSpec.report
      report['summary'].merge!(counts)
      document = ComplianceRenderingSpec.render(ComplianceRenderingSpec.target([report]))
      pair_detail = document.at_css('.compliance-pair-detail')
      latest_pass = pair_detail.at_css('.compliance-detail-stats > div:last-child dd')
      expect(latest_pass.at_css('.compliance-passed-tests')&.text).to be == expected
      expect(latest_pass.at_css('time')['datetime']).to be == report['generated_at']
      document.css('.compliance-axis-details tr[data-version]').each do |row|
        expect(row.css('td')[2].at_css('.compliance-passed-tests')&.text).to be == expected
      end
      expect(document.css('[data-compliance-panel]').text.include?('%')).to be == false
      expect(document.css('.compliance-detail > p').size).to be == 0
    end
  end

  it 'shows each pair status and exposes distinct explanations for failed, stale, and untested cells' do
    reports = [
      ComplianceRenderingSpec.report(sxl: '1.0.7', at: '2026-05-01T00:00:00Z'),
      ComplianceRenderingSpec.report(sxl: '1.0.15', status: 'failed'),
      ComplianceRenderingSpec.report(id: 41, sxl: '1.2.0', at: '2026-06-16T00:00:00Z'),
      ComplianceRenderingSpec.report(sxl: '1.2.0', status: 'failed'),
      ComplianceRenderingSpec.report,
      ComplianceRenderingSpec.report(core: '3.3.0')
    ]
    document = ComplianceRenderingSpec.render(ComplianceRenderingSpec.target(reports))
    device = document.at_css('[data-compliance-device]')
    matrix = device.at_css('.compliance-device-matrix')
    expect(matrix.css('thead th')[1..2].map { |cell| cell.text.strip }).to be == ['3.2.2', '3.3.0']
    rows = matrix.css('tbody tr')
    expect(rows.map { |row| row.at_css('th').text.strip }).to be == ['TLC 1.0.7', 'TLC 1.0.15', 'TLC 1.2.0', 'TLC 1.2.1']
    expect(rows.map { |row| row.css('td a').map { |cell| cell.text.strip } })
      .to be == [['', '', ''], ['', '', ''], ['(√)', '', '(√)'], ['√', '√', '√']]
    expect(matrix.css('tfoot td a').map { |cell| cell.text.strip }).to be == ['', '√']

    {
      'core-3-2-2-tlc-1-0-7' => 'No results within the last 30 days.',
      'core-3-2-2-tlc-1-0-15' => 'No passing result within the last 30 days.',
      'core-3-2-2-tlc-1-2-0' => 'Latest run failed; an earlier pass is still within 30 days.',
      'core-3-2-2-tlc-1-2-1' => 'Latest run passed within the last 30 days.',
      'core-3-3-0-tlc-1-0-15' => 'This combination has not been tested in the collected results.'
    }.each do |key, explanation|
      id = "compliance-demo-#{key}"
      link = device.at_css(".compliance-cell[aria-controls='#{id}']")
      expect(link['aria-label'].include?(explanation)).to be == true
      detail = device.at_css("section[id='#{id}']")
      expect(detail.at_css('h5').text.include?('Core')).to be == true
      expect(detail.at_css('.compliance-status-explanation')).to be == nil
    end
    stale = device.at_css('#compliance-demo-core-3-2-2-tlc-1-0-7')
    expect(stale.css('time').map { |time| time['datetime'] }).to be == ['2026-05-01T00:00:00Z'] * 2
    grace = device.at_css('#compliance-demo-core-3-2-2-tlc-1-2-0')
    expect(grace.at_css('dd').text.gsub(/\s+/, ' ').strip).to be == '1/2 runs passed'
    expect(grace.css('time').map { |time| time['datetime'] })
      .to be == ['2026-06-17T00:00:00Z', '2026-06-16T00:00:00Z']
    device.css('[data-compliance-select]').each do |link|
      expect(device.css("section[id='#{link['data-compliance-select']}']").size).to be == 1
    end
  end

  it 'keeps device details separate and explains the pairs behind combined marks' do
    reports = [
      ComplianceRenderingSpec.report(id: 41, sxl: '1.0.15', at: '2026-06-16T00:00:00Z'),
      ComplianceRenderingSpec.report(sxl: '1.0.15', status: 'failed'),
      ComplianceRenderingSpec.report
    ]
    first = ComplianceRenderingSpec.target(reports)
    second = ComplianceRenderingSpec.target([ComplianceRenderingSpec.report])
    second['id'] = 'other'
    document = ComplianceRenderingSpec.render([first, second])
    ids = document.css('[id]').map { |node| node['id'] }
    expect(ids.uniq.size).to be == ids.size
    devices = document.css('[data-compliance-device]')
    expect(devices.size).to be == 2
    expect(devices.first.at_css('.compliance-axis-cell[data-version="core 3.2.2"]').text.strip).to be == '(√)'
    expect(devices.last.at_css('.compliance-axis-cell[data-version="core 3.2.2"]').text.strip).to be == '√'
    detail = document.at_css('#compliance-demo-overall-core-3-2-2')
    items = detail.css('.compliance-contributing-pairs li').map { |item| item.text.gsub(/\s+/, ' ').strip }
    expect(items.any? { |item| item.include?('TLC 1.0.15') && item.include?('Latest run failed') }).to be == true
    expect(items.any? { |item| item.include?('TLC 1.2.1') && item.include?('Latest run passed') }).to be == true
  end

  it 'orders overview versions numerically across devices and keeps columns aligned with their results' do
    first = ComplianceRenderingSpec.target([
      ComplianceRenderingSpec.report(core: '3.10.0', sxl: '1.0.10', status: 'failed'),
      ComplianceRenderingSpec.report(core: '3.9.0', sxl: '1.0.9')
    ])
    second = ComplianceRenderingSpec.target([
      ComplianceRenderingSpec.report(core: '3.2.2', sxl: '1.0.7'),
      ComplianceRenderingSpec.report(core: '3.9.0', sxl: '1.0.9')
    ])
    document = ComplianceRenderingSpec.render([first, second])
    tables = document.css('table.compliance-matrix')
    expect(tables[0].css('thead th').map { |node| node.text.strip })
      .to be == ['Device', '3.2.2', '3.9.0', '3.10.0']
    expect(tables[1].css('thead th').map { |node| node.text.strip })
      .to be == ['Device', '1.0.7', '1.0.9', '1.0.10']
    tables.each do |table|
      expect(table.at_css('tbody tr').css('td').drop(1).map { |node| node.text.strip }).to be == ['', '√', '']
    end
  end

  it 'ignores missing placeholders in both histories and checkmarks, including cached summaries' do
    report = ComplianceRenderingSpec.report
    metadata = report.fetch('target')
    runs = RSMP::Website::Compliance::RunBuilder.new(metadata, [report]).runs
    summary = RSMP::Website::Compliance::Summary.new(
      targets: [metadata], runs_by_target: { 'demo' => runs }, now: Time.utc(2026, 6, 18)
    ).to_h
    missing_run = {
      'run_id' => 43, 'run_attempt' => 1, 'completed_at' => '2026-06-17T01:00:00Z', 'status' => 'missing'
    }
    previous_pair = summary['targets'].first['versions'].first
    previous_pair['latest_run'] = missing_run
    previous_pair['last_status'] = 'missing'
    summary['targets'].first['versions'] << {
      'core' => '3.2.2', 'sxls' => { 'tlc' => '1.0.15' },
      'latest_run' => missing_run, 'last_status' => 'missing'
    }
    runs << missing_run.merge('cells' => [
      { 'core' => '3.2.2', 'sxls' => { 'tlc' => '1.2.1' }, 'status' => 'missing' },
      { 'core' => '3.2.2', 'sxls' => { 'tlc' => '1.0.15' }, 'status' => 'missing' }
    ])
    2.times do
      summary = RSMP::Website::Compliance::Summary.new(
        previous_summary: summary, runs_by_target: { 'demo' => runs }, now: Time.utc(2026, 6, 18)
      ).to_h
      target = summary['targets'].first
      expect(target['versions'].size).to be == 1
      pair = target['versions'].first
      expect(pair['last_status']).to be == 'passed'
      expect(pair.dig('latest_run', 'run_id')).to be == 42
      expect(pair['last_30_days']).to be == { 'passed_runs' => 1, 'total_runs' => 1, 'pass_percentage' => 100.0 }
      document = ComplianceRenderingSpec.render(target)
      expect(ComplianceRenderingSpec.overview_cell(document, 'Core', '3.2.2').text.strip).to be == '√'
      expect(ComplianceRenderingSpec.overview_cell(document, 'Traffic Light Controller SXL', '1.2.1').text.strip).to be == '√'
      expect(ComplianceRenderingSpec.detail_cell(document, 'core 3.2.2').text.strip).to be == '√'
      expect(ComplianceRenderingSpec.detail_cell(document, 'tlc 1.2.1').text.strip).to be == '√'
    end
  end

  it 'shows passing tests out of tests that ran, excluding skips but including errors' do
    [
      [{ 'test_count' => 50, 'passed_count' => 34, 'skipped_count' => 4,
         'failed_count' => 11, 'errored_count' => 1, 'status' => 'failed' }, '34/46 tests passed'],
      [{ 'test_count' => 133, 'skipped_count' => 0, 'failed_count' => 1, 'errored_count' => 0 }, '132/133 tests passed'],
      [{ 'test_count' => 133, 'passed_count' => 118, 'skipped_count' => 14,
         'failed_count' => 1, 'errored_count' => 0 }, '118/119 tests passed'],
      [{ 'test_count' => 133, 'passed_count' => 0, 'skipped_count' => 132,
         'failed_count' => 0, 'errored_count' => 1 }, '0/1 tests passed'],
      [{ 'test_count' => 133, 'passed_count' => 133, 'failed_count' => 0, 'errored_count' => 0 }, 'All 133 tests passed'],
      [{ 'test_count' => 130, 'passed_count' => 120, 'skipped_count' => 10 }, 'All 120 tests passed'],
      [{ 'test_count' => 130, 'skipped_count' => 10 }, 'All 120 tests passed'],
      [{ 'test_count' => 130, 'passed_count' => 0, 'skipped_count' => 130 }, 'No tests ran'],
      [{ 'test_count' => 144, 'failed_count' => 28, 'status' => 'failed' }, ''],
      [{ 'test_count' => 144, 'failed_count' => 0, 'status' => 'passed' }, 'Passed']
    ].each do |counts, expected|
      report = ComplianceRenderingSpec.report
      report['summary'].merge!(counts)
      document = ComplianceRenderingSpec.render(ComplianceRenderingSpec.target([report]))
      pair_result = document.at_css('.compliance-pair-detail .compliance-detail-stats > div:nth-child(2) dd')
      expect(pair_result.text.gsub(/\s+/, ' ').strip.end_with?(expected)).to be == true
      rows = document.css('.compliance-axis-details tr[data-version]').select { |row| row.at_css('td') }
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
      expect(row.css('td')[1].text.strip.gsub(/\s+/, ' ')).to be == '1/4 runs passed 2/5 pairs passed'
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
      expect(detail.parent.css('td')[1].text.strip.gsub(/\s+/, ' ')).to be == '0/2 runs passed 2/4 pairs passed'
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
          .to be == "2026-06-16 02:00 UTC All 2 pairs passed 200 tests passed"
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
    expect(document.css('.compliance-device-matrix tbody th').map { |node| node.text.strip })
      .to be == ['TLC 1.2.1', 'VMS 1.2.1', 'VMS 9.0.0']
  end
end
