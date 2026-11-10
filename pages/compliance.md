---
layout: page
title: Compliance
permalink: /compliance/
has_children: true
nav_order: 4
---

# Compliance
RSMP Compliance is checked by the RSMP [Test Hub]({% link pages/testhub.md %}). The test hub uses the [RSMP Validator](https://github.com/rsmp-nordic/rsmp_validator) to automatically runs tests every night.

We encourage you to [get your equipment or system included in the RSMP Test Hub]({% link pages/testhub.md %}) so you can showcase your compliance below.

## Coverage
The Validator mainly tests the protocol layer. This includes checking that the correct message types are send in the right order, and with a valid structure. It includes only limited validation of behavioural aspects.

For example, for traffic ligth controllers, it checks that you can can send a command to change the signal plan, and that the associated status then reports the new signal plan. But it does not (yet) check how the signal groups actually change state over time.

We expect to expand the test suite over time to cover more behavioural aspects.

Tests run on configured combinations of Core and SXL versions. The combinations tested can differ between devices and runs.

## Reading the results

The overview tables combine recent results for each Core or SXL version. Each device also has a matrix with **Core versions in columns and SXL versions in rows**, showing the individual combinations. Each row includes the SXL name and version.

Select any matrix cell, including a blank one, to open its details below the matrix. The bold **All** column combines Core results for each SXL row; the bold **All** row combines SXL results for each Core column. Select either to see its combined statistics. The selected cell is highlighted. Close the panel or press Escape to return to the matrix.

For an individual pair:

- **√** means its latest result passed within the last 30 days.
- **(√)** means its latest result failed, but it passed at least once within the last 30 days.
- A blank means no passing result within 30 days, no recent results, or no collected results for the pair. Select the cell to distinguish these cases. An untested combination is not necessarily unsupported.

For the combined Core and SXL marks, **√** requires every recently tested pair's latest result to pass. **(√)** requires every recently tested pair to have passed within 30 days, with at least one latest result failing. Otherwise the mark is blank. Pairs with no results in the last 30 days do not contribute. The overview tables and the matrix totals use the same rules.

The parenthesized mark gives time to investigate problems with a device, the validator, or the test infrastructure. Its grace period runs from each pair's last passing result, not from its first failure.

## Detail statistics

For a selected pair, **30 Days** shows how many runs passed out of the total. Repeated tests of that pair count separately, including rerun attempts. **Latest Run** shows that pair's most recent result, and **Latest Pass** shows its most recent passing result and the number of tests passed, when available. Both remain visible when older than 30 days, even though those results no longer qualify for a checkmark.

Test totals include only tests that ran. Skipped tests are excluded; errors count as unsuccessful. Older reports that cannot distinguish passed and skipped tests show the outcome without a test total.

The combined Core/SXL panels also retain workflow statistics. A workflow attempt passes for a version only if all its reported pairs involving that version pass. Each attempt has equal weight, whether curated or full. The additional pair count totals individual pair tests across those attempts. “Pairs not tested” identifies pairs seen within the current 30-day window but absent from that workflow. A passing curated workflow can therefore coexist with **(√)** when another pair's latest result failed in an earlier workflow.

All statistics use received results only. Missing reports are excluded, so passing results do not establish that every planned combination was tested. The overview marks link to individual passing runs; use the device matrix to inspect the evidence for each pair.

{% assign compliance_targets = site.data.compliance.summary.targets | default: empty %}
{% assign site_targets = compliance_targets | where: "kind", "site" %}
{% assign supervisor_targets = compliance_targets | where: "kind", "supervisor" %}

{% if site.data.compliance.summary.generated_at %}
Compliance data last updated {{ site.data.compliance.summary.generated_at | date: "%Y-%m-%d %H:%M UTC" }}.
{% endif %}

## Traffic Light Controller Compliance

{% include compliance_table.html targets=site_targets name_heading="Controller" %}

## Central Systems Compliance
Note: Testing of central system is still rudimentary because the RSMP Validator will acts as a site during testing, and commands and status requests can only by initiated from the supervisor.

At this point, only the initial handshake is tested, as well as reception of aggregated status. Results are therefore not an indication of whether a central system has full and correct support for specific types of equipment.

The validator connects using the traffic light controller SXL.

{% include compliance_table.html targets=supervisor_targets name_heading="System" %}

## Core and SXL versions
View available [core and SXL versions](https://rsmp-nordic.org/specification/).

{% include compliance_relative_time.html %}
<script src="{{ '/assets/js/compliance.js' | relative_url }}" defer></script>
