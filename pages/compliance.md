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

## Traffic Light Controller Compliance
Click on *View* under Test Runs to see details of all the latest as well as previous test runs.

| Controller | Test Runs | Note |
|--|--|--|
| ![Gem TLC](https://github.com/rsmp-nordic/rsmp_validator/actions/workflows/gem_tlc.yaml/badge.svg?branch=main) | [View](https://github.com/rsmp-nordic/rsmp_validator/actions/workflows/gem_tlc.yaml?query=branch=main) | RSMP Nordic command-line TLC emulator |
| ![Cross RS4S/RS4T](https://github.com/rsmp-nordic/rsmp_validator/actions/workflows/cross_rs4s.yaml/badge.svg?branch=main&event=schedule) | [View](https://github.com/rsmp-nordic/rsmp_validator/actions/workflows/cross_rs4s.yaml?query=branch=main&event=schedule) | Cross RS4S/RS4T |
| ![Kapsch ETX](https://github.com/rsmp-nordic/rsmp_validator/actions/workflows/kapsch_etx.yaml/badge.svg?branch=main&event=schedule) | [View](https://github.com/rsmp-nordic/rsmp_validator/actions/workflows/kapsch_etx.yaml?query=branch=main&event=schedule) | Kapsch ETX |
| ![La Semaforica TECSEN Cartesio](https://github.com/rsmp-nordic/rsmp_validator/actions/workflows/semaforica_cartesio.yaml/badge.svg?branch=main&event=schedule) | [View](https://github.com/rsmp-nordic/rsmp_validator/actions/workflows/semaforica_cartesio.yaml?query=branch=main&event=schedule) | La Semaforica TECSEN Cartesio |
| ![Swarco ITC-3](https://github.com/rsmp-nordic/rsmp_validator/actions/workflows/swarco_itc3.yaml/badge.svg?branch=main&event=schedule) | [View](https://github.com/rsmp-nordic/rsmp_validator/actions/workflows/swarco_itc3.yaml?query=branch=main&event=schedule) | Swarco ITC-3. |

## Central Systems Compliance
Note: Testing of central system is still rudimentary because the RSMP Validator will acts as a site during testing, and commands and status requests can only by initiated from the supervisor.

At this point, only the initial handshake is tested, as well as reception of aggregated status. Results are therefore not an indication of whether a central system has full and correct support for specific types of equipment. 

| System | Test Runs | Note |
|--|--|--|
| ![Gem Supervisor](https://github.com/rsmp-nordic/rsmp_validator/actions/workflows/gem_supervisor.yaml/badge.svg?branch=main) | [View](https://github.com/rsmp-nordic/rsmp_validator/actions/workflows/gem_supervisor.yaml?query=branch=main) | RSMP Nordic command-line supervisor |
| ![TECSEN TMacs](https://github.com/rsmp-nordic/rsmp_validator/actions/workflows/tecsen_tmacs.yaml/badge.svg?branch=main&event=schedule) | [View](https://github.com/rsmp-nordic/rsmp_validator/actions/workflows/tecsen_tmacs.yaml?query=branch=main&event=schedule) | TECSEN TMacs system |


## Notes on Results
We run tests on a matrix of RSMP Core and SXL versions. We plan to expand the result section to provide more details about results for specific versions, individual tests, compliance over time, etc. Until then you can view the test runs to inspect details.

