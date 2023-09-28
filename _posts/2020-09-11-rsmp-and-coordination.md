---
layout: post
title: "RSMP and Traffic Light Coordination"
date: 2020-10-16
image: /assets/images/coordination.png
image_attribution: City of Copenhagen
---

Unlike other protocols, RSMP supports communication directly between traffic controllers in order to enable coordination. Coordination allows for several intersections to be controlled together in a coordinated control mode. This can be used to achieve green wave between intersections.

Coordination can be achieved using several different control strategies:

- Synchronized clock. (Fixed cycle length)
- Synchronized cycle counter. (Fixed cycle length)
- Local coordination. (Variable cycle length)

## Clock Synchronization
Synchronized clock is the simplest control strategy and does not involve direct connection between the controllers. Each controller synchronizes its clock using a reliable source and switches time plan independently. It uses internal control bits with an offset time to achieve green wave.

## Cycle Counter Synchronization
Synchronized cycle counter requires direct connection between the controllers. The master controller resets the cycle counter of the other controllers in each cycle. Each controller applies it’s own offset time. This control strategy can be used with either internal or external control bits – to control when each signal group should go to green or red during the cycle.

## Local Coordination
Local coordination also requires direct connection between controllers. It involves two or more traffic controllers sending green or red orders to specific signal groups in the other intersection(s). With its variable cycle length is highly traffic actuated and allows the traffic controller to adapt according to the current traffic volumes in a very dynamic way. But it’s adoption depends of local circumstances.

With synchronized cycle counter and local coordination, direct connection between the traffic controllers is required in order to guarantee the reliability of the coordination. Using RSMP and the standard network interface of the traffic controller, dedicated wiring is no longer needed to achieve coordination reliably.

## Implementation Status
RSMP implements coordination using commands M0002, M0006 and M0013 and status S0004.

Coordination with RSMP was tested already back in 2014 together with Swarco, Dynniq and the former TTS (now Swarco). Today the technology is mature, allowing it to be used in a live environment.

Since a while back, two traffic controllers in Stockholm, Sweden have been tested to use local coordination with RSMP.

Here is an example time-space diagram of the coordination of those controllers:

![RSMP scenario management](/assets/images/coordination-diagram.png)

- Ceased green demand (yellow) of signal group 3 in the intersection on the left orders start of signal group 1 in the intersection on right in the diagram
- Ceased green demand (yellow) of signal group 6 in the intersection on the right orders start of signal group 4 in the intersection on the left in the diagram

The RSMP coordination specification is included in the SXL for Traffic Light Controlleres 1.0.15.
