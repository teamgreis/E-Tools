import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/modules/module_registry.dart';
import '../../core/modules/tool_module.dart';
import '../../core/state/module_state.dart';
import '../glass/glass_controls.dart';
import '../glass/glass_surface.dart';
import 'module_tile.dart';

/// The module menu that expands above the bottom dock.
///
/// Shows the three favorite slots and the full module catalogue grouped by
/// category, with live search. Any module registered in [ModuleRegistry]
/// appears here automatically.
class ModuleMenuPanel extends ConsumerStatefulWidget {
  const ModuleMenuPanel({super.key});

  @override
  ConsumerState<ModuleMenuPanel> createState() => _ModuleMenuPanelState();
}

class _ModuleMenuPanelState extends ConsumerState<ModuleMenuPanel> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final modules = ModuleRegistry.all
        .where((module) => module.matchesQuery(_query))
        .toList();
    final favorites = ref.watch(favoritesProvider);

    return Material(
      type: MaterialType.transparency,
      child: GlassSurface(
        radius: 28,
        blur: 28,
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 4, bottom: 4),
              child: Row(
                children: [
                  Text(
                    'Module',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const Spacer(),
                  IconButton(
                    tooltip: 'Settings',
                    icon: const Icon(Icons.settings_outlined),
                    onPressed: () => GoRouter.of(context).push('/settings'),
                  ),
                ],
              ),
            ),
            GlassSearchField(
              controller: _searchController,
              hintText: 'Search modules',
              onChanged: (value) => setState(() => _query = value),
            ),
            const SizedBox(height: 8),
            Flexible(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.sizeOf(context).height * 0.55,
                ),
                child: ListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  children: [
                    const _SectionHeader(title: 'Favorites'),
                    for (var i = 0; i < FavoritesNotifier.maxFavorites; i++)
                      if (i < favorites.length)
                        ModuleRow(
                          key: ValueKey('favorite_${favorites[i]}'),
                          module: ModuleRegistry.byId(favorites[i])!,
                        )
                      else
                        const _EmptyFavoriteRow(),
                    for (final category in ModuleRegistry.categories)
                      if (modules.any((m) => m.category == category))
                        _CategorySection(
                          category: category,
                          modules: modules
                              .where((m) => m.category == category)
                              .toList(),
                        ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
      child: Text(
        title.toUpperCase(),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              letterSpacing: 1.2,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
      ),
    );
  }
}

class _CategorySection extends StatelessWidget {
  const _CategorySection({required this.category, required this.modules});

  final String category;
  final List<ToolModule> modules;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(title: category),
        for (final module in modules)
          ModuleRow(key: ValueKey(module.id), module: module),
      ],
    );
  }
}

class _EmptyFavoriteRow extends StatelessWidget {
  const _EmptyFavoriteRow();

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
      leading: Icon(Icons.add,
          color: Theme.of(context).colorScheme.onSurfaceVariant),
      title: Text(
        'Empty favorite slot',
        style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
      ),
    );
  }
}
