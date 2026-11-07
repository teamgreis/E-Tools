# Roadmap

Milestones are scope gates, not calendar promises. Hardware-dependent releases require testing on named Android tablets and physical adapters.

| Milestone | Scope |
|---|---|
| 0.1 Foundation | App shell, design system, adaptive navigation, dashboard, registry, search, favorites, settings, local database, CI |
| 0.2 Core calculations | Electrical fundamentals, unit handling, Ohm's law, power, voltage drop with explicit assumptions |
| 0.3 Network diagnostics | IP/CIDR, DNS, ping, TCP, HTTP, TLS, route diagnostics and authorized LAN checks |
| 0.4 Hardware Center MVP | USB Host discovery, VID/PID/interface inventory, permission handling, compatibility states and device diagnostics |
| 0.5 Wired network testing | USB-C Ethernet adapter support, link state/speed where exposed, IP configuration visibility and network test workflow |
| 0.6 Network Design | Subnet/VLAN planning, topology editor, rack/patch-panel maps, port/cable schedules and exports |
| 0.7 Serial interfaces | USB-UART/RS232/RS485 transport, terminal, Modbus RTU read-only client and adapter compatibility matrix |
| 0.8 Industrial protocols | Modbus TCP, MQTT TLS, OPC UA read-only browsing; BACnet/CAN evaluated as adapter/platform-specific extensions |
| 0.9 Maintenance & Operations | Asset register, work orders, preventive maintenance, fault history, QR lookup and offline reports |
| 0.10 IT & Server | SSH, server inventory, Docker, monitoring, SNMP, API tester and secure connection profiles |
| 0.11 Documents & Productivity | PDF plans, project workspaces, notes, checklists, attachments and import/export |
| 0.12 Scanner & 3D | QR/barcodes, asset labels, filament and print cost, G-code inspection and printer profiles |
| 0.13 Automation | Workflow model, visual builder, HTTP actions, conditions, webhooks, bounded schedules/retries, logs and cancellation |
| 0.14 Diagnostics | Cross-module guided flows, adapter/protocol troubleshooting, log analyzer, reports and history |
| 1.0 Stable | Regression, accessibility, performance, security and safety review; documentation and signed Android release |

## Release gates

A milestone is releasable when:
- core flows work on target Android versions and supported tablet models
- validation and error states are implemented
- unit/widget/integration tests cover critical paths
- permission, privacy, security and safety behavior is reviewed
- tablet and phone layouts are checked
- hardware capabilities pass tests on actual adapters, not just emulators
- offline behavior, compatibility limits and setup are documented
