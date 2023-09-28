---
layout: post
title:  "RSMP and Scenario Management in Copenhagen"
date:   2020-10-16
image: /assets/images/cykel_vms_nørrebrogade.jpg
image_attribution: City of Copenhagen
image_license:
  description: Copyright
---

The traffic signals play an important role in the flow of traffic in most cities. The City of Copenhagen has traditionally used time-controlled signal programs, eg morning program, afternoon program and evening program.

The times when the program changes are determined based on knowledge of how the traffic typically behaves at the intersection.

It is a simple method that works – as long as the traffic behaves as it usually does and there is enough capacity on the roads.

## Need for dynamic traffic management

When the City of Copenhagen launched its ITS program, the goal was i.a. to achieve a more dynamic management of traffic so that capacity could be better utilized and increasing traffic volumes and more unpredictable traffic patterns could be better handled.

In addition, it was a goal to be able to manage traffic more strategically based on traffic policy objectives for e.g. travel times, air quality and modal split. It was at the same time a desire to avoid being locked into equipment from certain suppliers.

To achieve this, the City of Copenhagen implemented a traffic management system based on MobiMaestro, with RSMP for communication with traffic signals and roadside equipment from various suppliers.

MobiMaestro is an existing platform, developed by a Dutch company. As part of the project, support for RSMP was added to MobiMaestro.

## Data via RSMP
RSMP is used in Copenhagen to retrieve data from both traffic signals and a number of sensors. RSMP is implemented directly in traffic signals from both Dynniq and Swarco. For sensors that do not implement RSMP directly, a small Linux box is used that translates to RSMP.

Data from radars, cameras and counting stations are retrieved via RSMP with the status messages S0201 and S0202. Data on the number of vehicles in the various lanes, as well as data on average speeds in each lane, are obtained from the sensors that can deliver this.

Data on how the individual signal groups change is retrieved with the status message S0001. Ie. data on when there is green, yellow and red in the different directions at an intersection.

RSMP allows you to subscribe to data at a fixed interval, or you can choose to have data sent as soon as there are changes. In Copenhagen, data is retrieved from sensors once a minute. Signal group data is received as soon as there are changes, typically once per second.

## Management via RSMP
RSMP can also be used to control traffic signals. Signal programs can e.g. can be changed and views on variable boards can be changed.

![RSMP scenario management](/assets/images/management_via_rsmp.png)

## Scenario management with MobiMaestro and RSMP
MobiMaestro integrates data from a variety of sources. In addition to data retrieved via RSMP, data on road works is received from the municipality’s GIS system, bus data from Movia and car data from INRIX. MobiMaestro also estimates travel times and number of stops for cyclists and crossing times for pedestrians, based on how the traffic signals change.

All of these different data types can be used for scenario management in MobiMaestro. A scenario is used for automated control and in short consists of a number of actions that are activated when certain criteria are met.

Input to a scenario can e.g. be a time, day of the week, traffic volumes or travel times.

Output can e.g. be changing signal programs or changing messages on variable boards. For example. via RSMP, signal program can be changed with the command M0002 at all intersections on a corridor, or content on variable boards can be changed.

## More flexibility with RSMP
RSMP allows for dynamic change of green times with the command M0014. This means that you are not limited to switching between predetermined signal programs. It only requires that you have once defined a number of dynamic bands in the signal program. Then you can move the bands via RSMP and thus change the distribution of green times between the different directions and signal groups at the intersection.

Scenarios may involve equipment from different vendors as they all communicate via RSMP. Thus, maintenance and operation can be simplified, and you get increased flexibility. For example. For example, a MobiMaestro scenario can control traffic signals from both Swarco and Dynniq.
