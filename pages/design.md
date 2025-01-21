---
layout: page
title: Design
permalink: /overview/
nav_order: 1
parent: Documentation
---

# Design
RSMP is a general protocol for communication between supervision systems and road side equipment, and direct communication between road side equipment. The aim is to offer a standardized protocol that works the same way regardless of supplier or type of road side equipment.

More technical details can be found in the [Core specification](https://rsmp-nordic.github.io/rsmp_core/3.2.2/) and in [Documentation]({% link pages/documentation.md %}).

### Transport Protocol
RSMP communication is based on TCP sockets. HTTP is not used. Because TCP sockets are full duplex, both sides can send and receive data at the same time.

### Message Structure
RSMP messages use the [JSON](https://www.json.org/json-en.html) format. For example, here's an Aggregated Status mesage:

```json
{
     "mType": "rSMsg",
     "type": "AggregatedStatus",
     "mId": "be12ab9a-800c-4c19-8c50-adf832f22420",
     "ntsOId": "O+14439=481WA001",
     "xNId": "",
     "cId": "O+14439=481WA001",
     "aSTS": "2015-06-08T08:05:06.584Z",
     "fP": null,
     "fS": null,
     "se": [ true,false,false,false,false,false,false,false ]
}
```

A benefit of JSON is that it's human-readable, making development and debugging easier. Because it's widely used there are libraries available for parsing, generating and validating JSON on all common platforms.

### Core Specification
The [Core specifications]({% link pages/specification.md %}) defines messages and behavior common to all types of equipment.

### Signal Exchange Lists (SXLs)
Signal Exchange Lists define the messages for a particular type of equipment, e.g. Traffic Light Controllers.

So far, RSMP Nordic has standardized an SXL only for traffic light controllers, but SXLs for other types of equipment are planned.

You can define your own SXL if you need to support a special types of equipment, although RSMP Nordic strongly recommend using a standardized SXL whenever possible.

In situations where you really need to add a particular functionality or messages that are not available in a standardized SXL, it's possible to add your own custom messages. However, RSMP Nordic strongly recommend that you avoid this, because you can easily loose the benefits of using a vendor-neutral protocol. Any special message implemented by a single (or a few) vendors will make it harder to switch vendor, and will not be supported by e.g. RSMP Nordic tools for automated validation.

If you have this type of needs that you feel are not currently met by the standardized SXLs, we encourage you to instead join the RSMP [User Group or Working Group]({% link pages/activities.md %}) and discuss your needs. It might make sense to include the required messages in upcoming SXL versions.

