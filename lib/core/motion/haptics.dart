import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../settings/app_settings.dart';

/// Haptic feedback on user input, gated by the settings toggle.
///
/// Mirrors Apple's feedback model: light ticks for discrete UI actions
/// (button presses, toggles), selection ticks for continuous input
/// (slider drags), medium impacts for state changes (favorite set/open).
abstract final class AppHaptics {
  static void tick(WidgetRef ref) {
    if (ref.read(appSettingsProvider).hapticsEnabled) {
      HapticFeedback.selectionClick();
    }
  }

  static void tap(WidgetRef ref) {
    if (ref.read(appSettingsProvider).hapticsEnabled) {
      HapticFeedback.lightImpact();
    }
  }

  static void stateChange(WidgetRef ref) {
    if (ref.read(appSettingsProvider).hapticsEnabled) {
      HapticFeedback.mediumImpact();
    }
  }
}
