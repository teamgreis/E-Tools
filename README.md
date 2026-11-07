# E-Tools

**One app. Every tool.**

E-Tools is a modular, tablet-first technical field toolkit for Android. It is designed for electricians, network engineers, IT administrators, industrial technicians and maintenance teams. It combines planning, diagnostics, documentation and supported external-hardware testing in one offline-capable workspace.

## Product principles

- **Field-ready:** useful on-site, including locations with unreliable or no internet access.
- **Local-first:** no mandatory account or cloud; synchronize only through explicitly configured integrations.
- **Modular:** tools are independently accessible and registered through a central tool registry.
- **Hardware-aware:** USB adapters and measurement interfaces are discovered and capability-checked; unsupported hardware is never presented as working.
- **Honest capabilities:** Android/OEM restrictions, adapter limitations and measurement uncertainty are shown clearly.
- **Secure by default:** least-privilege permissions, secure secret storage, explicit network actions and redacted logs.
- **Tablet-first:** adaptive layouts, keyboard and stylus support, with a usable phone layout.

## Modules

1. Network & Connectivity
2. System & Device
3. Developer Tools
4. Server Administration
5. Electrical Engineering
6. 3D Printing
7. Automation & Workflow
8. Security & Privacy
9. Files & Documents
10. Productivity
11. Barcode & Scanner
12. Diagnostics & Troubleshooting
13. Network Design
14. Industrial Technology
15. Maintenance & Operations
16. Hardware Center

See [docs/MODULES.md](docs/MODULES.md) for the full module scope and acceptance criteria.

## Target workflows

- Plan IP ranges, VLANs, racks, patch panels and cable routes; then validate a live network through a supported USB-C Ethernet adapter.
- Record electrical calculations, circuits, measurements and installation documentation.
- Connect to supported serial, RS232, RS485 and CAN interfaces for device diagnostics.
- Inspect Modbus TCP/RTU, MQTT and OPC UA endpoints where protocol and hardware support are available.
- Manage server connections, infrastructure checks, maintenance tasks and technical reports.
- Keep project records, checklists, photos and equipment history available offline.

## Technology

- Flutter / Dart, Material 3
- Riverpod for state management
- go_router for navigation
- Drift + SQLite for structured local data
- flutter_secure_storage for secrets
- Dio for HTTP networking
- Kotlin native Android integration for USB Host, adapter discovery and supported interfaces
- Pigeon/platform channels for typed Flutter/native communication

## Getting started

Install the Flutter SDK and Android toolchain, then:

```bash
flutter pub get
flutter run
flutter analyze
flutter test
```

The repository contains the product specification and an incremental Flutter application scaffold. Generate/maintain Android platform files with the Flutter toolchain as implementation work proceeds.

## Repository layout

```
lib/
  app/       app shell, router and theme
  core/      shared infrastructure
  features/  feature-first modules
  shared/    reusable models and components
docs/        product, hardware and engineering specifications
test/        unit and widget tests
```

## Project status

The repository currently contains the product specification and an extensible Flutter application shell. The listed professional workflows and hardware integrations are planned scope, not claims of completed functionality. A capability is implemented only after validation, error handling, tests, device testing and permission review.

## Safety and authorization

Use network diagnostics only on networks and systems you are authorized to test. Electrical calculations and records are engineering aids, not certification of an installation or a substitute for applicable standards, qualified personnel or approved test equipment. Never connect a general-purpose tablet or unverified adapter directly to hazardous electrical circuits. Server operations that can change or delete data require explicit confirmation.

See [docs/SECURITY.md](docs/SECURITY.md), [docs/ELECTRICAL_ENGINEERING.md](docs/ELECTRICAL_ENGINEERING.md) and [docs/HARDWARE_COMPATIBILITY.md](docs/HARDWARE_COMPATIBILITY.md).

## License

License: TBD. Do not assume this project is open for reuse until a license is added.
