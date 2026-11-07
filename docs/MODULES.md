# E-Tools — Module Specification

This document defines planned scope for the 16 modules. A feature is not complete merely because it appears in navigation. Hardware-dependent capabilities must pass compatibility and real-device tests before being marked available.

## 01 — Network & Connectivity

- IPv4/IPv6 validation; CIDR, subnet, network/broadcast address and usable ranges
- Ping, traceroute and TCP port reachability, with platform limitations surfaced
- DNS record lookup; HTTP status, headers and timing; TLS certificate inspection
- Wake-on-LAN, public IP lookup, Wi-Fi QR generation and connection information where Android permits
- LAN discovery and user-initiated speed tests
- Ethernet interface details, link state, negotiated speed and interface statistics when exposed by the adapter/Android stack

**Acceptance:** validate input, show timeouts and partial results, distinguish DNS failure from transport failure, and never scan networks without an explicit user action.

## 02 — System & Device

- Device manufacturer/model, Android version, ABI, screen size/density
- Storage and battery metadata, available sensors and live sensor readings
- App metadata and permissions only where supported by Android APIs
- Diagnostic snapshot export and hardware capability summary

**Platform note:** do not promise unrestricted process lists, exact battery health, thermal data or full installed-app inventories. Label unavailable or OEM-restricted data.

## 03 — Developer Tools

- JSON format/validate/tree; XML and YAML inspection
- HTML/CSS/JavaScript/SQL formatting; Markdown preview
- Base64, URL, HTML entity, Unicode and hex conversions
- JWT payload inspection (decode only; no claim of signature validation)
- UUID, regular expressions, Unix timestamps, color conversion, text diff
- Minification, API request tester and HTTP header analyzer

**Acceptance:** safe handling of malformed and large input, useful parser errors, copy/share actions and no unexpected upload of input.

## 04 — Server Administration

- SSH connection profiles and terminal; strict host-key verification and known-host management
- Server inventory and authenticated monitoring endpoint/agent
- CPU, RAM, disk, network and uptime metrics
- Docker host/container overview, logs, image metadata and lifecycle controls
- HTTP uptime, domain/DNS/TLS checks, database connection profiles and REST APIs
- Home Assistant and other self-hosted integrations
- Remote service checks and maintenance history

**Security:** never expose an unauthenticated Docker socket. Confirm destructive or service-impacting actions.

## 05 — Electrical Engineering

- Ohm's law, voltage/current/power, DC and AC fundamentals
- Single-phase and three-phase power calculations, power factor and energy
- Cable sizing and voltage-drop estimation with explicit assumptions
- Conductor, cable and protective-device reference tables
- Circuit, distribution-board, breaker and RCD documentation
- Circuit schedules, cable/terminal labels, material lists and installation notes
- Measurement logbooks and configurable test-protocol templates
- Drawing/PDF viewer with annotations and circuit/asset references

**Safety:** calculations are indicative engineering aids. They must show assumptions, units, applicable environmental/install conditions and the need to verify against current standards and manufacturer data. The app must not certify installations or replace approved electrical test instruments or qualified personnel.

See [ELECTRICAL_ENGINEERING.md](ELECTRICAL_ENGINEERING.md).

## 06 — 3D Printing

- Filament mass/length, material cost, print-time and electricity-cost estimates
- Volume, scale and printer/material profiles
- G-code inspection, metadata/statistics and safety warnings
- Print notes/history and optional printer integrations (including Bambu Lab where feasible)

Never execute G-code or send printer commands without an explicit user action and selected target.

## 07 — Automation & Workflow

- Visual node-based workflow builder
- Triggers, actions, conditions, branches and variables
- HTTP GET/POST/PUT/PATCH/DELETE, webhooks and JSON mapping
- Notifications, schedules, supported file events and Home Assistant/custom REST integrations
- Run history, logs, retry/backoff, timeouts, cancellation and dry-run
- Templates plus workflow import/export
- Reusable field checklists and repeatable diagnostic sequences

Initial release excludes arbitrary code execution. Apply bounded loops, execution limits, scoped permissions and explicit enable/disable controls.

## 08 — Security & Privacy

- Password, passphrase and token generators
- Local strength estimation; SHA-256/SHA-512 and MD5 for legacy compatibility
- HMAC, file integrity/hash comparison
- TLS certificate and HTTP security-header inspection
- URL/domain inspection, secure local secrets and later TOTP support
- Private checklists and notes

Never send passwords to a remote strength service. Clearly distinguish hashing, encoding, encryption, decoding and signature verification.

## 09 — Files & Documents

- File metadata, size, hashes and file comparison
- Text, JSON, XML, YAML and Markdown viewer/editor
- CSV viewer/editor; ZIP listing and metadata
- Batch rename preview, export and share
- Android Storage Access Framework (SAF) integration
- Project attachments, photos, PDF plans and exported test reports

Use scoped access; do not request broad storage permissions when SAF is sufficient.

## 10 — Productivity

- Notes, checklists, tasks and lightweight workspaces
- Timer, stopwatch, date/time difference
- Text editor and word/character count
- Explicit clipboard actions with privacy-aware handling
- Favorites, collections and dashboard shortcuts
- Job/site workspaces with task status and handover notes

## 11 — Barcode & Scanner

- QR, EAN-13/EAN-8, Code 128/39 and Data Matrix where supported
- QR generation for URL, text, contact and Wi-Fi
- Barcode generation, scan history, export and share
- Asset, cabinet, port, cable and equipment labels
- NFC tag reading/writing only where Android device and tag technology permit

Request camera/NFC permission only when the feature is opened. Never auto-open a scanned URL or execute scanned payloads.

## 12 — Diagnostics & Troubleshooting

- Guided system, network, server and adapter checks
- DNS, HTTP, TLS, reachability and storage diagnostics
- Log analyzer and error-code lookup
- Device capability/compatibility checks
- Diagnostic report generation and problem/solution history
- Evidence-based findings separated from suggested causes

**Smart Diagnostics sequence:** resolve hostname → show resolved addresses → test reachability → test TCP port → inspect HTTP → inspect TLS → summarize observations, failures and next steps. Clearly separate measured facts from hypotheses.

## 13 — Network Design

- IPv4/IPv6 address plans, subnet allocation and VLSM
- VLAN, subnet, DHCP, DNS and gateway planning
- Visual topology editor with switches, routers, firewalls, access points, servers and endpoints
- Rack elevations, patch panels, port maps and cable schedules
- Network outlet, cable and port labeling
- Equipment inventory with model, firmware, serial/asset ID and location
- Site surveys and Wi-Fi coverage notes; no claim of calibrated RF measurement without suitable hardware
- Planned-versus-observed configuration comparison
- Exportable diagrams, address plans, port maps and implementation checklists

See [NETWORK_DESIGN.md](NETWORK_DESIGN.md).

## 14 — Industrial Technology

- Modbus TCP client and register viewer
- Modbus RTU over supported USB-RS485 adapters
- MQTT client with TLS and credential support
- OPC UA client for browsing and reading permitted nodes
- BACnet/IP discovery and read-only object inspection where supported
- Serial console for supported USB-UART/RS232 adapters
- CAN interface support as a later, adapter-specific capability
- Register maps, device profiles, polling intervals, value scaling and timestamped logs

Start with read-only operations. Writes, commands and control actions require explicit confirmation, visible target identity and an audit entry. Never imply safety-rated control capability.

See [INDUSTRIAL_TECHNOLOGY.md](INDUSTRIAL_TECHNOLOGY.md).

## 15 — Maintenance & Operations

- Site, asset, machine and component inventory
- Preventive maintenance schedules and due dates
- Work orders, checklists, notes, photos and sign-off records
- Fault, incident and downtime tracking
- Spare parts, stock references and material usage
- QR/NFC asset lookup
- Service and measurement history per asset
- Offline job packs and PDF/CSV handover reports
- Optional import/export and later integration with CMMS systems

See [MAINTENANCE_OPERATIONS.md](MAINTENANCE_OPERATIONS.md).

## 16 — Hardware Center

- USB Host device discovery and detach/attach lifecycle
- Vendor ID, product ID, interface and endpoint inventory
- Adapter capability profiles and compatibility status
- USB-C Ethernet, USB-UART, RS232, RS485 and supported CAN adapters
- Permission requests and connection-state diagnostics
- Link state, negotiated Ethernet speed and counters where exposed
- Adapter-specific test and troubleshooting pages
- Power-delivery and hub information only where Android exposes it
- User-maintained compatibility reports by tablet model, Android version and adapter chipset

**Platform note:** USB enumeration does not guarantee driver or protocol support. Android kernel drivers, USB host support, chipset, vendor SDK and power requirements determine what actually works. Never show a green "supported" state based only on VID/PID recognition.

See [HARDWARE_COMPATIBILITY.md](HARDWARE_COMPATIBILITY.md).

## Global capabilities

- Universal search across names, descriptions, categories and keywords
- Favorites, recent tools and custom collections
- Tool-to-tool handoff (for example IP → DNS → HTTP → TLS)
- Shared project/site/asset context across modules
- Dashboard widgets: device/network status, adapter status, favorites, recent activity, server uptime and shortcuts
- Settings: theme, language, font size, dashboard, privacy, permissions, data management and import/export
- Offline-first project data with explicit sync integrations

## Definition of done

Each tool must have a stable ID, clear input/output contract, validation, useful errors, responsive UI, permission review, tests and search/category integration. Hardware tools additionally require tests on named physical devices and adapters, including disconnect, permission-denied, unsupported-device and low-power cases. Offline behavior, safety boundaries and data retention must be documented.
