---
layout: page
title: About
nav_order: 1
---

![RSMP banner](/assets/images/rsmp_nordic_banner.jpg)

# A Nordic Approach to Roadside Equipment
{: .fs-10}
RSMP is an open and [modern protocol]({% link pages/documentation.md %}) for communication between traffic lights, road side equipment and central monitoring and traffic management systems.

RSMP is maintained by the [RSMP Nordic partnership]({% link pages/activities.md %}) of Nordic road authorities and has no license fees. It's supported by [open-source tools]({% link pages/tools.md %}) for development and validation.

Because RSMP is open and vendor-neutral protocol, road authortities are free to mix equipment and systems from different suppliers.

This can often lead to more efficient and stable system maintenance. For example, a single supervisor system can be used to manange equipment from different suppliers.

## Meeting Different Needs
RSMP is suitable for a wide range of use-cases, from small municipalities with only few traffic lights and basic needs, to larger road authorities with complex setups that include a lot of equipment and the need for advanced traffic management.

Example of what RSMP can be used for:

 - Monitor roadside equipment, e.g. keep an eye out for errors on traffic signals or variable message signs.
 - Manage traffic, e.g. by changing signal programs, change green times, or change content on variable message signs.
 - Collect data from equipment such as counting stations or bicycle barometers.
 - Prioritize different types of traffic such as bicycles, buses, and trams.
 - Automate traffic scenario management for optimizing daily traffic flows and handling traffic incidents.

## Benefits
An open protocol like RSMP stimulates innovation and market competition, reduce maintenance costs and make it easier for equipment from different vendors to work together.

With RSMP, road authorities can achieve:

 - A single protocol for communication between most of their roadside equipment.
 - A single monitoring systems that covers equipment from different vendors.
 - Greater freedom to change equipment and suppliers.

## Equipment Types
RSMP is currently used across the Nordic region for monitoring and managing different types of equipment.

|---|---|
| **Traffic Light Controllers** | traffic management, signal plans, detector logics and I/O, traffic data, statuses and alarms | 
| **Variable Messages Signs** | change display content, upload bitmaps, statuses and alarms |
| **Traffic Counters** | aquire traffic data, status and alarms |
| **Payment Systems** | statuses and alarms
| **Street Lightning Systems** | statuses and alarms |

So far, RSMP Nordic has standardized an SXL only for traffic light controllers, but SXLs for other types of equipment as planned. Other types of equipment currently used custom SXLs. There's nothing wrong with custom SXLs, but standardizing SXLs provide benefits to road authorities.

## Traffic Light Controller Functionality
RSMP include an extensive set of messages and alarms for working with traffic light controllers.

|---|---|
| **System** | Version, Clock, Mode, Restart, Security, Config Checksum, Config Download |
| **Modes** | Fixed time, Yellow Flash, Traffic Situations, Emergency Routes |
| **Signal Plans** | Change plan, Timetable, Calendar, Offset time, Cycle time, Dynamic Bands |
| **Signal Groups** | Force Green/Red, Time-to-Green |
| **Input/Output** | Force On/Off, Sensitivity |
| **Detector Logics** | Force Active |
| **Traffic Data** | Volume, Speed, Occupancy, Classification |
| **Alarms** | Hardware, Network, Lamps, Push Buttons, Doors, Detectors |
| **Status** | Request, Subscribe, On change or by interval |

## Backed by Nordic Road Authorities
RSMP is maintained and developed by the [RSMP Nordic partnership]({% link pages/activities.md %}) of Nordic road authorities. We strive to meet the need of both small and big road authorities.

RSMP has been proven on street since 2011 by major Nordic players such as the Swedish Transport Administration and the City of Copenhagen. The use of RSMP is growing across the Nordics.

![Stockholm Municipality]({{ "assets/images/logo_stockholm.png"}}){:class='logo'}
![Danish Road Directorate]({{ "assets/images/logo_vd.jpg"}}){:class='logo'}
![Copenhagen Municipality]({{ "assets/images/logo_kk.png"}}){:class='logo'}
![Swedish Transport Administration]({{ "assets/images/logo_tv.png"}}){:class='logo'}
![Norwegian Public Roads Administration]({{ "assets/images/logo_sv.jpg"}}){:class='logo'}

## Supported by the Industry
A growing list of suppliers provide equipment and systems that support RSMP.

## Supported by EU Interreg
RSMP Nordic has received funding from EU Interreg Öresund-Kattegat-Skagerak.

![Interreg Øresund Kattegat Skagerak Logo]({{ "assets/images/Interreg_OKS_407px.jpg"}})

## RSMP and EU Standardization
The EU is working on several ITS standards, e.g. in the CEN TC278/WG17 working group. RSMP Nordic supports this work and welcomes European standards as long as they are of high quality and meet the needs of the Nordic region.

European standards will take time to develop and the current approach is to build on regional standards to provide a graceful transition into new EU-standards. We maintain RSMP as a regional standard that can be interfaced or replaced with European standards once they are ready.

RSMP Nordic will provide a constructive Nordic voice in the ongoing EU standardization process.

## RSMP Internationally
Although RSMP Nordic focuses on the needs of Nordic road authorities, RSMP is a general protocol that can be used anywhere in the world.  We publish all specifications, documentation, and tools in English.

Road authorities from all parts in the world are welcome to join RSMP Nordic

## Participate
The RSMP Nordic partnership is open for anyone interested in RSMP, both road authorities, suppliers, and consultants.

We share knowledge and needs in the [User Group]({% link pages/activities.md %}), and meet in in the [Working Group]({% link pages/activities.md %}) to discuss and develop the next versions of the specifications and tools.

There is no RSMP Nordic partnership fee.

