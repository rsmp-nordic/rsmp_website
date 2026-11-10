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

For each device, a **run** is one GitHub workflow execution attempt, which may test several Core/SXL pairings. A Core row includes only pairings using that Core version; an SXL row includes only pairings using that SXL version. A run passes for that row only if **all its reported pairings involving the version pass**, even if other versions in the same workflow fail. Rerun attempts count separately.

Statistics and checkmarks use only received test results. Missing reports are excluded, and a workflow with no reported pairing involving a version does not count as a run for that row. Passing results therefore do not confirm that every planned pairing was tested.

The **30 Days** percentage is **passing workflow runs / total workflow runs × 100%**. Each workflow attempt has equal weight, whether curated or full. For example, a workflow testing Core 3.2.2 with five SXL versions counts as one run for Core 3.2.2. If any of those five pairings fails, that run does not pass for the Core row.

**Latest Run** shows the latest workflow run involving the version: its date, the number of passing pairings, and the summed test results across those pairings. Skipped tests are excluded from the test total; tests that errored count as unsuccessful. If any report lacks enough count information, the outcome is shown without a test subtotal. Workflow runs are dated by the last reported pairing's completion time, including for the 30-day cutoff.

**Latest Pass** shows the latest workflow run where all reported pairings involving the version passed, together with the pairing count. It can be older than 30 days. A curated run may qualify with fewer pairings than a full run.

For each Core or SXL version, checkmarks consider every pairing involving that version with a received result in the last 30 days. Each pairing's latest result is determined by its own completion time:

- **√** means every recently tested pairing's latest result passed.
- **(√)** means every recently tested pairing has passed at least once within 30 days, but at least one pairing's latest result did not pass.
- A blank means at least one recently tested pairing has no passing result within 30 days, or there are no results within that window.

The parenthesized checkmark provides a grace period to investigate and fix problems with a device, the validator, or the test infrastructure. The period runs from each pairing's last successful test, not from its first failure. A pairing that has never passed cannot qualify through another pairing's success.

For example, if Core 3.2.2 passes with SXL 1.2.1 but fails with SXL 1.0.15, it receives **(√)** only if the 1.0.15 pairing also passed within the last 30 days. Otherwise its status is blank.

Both checkmarks link to the most recent individual passing pair result; that run alone does not demonstrate success for all pairings. Unlike the workflow-based detail columns, checkmarks track each pairing across workflows. A passing curated “Latest Run” can therefore coexist with **(√)** if a pairing last tested in an earlier full run failed. Pairings with no results in the last 30 days no longer participate in the checkmark assessment. Untested combinations are not covered by either checkmark.

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
