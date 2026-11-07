# Network Design — Detailed Specification

## Planning workspace

Each project/site can contain buildings, floors, rooms, racks, devices, links, outlets and cable runs. Use stable object IDs so drawings, inventory and test results can reference the same asset.

## IP and VLAN planning

- IPv4 CIDR and IPv6 prefix allocation.
- Subnet and VLSM planning with overlap detection.
- VLAN ID, name, purpose, subnet, gateway, DHCP scope and tagged/untagged port notes.
- Address reservations, static assignments and exclusions.
- DNS zones/records and gateway documentation.
- Exportable address plans (CSV/PDF).

## Visual topology

- Drag-and-drop router, firewall, switch, access point, server, endpoint and WAN/cloud nodes.
- Physical and logical links with speed/media labels.
- Link status is planned/documented unless verified by a live supported interface.
- Layers for physical, logical, VLAN and wireless views.
- Import/export a versioned E-Tools project format; later evaluate standard diagram interchange formats.

## Racks and cabling

- Rack elevations with U positions and equipment dimensions.
- Patch-panel port maps and switch port maps.
- Cable ID, category/fiber type, length, endpoints, route, status and test result.
- Outlet/port labeling and QR-code generation.
- Planned-to-installed comparison and change notes.

## Site survey

- Record access-point positions, channel, band, observed signal values and notes where Android exposes them.
- Allow manual floor-plan annotations and survey points.
- Do not claim calibrated heatmaps or professional RF certification without validated measurement hardware and methodology.

## Live validation handoff

From a selected device, port or subnet, open relevant diagnostics: ping, DNS, TCP, HTTP/TLS and supported Ethernet link information. Discovery/scanning must be explicit, bounded and restricted to authorized networks.

## Acceptance

- Detect overlapping subnets, duplicate IDs and invalid VLAN/address assignments.
- Preserve project history and export reproducible plans.
- Clearly distinguish planned values, manually confirmed values and live observations.
- Support offline editing and conflict-aware future synchronization.
