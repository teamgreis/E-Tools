import 'package:flutter/material.dart';

import '../../core/modules/module_registry.dart';
import '../../core/modules/tool_module.dart';
import '../components/module_tile.dart';

/// The dashboard: every registered module as a glass card, grouped by
/// category.
///
/// The grid is fully registry-driven — a newly registered module appears
/// here without touching this file.
class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final modules = ModuleRegistry.all;
    final width = MediaQuery.sizeOf(context).width;
    final columns = width >= 1400
        ? 4
        : width >= 1100
            ? 3
            : width >= 700
                ? 2
                : 1;

    final categories = <String>[];
    for (final module in modules) {
      if (!categories.contains(module.category)) {
        categories.add(module.category);
      }
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('E-Tools'),
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your toolbox',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'One app. Every tool. — ${modules.length} modules in '
                      '${categories.length} categories',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              ),
            ),
            for (final category in categories) ...[
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 6),
                sliver: SliverToBoxAdapter(
                  child: Row(
                    children: [
                      Text(
                        category.toUpperCase(),
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              letterSpacing: 1.2,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Theme.of(context)
                              .colorScheme
                              .secondaryContainer
                              .withValues(alpha: 0.6),
                        ),
                        child: Text(
                          '${ModuleRegistry.byCategory(category).length}',
                          style:
                              Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSecondaryContainer,
                                  ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 60),
                sliver: SliverGrid.builder(
                  itemCount: ModuleRegistry.byCategory(category).length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: columns,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    mainAxisExtent: 116,
                  ),
                  itemBuilder: (context, index) => ModuleCard(
                    module: modulesForCategory(category)[index],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  List<ToolModule> modulesForCategory(String category) =>
      ModuleRegistry.byCategory(category);
}
