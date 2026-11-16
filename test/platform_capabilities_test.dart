import 'package:e_tools/core/platform_capabilities.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('sensor and camera streams are unavailable on the test VM', () {
    // The unit-test VM (CI ubuntu runners, developer desktops) is never
    // Android/iOS, so both hardware flags must honestly be false here.
    // The flags themselves are contract-tested on device runs elsewhere.
    expect(sensorStreamsSupported, isFalse);
    expect(cameraScannerSupported, isFalse);
  });

  test('android-only device info is unavailable off Android', () {
    expect(androidDeviceInfoSupported, isFalse);
  });
}
