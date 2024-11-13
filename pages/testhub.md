---
title: Test Hub
permalink: /testhub/
nav_order: 4
parent: Documentation
---

# RSMP Test Hub
The RSMP Test Hub is used for continuous validation of RSMP compliance of equipment and systems. Results are published at the [compliance page]({% link pages/compliance.md %}).

You should not test device/system located on street or in production, because testing will send commands, raise alarms, etc. which can interfere with normal operation and cause unsafe situation.

## Overview
The RSMP Test Hub uses GitHub Actions to run tests. 

```mermaid
graph LR
GitHub <--> Runner
Runner <--> Validator
Validator <-->|RSMP| Device/System
```

You install GitHub Runner on a Linux server (or docker container). The runner must be able to contact GitHub and your device/system.

Detailed instructions for connecting your equipment or system to the RSMP test hub is shown below. Please contact the [secretariat]({% link pages/contact.md %}) to receive a unique token for your equipment/system.


When testing is initiated on GitHub, the runner installs all required software, including Ruby, Ruby gems and the RSMP Validator. The runner then runs the Validator, which connects to the device/system using RSMP. Testing then involves exchanging RSMP message while validating messages structure and flow.

The test results are then reported back to GitHub.

Finally, we can show your device/system with a validation flag at our [compliance page]({% link pages/compliance.md %}).

Tests are run every night and also whenever there are commits to the Validator repo. We recommend you have your device/system permamently setup for testing, to always show up-to-date test results.

The test hub can run tests on a matrix of core and SXL versions. We recommend running on the widest possible range of versions.

## Getting Started
The following instructions are provided as a guideline, but could change.

Check the [GitHub runner docs](https://docs.github.com/en/actions/hosting-your-own-runners) for the latests documentation.

Check the [latest version of the GitHub Runner](https://github.com/actions/runner/releases) and adjust the instructions accordingly.

You must install the Github Runner on a Linux system. The following instructions assume an x64 architecture.

The instructions include a unique token. To receive a unique token for your device/equipment, please contact the [Secretariat]({% link pages/contact.md %}).

### Instructions
1. Download
```
# Create a folder
$ mkdir actions-runner && cd actions-runner
# Download the latest runner package
$ curl -o actions-runner-linux-x64-2.320.0.tar.gz -L https://github.com/actions/runner/releases/download/v2.320.0/actions-runner-linux-x64-2.320.0.tar.gz
# Optional: Validate the hash
$ echo "93ac1b7ce743ee85b5d386f5c1787385ef07b3d7c728ff66ce0d3813d5f46900 actions-runner-linux-x64-2.320.0.tar.gz" | shasum -a 256 -c
# Extract the installer
$ tar xzf ./actions-runner-linux-x64-2.320.0.tar.gz
```

2. Configure
```
# Create the runner and start the configuration experience
# <token> must be replace with a unique token provided by RSMP Nordic.
$ ./config.sh --url https://github.com/rsmp-nordic/rsmp_validator --token <token>
# Last step, run it!
$ ./run.sh
```