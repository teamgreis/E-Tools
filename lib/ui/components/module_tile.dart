import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/modules/tool_module.dart';
import '../../core/state/module_state.dart';
import '../glass/glass_surface.dart';
import '../module_actions.dart';

/// Grid card for a module (dashboard).
class ModuleCard extends ConsumerWidget {
  const ModuleCard({super.key, required this.module});

  final ToolModule module;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFavorite = ref.watch(favoritesProvider).contains(module.id);

    return GlassSurface(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => openModule(context, ref, module.id),
        child: Row(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
              child: Icon(
                module.icon,
                color: Theme.of(context).colorScheme.onSecondaryContainer,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    module.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    module.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(
                isFavorite ? Icons.star_rounded : Icons.star_outline_rounded,
                size: 20,
              ),
              color: isFavorite
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onSurfaceVariant,
              tooltip: isFavorite ? 'Remove favorite' : 'Add favorite',
              onPressed: () => toggleFavorite(context, ref, module.id),
            ),
          ],
        ),
      ),
    );
  }
}

/// List row for a module (menu panel).
class ModuleRow extends ConsumerWidget {
  const ModuleRow({super.key, required this.module});

  final ToolModule module;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFavorite = ref.watch(favoritesProvider).contains(module.id);

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
      leading: Icon(module.icon, color: Theme.of(context).colorScheme.primary),
      title: Text(module.title, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text(
        module.description,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: IconButton(
        icon: Icon(
          isFavorite ? Icons.star_rounded : Icons.star_outline_rounded,
          size: 20,
        ),
        color: isFavorite
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.onSurfaceVariant,
        tooltip: isFavorite ? 'Remove favorite' : 'Add favorite',
        onPressed: () => toggleFavorite(context, ref, module.id),
      ),
      onTap: () => openModule(context, ref, module.id),
    );
  }
}
