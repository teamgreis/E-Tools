import 'package:flutter/material.dart';

/// The ambient background behind all glass surfaces.
///
/// The backdrop blur of [GlassSurface] samples these gradient blobs, so the
/// liquid-glass effect actually has something to refract.
class AppBackground extends StatelessWidget {
  const AppBackground({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = Theme.of(context).colorScheme.primary;

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [const Color(0xFF14141C), const Color(0xFF08080C)]
              : [const Color(0xFFF6F6FA), const Color(0xFFE8E8F2)],
        ),
      ),
      child: Stack(
        children: [
          _Blob(
            size: 420,
            top: -140,
            left: -120,
            color: accent.withValues(alpha: isDark ? 0.22 : 0.16),
          ),
          _Blob(
            size: 360,
            bottom: -120,
            right: -100,
            color:
                const Color(0xFF3FA9F5).withValues(alpha: isDark ? 0.16 : 0.12),
          ),
        ],
      ),
    );
  }
}

class _Blob extends StatelessWidget {
  const _Blob({
    required this.size,
    this.top,
    this.left,
    this.right,
    this.bottom,
    required this.color,
  });

  final double size;
  final double? top;
  final double? left;
  final double? right;
  final double? bottom;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      left: left,
      right: right,
      bottom: bottom,
      child: IgnorePointer(
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [color, color.withValues(alpha: 0)],
            ),
          ),
        ),
      ),
    );
  }
}
