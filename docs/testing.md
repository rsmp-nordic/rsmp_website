# RSMP Nordic Testing Tools

## Background
Roadside Message Protocol (RSMP) is an open, modern, lightweight, flexible, and interoperable protocol for communication between traffic lights, road-side equipment and central systems from different vendors.

RSMP is maintained by RSMP Nordic, see https://rsmp-nordic.org

RSMP Nordic maintains a set of open-source tools for validating RSMP implementations. The tools can also be used as assistance during development, for testing equipment, and as building blocks for new tools.

## Tools
### RSMP Simulator
An easy-to-use Windows app that can connect to RSMP equipment or system. You can manually send messages and see what is exchanged, raise alarms, etc.

### RSMP Validator
A test system based on RSpec and written in the Ruby language, which can be used for automated testing. It include a set of tests that validate various aspects of an RSMP implementation. You can run all tests, or a selection of tests, and get a report on any errors found.

The RSMP Validator uses the RSMP Ruby gem to handle RSMP communication and message validation.
 
### rsmp (Gem)
A Ruby gem (library) which implements the RSMP protocol. It makes it easy to programmatically run RSMP sites or supervisors, send and wait for messages, etc. using Ruby.

The gem also include a simple Traffic Light Controller emulator, which implements  enough functionality to pass all tests in the RSMP Validator.

The gem include command-line tools for quickly running rsmp supervisors or sites, and log messages exchanged. You can configure port, etc.

### rsmp_schemer (Gem)
A Ruby gem (library) that makes it easy to validate RSMP messages against specific version of RSMP core and SXL JSON Schemas.

### rsmp_schema
JSON Schemas documenting the format of all RSMP messages in a machine-readable way. The schema is useful for automatically validating RSMP messsages.
There's a schema covering the Core specification, and a schema for Traffic Light Controllers. For each schema, we maintain branches for each released version.
Validating RSMP messages against the JSON Schema requires the use of a JSON Schema validation library. These exist for all major programming languages. For Ruby, you can use the rsmp_schemer gem to easily handle validation against a specific schema.

## Using the RSMP Validator
The RSMP Validator is a test system based on RSpec and written in the Ruby language, which can be used for automated testing. 

The validator currently has tests only for traffic light controllers, since this is is only standardized SXL so far. 

The validator starts an RSMP supervisor, and waits for the site (equipment) to connect. Once the site is connected, the validator will send message and wait for responses. A number of checks will be performed on the received messages to ensure that the site implements the RSMP specification correctly. All messages are checked against the RSMP JSON Schema to check that they have the correct format, attribute names, etc.

IMPORTANT: During testing, the validator will send many different commands to the site. For traffic light controllers this include commands to change signal plans, force detector logics, restart the controller, etc. For this reason you should NOT use the validator to test equipment that is in use on street.

### Prerequisites
#### Git command-line tools
Git is used to fetch and update tools, dependencies, etc. For installation instructions, see https://git-scm.com/downloads

Check that git is installed:

```sh
% git --version
git version 2.31.1
```

#### The Ruby language
It's recommended to use a Ruby version manager like https://github.com/rbenv/rbenv.

Check that Ruby is installed:

```sh
% ruby --version
ruby 3.0.0p0 (2020-12-25 revision 95aff21468) [x86_64-darwin20]
```

#### Bundler
Bundler is a poplular package manager for Ruby. For installation instructions, see https://bundler.io

Check that Bundler is installed:

```sh
% bundler --version
Bundler version 2.2.15
```

### Installing
The RSMP validator can talk to an RSMP sites on the same machine or via network via network.

If you're testing physical equipment like a traffic light controller, you will typically install the validator it on a separate machine. The site will then connect to the validator via network.

For development, it can be useful to install the validator on the same machine as the RSMP implementation your working on. The site will then connect to the validator on localhost.

1. Clone the rsmp_validator git repository:

```sh
% git clone https://github.com/rsmp-nordic/rsmp_validator.git
```

5. Use Bundler to install dependencies
```sh
% bundle 
Using concurrent-ruby 1.1.7
Using i18n 1.8.7
...
Using rspec 3.10.0
Using yard 0.9.26
Bundle complete! 4 Gemfile dependencies, 28 gems now installed.
Use `bundle info [gemname]` to see where a bundled gem is installed.
```

You will now have RSpec and all other dependencies installed.

You should use ```bundle exec```to run rspec and other commands that come from gems, to ensure you're using the correct version of the gems. See https://bundler.io/man/bundle-exec.1.html.

### Configuration
To test a site, the validator needs some information about it. For example, the validator needs to know the SXL (type of equipment), what signal plans is has, etc. Before testing, you need to puts this information into a configuration file, in YAML format.

1. Setup a configuration file for the site.
2. Modify the site RSMP configuration, so that it connect to the validator

### Running
Run tests
1. run rspec

### Documenting test results
When you run tests, RSpec will produce a report about what tests succeeded/fail. The output is printed to the console, but you can redirect it to a file if you want.

In additional to this, the validator produces a log detailing the progress of each tests. This log is located in log/validation.log

Typically, the equipment you test also produces it's own internal log.

The recommended way to document the result of a test run is to collect the following:
- Version of the validator. This includes the version, and the specific git commit.
- Version of the equipment. This mifght includes versions of relevant software and hardware.
- YAML validator config fil for the equipment tested
- RSpec output
- Validator log at log/validator.log
- Configuration of the euiqment
- Log file(s) from the equipment