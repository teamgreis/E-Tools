import 'package:flutter/material.dart';

import '../../core/theme/design_tokens.dart';
import 'glass_surface.dart';

/// A compact glass control used by the bottom dock and inside lists.
class GlassIconButton extends StatelessWidget {
  const GlassIconButton({
    super.key,
    required this.icon,
    required this.tooltip,
    this.onTap,
    this.selected = false,
    this.size = 44,
    this.empty = false,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback? onTap;
  final bool selected;
  final double size;
  final bool empty;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Tooltip(
      message: tooltip,
      child: Semantics(
        button: true,
        label: tooltip,
        child: GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
          child: AnimatedContainer(
            duration: DesignTokens.motionFast,
            curve: DesignTokens.curve,
            width: size,
            height: size,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(size / 3),
              color: selected
                  ? scheme.primary.withValues(alpha: 0.16)
                  : Colors.white.withValues(alpha: isDark ? 0.06 : 0.35),
              border: Border.all(
                color: empty
                    ? scheme.onSurfaceVariant.withValues(alpha: 0.4)
                    : selected
                        ? scheme.primary
                        : Colors.white.withValues(alpha: isDark ? 0.14 : 0.8),
                width: selected ? 1.5 : 1,
              ),
            ),
            child: Icon(
              icon,
              size: size * 0.42,
              color: empty
                  ? scheme.onSurfaceVariant
                  : selected
                      ? scheme.primary
                      : scheme.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}

/// Glass search field used by the module menu.
class GlassSearchField extends StatelessWidget {
  const GlassSearchField({
    super.key,
    required this.controller,
    required this.hintText,
    this.onChanged,
  });

  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Material(
      type: MaterialType.transparency,
      child: GlassSurface(
        radius: DesignTokens.radiusControl,
        blur: DesignTokens.glassBlurSoft,
        shadow: false,
        padding: const EdgeInsets.symmetric(horizontal: DesignTokens.spaceM),
        child: Row(
          children: [
            Icon(Icons.search, color: scheme.onSurfaceVariant),
            const SizedBox(width: DesignTokens.spaceS),
            Expanded(
              child: TextField(
                controller: controller,
                onChanged: onChanged,
                cursorColor: scheme.primary,
                style: TextStyle(color: scheme.onSurface),
                decoration: InputDecoration(
                  hintText: hintText,
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  filled: false,
                  hintStyle: TextStyle(color: scheme.onSurfaceVariant),
                ),
              ),
            ),
            ValueListenableBuilder<TextEditingValue>(
              valueListenable: controller,
              builder: (context, value, _) {
                if (value.text.isEmpty) return const SizedBox.shrink();
                return IconButton(
                  icon: const Icon(Icons.close, size: 18),
                  color: scheme.onSurfaceVariant,
                  visualDensity: VisualDensity.compact,
                  onPressed: () {
                    controller.clear();
                    onChanged?.call('');
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
