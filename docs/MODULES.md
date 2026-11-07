# E-Tools — Module Specification

This document defines the planned scope. A feature is not complete merely because it appears in navigation.

## 01 — Network & Connectivity

- IPv4/IPv6 validation; CIDR, subnet, network/broadcast address and usable ranges
- Ping, traceroute and TCP port reachability, with platform limitations surfaced
- DNS record lookup; HTTP status, headers and timing; TLS certificate inspection
- Wake-on-LAN, public IP lookup, Wi-Fi QR generation and connection information where Android permits
- LAN discovery and user-initiated speed tests

**Acceptance:** validate input, show timeouts and partial results, distinguish DNS failure from transport failure, and never scan networks without an explicit user action.

## 02 — System & Device

- Device manufacturer/model, Android version, ABI, screen size/density
- Storage and battery metadata, available sensors and live sensor readings
- App metadata and permissions only where supported by Android APIs
- Diagnostic snapshot export

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

**Security:** never expose an unauthenticated Docker socket. Confirm destructive or service-impacting actions.

## 05 — Engineering & Electronics

- Ohm's law, voltage/current/power and resistor color codes
- LED series resistor and series/parallel circuit helpers
- Capacitors, PSU sizing, cable cross-section and voltage drop
- AC/DC helper calculations, frequency, dB, efficiency and energy costs

Every calculation must state assumptions, units and applicable safety caveats. These tools do not replace qualified electrical design or measurement.

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

Use scoped access; do not request broad storage permissions when SAF is sufficient.

## 10 — Productivity

- Notes, checklists, tasks and lightweight workspaces
- Timer, stopwatch, world clock and date/time difference
- Text editor and word/character count
- Explicit clipboard actions with privacy-aware handling
- Favorites, collections and dashboard shortcuts

## 11 — Barcode & Scanner

- QR, EAN-13/EAN-8, Code 128/39 and Data Matrix where supported
- QR generation for URL, text, contact and Wi-Fi
- Barcode generation, scan history, export and share

Request camera permission only when the scanner is opened. Never auto-open a scanned URL.

## 12 — Diagnostics & Troubleshooting

- Guided system, network and server checks
- DNS, HTTP, TLS, reachability and storage diagnostics
- Log analyzer and error-code lookup
- Device capability/compatibility checks
- Diagnostic report generation and problem/solution history

**Smart Diagnostics sequence:** resolve hostname → show resolved addresses → test reachability → test TCP port → inspect HTTP → inspect TLS → summarize observations, failures and next steps. Clearly separate measured facts from hypotheses.

## Global capabilities

- Universal search across names, descriptions, categories and keywords
- Favorites, recent tools and custom collections
- Tool-to-tool handoff (for example IP → DNS → HTTP → TLS)
- Dashboard widgets: device/network status, favorites, recent activity, server uptime and shortcuts
- Settings: theme, language, font size, dashboard, privacy, permissions, data management and import/export

## Definition of done

Each tool must have a stable ID, clear input/output contract, validation, useful errors, responsive UI, permission review, tests and search/category integration. Offline behavior and data retention must be documented.
