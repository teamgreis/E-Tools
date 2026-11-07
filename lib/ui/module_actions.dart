import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/modules/module_registry.dart';
import '../../core/state/module_state.dart';
import 'glass/glass_surface.dart';

/// Opens a module and records it as recently used.
void openModule(BuildContext context, WidgetRef ref, String moduleId) {
  GoRouter.of(context).go('/module/$moduleId');
}

/// Star toggle for a module: fills an empty slot, removes an existing
/// favorite, or asks which favorite to replace when all three slots are
/// already taken.
void toggleFavorite(BuildContext context, WidgetRef ref, String moduleId) {
  final favorites = ref.read(favoritesProvider.notifier);
  if (favorites.contains(moduleId)) {
    favorites.remove(moduleId);
    return;
  }
  if (!favorites.isFull) {
    favorites.add(moduleId);
    return;
  }

  showDialog<void>(
    context: context,
    barrierColor: Colors.black.withValues(alpha: 0.35),
    builder: (dialogContext) => Dialog(
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      child: GlassSurface(
        radius: 28,
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Replace favorite',
              style: Theme.of(dialogContext).textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Text(
              'All three favorite slots are in use.',
              style: Theme.of(dialogContext).textTheme.bodySmall,
            ),
            const SizedBox(height: 12),
            for (final id in ref.read(favoritesProvider))
              _FavoriteSlotRow(
                moduleId: id,
                onReplace: () {
                  favorites.replace(id, moduleId);
                  Navigator.of(dialogContext).pop();
                },
              ),
          ],
        ),
      ),
    ),
  );
}

class _FavoriteSlotRow extends StatelessWidget {
  const _FavoriteSlotRow({required this.moduleId, required this.onReplace});

  final String moduleId;
  final VoidCallback onReplace;

  @override
  Widget build(BuildContext context) {
    final module = ModuleRegistry.byId(moduleId);
    if (module == null) return const SizedBox.shrink();
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(module.icon),
      title: Text(module.title),
      trailing: const Icon(Icons.chevron_right),
      onTap: onReplace,
    );
  }
}
