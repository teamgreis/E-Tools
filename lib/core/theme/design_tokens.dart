import 'package:flutter/material.dart';

/// Central design tokens for the E-Tools liquid-glass design system.
///
/// Every visual property (radius, blur strength, spacing, motion) is defined
/// here so that additional modules automatically inherit the system look.
abstract final class DesignTokens {
  static const accent = Color(0xFF7656D6);

  /// Corner radii
  static const radiusCard = 24.0;
  static const radiusDock = 30.0;
  static const radiusControl = 16.0;

  /// Backdrop blur intensities for glass surfaces.
  static const glassBlur = 24.0;
  static const glassBlurSoft = 12.0;

  /// Dock metrics.
  static const dockHeight = 72.0;

  /// Spacing scale.
  static const spaceXS = 4.0;
  static const spaceS = 8.0;
  static const spaceM = 12.0;
  static const spaceL = 16.0;
  static const spaceXL = 20.0;
  static const spaceXXL = 24.0;

  /// Motion.
  static const motionFast = Duration(milliseconds: 160);
  static const motionBase = Duration(milliseconds: 240);
  static const motionSlow = Duration(milliseconds: 420);
  static const curve = Curves.easeOutCubic;
}
