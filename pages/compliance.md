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
RSMP Nordic hosts a RSMP Test Hub, which automatically runs the RSMP Validator tests every night against equipment from various suppliers. The latest results are published here. Click on *View Run* to see details and older test runs.

| Device | Test Runs | Note |
|--|--|--|
| [![Gem TLC](https://github.com/rsmp-nordic/rsmp_validator/actions/workflows/gem_tlc.yaml/badge.svg?branch=main)](https://github.com/rsmp-nordic/rsmp_validator/actions/workflows/gem_tlc.yaml) | [View runs](https://github.com/rsmp-nordic/rsmp_validator/actions/workflows/gem_tlc.yaml?query=branch=main) | TLC emulator from RSMP Nordic. |
| [![Swarco ITC-3](https://github.com/rsmp-nordic/rsmp_validator/actions/workflows/swarco_itc3.yaml/badge.svg?branch=main&event=schedule)](https://github.com/rsmp-nordic/rsmp_validator/actions/workflows/swarco_itc3.yaml) | [View runs](https://github.com/rsmp-nordic/rsmp_validator/actions/workflows/swarco_itc3.yaml?query=branch=main&event=schedule) | Physical device. |
| [![La Semaforica Cartesio](https://github.com/rsmp-nordic/rsmp_validator/actions/workflows/semaforica_cartesio.yaml/badge.svg?branch=main&event=schedule)](https://github.com/rsmp-nordic/rsmp_validator/actions/workflows/semaforica_cartesio.yaml) | [View runs](https://github.com/rsmp-nordic/rsmp_validator/actions/workflows/semaforica_cartesio.yaml?query=branch=main&event=schedule) | Physical device. |

Note: Until the [RSMP Validator](https://github.com/rsmp-nordic/rsmp_validator) reaches version 1.0, test results are preliminary.

Supplier that would like their equipment included in our Test Hub are encouraged to contact the [secretariat]({% link pages/contact.md %}).
