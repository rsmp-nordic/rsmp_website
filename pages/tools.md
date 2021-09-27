---
layout: page
title: Tools
permalink: /tools/
nav_order: 3
parent: Documentation
---

# RSMP Tools
RSMP Nordic maintains a set of open source tools for working with RSMP.

This includes both GUI and command line tools for validation and interacting with RSMP implementations.

![RSMP Test Stack](/assets/images/test_stack.png)

See all our [GitHub repositories](https://github.com/rsmp-nordic).

## RSMP Simulator
The [RSMP Simulator ](https://github.com/rsmp-nordic/rsmp_simulator) is a Windows application written in C# that can be used for manual testing of RSMP implementations. You can download it along with its documentation from the ![release page](https://github.com/rsmp-nordic/rsmp_simulator/releases).

![RSMP Simulator](/assets/images/simulator_1.0.1.5.png)

## RSMP Validator
The [RSMP Validator](https://rsmp-nordic.github.io/rsmp_validator) is a command line tool based on Ruby and RSpec that can be used for automated validation of RSMP implementations.

## RSMP Building Blocks
We also maintain several Ruby gems (libraries) for working with RSMP.

The RSMP Validator is built on these building blocks, but you can also use them yourself to build new or specialized RSMP tools.

### RSMP Ruby Gem
The [RSMP gem](https://github.com/rsmp-nordic/rsmp) is a Ruby library for handling RMSP communication.

It also includes command line tools that make it easy to run an RSMP site or supervisor on the command line and view messages as they are exchanged.

![RSMP CLI Supervisor](/assets/images/cli_supervisor.png)

### RSMP Schemer Gem
The [RSMP Schemer gem](https://github.com/rsmp-nordic/rsmp_schemer) is a Ruby library that makes it easy to validate RSMP messages against specific versions of the RSMP JSON Schemas.

### RSMP Schema
A [JSON Schema](https://github.com/rsmp-nordic/rsmp_schema) for automatically validating the format of RSMP messages.



