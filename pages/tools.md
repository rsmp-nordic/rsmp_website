---
layout: page
title: Tools
permalink: /tools/
nav_order: 3
parent: Documentation
---

# RSMP Tools
RSMP Nordic maintains a set of open source tools for working with RSMP.

This includes both GUI and command-line tools for validation and interacting with RSMP implementations.

![RSMP Test Stack](/assets/images/test_stack.png)

See all our [GitHub repositories](https://github.com/rsmp-nordic).

## RSMP Simulator
The [RSMP Simulator ](https://github.com/rsmp-nordic/rsmp_simulator) is a Windows application written in C# that can be used for manual testing of RSMP implementations. You can download it along with its documentation from the [release page](https://github.com/rsmp-nordic/rsmp_simulator/releases).

![RSMP Simulator](/assets/images/simulator_1.0.1.5.png)

## RSMP Validator
The [RSMP Validator](https://rsmp-nordic.github.io/rsmp_validator) is a command-line tool based on Ruby and Sus that can be used for automated validation of RSMP implementations.

It is distributed as the `rsmp-validator` Ruby gem and can be run with the `rsmp-validator` command. See the [validator documentation](https://rsmp-nordic.github.io/rsmp_validator/) for installation, Docker usage and configuration.

## RSMP Libraries
We also maintain Ruby libraries and reusable schemas for working with RSMP.

The RSMP Validator is built on these building blocks, but you can also use them yourself to build new or specialized RSMP tools.

### RSMP Ruby Gem
The [RSMP gem](https://github.com/rsmp-nordic/rsmp) is a Ruby library for handling RSMP communication and schema validation.

It includes JSON Schemas for supported Core and SXL versions, as well as command-line tools that make it easy to run an RSMP site or supervisor and view messages as they are exchanged.

![RSMP CLI Supervisor](/assets/images/cli_supervisor.png)

### RSMP JSON Schemas
JSON Schemas for RSMP Core and SXL specifications are now maintained together with the specification repositories and distributed with the `rsmp` gem.

The older [`rsmp_schema`](https://github.com/rsmp-nordic/rsmp_schema) repository and gem are deprecated and will no longer be updated.


