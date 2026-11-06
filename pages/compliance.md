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

For each device, one test run checks one Core/SXL combination. A Core version's statistics count every collected run using that Core version, regardless of SXL version. An SXL version's statistics likewise count every run using that SXL version, regardless of Core version.

The 30-day pass rate is **passing runs / total runs × 100%**. Each run has equal weight. For example, testing SXL 1.2.1 with Core 3.2.0 and Core 3.2.2 counts as two runs for SXL 1.2.1. If one passes and one fails, its pass rate is 50%. A single GitHub workflow can contain many such test runs.

The Core and SXL tables summarize results across the tested combinations, ordered by each pairing's completion time:

- **√** means the most recently tested pairing involving that version passed within the last 30 days.
- **(√)** means the most recently tested pairing did not pass, but another pairing involving that version passed within the last 30 days.
- A blank means no pairing involving that version passed within the last 30 days.

Both checkmarks link to the latest passing result. A passing result for a version does not imply that every combination has passed.

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
