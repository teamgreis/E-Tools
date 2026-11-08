import 'package:flutter/material.dart';

import '../settings/app_settings.dart';

/// Apple-style spring curves and durations used across the app.
///
/// `overshoot` is a critically damped-then-slightly-underdamped curve,
/// the Flutter equivalent of iOS's spring presentation.
abstract final class Springs {
  static const Cubic overshoot = Cubic(0.34, 1.56, 0.64, 1.0);
  static const Cubic snappy = Cubic(0.2, 0.0, 0.0, 1.0);
  static const Cubic gentle = Cubic(0.4, 0.0, 0.2, 1.0);

  static const Duration fast = Duration(milliseconds: 220);
  static const Duration base = Duration(milliseconds: 420);
  static const Duration slow = Duration(milliseconds: 640);

  /// Returns the curve for the current accessibility setting.
  static Curve curveFor(AppSettings settings, {bool allowOvershoot = true}) {
    if (settings.reducedMotion) return Curves.linear;
    return allowOvershoot ? overshoot : snappy;
  }

  static Duration durationFor(AppSettings settings, [Duration? base]) {
    if (settings.reducedMotion) return Duration.zero;
    return base ?? Springs.base;
  }
}
