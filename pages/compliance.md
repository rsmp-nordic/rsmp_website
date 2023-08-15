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
RMSP Nordic hosts a RSMP Test Hub, where we automatically run the RSMP Validator tests daily against equipment from various suppliers. The current results are published here.

| Device | Test Runs | Note |
|--|--|--|
| [![Gem TLC](https://github.com/rsmp-nordic/rsmp_validator/actions/workflows/gem_tlc.yml/badge.svg?branch=master&event=push)](https://github.com/rsmp-nordic/rsmp_validator/actions/workflows/gem_tlc.yml) | [View runs](https://github.com/rsmp-nordic/rsmp_validator/actions/workflows/gem_tlc.yml?query=branch%3Amaster) | TLC emulator from RSMP Nordic |
| [![Dynniq EC-2](https://github.com/rsmp-nordic/rsmp_validator/actions/workflows/dynniq_ec2.yml/badge.svg?event=schedule)](https://github.com/rsmp-nordic/rsmp_validator/actions/workflows/dynniq_ec2.yml) | [View runs](https://github.com/rsmp-nordic/rsmp_validator/actions/workflows/dynniq_ec2.yml?query=event%3Aschedule) | Physical device |
| [![Swarco ITC-2](https://github.com/rsmp-nordic/rsmp_validator/actions/workflows/swarco_itc2.yml/badge.svg?event=schedule)](https://github.com/rsmp-nordic/rsmp_validator/actions/workflows/swarco_itc2.yml) | [View runs](https://github.com/rsmp-nordic/rsmp_validator/actions/workflows/swarco_itc2.yml?query=event%3Aschedule) | Software simulator |
| [![Swarco ITC-3](https://github.com/rsmp-nordic/rsmp_validator/actions/workflows/swarco_itc3.yml/badge.svg?event=schedule)](https://github.com/rsmp-nordic/rsmp_validator/actions/workflows/swarco_itc3.yml) | [View runs](https://github.com/rsmp-nordic/rsmp_validator/actions/workflows/swarco_itc3.yml?query=event%3Aschedule) | Physical device |

Note: Until the [RMSP Validator](https://github.com/rsmp-nordic/rsmp_validator) reaches version 1.0, test results are preliminary.

Supplier that would like their equipment included in our Test Hub are encouraged to contact the [secretariat]({% link pages/contact.md %}).
