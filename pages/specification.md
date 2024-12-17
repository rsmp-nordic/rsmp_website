---
layout: page
title: Specification
permalink: /specification/
nav_order: 2
parent: Documentation
---

# RSMP Specification
The RSMP Specification defines the message formats and behaviour for communicating via RSMP.

- Core defines messages and behavior common to all types of equipment.
- Signal Exchange Lists (SXLs) define the messages for a particular type of equipment, e.g. Traffic Light Controllers. So far, RSMP Nordic has standardized an SXL only for traffic light controllers, but SXLs for other types of equipment are planned.

### GitHub
The RSMP specifications are maintained on [GitHub](https://github.com/rsmp-nordic).

Each repository on GitHub has its own issue tracker that is used to keep track of errors, proposed improvements, etc. You are welcome to ask questions or report errors on GitHub; you just need an account on GitHub, which is quick and free to create.

### JSON Schema
The RSMP specification is also documented as [JSON Schema](https://github.com/rsmp-nordic/rsmp_schema), which makes it possible automatically to validate the format of RSMP messages.

## Core
The core specification defines the basic message structure and behavior common to all implementations and equipment types.

View the [GitHub repository](https://github.com/rsmp-nordic/rsmp_core).

| --- | --- |
| 3.3.0 (draft)  | [Online][core_3.3.0_online] |
| **3.2.2 (latest release)** | [Online][core_3.2.2_online], [PDF][core_3.2.2_pdf] |
| 3.2.1          | [Online][core_3.2.1_online], [PDF][core_3.2.1_pdf] |
| 3.2            | [Online][core_3.2_online],   [PDF][core_3.2_pdf]   |
| 3.1.5          | [Online][core_3.1.5_online], [PDF][core_3.1.5_pdf] |
| 3.1.4          | [Online][core_3.1.4_online], [PDF][core_3.1.4_pdf] |
| 3.1.3          | [Online][core_3.1.3_online], [PDF][core_3.1.3_pdf] |
| 3.1.2          | [Online][core_3.1.2_online], [PDF][core_3.1.2_pdf] |

[core_3.3.0_online]: https://rsmp-nordic.github.io/rsmp_core/3.3.0/

[core_3.2.2_pdf]: https://github.com/rsmp-nordic/rsmp_core/releases/download/v3.2.2/rsmp-spec-3.2.2.pdf
[core_3.2.2_online]: https://rsmp-nordic.github.io/rsmp_core/3.2.2/

[core_3.2.1_pdf]: https://github.com/rsmp-nordic/rsmp_core/releases/download/v3.2.1/rsmp-spec-3.2.1.pdf
[core_3.2.1_online]: https://rsmp-nordic.github.io/rsmp_core/3.2.1/

[core_3.2_pdf]: https://github.com/rsmp-nordic/rsmp_core/releases/download/v3.2/rsmp-spec-3.2.pdf
[core_3.2_online]: https://rsmp-nordic.github.io/rsmp_core/3.2/

[core_3.1.5_pdf]: https://github.com/rsmp-nordic/rsmp_core/releases/download/v3.1.5/rsmp-spec-3.1.5.pdf
[core_3.1.5_online]: https://rsmp-nordic.github.io/rsmp_core/3.1.5

[core_3.1.4_pdf]: https://github.com/rsmp-nordic/rsmp_core/releases/download/v3.1.4/rsmp-spec-3.1.4.pdf
[core_3.1.4_online]: https://rsmp-nordic.github.io/rsmp_core/3.1.4

[core_3.1.3_pdf]: https://github.com/rsmp-nordic/rsmp_core/releases/download/v3.1.3/rsmp-spec-3.1.3.pdf
[core_3.1.3_online]: https://rsmp-nordic.github.io/rsmp_core/3.1.3

[core_3.1.2_pdf]: https://github.com/rsmp-nordic/rsmp_core/releases/download/v3.1.2/rsmp-spec-3.1.2.pdf
[core_3.1.2_online]: https://rsmp-nordic.github.io/rsmp_core/3.1.2


## Traffic Light Controller SXL
The SXL specification for Traffic Light Controllers. 

View the [GitHub repository](https://github.com/rsmp-nordic/rsmp_sxl_traffic_lights).

| --- | --- |
| **1.2.1 (latest release)**  | [Online][tlc_1.2.1_online], [Excel][tlc_1.2.1_excel], [PDF][tlc_1.2.1_pdf] |
| 1.2            | [Online][tlc_1.2_online], [Excel][tlc_1.2_excel], [PDF][tlc_1.2_pdf] |
| 1.1            | [Online][tlc_1.1_online],    [Excel][tlc_1.1_excel],    [PDF][tlc_1.1_pdf]    |
| 1.0.15         | [Online][tlc_1.0.15_online], [Excel][tlc_1.0.15_excel], [PDF][tlc_1.0.15_pdf] |
| 1.0.14         | [GitHub][tlc_1.0.14_github], [Excel][tlc_1.0.14_excel] |
| 1.0.13         | [GitHub][tlc_1.0.13_github], [Excel][tlc_1.0.13_excel] |

[tlc_1.2.1_pdf]: https://github.com/rsmp-nordic/rsmp_sxl_traffic_lights/releases/download/v1.2.1/sxl-tlc-1.2.1.pdf
[tlc_1.2.1_excel]: https://github.com/rsmp-nordic/rsmp_sxl_traffic_lights/releases/download/v1.2.1/SXL_Traffic_Controller_ver_1_2_1.xlsx
[tlc_1.2.1_online]: https://rsmp-nordic.github.io/rsmp_sxl_traffic_lights/1.2.1

[tlc_1.2_pdf]: https://github.com/rsmp-nordic/rsmp_sxl_traffic_lights/releases/download/v1.2/sxl-tlc-1.2.pdf
[tlc_1.2_excel]: https://github.com/rsmp-nordic/rsmp_sxl_traffic_lights/releases/download/v1.2/SXL_Traffic_Controller_ver_1_2.xlsx
[tlc_1.2_online]: https://rsmp-nordic.github.io/rsmp_sxl_traffic_lights/1.2

[tlc_1.1_pdf]: https://github.com/rsmp-nordic/rsmp_sxl_traffic_lights/releases/download/v1.1/sxl-tlc-1.1.pdf
[tlc_1.1_excel]: https://github.com/rsmp-nordic/rsmp_sxl_traffic_lights/releases/download/v1.1/SXL_Traffic_Controller_ver_1_1.xlsx
[tlc_1.1_online]: https://rsmp-nordic.github.io/rsmp_sxl_traffic_lights/1.1

[tlc_1.0.15_pdf]: https://github.com/rsmp-nordic/rsmp_sxl_traffic_lights/releases/download/v1.0.15/sxl-tlc-1.0.15.pdf
[tlc_1.0.15_excel]: https://github.com/rsmp-nordic/rsmp_sxl_traffic_lights/releases/download/v1.0.15/SXL_Traffic_Controller_ver_1_0_15-2020-10-30.xlsx
[tlc_1.0.15_online]: https://rsmp-nordic.github.io/rsmp_sxl_traffic_lights/1.0.15/

[tlc_1.0.14_excel]: https://github.com/rsmp-nordic/rsmp_sxl_traffic_lights/releases/download/v1.0.14/SXL_Traffic_Controller_ver_1_0_14-2017-10-30.xlsx
[tlc_1.0.14_github]: https://github.com/rsmp-nordic/rsmp_sxl_traffic_lights/blob/v1.0.14/sxl_traffic_controller.md

[tlc_1.0.13_excel]: https://github.com/rsmp-nordic/rsmp_sxl_traffic_lights/releases/download/v1.0.13/SXL_Traffic_Controller_ver_1_0_13-2017-06-26.xlsx
[tlc_1.0.13_github]: https://github.com/rsmp-nordic/rsmp_sxl_traffic_lights/blob/v1.0.13/sxl_traffic_controller.md
