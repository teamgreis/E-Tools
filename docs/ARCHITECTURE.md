# Architecture

## Stack

- Flutter and Dart
- Material 3 design system
- Riverpod for state and dependency management
- go_router for navigation
- Drift/SQLite for structured local persistence
- SharedPreferences for non-sensitive preferences
- flutter_secure_storage for secrets
- Dio for HTTP requests
- mobile_scanner for barcode/QR scanning
- Kotlin platform integration through Pigeon or platform channels
- flutter_test, mocktail and integration_test

Pin dependency versions deliberately and review Android minimum SDK requirements before adding plugins.

## Feature-first structure

```
lib/
  main.dart
  app/
    app.dart
    router.dart
    bootstrap.dart
  core/
    theme/
    database/
    security/
    networking/
    permissions/
    logging/
    widgets/
  shared/
    models/
    services/
    components/
  features/
    dashboard/
    search/
    tool_registry/
    network/
    system/
    developer/
    server/
    engineering/
    printing/
    automation/
    security/
    files/
    productivity/
    scanner/
    diagnostics/
```

Each substantial feature may use presentation, application, domain and data layers. Keep simple utilities lightweight; do not create abstraction layers without a reason.

## Data flow

UI → Riverpod controller/provider → use case/service → repository interface → data source.

The UI must not call platform APIs or persistence directly. Domain logic should be testable without Flutter widgets.

## Tool registry

Each tool descriptor should expose:
- stable ID, title, description, category and keywords
- icon identifier and route
- availability state: available, limited, requiresConnection, planned or unavailable
- permission requirements and optional capability metadata

The registry powers navigation, search, categories, favorites and dashboard shortcuts. Keep tool IDs stable for persisted favorites and history.

## Data and execution

- Local-first defaults; remote calls are user-initiated or explicitly configured.
- Do not store sensitive inputs in history by default.
- Redact credentials, tokens and personal data from logs.
- Stream large files and move expensive parsing off the UI isolate.
- Avoid polling while the app is inactive; apply cache freshness policies.
- Workflow execution must support cancellation, timeouts, bounded retries and execution limits.

## Android integration

Use Kotlin adapters for Android-specific capabilities. Check API level, permission state and OEM availability at runtime. Explain limitations instead of returning fabricated values. Use SAF for user-selected files and request camera access only when scanning begins.

## Adaptive UI

Tablet: persistent navigation rail/sidebar, broad workspace and optional detail pane. Phone: bottom navigation and compact layouts. Support keyboard, stylus, multi-window, large text and accessible semantics.
