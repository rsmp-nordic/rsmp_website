---
layout: page
title: Activity Plan
permalink: /plan/
nav_order: 2
parent: Activities
---

# RSMP Nordic Activity Plan 2025–2026
Revision 4, 2025-10-02

## About
This document describes the RSMP Nordic activity and resource plan for Q3 2025 – Q3 2026. As usual it covers a one‑year period.

The purpose and format of activity plans is described in the RSMP Charter, see <https://rsmp-nordic.org/charter>.

## Summary

### Status
A lot of important work was completed in the previous activity period, including on the Core and TLC spec, the RSMP 4 recommendation and traffic light controller (TLC) programming.

However, we have been stretched for hours, because we did not secure EU funding yet and the Swedish Transport Administration reduced their number of hours. This means some activity tasks are delayed.

- We applied for funding from Nordic Innovation which unfortunately did not come through.
- Use of and support for RSMP grows. Several new traffic light controller manufacturers now support RSMP and have connected to the RSMP test hub.
- French partners are continuing their work on adopting RSMP nation‑wide. They have provided valuable input to the Core working group, which has resulted in several important improvements to the upcoming 3.3.0 release. This will make RSMP more flexible and robust and will support adoption in France.
- French partners are also working on their proposal for end‑to‑end encryption. As the proposal is not ready, we will not have time to include this feature in Core 3.3.0. Pending further discussion, it might be integrated into a later Core version.
- Work on an open and vendor‑neutral specification for traffic light programs is ongoing with positive contributions from manufacturers and road authorities. Programming controllers is done differently across Europe, but we have identified the key control strategies that we need to support.
- A recommendation for RSMP 4 built on top of the internet‑of‑things protocol MQTT has been produced. It can bring significant benefits and make implementation and maintenance easier, but developing the full specification and test tools will require time and resources.

### Proposal
- The top priority in the upcoming period will be to get funding for accelerating our work. We will form a task force within the Secretariat specifically with this focus.
- No new major task has been added to the activity plan, except small follow‑up patch releases of the Core and TLC SXL specifications in 2026.
- Until we ensure funding, the pace of some working groups and tasks will slow down, but we will ensure progress on core tasks like maintaining the existing spec and test tools.
- We propose moving ahead with RSMP 4 by gathering additional feedback from European road authorities and manufacturers, to ensure broad support. We will also start estimating the resources needed for developing the full specification and test tools.

## Steering Group
The partners from each country choose two representatives, according to the RSMP Nordic Charter. The RSMP charter allows 11 members in the steering group, and it will have 10 in the upcoming period.

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

According to the RSMP Nordic Charter, French partners are invited as guests to the steering group.

## Appointments
Members of the Technical Board and Secretariat are appointed by the steering group. Participation in working groups does not require appointments by the steering group.

### Technical Board
- David Otterdahl, Swedish Transport Administration.  
- Emil Tin, City of Copenhagen.  
- Juho Neuvonen, Fintraffic. (new)

### Secretariat
The secretariat is appointed by the Steering Group.
- David Otterdahl, Swedish Transport Administration.  
- Emil Tin, City of Copenhagen.  
- Dia Bækgaard Pedersen, City of Copenhagen.  
- Tanjamaria Ballhorn, City of Copenhagen. (new)  
- Dimos Kyriakou, City of Oslo. (new)

## Resources
30 hours/week has been pledged in total. A few additional partners are expected to pledge hours, but the number is not yet known.

| Country | Organization | Committed hours/week |
|---|---|---:|
| Sweden | Swedish Road Authority | 6 |
| Sweden | City of Stockholm | 2 |
| Denmark | City of Copenhagen | 12 |
| Norway | Norwegian Public Roads Administration | To be determined |
| Norway | City of Oslo | 4 |
| Finland | Fintraffic | 2 |
| Finland | City of Oulu | 2 |
| France | Ascquer | 2 |
| France | French Department of Transport | 2 |
| France | CEREMA | 4 |

## Activities

### Develop the RSMP Core Specification
The core part of the RSMP specification defines the basic message structure and behaviour that is common for all types of equipment.

#### Release Core Specification 3.3.0 — ongoing
Work is far along and a release is expected in 2025 Q4. 3.3.0 is a significant update with many important additions and clarifications, including improvements which make RSMP more flexible and robust, and supports adoption in France.

#### Release Core Specification 3.3.1 — new
A patch release with small fixes and clarifications, expected in the second half of 2026.

#### Core 4.0 recommendation — completed
We investigated many technical questions, got more feedback from manufacturers and authorities and investigated how the existing TLC SXL can be migrated. Based on this we have produced a recommendation to the steering group for moving ahead with RSMP 4 development while keeping RSMP 3 maintained.

#### Core 4.0 Roadmap — ongoing
We will gather additional feedback from a wider range of European road authorities and manufacturers to ensure broad support. If this is positive, we will proceed with more detailed planning, including ensuring adequate funding for development. If the steering group at that point decides to go ahead, the full specification must be developed, supported by test tools. This work is expected to take 1–2 years.

#### Core Security — ongoing
France is still working on proposals related to end‑to‑end encryption in RSMP, and French research institutions have provided feedback and suggestions for improvements. We will not be able to include end‑to‑end encryption in the upcoming Core 3.3.0 release, since the proposal is not ready yet and it will require discussion. Instead, it might be included in a later release, pending further discussion.

### Develop the SXL for Traffic Light Controllers
The SXL for traffic light controller specification defines what messages can be exchanged with TLCs, e.g., messages for changing signal plan, fetching traffic data, etc.

#### Release SXL for Traffic Light Controllers 1.3 — ongoing
A release with several improvements and many clarifications, expected in 2025 Q4.

#### Release SXL for Traffic Light Controllers 1.3.1 — new
A follow‑up patch version with small fixes and clarifications. Expected in the second half of 2026.

### Traffic Light Programming
There is a big need for making traffic light controller signal programming easier, cheaper, and more flexible for road authorities. An open and vendor‑neutral RSMP specification for signal programs can open the possibility for vendor‑neutral tools and workflow for signal programming, open‑source tools, etc.

#### Describe Needs — ongoing
We have had extensive dialogue with road authorities to understand how they work with programming traffic light controllers. There is a wide range of strategies, methods and tools in use across Europe. We have identified a key set of control strategies that would cover most needs: fixed‑timed, stage‑based, group‑based and policy‑based. We have defined and described expected workflows and elements like programs, configurations and editors.

#### Signal Program Specification 1.0 — ongoing
We have created an early draft for fixed‑time programs and have built a prototype TLC emulation tool that can run them. Fixed‑time programs include the ability to coordinate intersections and adjust offset‑times gradually over time. We are working on an early draft for stage‑based programs. We are currently investigating group‑based control, which is even more flexible than stage‑based, but also more complicated to specify. We have also discussed policy‑based control strategies, also known as fully adaptive programs.

#### Roadmap — delayed
At a later point we must consider funding, incentives for vendors, pilot projects, tendering strategies, etc., and provide recommendations.

### Develop SXLs for Other Types of Equipment
RSMP can be used for many different types of equipment, and this is indeed already the case in many cities. However, only the SXL for Traffic Light Controllers has been standardized by RSMP Nordic; all other uses of RSMP for other types of equipment rely on custom SXLs. This means every project reinvents the same type of messages, and that equipment and systems using these custom SXLs are incompatible.

#### Release SXLs for other types of equipment — ongoing
We decided to first focus on Variable Message Signs (VMS). We have created a flexible concept for VMSs optionally using HTML as a flexible, powerful and well‑established way to work with layout and placement of elements. It also provides an excellent way to handle dynamic content by using JavaScript. Next step will be to design the full SXL.

We also worked on an SXL for sensors. A more flexible and efficient way to aggregate and stream data would be useful, which might be easier to achieve with a potential RSMP Core 4. Work on this SXL is therefore awaiting decisions on RSMP 4.

### Testing Tools

#### RSMP Validator
The RSMP Validator has been in real‑world use for years. Releasing version 1.0 is therefore more a matter of signalling that it is stable, than actual code changes. However, we do want to make sure that tools are modernized and well‑documented for the release of version 1.0.

#### Release version 1.0 of the Validator components — ongoing
A release was planned for first half of 2025 but has been pushed to first half of 2026 due to priority on other tasks.

#### Release version 1.0 of the Validator — delayed
A release was planned for first half of 2025 but has been pushed to first half of 2026 due to priority on other tasks.

#### Tooling for documenting test results — delayed
Work has been delayed due to prioritization of other tasks.

#### Expand the validator Test Hub — ongoing
Use of the test hub by manufacturers has grown. We now have equipment and systems from Cross, Kapsch, La Semaforica, Lightmotion, SWARCO, Technolution and TECSEN connected. We will keep working to get more manufacturers to connect, e.g. TLC manufacturers Yunex and ASIST, as well as suppliers of traffic management systems.

#### RSMP Simulator
The RSMP simulator is an interactive GUI‑based tool for Windows that can be used for testing any type of equipment or supervision system that implements RSMP.

#### Release a new version — ongoing
New versions will be released to support upcoming Core and TLC SXL specification releases.

### Certification
A way to certify equipment and systems would make it easier for road authorities to tender and buy equipment and systems with the knowledge that everything is compatible.

In France, a national body has been tasked with certifying RSMP products. We have had initial dialogue with French partners about how we could build on this, as well as the existing RSMP Nordic test tools and infrastructure, to establish a European RSMP certification.

#### Describe needs and challenges related to RSMP certification — ongoing
Talk with road authorities and suppliers to understand the need, challenges and opportunities regarding RSMP certification. Talk with French partners about their initiative regarding RSMP certification.

#### Research into how an RSMP certification could be organized — delayed
Describe potential scenarios for how certification would be organized and run. What partners, funding, etc. would be involved? Are there relevant regulations/laws/standardization to observe?

#### How existing testing tools and the test hub could be utilized — delayed
The existing testing tools could probably be utilized. We will consider how these tools can be utilized, expanded, or otherwise provide value. And/or whether new tools are needed.

### Communication
A strong partnership around RSMP will benefit us all, by providing more resources, knowledge and network.

A strong partnership will be based on committed partners that understand the value and potential in an open protocol for communication with roadside equipment.

Expanded use of RSMP by road authorities can help attract new suppliers and increase competition, which can in turn help lower prices and provide increased options and flexibility for road authorities.

New suppliers supporting RSMP will likewise increase competition.

Sharing RSMP success stories and the visions behind it are in the benefit of the RSMP Nordic partnership, which is why communication should not be ignored.

#### Refine the rsmp-nordic.org website — ongoing
The compliance page was expanded. Keeping the website updated is a continuous activity.

#### Tell about RSMP and RSMP Nordic at conferences, webinars, etc. — delayed
We have not had time to attend conferences in the previous activity period.

#### Organize RSMP Nordic User Group meetings — ongoing
The user group is ongoing and meets online every second week, organized and facilitated by City of Oslo.

#### Invite relevant road authorities — ongoing
We have had tentative talks with Spanish manufacturers about the protocol situation in Spain. There are ongoing projects with RSMP in Croatia.

#### Encourage new suppliers to support RSMP — ongoing
A new Finnish company Lightmotion have added RSMP support to their new traffic light controller Satellite and have connected it to the test hub. Yunex and ASIST are also adding RSMP support to their controllers and we are encouraging them to connect to the test hub. We will continue to provide information that makes it easy and attractive for new suppliers to implement RSMP in their equipment and systems.

#### Engage in Nordic and European standardization activities — delayed
The Swedish Transport Administration participates in NordicWays 3 which is engaged in standardization of ITS in the Nordic region, and RSMP. French partners have a strong representation in EU groups on standardization. France has mentioned the possibility of working towards RSMP as an EU standard. However, we have not been able to push RSMP forward as a standard in Europe yet.

#### Strategic communication — delayed
We should still get better at telling the RSMP success stories, how much it is used, etc. This includes internal communication.
- Discuss internal communication with partners to ensure we align strategies regarding open and vendor‑neutral protocols and tools.
- Maintain the RSMP Nordic website with up‑to‑date information about benefits, existing use, etc.
- Use important channels like LinkedIn to share information about RSMP to current and potential users of RSMP.

We have not had time to work on this in the previous activity period.

#### Yearly RSMP Symposium — delayed
Arrange a yearly physical meet‑up, with presentations, workshops, etc. We previously arranged two successful RSMP Symposiums and should do it again and make it a yearly occurring event. We did not have time to plan and execute an RSMP Symposium in the previous activity period.

### EU‑Funding
Because RSMP Nordic is a European partnership, there should be many opportunities for EU funding. EU funding could help accelerate our work, for the benefit of road authorities.

In the previous activity period, we applied for funding from Nordic Innovation, but unfortunately it did not go through. Ensuring EU funding will be a top priority in the upcoming period.

#### Identify opportunities — ongoing
Identify projects and funding opportunities and figure out which ones best fit our needs. Find partners that have experience and can help. Greater Copenhagen EU Office is helping to screen for suitable EU programs that we can apply to.

#### Write applications — delayed
Getting funding depends on writing a good application. We can either do it ourselves or involve partners that specialize in this like IMEC. We did apply for funding from Nordic Innovation, which did not go through. Once we identify other suitable programs we will apply.

#### Implementation — delayed
If/when we receive funding, we need a setup to ensure efficient implementation, reporting, etc.

### Administration
Administrative tasks will be handled by the Secretariat.

#### Maintain membership list — ongoing
The list is being maintained by the secretariat.

#### Facilitate Steering Group meetings — ongoing
The Steering Group now meets twice per year. The Board prepares a proposal for the new activity plan.

#### Facilitate User Group meetings — ongoing
Continue to organize and facilitate RSMP User Group meetings, where all users of RSMP can exchange knowledge and experience related to RSMP, as well as ask questions.
