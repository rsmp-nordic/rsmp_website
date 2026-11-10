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

## How statistics are calculated

For each device, a **run** is one GitHub workflow execution attempt, which may test several Core/SXL pairs. A Core row includes only pairs using that Core version; an SXL row includes only pairs using that SXL version. A run passes for that row only if **all its reported pairs involving the version pass**, even if other versions in the same workflow fail. Rerun attempts count separately.

Statistics and checkmarks use only received test results. Missing reports are excluded, and a workflow with no reported pair involving a version does not count as a run for that row. Passing results therefore do not confirm that every planned pair was tested.

The **30 Days** percentage is **passing workflow runs / total workflow runs × 100%**. Each workflow attempt has equal weight, whether curated or full. For example, a workflow testing Core 3.2.2 with five SXL versions counts as one run for Core 3.2.2. If any of those five pairs fails, that run does not pass for the Core row. The additional **pairs passed** count totals individual pair tests across these workflow runs; repeated tests of the same Core/SXL pair count separately. The percentage remains based on workflow runs, not pair tests.

**Latest Run** shows the latest workflow run involving the version: its date, the number of passing pairs, and the summed test results across those pairs. Skipped tests are excluded from the test total; tests that errored count as unsuccessful. If any report lacks enough count information, the outcome is shown without a test subtotal. Workflow runs are dated by the last reported pair's completion time, including for the 30-day cutoff.

**Latest Pass** shows the latest workflow run where all reported pairs involving the version passed, together with the pair count. It can be older than 30 days. A curated run may qualify with fewer pairs than a full run. Both Latest Run and Latest Pass show **pairs not tested** when other pairs involving the version were tested within the current 30-day window but were absent from that workflow. This includes pairs that have never passed. The line is omitted when no such pairs exist. Hover over the pair counts to see the partner versions and, for tested pairs, their results.

For each Core or SXL version, checkmarks consider every pair involving that version with a received result in the last 30 days. Each pair's latest result is determined by its own completion time:

- **√** means every recently tested pair's latest result passed.
- **(√)** means every recently tested pair has passed at least once within 30 days, but at least one pair's latest result did not pass.
- A blank means at least one recently tested pair has no passing result within 30 days, or there are no results within that window.

The parenthesized checkmark provides a grace period to investigate and fix problems with a device, the validator, or the test infrastructure. The period runs from each pair's last successful test, not from its first failure. A pair that has never passed cannot qualify through another pair's success.

For example, if Core 3.2.2 passes with SXL 1.2.1 but fails with SXL 1.0.15, it receives **(√)** only if the 1.0.15 pair also passed within the last 30 days. Otherwise its status is blank.

Both checkmarks link to the most recent individual passing pair result; that run alone does not demonstrate success for all pairs. Unlike the workflow-based detail columns, checkmarks track each pair across workflows. A passing curated “Latest Run” can therefore coexist with **(√)** if a pair last tested in an earlier full run failed. Pairings with no results in the last 30 days no longer participate in the checkmark assessment. Untested combinations are not covered by either checkmark.

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
