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

## Traffic Light Controller Compliance
Click 'View' under Details to see details of latest and earlier test runs.
View [core versions](https://rsmp-nordic.org/specification/).

| Comtroller | Core | SXL | Status | Runs |
|--|--|--|--|--|
| RSMP Nordic [CLI TLC](https://github.com/rsmp-nordic/rsmp) | 3.1.2 to 3.2.2 | 1.2.1 | ![Gem TLC](https://github.com/rsmp-nordic/rsmp_validator/actions/workflows/gem_tlc.yaml/badge.svg?branch=main) | [Details](https://github.com/rsmp-nordic/rsmp_validator/actions/workflows/gem_tlc.yaml?query=branch=main) |
| Cross [RS4S/RS4T](https://www.cross-traffic.com/en/traffic-light-controllers/) | 3.1.2 to 3.2.2 | 1.2.1 | ![Cross RS4S/RS4S](https://github.com/rsmp-nordic/rsmp_validator/actions/workflows/cross_rs4s.yaml/badge.svg?branch=main&event=schedule) | [Details](https://github.com/rsmp-nordic/rsmp_validator/actions/workflows/cross_rs4s.yaml?query=branch=main&event=schedule) |
| Kapsch [EcoTrafiX](https://www.kapsch.net/_Resources/Persistent/f9e0a0525985dc4a9d0b3cb6b67476c0b1257b1c/Kapsch_EcoTrafiX-Controller-16_Datasheet-EN.pdf) | 3.1.2 to 3.2.2 | 1.2.1 | ![Kapsch ETX](https://github.com/rsmp-nordic/rsmp_validator/actions/workflows/kapsch_etx.yaml/badge.svg?branch=main&event=schedule) | [Details](https://github.com/rsmp-nordic/rsmp_validator/actions/workflows/kapsch_etx.yaml?query=branch=main&event=schedule) |
| La Semaforica TECSEN [Cartesio](https://lasemaforica.com/en/products/cartesio-highest-processing-power-interactive-traffic-controllers/) | 3.1.2 to 3.2.2 | 1.2.1 | ![La Semaforica TECSEN Cartesio](https://github.com/rsmp-nordic/rsmp_validator/actions/workflows/semaforica_cartesio.yaml/badge.svg?branch=main&event=schedule) | [Details](https://github.com/rsmp-nordic/rsmp_validator/actions/workflows/semaforica_cartesio.yaml?query=branch=main&event=schedule) |
| LightMotion [Satellite](https://lightmotion.fi/) | 3.2.2 | 1.2 | ![LightMotion Satellite](https://github.com/rsmp-nordic/rsmp_validator/actions/workflows/lightmotion_satellite.yaml/badge.svg?branch=main&event=schedule) | [Details](https://github.com/rsmp-nordic/rsmp_validator/actions/workflows/lightmotion_satellite.yaml?query=branch=main&event=schedule) |
| Swarco [ITC-3](https://www.swarco.com/products/traffic-light-controllers/itc-3-traffic-controller) | 3.1.2 to 3.2.2 | 1.0.15 | ![Swarco ITC-3](https://github.com/rsmp-nordic/rsmp_validator/actions/workflows/swarco_itc3.yaml/badge.svg?branch=main&event=schedule)  | [Details](https://github.com/rsmp-nordic/rsmp_validator/actions/workflows/swarco_itc3.yaml?query=branch=main&event=schedule) |

## Central Systems Compliance
Note: Testing of central system is still rudimentary because the RSMP Validator will acts as a site during testing, and commands and status requests can only by initiated from the supervisor.

At this point, only the initial handshake is tested, as well as reception of aggregated status. Results are therefore not an indication of whether a central system has full and correct support for specific types of equipment.

The validator connects using the traffic light controller SXL.

| System | Core | SXL | Status | Runs |
|--|--|--|--|--|
| RSMP Nordic [CLI supervisor](https://github.com/rsmp-nordic/rsmp) |  3.1.2 to 3.2.2 | 1.2.1 | ![Gem Supervisor](https://github.com/rsmp-nordic/rsmp_validator/actions/workflows/gem_supervisor.yaml/badge.svg?branch=main) | [Details](https://github.com/rsmp-nordic/rsmp_validator/actions/workflows/gem_supervisor.yaml?query=branch=main) |
| TECSEN [TMacs](https://www.tmacs.it/en/) | 3.2.2 | 1.2.1 | ![TECSEN TMacs](https://github.com/rsmp-nordic/rsmp_validator/actions/workflows/tecsen_tmacs.yaml/badge.svg?branch=main&event=schedule) | [Details](https://github.com/rsmp-nordic/rsmp_validator/actions/workflows/tecsen_tmacs.yaml?query=branch=main&event=schedule) |

## Core versions
See the list of available [core versions](https://rsmp-nordic.org/specification/).

## Notes on Results
We run tests on a matrix of RSMP Core and SXL versions. We plan to expand the result section to provide more details about results for specific versions, individual tests, compliance over time, etc. Until then you can view the test runs to inspect details.

