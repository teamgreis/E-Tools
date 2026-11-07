# E-Tools

**One app. Every tool.**

E-Tools is a modular, tablet-first toolbox for Android, built with Flutter. It brings practical network, developer, server, engineering, automation, security, file, productivity, scanning and diagnostic utilities into one consistent workspace.

## Product principles

- **Local-first:** core tools work offline where possible; no mandatory account or cloud.
- **Modular:** each tool is independently accessible and registered through a central tool registry.
- **Honest capabilities:** Android/OEM restrictions are shown clearly; no fake or placeholder readings.
- **Secure by default:** least-privilege permissions, secure secret storage, explicit network actions and redacted logs.
- **Tablet-first:** adaptive layouts, keyboard and stylus support, with a usable phone layout.

## Modules

1. Network & Connectivity
2. System & Device
3. Developer Tools
4. Server Administration
5. Engineering & Electronics
6. 3D Printing
7. Automation & Workflow
8. Security & Privacy
9. Files & Documents
10. Productivity
11. Barcode & Scanner
12. Diagnostics & Troubleshooting

See [docs/MODULES.md](docs/MODULES.md) for scope and acceptance criteria.

## Technology

- Flutter / Dart, Material 3
- Riverpod for state management
- go_router for navigation
- Drift + SQLite for structured local data
- flutter_secure_storage for secrets
- Dio for HTTP networking
- Native Kotlin platform integration where Android APIs are required

## Getting started

Install the Flutter SDK and Android toolchain, then:

```bash
flutter pub get
flutter run
flutter analyze
flutter test
```

## Repository layout

```
lib/
  app/       app shell, router and theme
  core/      shared infrastructure
  features/  feature-first modules
  shared/    reusable models and components
docs/        product and engineering documentation
test/        unit and widget tests
```

## Project status

This repository starts with the product specification and an extensible Flutter application shell. Feature modules are delivered incrementally; a listed capability is not considered implemented until it has validation, error handling, tests and permission review.

## Security

Only test systems and networks you are authorized to access. Server operations that can change or delete data require explicit confirmation. See [docs/SECURITY.md](docs/SECURITY.md).

## License

License: TBD. Do not assume this project is open for reuse until a license is added.
