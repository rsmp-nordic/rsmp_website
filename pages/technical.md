---
layout: page
title: Technical
permalink: /technical/
nav_order: 3
has_children: true
---

# Technical
RSMP consists of a specification, plus supporting tools for development and validation.

## Specification
The RSMP [specification]({% link pages/specification.md %}) defines the message formats and behaviour for communicating via RSMP.

### Custom SXLs
You can define your own SXL if you need to support a special type of equipment, although we always recommend using RSMP Nordic standardized SXL whenever available.

If you use a standardized SXL, it's possible to add you own custom messages, although we do not recommend it, as you can easily loose the benefits of a using a vendor-neutral protocol. Any special message implemented only by a single (or a few) vendors will make it harder to switch vendor, and will not be suppored by e.g. RSMP Nordic tools for automated validation.

We encourage you to instead join the RSMP [User Group or Working Group]({% link pages/activities.md %}) and see if you need is shared between other users. In that case it might make sense to include the required messages in upcoming versions of the RSMP specification.

## RSMP Tools
RSMP Nordic maintains a set of [open-source tools]({% link pages/tools.md %}) for working with RSMP.

