---
layout: page
title: About
permalink: /about/
nav_order: 1
---

# An Open Approach to Roadside Equipment
Effective and intelligent handling of traffic has a priority in Nordic cities, municipalities and road authorities.

Proprietary protocols often cause vendor lock-in and make it hard to switch suppliers and lead to fragmented infrastructure. Often parallel monitoring systems are requird. This increase costs for road authorities.

Open protocols can reduce maintenance costs, increase interoperability and support innovation.

RSMP (Roadside Message Protocol) was developed with this in mind, as an open, modern and lightweight protocol to meet the need of road authorities.

RSMP can be easily extended via Signal Exchange List, which are maintained for different types of equipments, like traffic signals and variable messages signs.

There is no license fee for using RSMP, and the specification and supporting open-source tools can be used freely.

## Meeting Different Needs
RSMP is suitable for a wide range of use-cases, from small municipalities with only few traffic lights and basic needs, to larger road authorities with complex setups that include a lot of equipment and the need for advanced traffic management.

Example of what RSMP can be used for:

 - Monitor roadside equipment, e.g. keep an eye out for errors on traffic signals or variable message signs.
 - Manage traffic, e.g. by changing signal programs, change green times, or change content on variable message signs.
 - Collect data from equipment such as counting stations or bicycle barometers.
 - Prioritize different types of traffic such as bicycles, buses, and trams.
 - Automate traffic scenario management for optimizing daily traffic flows and handling traffic incidents.

## Equipment Types
RSMP is currently used across the Nordic region for monitoring and managing different types of equipment.

|---|---|
| **Traffic Light Controllers** | traffic management, signal plans, detector logics and I/O, traffic data, status and alarms | 
| **Variable Messages Signs** | change display content, upload bitmaps, status and alarms |
| **Traffic Counters** | aquire traffic data, status and alarms |
| **Payment Systems** | status and alarms
| **Street Lightning Systems** | status and alarms |

So far, RSMP Nordic has standardized an SXL only for traffic light controllers, but SXLs for other types of equipment as planned. Other types of equipment currently used custom SXLs. There's nothing wrong with custom SXLs, but standardizing SXLs provide benefits to road authorities.

## Traffic Light Controller Functionality
RSMP include an extensive set of messages and alarms for working with traffic light controllers.

|---|---|
| **System** | Version, Clock, Mode, Restart, Security, Config Checksum, Config Download |
| **Modes** | Fixed time, Yellow Flash, Traffic Situations, Emergency Routes |
| **Signal Plans** | Change plan, Timetable, Calendar, Offset time, Cycle time, Dynamic Bands |
| **Signal Groups** | Force Green, Force Red, Time to Green |
| **Input/Output** | Force Green/Red, Sensitivity |
| **Detector Logics** | Force Active |
| **Traffic Data** | Volume, Speed, Occupancy, Classification |
| **Alarms** | Hardware, Network, Lamps, Push Buttons, Doors, Detectors |
| **Status** | Request, Subscribe, On change or by interval |


## Benefits
An open protocol like RSMP stimulates innovation and market competition, reduce maintenance costs and make it easier for equipment from different vendors to work together.

With RSMP, a road authority can achieve:

 - A single protocol for communication between all roadside equipment.
 - A single monitoring systems that covers equipment for different vendors.
 - Greater freedom to change equipment and vendors.

## Supporting EU-standardisation
The EU is working on several ITS standards, e.g. in the CEN TC278/WG17 working group. RSMP Nordic supports this work and welcome European standards, as long as they are of high quality and meet the needs of the Nordic region.

European standards will take time to develop and the current approach is to build on regional standards to provide a graceful transition into new EU-standards. We maintain RSMP as a regional standard that can be interfaced or replaced with European standards once they are ready.

RSMP Nordic will provide a constructive Nordic voice in the ongoing EU standardisation process.