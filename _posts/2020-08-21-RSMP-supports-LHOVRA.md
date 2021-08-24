---
layout: post
title:  "RSMP Supports LHOVRA"
date:  2020-08-21
image:
  url: /assets/images/lhovra-intersection.png
---

Since the very beginning, signalized intersections have been controlled by traffic signal controllers that had a predetermined function. The predetermined function is characterized by constant cycle length and phase sequence which remains equal from cycle to cycle.

Nowadays, traffic light controllers can be programmed to modify their cycle lengths according to the current traffic flow demand at every moment. The traffic flow data is taken from detectors located along the intersection area which requires proper installation in all approaches to detect the presence of vehicles.

Therefore, actuated signal control helps to fulfill the variable demand of traffic in a more efficient way. One common control strategy, using the detector data is the so called LHOVRA strategy, commonly used in Sweden and other Scandinavian countries. It helps to increase road safety, reduce the travel time and the number of stopped vehicles at intersections along high speed roads.

LHOVRA stands for:

| Acronym | Swedish name          | English translation   | RSMP signal Group status (ASCII) |
| --------| --------------------- | --------------------- | -------------------------------- |
| L       | Lastbilsprioritering  | Truck/bus priority    | 3                                |
| H       | Huvudvägsprioritering | Main road priority    | 3                                |
| O       | Olycksreduktion       | Incident reduction    | 8                                |
| V       | Variabel gultid       | Variable yellow time  | O                                |
| R       | Rödkörningskontroll   | Red running control   | P                                |
| A       | Allrödvänding         | All red turning       | A                                |


- L and H function priorities traffic
- O extents green time. It should permit the last extending vehicle to pass through the dilemma zone in a safe way before the traffic light changes from green to red
- V reduces the delay when the traffic light switches from green to red. In case of no approaching vehicles, the yellow time is shortened
- R extends the red time. It allows some vehicles to pass through an intersection when the traffic light shows red with just minimum chances of collision.
- A allows the intersections to show red in all directions. The aim of this function is to reduce the number of green-yellow-red-green cycles and if they occur, ensure that the vehicle is far enough from the approaching area. The purpose is to reduce unnecessary changes that can disrupt smooth driving.

RSMP with the Signal Exchange List (SXL) for traffic lights, provides 28 different signal group statuses (S0001), including support for the LHOVRA statuses. This allows the supervision system to monitor and diagnose the intersection in terms of its performance regarding the LHOVRA strategy.

The figure below represents a signal exchange diagram, showing two signal groups switching between green, yellow and red using the O and V function. The O function uses the variable past-end-green time to extend green and the V function uses the variable yellow time to reduce yellow time, when possible.

![RSMP scenario management](/assets/images/lhovra-example.png)

Since RSMP contains all the necessary LHOVRA statuses, this type of information is possible to transmit and show in a live diagram, using a surveillance system.

In the diagram above, both signal group uses eight seconds of variable past-end-green time, which is the maximum allowed duration according to the traffic controllers configuration.

Using this kind of data, it is possible to establish detailed level of statistics regarding the performance of the traffic controller, very valuable to traffic engineers.

