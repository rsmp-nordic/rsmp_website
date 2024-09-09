---
layout: page
title: Compliance
permalink: /compliance/
nav_order: 4
---

# Compliance

## Validation Tools
RSMP Nordic does not offer certifications. Instead we offer [open source tools]({% link pages/documentation.md %}) that can be used to check and document compliance to the RSMP specification.

These validation tools can be used by suppliers, road authorities or anyone else that would like to validate or experience with equipment or supervisor systems.

As a road authority, you can require venders to use the validation tools to document compliance to the RSMP specifications.

As a vendor, you can use the tools during development and testing of products, and to document compliance to the RSMP specifications.

## Test Hub
RSMP Nordic hosts a RSMP Test Hub, which automatically runs the RSMP Validator tests every night against equipment and systems from various suppliers. The latest results are published here. Click on *Test Runs/View* to see details and older test runs.

Note: The validator has been in active use for several years, but until the [RSMP Validator](https://github.com/rsmp-nordic/rsmp_validator) reaches version 1.0, test results are preliminary. 

Suppliers that would like their equipment included in our Test Hub are encouraged to contact the [secretariat]({% link pages/contact.md %}).

### Test Results for Devices

| Device | Test Runs | Note |
|--|--|--|
| ![Gem TLC](https://github.com/rsmp-nordic/rsmp_validator/actions/workflows/gem_tlc.yaml/badge.svg?branch=main) | [View](https://github.com/rsmp-nordic/rsmp_validator/actions/workflows/gem_tlc.yaml?query=branch=main) | RSMP Nordic command-line TLC emulator |
| ![Swarco ITC-3](https://github.com/rsmp-nordic/rsmp_validator/actions/workflows/swarco_itc3.yaml/badge.svg?branch=main&event=schedule) | [View](https://github.com/rsmp-nordic/rsmp_validator/actions/workflows/swarco_itc3.yaml?query=branch=main&event=schedule) | Swarco ITC-3 |
| ![La Semaforica TECSEN Cartesio](https://github.com/rsmp-nordic/rsmp_validator/actions/workflows/semaforica_cartesio.yaml/badge.svg?branch=main&event=schedule) | [View](https://github.com/rsmp-nordic/rsmp_validator/actions/workflows/semaforica_cartesio.yaml?query=branch=main&event=schedule) | La Semaforica TECSEN Cartesio |

### Test Results for Central Systems
Note: Testing of central system is still rudimentary because the RSMP Validator will acts as a site during testing, and commands and status requests can only by initiated from the supervisor.

At this point, only the initial handshake is tested, as well as reception of aggregated status. These are therefore not an indication of whether a central system has a a full and correct support for specific types of equipment. 

| System | Test Runs | Note |
|--|--|--|
| ![Gem Supervisor](https://github.com/rsmp-nordic/rsmp_validator/actions/workflows/gem_supervisor.yaml/badge.svg?branch=main) | [View](https://github.com/rsmp-nordic/rsmp_validator/actions/workflows/gem_supervisor.yaml?query=branch=main) | RSMP Nordic command-line supervisor |
| ![TECSEN TMacs](https://github.com/rsmp-nordic/rsmp_validator/actions/workflows/tecsen_tmacs.yaml/badge.svg?branch=main&event=schedule) | [View](https://github.com/rsmp-nordic/rsmp_validator/actions/workflows/tecsen_tmacs.yaml?query=branch=main&event=schedule) | TECSEN TMacs system |

