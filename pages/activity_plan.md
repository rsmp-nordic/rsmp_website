---
layout: page
title: Activity Plan
permalink: /plan/
nav_order: 2
parent: Activities
---

# RSMP Nordic Activity Plan 2024-2025
Revision 2, 2024-06-06

## About
This document describes the RSMP Nordic activity and resource plan for Q3 2024 – Q3 2025.

The purpose and format of activity plans is outlined in the RSMP Charter, see <https://rsmp-nordic.org/charter>.

The previous activity plan was for the period Q3 2021 – Q3 2022. We got a lot of the planned activities completed, but other activities were delayed or postponed due to an extended sick leave of Emil Tin in the Tech Board and Secretariat.

This activity plan therefore picks up from the previous activity plan. It starts from Q3 2024, and as usual covers a one-year period.

## Summary
There is significant use of RSMP in Finland, and partners Fintraffic and the City of Oulu have now joined the Steering Group.

After a constructive dialogue with French road authorities and industry it looks increasingly likely that France will adopt RSMP. This could be a big leap forward for RSMP. The French Department of Transport, and CEREMA, Centre for Studies and Expertise on Risks, the Environment, Mobility and Urban Planning have joined the steering group as guests.

A growing number of suppliers support RSMP in their equipment and systems, but in the Nordic region, the market for traffic light controllers is still dominated by a single vendor.

We will continue to maintain and develop the RSMP 3 specifications and the supporting testing tools, to meet the needs of road authorities.

A concept for a future RSMP 4 built on top of the internet-of-things protocol MQTT looks promising and could bring major benefits. But it would require new implementations in equipment and systems.

Road authorities are looking for easier and more flexible ways to program their traffic lights. RSMP Nordic will work on an open and vendor-neutral specification for signal programs, as a stepping-stone towards vendor-neutral tools and workflows.

Many partners would like to see official certification of RMSP equipment and systems, because it could make it easier for them to tender, implement and maintain the road-side equipment and central systems. Existing initiatives related to future RSMP certification in France could perhaps be built on or used as inspiration.

RSMP could potentially grow into a European protocol, and there could be opportunities for EU-funding. This is a strategic question for the Steering Group to consider.

## Steering Group
Partners from each country choose their two representatives, according to the RSMP Nordic Charter. The RSMP charter allows 11 members in the steering group, and it will have 10 in the upcoming period.

### Sweden
Swedish Transport Administration  
City of Stockholm

### Denmark
Danish Road Authority  
City of Copenhagen

### Norway
Norwegian Public Roads Administration  
City of Oslo

### Finland
Fintraffic  
City of Oulu

### France
Department of Transport  
CEREMA

## Appointments
Members of the Technical Board and Secretariat are appointed by the steering group.

Participation in working groups does not require appointment by the steering group.

## Technical Board
- David Otterdahl, Swedish Transport Administration.
- Emil Tin, City of Copenhagen.
- Rafael Couto Figueiredo, Danish Road Directorate.
- Stefan Sparv, City of Stockholm.

## Secretariat
- David Otterdahl, Swedish Transport Administration.
- Emil Tin, City of Copenhagen.
- Dia Bækgaard Pedersen, City of Copenhagen.
- Jørgen Remme Tresse, City of Oslo.

## Resources

### Sweden
Swedish Road Authority, 12 hours/week.  
City of Stockholm, 2 hours/week.

### Denmark
City of Copenhagen, 12 hours/week.  
Danish Road Authority, hours to bedetermined.

### Norway
Norwegian Public Roads Administration, hours to be determined.  
City of Oslo, 4 hour/week.

### Finland
Fintraffic, hours to be determined.  
City of Oulu, hours to be determined.

### France
French Department of Transport, hours to be determined.  
CERAMA, hours to be determined.

## Activities

### Develop the RSMP Core Specification

The core part of the RSMP specification defines the basic message structure and behavior that is common for all types of equipment.

#### Release Core Specification 3.2: completed

#### Release Core Specification 3.2.1: completed

#### Release Core Specification 3.3: ongoing

Work is ongoing and a release is planned for October 2024.

#### Draft for Core Specification 4.0: ongoing

In the previous activity period, we have investigated different technical concepts for a potential future RSMP 4.

Building RSMP 4 on top of MQTT looks promising. MQTT is a widely used internet-of-things protocol and provides a battle-hardened transport layer which could solve many of the issues we have seen with RSMP 3 related to connection sequence, message acknowledgement, etc.

MQTT uses a broker architecture, which makes it easy to have multiple supervisors/central systems. There is many existing 3rd party MQTT tools, e.g. for brokers, inspecting traffic or persisting data to a database.

MQTT binary payloads can help reduce bandwidth. MQTT can be run over QUIC, which is a newer alternative to TCP, with better performance and build-in TLS encryption.

We have produced a working proof-of-concept that exchange RSMP 4 messages via MQTT.

We will continue the work based on the assumption that RMSP 4 would be built on top of MQTT:

- Clarify remaining technical design questions.
- Get more feedback from vendors and road authorities.
- Map existing TLC SXL to RSMP 4 modules and messages.
- Extend our existing proof-of-concept to handle the full TLC SXL.

The goal is to provide a recommendation to the steering group on whether and when to move ahead with Core 4.0 or focus on more conservative releases of the 3.x series.

#### Core Security: new

There’s a growing focus on security in the operation of road-side equipment, and there are more and more requirements and regulations in this area.

We will make RSMP stay up-to-date and can meet all EU/national regulations.

An important aspect is encrypting messages, to prevent eavesdropping or manipulation of messages.

RSMP already supports TLS (transport layer security) which is the mechanism used to secure e.g. HTTPS and VPNs. However, TLS requires managing and renewing certificates, which is currently seen as a challenge when it comes to road-side equipment.

France is currently working on proposals related to encryption in HTML.

We would like to support end-to-end encryption in RSMP in a way that is practical to implement and manage by road authorities, either by not needing TLS certificates, or by having a convenient way to manage and update certificates.

### Develop the SXL for Traffic Light Controllers

The SXL for traffic light controller specification defines what messages can be exchanged with TLCs, e.g., message for changing signal plan, fetch traffic data, etc.

#### Release SXL for Traffic Light Controllers 1.1: completed

#### Release SXL for Traffic Light Controllers 1.2: completed

#### Release SXL for Traffic Light Controllers 1.2.1: completed

#### Release SXL for Traffic Light Controllers 1.3: ongoing

A more substantive release. Tentative release schedule is October 2024.

#### Integration with LISA: cancelled

We had a promising dialog with Schlotthauer & Wauer (the makers of the LISA) about how to add RSMP support in LISA, so that LISA signal programs could be transferred to the controller via RSMP.

But after SWARCO purchased Schlotthauer & Wauer, the dialogue stalled, and we were informed that they no longer intend to support RSMP in LISA. In the spring of 2023 SWARCO informed road authorities that they will no longer sell LISA in the Nordic region.

Considering this, work on getting RSMP support in LISA has been aborted.

The question of how traffic light signal programming can be made easier, cheaper, and more flexible for road authorities is still very important, and we propose a new activity focused on signal programming, see below.

### Traffic Light Programming

There is a big need for making traffic light controller signal programming easier, cheaper, and more flexible for road authorities.

This need has been an important driver for the growth of LISA in Denmark.

However, LISA is a proprietary solution. Relying on proprietary formats and software comes with risks, as demonstrated by SWARCOS recent decision to stop selling LISA in the Nordic region.

In the Nordic Region, road authorities have traditionally been reluctant to impose standardization on signal programming. Instead, each vendor has their own proprietary formats and tools, which is one of the main reasons signal programming causes so many challenges for road authorities.

In other regions, e.g. France, signal programming is much more standardized by road authorities.

RSMP has so far not really had a vision for how to meet the need for easy signal programming. But an open and vendor-neutral RSMP specification for signal programs could open the possibility for vendor-neutral tools and workflow for signal programming, open-source tools, etc.

An RSMP specification for signal programs would be a description of the file format, structure and parameters that describe a traffic light signal program.

#### Describe Needs: new

Collect and prioritize the needs of road authorities when it comes to signal programming. Needs vary by country, but we will look for common challenges and opportunities.

#### Signal Program Specification 1.0: new

Define a specification for signal programs. What use-cases must be covered, and how? Start with a minimal specification that includes just fixed-timed programs. Later this can be extended to cover traffic actuated control, fully adaptive, etc.

#### Roadmap: new

Investigate how we could move from having a specification to having tools and equipment in production. We will consider funding, incentives for vendors, pilot projects, tendering strategies, etc. and provide recommendations.

### Develop SXLs for Other Types of Equipment

RSMP can be used for many different types of equipment, and this is indeed already the case in many cities. However, only the SXL for Traffic Light Controllers have been standardized by RSMP Nordic, all other uses of RSMP for other types of equipment rely on custom SXLs. This means every project reinvents the same type of messages, and that equipment and systems using these custom SXLs are incompatible.

#### Release SXLs for other types of equipment: ongoing

We decided to first focus on Variable Messages Signs (VMS).

There are many different types of variable messages signs. We have collected a list of the use-cases we want to support. Based on this we have created a technical concept that we will now get feedback on from vendors and then detail.

Work have been initiated on an SXL for traffic counters.

Work on an SXL for IO-devices have not yet been started.

Next steps will be to:

- Get feedback on the VMS SXL and refine it.
- Continue work on the Traffic Counter SXL.
- Coordinate with work on a potential RSMP 4.

### Testing Tools

#### RSMP Validator

The RSMP Validator is a modular stack containing several components that can be reused:

- RSMP Schema: JSON Schema for automatic validation of the format of RSMP message. Includes a Ruby gem that handles validation of RSMP message against different version of the specification.
- RSMP Gem: library and command-line-tools for working with RSMP communication.
- RSMP Validator: testing tool based on RSpec, for automatic testing.

#### Release version 1.0 of the Validator components: ongoing

Release of the RSMP gem and schemas in version 1.0 was planned for the previous activity period but has been moved to Q2 2024.

#### Release version 1.0 of the Validator: ongoing

The validator is currently in version 0.1, which signifies that many things have changed frequency as the design has been developed.

Any remaining rough edges should be fixed, and the validator should be released as version 1.0 with sufficient documentation.

Expected release in Q2 2024.

Working/user group meetings should be organized, to inform about how the validator can be used to enhance quality and interoperability of RSMP implementations, and to help road authorities assess the completeness and quality of delivered equipment and systems.

#### Tooling for documenting test results: ongoing

We now publish test results on <https://rsmp-nordic-org>, but the format is still basic, and we would like to expand it.

We propose to work on a way to certify equipment, perhaps inspired by ongoing work in France, see elsewhere in this document.

#### Expand the validator Test Hub: ongoing

It has been a challenge to get vendors to keep their test equipment online and available for testing. We’re in dialogue with SWARCO Technology about their equipment. We’re also in dialogue with Yunix, Kapsch and other vendors.

#### RSMP Simulator

The RSMP simulator is an interactive GUI based tool for Windows that can be used for testing any type of equipment or supervision system that implements RSMP.

#### Release a new version: ongoing

Several new versions have been released, to keep the software up to date with the core and SXL releases.

#### Certification

A way to certify equipment and systems would make it easier for road authorities to tender and buy equipment and systems with the knowledge that everything is compatible.

The RSMP specification itself should ensure that things are interoperable, but challenges can arise if suppliers don’t implement according to the specification, or parts of the specification turn out to be ambiguous.

A certification could also be attractive to suppliers, as an official “green stamp” can help them promote their products.

The question is how such a certification could be organized.

In France, a national body has been tasked with certifying RSMP products. Perhaps RSMP Nordic could be inspired by this work, or the French initiative could somehow be the start of a European RSMP certification.

#### Describe needs and challenges related to RSMP certification: new

Talk with road authorities and suppliers to understand the need, challenges and opportunities regarding RSMP certification.

Talk with French partners about their initiative regarding RSMP certification.

#### Research how an RSMP certification could be organized: new

Describe potential scenarios for how certification would be organized and run. What partners, funding, etc. would be involved? Are there relevant regulations/laws/standardization to observe?

#### Look into how existing testing tools and the test hub could be utilized: new

The existing testing tools could probably be utilized. We’ll consider how these tools can be utilized, expanded, or otherwise provide value. And/or whether new tools are needed.

## Communication

A strong partnership around RSMP will benefit all partners, by providing more resources and knowledge sharing.

A strong partnership will be based on committed partners that understand the value and potential in an open protocol for communication with roadside equipment.

Expanded use of RSMP by road authorities can help attract new suppliers and increase competition, which can in turn help lower prices and provide increased options and flexibility for road authorities.

New suppliers supporting RSMP will likewise increase competition.

Expanding the RSMP eco-system depends on several factors including the RSMP specification and the organization behind it, the range and quality of RSMP implementations, as well as documentation and communication. Sharing RSMP success stories, the visions behind it is in the benefit of the RSMP Nordic partnership, which is why communication should not be ignored.

### Refine the rsmp-nordic.org website: ongoing

Additional info was added, pages edited, etc. Keeping the website updated is a continuous activity.

### Tell about RSMP and RSMP Nordic at conferences, webinars, etc.: ongoing

We gave a presentation at an important national conference in Paris on road equipment, attended by all relevant French authorities and vendors. The central topic of the conference was the adoption of RSMP in France.

We will continue to attend relevant conferences to inform about RSMP, when possible.

### Organize RSMP Nordic User Group meetings: ongoing

The user group in ongoing and meets online every second week. We propose delegating the facilitation to a new partner.

### Invite relevant road authorities: ongoing

Finland have joined Steering Group, represented by Fintraffic (national) and Oulu (municipal).

France is getting closer to adapting RSMP nationally and have been invited to the Steering Group as guest members, represented by the Department of Transportation and CEREMA (Centre for Studies on Risks, the Environment, Mobility and Urban Planning).

### Encourage new suppliers to support RSMP: ongoing

Yunix are working on supporting RSMP in their TLCs and have been selected to provide equipment in Norway.

La Semaphorica have implemented RSMP in their TLCs.

Lacroix have implemented RSPM in their TLCs.

Several French vendors are involved in the work of adapting RSMP in France.

Intetra from Turkey are working on supporting RMSP in their TLCs.

A new Finish company LightMotion is working on traffic light controllers with RSMP.

We will continue to provide information that makes it easy and attractive for new suppliers to implement RMSP in their products. This includes both equipment and supervisor systems.

### Engage in Nordic and European standardization activities: ongoing

RSMP is not alone. There are other protocols, standards and initiatives that overlap with RSMP. We should engage in European initiatives to ensure that we understand the trends and possibilities in this space, as well as inform others about our needs and visions. This will help us ensure that RSMP plays a meaningful role and will provide value to road authorities now and in the future.

The Swedish Transport Administration participates in NordicWays 3 which is engaged in standardization of ITS in the Nordic region.

French partners have a strong representation in EU-groups on standardization. France has mentioned the possibility of working towards RSMP as an EU-standard. This is a strategic question that we would like to invite the steering group to consider.

### Strategic communication: new

We should get better at telling the RSMP success stories, how much it's used, etc. This includes internal communication.

- Discuss internal communication with partners to ensure we align on strategies regarding open and vendor-neutral protocols and tools.
- Maintain the RSMP Nordic website with up-to-data information about benefits, existing use, etc.
- Use important channels, like LinkedIn to share information about RSMP to current and potential users of RSMP.

### Yearly RSMP Symposium

Arrange a yearly physical meet-up, with presentations, workshops, etc. We previously arranged two successful RSMP Symposiums and should do it again and make it a yearly occurrence event.

It can perhaps happen during Intertraffic, ITS Europe or other big European conferences.

## EU-Funding

Because RSMP Nordic is a Nordic/European partnership, there should be many opportunities for EU-funding.

EU-funding could help accelerate our work, for the benefit of road authorities.

We previously received funding from EU-Interreg, to establish our RSMP Nordic partnership.

EU-funding requires investing time upfront. We need to identify suitable activities and the right funding opportunities and write applications. If we receive funding, there are administrative tasks. But overall, it could be a great opportunity.

We should draw on the experience and skills we already have in this area.

### Identify opportunities: new

Identify projects and funding opportunities and figure out which ones best fit our needs. Find partners that have experience and can help.

### Write applications: new

Getting funding depends on writing a good application. We can either do it ourselves, or involve partners that specialize in this like IMEC.

### Implementation: new

If we receive funding, we need a setup that ensures implementation, reporting, etc.

## Administration

Administrative tasks will be handled by the secretariat.

### Maintain membership list: ongoing

The list is being maintained by the secretariat, currently by the City of Copenhagen.

### Facilitate Steering Group meetings: ongoing

There has been gaps in the meetings, due to the extended sick leave of Emil Tin, but they are now running again.

### Facilitate User Group meetings: ongoing

Continue to organize and facilitate RSMP User Group meetings, where all users of RSMP can exchange knowledge and experience related to RSMP.

### Look into opportunities for additional EU funding: ongoing

We have briefly looked at some options but did not find good matches. There are probably many opportunities, e.g. from EU programs, especially if we start having a broader European use and partner group.
