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
- Kotlin native Android integration for USB Host and device APIs
- Pigeon/platform channels for typed Flutter/native communication
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
    hardware/
      usb/
      adapters/
      capabilities/
    projects/
    reporting/
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
    network_design/
    system/
    developer/
    server/
    electrical/
    printing/
    automation/
    security/
    files/
    productivity/
    scanner/
    diagnostics/
    industrial/
    maintenance/
    hardware_center/
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
- safety classification and whether the operation is read-only or mutating

The registry powers navigation, search, categories, favorites and dashboard shortcuts. Keep tool IDs stable for persisted favorites and history.

## Hardware abstraction

Flutter features must depend on domain-level interfaces, not USB plugin details. Suggested boundaries:

- `UsbDeviceEnumerator`: enumerate attached devices and interfaces.
- `AdapterProfileRepository`: map known VID/PID/interface combinations to candidate capabilities.
- `HardwarePermissionService`: request and observe Android USB permission.
- `EthernetDiagnostics`: expose only link and interface data actually provided by Android/driver.
- `SerialTransport`: open, configure, read, write and close supported UART interfaces.
- `IndustrialTransport`: protocol-specific transport and session lifecycle.
- `HardwareCapabilityReport`: explain supported, limited, unknown and unsupported states with evidence.

A recognized USB identity is not proof that a device is usable. Compatibility requires driver/SDK support, successful permission, interface claim, protocol handshake where appropriate and real-device tests. Handle detach events, permission denial, device reset, timeout and insufficient power.

## Industrial protocol boundaries

- Keep Modbus, MQTT, OPC UA and BACnet implementations behind protocol-specific clients.
- Default to read-only discovery and monitoring.
- Make writes/commands a separate capability requiring explicit user confirmation.
- Store endpoint credentials in secure storage, never in ordinary project exports or logs.
- Validate polling intervals, request sizes and reconnect/backoff behavior.
- Show raw values, scaling rules, units, timestamps and source quality where available.

## Data and execution

- Local-first defaults; remote calls are user-initiated or explicitly configured.
- Do not store sensitive inputs in history by default.
- Redact credentials, tokens and personal data from logs.
- Stream large files and move expensive parsing off the UI isolate.
- Avoid polling while the app is inactive; apply cache freshness policies.
- Workflow execution must support cancellation, timeouts, bounded retries and execution limits.
- Project records should support offline use, versioned export and explicit synchronization.

## Android integration

Use Kotlin adapters for Android-specific capabilities. Check API level, permission state, USB host availability, connected interface descriptors and OEM availability at runtime. Validate the target tablet's USB-C OTG behavior and power budget. Use SAF for user-selected files and request camera/NFC access only when the relevant feature begins.

Do not assume Android exposes Ethernet interface controls, monitor mode, arbitrary USB drivers, raw sockets or all serial chipsets. Maintain a tested compatibility matrix by tablet model, Android build and adapter.

## Adaptive UI

Tablet: persistent navigation rail/sidebar, broad workspace and optional detail pane. Phone: bottom navigation and compact layouts. Support keyboard, stylus, multi-window, large text and accessible semantics.

## Testing strategy

- Unit tests for calculations, subnet allocation, protocol parsers and validation.
- Contract tests for hardware abstractions using fake transports.
- Instrumented Android tests for USB permissions and attach/detach lifecycle.
- Physical-device matrix for each supported adapter and tablet.
- Integration tests for read-only protocol sessions and explicit write confirmation.
- Regression tests for offline project data and export/import.
