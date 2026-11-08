import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/settings/app_settings.dart';
import '../../core/theme/design_tokens.dart';

/// The core liquid-glass surface: a live backdrop blur, a translucent
/// gradient tint, a specular border and a soft ambient shadow.
///
/// This is the only primitive every glass component (cards, dock, menu
/// panel, dialogs) is built from, which keeps the design system coherent
/// when new modules are added.
///
/// Blur and tint scale with the live glass settings, so the settings
/// sliders (`0 = fully transparent` ... `1 = maximum blur`) change every
/// surface in the app instantly.
class GlassSurface extends ConsumerWidget {
  const GlassSurface({
    super.key,
    required this.child,
    this.radius = DesignTokens.radiusCard,
    this.blur = DesignTokens.glassBlur,
    this.tintOpacity,
    this.padding,
    this.shadow = true,
    this.selected = false,
  });

  final Widget child;
  final double radius;
  final double blur;
  final double? tintOpacity;
  final EdgeInsetsGeometry? padding;
  final bool shadow;
  final bool selected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final settings = ref.watch(appSettingsProvider);
    final effectiveBlur = blur * settings.glassBlur;
    final tintAlpha =
        (tintOpacity ?? (isDark ? 0.08 : 0.55)) * settings.glassTint;
    final tint = Colors.white.withValues(alpha: tintAlpha);
    final highlight = Colors.white.withValues(alpha: isDark ? 0.12 : 0.7);
    final border = selected
        ? Theme.of(context).colorScheme.primary
        : Colors.white.withValues(alpha: isDark ? 0.16 : 0.85);
    final borderWidth = selected ? 1.5 : 1.0;

    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: effectiveBlur, sigmaY: effectiveBlur),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                highlight,
                tint,
                tint.withValues(alpha: isDark ? 0.05 : 0.30),
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
            border: Border.all(color: border, width: borderWidth),
            boxShadow: shadow
                ? [
                    BoxShadow(
                      color:
                          Colors.black.withValues(alpha: isDark ? 0.35 : 0.12),
                      blurRadius: 2 * radius,
                      offset: const Offset(0, 10),
                    ),
                  ]
                : null,
          ),
          child: padding == null
              ? child
              : Padding(padding: padding!, child: child),
        ),
      ),
    );
  }
}
