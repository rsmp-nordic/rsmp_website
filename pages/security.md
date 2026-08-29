---
layout: page
title: Security
permalink: /documentation/security/
nav_order: 3
parent: Documentation
---

# Security responsibilities

Security in an RSMP deployment is a shared responsibility. RSMP Nordic defines
the protocol and maintains supporting documentation and tools. It does not
design, operate, approve, or secure individual deployments.

Using RSMP does not by itself make a system secure. Security depends on the
RSMP version and communication protection in use, the quality of each
implementation, and how the complete system is commissioned and operated.

## What the RSMP specifications cover

The [RSMP specifications]({% link pages/specification.md %}) define message
formats, protocol behaviour, and interoperability requirements. They also state
the security properties, assumptions, and limitations of security mechanisms
that are part of a specification.

RSMP Core does not provide communication security. A deployment can protect
the TCP connection carrying RSMP by using an external mechanism such as TLS or
a VPN. This does not change RSMP messages or protocol behaviour. A separate
RSMP security profile may define additional protection, authentication, or
authorization. Its security properties apply only when the profile is
implemented, configured, and enabled as specified.

The versioned specifications are authoritative. This page explains who is
responsible for applying them.

## Security mechanisms and status

RSMP can be used with different communication protection. The protection in
use must be agreed for each deployment and configured consistently at both
endpoints.

| Option | Status | Security properties | Published test coverage |
| --- | --- | --- | --- |
| RSMP over unprotected TCP | Base transport defined by RSMP Core | No cryptographic confidentiality, message integrity, or peer authentication | RSMP Core and SXL protocol behaviour |
| RSMP over TLS | External deployment option outside RSMP Core | Can provide confidentiality, integrity, and certificate-based authentication between the endpoints that terminate TLS | No TLS-specific conformance claim is currently published |
| RSMP through a VPN | External deployment option outside RSMP Core | Can protect communication between the VPN endpoints. The properties depend on the VPN technology and configuration | No VPN-specific conformance claim is currently published |
| Application-level end-to-end encryption | Draft, expected to be included in an upcoming RSMP Core 3.x release | Intended to protect RSMP message content between application endpoints. Details may change before release | No conformance claim is currently published |

Neither TLS nor a VPN changes the RSMP protocol. TLS protects an individual
TCP connection between its TLS endpoints. A VPN protects network traffic
between its tunnel endpoints. If a VPN terminates at network gateways, traffic
outside the tunnel is not protected by the VPN and must be considered
separately.

External protection must not be presented as an RSMP security profile unless
it is defined by a released RSMP specification. The current status of
specifications is listed on the [Specification page]({% link
pages/specification.md %}).

Draft mechanisms are not part of the current RSMP standards. Their design and
target release may change before publication.

## Responsibilities

| Area | RSMP specifications | RSMP Nordic | Road authorities and suppliers |
| --- | --- | --- | --- |
| Protocol behaviour | Define messages, state transitions, and interoperability requirements | Maintain and version the specifications | Select appropriate versions and implement them correctly |
| Communication protection | State that Core does not provide communication security and define any separate RSMP security profiles | Maintain approved profiles and clarify their security properties | Select, configure, and operate suitable protection for each deployment |
| Credentials and keys | Define protocol-visible formats and behaviour where applicable | Provide specifications, examples, and conformance material | Provision, store, renew, revoke, back up, and recover credentials and keys securely |
| Implementations | Define conformance requirements | Maintain agreed reference tools and tests | Use secure development practices, protect secrets, manage dependencies, and provide security updates |
| Devices and networks | State assumptions that affect protocol security | Explain how RSMP interacts with relevant security controls | Secure devices, operating systems, firmware, networks, remote access, and physical installations |
| Operations | Define protocol-visible errors and required failure behaviour | Document the intended protocol behaviour | Monitor systems, respond to incidents, maintain availability, and recover safely |
| Assurance and compliance | Define what it means to conform to a particular RSMP specification | Coordinate review of reported protocol issues | Perform risk assessments, audits, certification, and regulatory compliance as required |

### RSMP Nordic

RSMP Nordic is responsible for:

- maintaining open, versioned RSMP specifications
- describing the security properties, assumptions, and known limitations of
  protocol features and approved security profiles
- correcting identified weaknesses in the specifications
- providing RSMP-specific implementation and integration guidance
- maintaining agreed schemas, test tools, test vectors, and other conformance
  material within their documented scope
- coordinating technical discussion about security changes to RSMP.

The RSMP Nordic [charter]({% link pages/charter.md %}) describes how decisions
about the protocol and supporting tools are made.

RSMP Nordic tools can help determine whether an implementation follows tested
parts of a specification. Passing those tests is not a security certification
of a product or deployment.

### Road authorities and system owners

The organization responsible for a deployment must:

- assess risks and define the required security and safety properties
- choose appropriate RSMP versions and communication protection
- define identities, authorization policy, and trust relationships
- ensure that credentials and keys are provisioned and managed securely
- establish requirements for suppliers, networks, monitoring, maintenance,
  incident response, and recovery
- ensure compliance with applicable laws, regulations, and organizational
  policies.

### Suppliers and implementers

Suppliers and implementers must:

- implement the selected RSMP specifications and security profiles correctly
- validate all input and fail safely when protocol or security checks fail
- protect private keys, credentials, configuration, logs, and other sensitive
  data
- secure the device, application, operating system, dependencies, update
  mechanism, and administrative interfaces
- document security-relevant configuration, assumptions, and operational
  requirements
- provide a process for reporting, correcting, and distributing fixes for
  vulnerabilities in their products.

Exact contractual responsibilities must be agreed between the road authority,
system owner, system integrator, operator, and suppliers. RSMP Nordic does not
certify products, approve deployments, operate networks, manage deployment
credentials, or accept the security or safety risk for a deployed system.

## Reporting a security issue

Do not open a public issue for a suspected vulnerability before it has been
assessed. Contact the RSMP Nordic Board using the details on the
[Contact page]({% link pages/contact.md %}).

Include the affected specification, tool, and version, the potential impact,
steps or material needed to reproduce the issue, and whether the information
has already been shared publicly. Do not include private keys, production
credentials, personal data, or other secrets unless a protected transfer has
been agreed with the Board.

The Board coordinates the initial assessment with the relevant maintainers and
decides how specification corrections, tool updates, and public disclosure are
handled. Product-specific vulnerabilities remain the supplier's
responsibility. Active deployment incidents must also be handled immediately
by the responsible system owner and operator.

## Supported versions and security corrections

RSMP Nordic develops and corrects the current drafts and the latest released
versions of RSMP Core and RSMP Nordic SXL specifications. Older releases remain
available for interoperability but do not normally receive corrections.

If an issue affects older versions, RSMP Nordic will identify the affected
versions and state whether a correction is provided or users must upgrade.
Draft versions can change without backward compatibility before release.

## Recommended requirements for TLS deployments

RSMP Core does not define a TLS security profile. When TLS is selected, its
requirements must be agreed as part of the deployment. RSMP Nordic recommends
that purchasers and system owners require the following. These are general
deployment recommendations, not RSMP Core conformance requirements.

- TLS 1.3 as the minimum permitted version
- certificate-based authentication of both endpoints, with validation against
  configured trust anchors and expected peer identities
- rejection of invalid, expired, revoked, or otherwise untrusted certificates
- authorization that binds the authenticated certificate identity to the
  expected RSMP peer and site identity
- failure without fallback to an unprotected connection if TLS establishment
  or validation fails
- secure provisioning, storage, renewal, revocation, backup, and recovery of
  certificates and private keys
- protection of the complete communication path, taking account of every TLS,
  proxy, gateway, and VPN termination point.

Applicable law, organizational security policy, and purchaser requirements
take precedence over these general recommendations. System owners and
suppliers are responsible for agreeing, implementing, and operating the TLS
configuration.

## Security testing and limitations

The [RSMP Validator](https://rsmp-nordic.github.io/rsmp_validator/) and
[Test Hub]({% link pages/testhub.md %}) primarily test RSMP message structure,
connection flow, and selected application behaviour. RSMP Nordic does not
currently run tests related to TLS or draft security profiles. Published test
results therefore make no claims about transport security or security-profile
conformance. Other limitations of the published results are described on the
[Compliance page]({% link pages/compliance.md %}).
