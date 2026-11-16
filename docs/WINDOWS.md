# Windows desktop support

E-Tools builds for Windows 10/11 x64 (release and debug) next to Android. This
document states — in the spirit of the product principles — exactly what works
on Windows, what is labelled as unsupported, and how the binary is produced.

## Status

- Implemented in: `windows/` (Flutter desktop runner, generated with
  `flutter create --platforms=windows`).
- Version: `0.2.0+2` — first build with Windows support.
- **No MSIX/Store packaging** (planned scope). Releases ship a portable ZIP of
  the release bundle: unzip, run `e_tools.exe`.
- Local builds require the Visual Studio "Desktop development with C++"
  workload (the Flutter Windows toolchain is MSVC-based). CI runners
  (`windows-latest`) provide it, so the official build runs in GitHub Actions:
  see `.github/workflows/build-windows.yml` (on tags `v*` or manual dispatch;
  artifact `e-tools-windows-x64`, attached to releases).

## Capability matrix (verified against the resolved plugin stack)

Works natively on Windows:

| Area | Implementation |
| --- | --- |
| All pure-Dart tools (network design, subnetting, Modbus frames, electrical math, G-code metadata, CSV, automation engine, password entropy, …) | platform-independent |
| Local database (assets, service notes, compatibility reports) | Drift + `sqlite3_flutter_libs` (bundles the Windows `sqlite3.dll`) |
| Secret vault | `flutter_secure_storage` → `flutter_secure_storage_windows` (DPAPI) |
| File picking | `file_picker` → `windows_file_picker` |
| Settings, favorites, recents | `shared_preferences` |
| Display metrics | `path_provider`, Flutter layout APIs |
| Battery level/state | `battery_plus` (Windows implementation) |
| Device information | `device_info_plus` (Windows implementation) |

Labelled as not available on Windows (the UI shows an honest note instead of
throwing `MissingPluginException`):

| Feature | Reason |
| --- | --- |
| Accelerometer streams | `sensors_plus` declares android/ios/web only |
| Camera barcode scanning | `mobile_scanner` declares android/ios/macos/web only |
| QR code *generation* | pure Dart (`qr_flutter`) — works everywhere, only *scanning* is Android |

Known honest limits on Windows (unchanged from the Android app): ICMP ping is
unavailable to apps, native USB host discovery is still planned scope, and the
system info tool keeps its Android-focused output on Android only.

## Building locally

```bash
flutter pub get
flutter build windows --release   # output: build/windows/x64/runner/Release/
```

Requires: Flutter stable, Visual Studio 2022 with "Desktop development with
C++", ~10 GB disk for runner + Gradle-free CMake artifacts.

## Building in CI

`.github/workflows/build-windows.yml` runs `analyze → test → build windows
--release`, zips `build/windows/x64/runner/Release/*` to
`e-tools-windows-x64.zip`, uploads it as a workflow artifact and attaches it to
tagged releases (`v*`). No Android SDK or Java setup is needed for the Windows
workflow.