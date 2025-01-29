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


## Equipment Compliance
Click on *Test Runs* to see details and older test runs.


| Device | Test Runs | Note |
|--|--|--|
| ![Gem TLC](https://github.com/rsmp-nordic/rsmp_validator/actions/workflows/gem_tlc.yaml/badge.svg?branch=main) | [View](https://github.com/rsmp-nordic/rsmp_validator/actions/workflows/gem_tlc.yaml?query=branch=main) | RSMP Nordic command-line TLC emulator |
| ![Swarco ITC-3](https://github.com/rsmp-nordic/rsmp_validator/actions/workflows/swarco_itc3.yaml/badge.svg?branch=main&event=schedule) | [View](https://github.com/rsmp-nordic/rsmp_validator/actions/workflows/swarco_itc3.yaml?query=branch=main&event=schedule) | Swarco ITC-3. Core versions 3.2.1 and 3.2.2 not yet supported. |
| ![La Semaforica TECSEN Cartesio](https://github.com/rsmp-nordic/rsmp_validator/actions/workflows/semaforica_cartesio.yaml/badge.svg?branch=main&event=schedule) | [View](https://github.com/rsmp-nordic/rsmp_validator/actions/workflows/semaforica_cartesio.yaml?query=branch=main&event=schedule) | La Semaforica TECSEN Cartesio |
| ![Cross RS4S/RS4T](https://github.com/rsmp-nordic/rsmp_validator/actions/workflows/cross_rs4s.yaml/badge.svg?branch=main&event=schedule) | [View](https://github.com/rsmp-nordic/rsmp_validator/actions/workflows/cross_rs4s.yaml?query=branch=main&event=schedule) | Cross RS4S/RS4T |

## Central Systems Compliance
Note: Testing of central system is still rudimentary because the RSMP Validator will acts as a site during testing, and commands and status requests can only by initiated from the supervisor.

At this point, only the initial handshake is tested, as well as reception of aggregated status. Results are therefore not an indication of whether a central system has full and correct support for specific types of equipment. 

| System | Test Runs | Note |
|--|--|--|
| ![Gem Supervisor](https://github.com/rsmp-nordic/rsmp_validator/actions/workflows/gem_supervisor.yaml/badge.svg?branch=main) | [View](https://github.com/rsmp-nordic/rsmp_validator/actions/workflows/gem_supervisor.yaml?query=branch=main) | RSMP Nordic command-line supervisor |
| ![TECSEN TMacs](https://github.com/rsmp-nordic/rsmp_validator/actions/workflows/tecsen_tmacs.yaml/badge.svg?branch=main&event=schedule) | [View](https://github.com/rsmp-nordic/rsmp_validator/actions/workflows/tecsen_tmacs.yaml?query=branch=main&event=schedule) | TECSEN TMacs system |


## Notes on Results
The validator has been in active use for several years, but until the [RSMP Validator](https://github.com/rsmp-nordic/rsmp_validator) reaches version 1.0, test results are preliminary. 

We run tests on a matrix of all RSMP Core and SXL versions. We expect to expand the result section to provide more details about results for specific versions, individual tests, compliance over time, etc.

