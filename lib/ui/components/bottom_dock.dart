import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/modules/module_registry.dart';
import '../../core/state/module_state.dart';
import '../glass/glass_controls.dart';
import '../glass/glass_surface.dart';
import '../module_actions.dart';

/// The floating bottom dock (iOS-style, no right sidebar).
///
/// Layout: three favorite slots, then the most recently used modules, then
/// the menu toggle. Empty favorite slots render an add button; recents appear
/// dynamically as modules are used.
class BottomDock extends ConsumerWidget {
  const BottomDock({
    super.key,
    required this.menuOpen,
    required this.onToggleMenu,
    required this.onAddFavorite,
  });

  final bool menuOpen;
  final VoidCallback onToggleMenu;
  final VoidCallback onAddFavorite;

  static const int visibleRecents = 3;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoritesProvider);
    final recents = ref.watch(recentsProvider);

    return SafeArea(
      top: false,
      child: Center(
        child: GlassSurface(
          radius: 30,
          blur: 28,
          tintOpacity: 0.4,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: SizedBox(
              height: 56,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (var i = 0; i < FavoritesNotifier.maxFavorites; i++)
                    if (i < favorites.length)
                      _DockModuleButton(moduleId: favorites[i])
                    else
                      GlassIconButton(
                        icon: Icons.add_rounded,
                        tooltip: 'Choose favorite',
                        empty: true,
                        onTap: onAddFavorite,
                      ),
                  if (recents.isNotEmpty)
                    Container(
                      width: 1,
                      height: 28,
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      color: Theme.of(context)
                          .colorScheme
                          .onSurfaceVariant
                          .withValues(alpha: 0.3),
                    ),
                  for (final id in recents.take(visibleRecents))
                    _DockModuleButton(moduleId: id),
                  const Spacer(),
                  GlassIconButton(
                    icon: menuOpen
                        ? Icons.close_rounded
                        : Icons.grid_view_rounded,
                    tooltip: menuOpen ? 'Close menu' : 'All modules',
                    onTap: onToggleMenu,
                    selected: menuOpen,
                    size: 44,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DockModuleButton extends ConsumerWidget {
  const _DockModuleButton({required this.moduleId});

  final String moduleId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final module = ModuleRegistry.byId(moduleId);
    if (module == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GlassIconButton(
        icon: module.icon,
        tooltip: module.title,
        onTap: () => openModule(context, ref, module.id),
      ),
    );
  }
}
