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

Test are run on a matrix of core versions.

Only one version of the SXL is tested.

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

<script>
  document.querySelectorAll('time[data-relative-time]').forEach(function(element) {
    var date = new Date(element.dateTime);
    if (Number.isNaN(date.getTime())) return;

    var seconds = Math.round((date.getTime() - Date.now()) / 1000);
    var units = [
      ['year', 31536000],
      ['month', 2592000],
      ['week', 604800],
      ['day', 86400],
      ['hour', 3600],
      ['minute', 60],
      ['second', 1]
    ];
    var formatter = new Intl.RelativeTimeFormat(undefined, { numeric: 'auto' });
    var unit = units.find(function(candidate) {
      return Math.abs(seconds) >= candidate[1] || candidate[0] == 'second';
    });

    element.textContent = formatter.format(Math.round(seconds / unit[1]), unit[0]);
  });
</script>
