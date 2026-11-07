import 'package:flutter/material.dart';

import '../../core/modules/module_registry.dart';
import '../components/module_tile.dart';

/// The dashboard: every registered module as a glass card.
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
                      'One app. Every tool.',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 120),
              sliver: SliverGrid.builder(
                itemCount: modules.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columns,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  mainAxisExtent: 116,
                ),
                itemBuilder: (context, index) =>
                    ModuleCard(module: modules[index]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
