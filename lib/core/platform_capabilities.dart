library;

import 'dart:io' show Platform;

/// Hardware and platform capabilities of the running machine, in one place.
///
/// The UI consults these flags before touching a platform channel: an
/// unsupported feature is labelled as unavailable instead of letting
/// MissingPluginException surface at runtime (honest capabilities, per the
/// product principles).
///
/// Verified against the resolved plugin stack (see docs/WINDOWS.md):
/// sensors_plus declares android/ios/web only — no Windows channel;
/// mobile_scanner declares android/ios/macos/web only — no Windows channel.

/// Accelerometer streams via sensors_plus. The plugin has no Windows
/// implementation; pressing a sensor control there would otherwise throw.
bool get sensorStreamsSupported => Platform.isAndroid || Platform.isIOS;

/// Camera barcode scanning via mobile_scanner. No Windows implementation
/// exists in the plugin; QR generation (qr_flutter) stays pure Dart and
/// works everywhere.
bool get cameraScannerSupported => Platform.isAndroid || Platform.isIOS;

/// DeviceInfoPlugin().androidInfo is only meaningful on Android. On Windows
/// the call raises MissingPluginException; show an honest note instead.
bool get androidDeviceInfoSupported => Platform.isAndroid;
