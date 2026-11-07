import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/modules/module_registry.dart';
import '../../core/state/module_state.dart';

/// Route target for a single module: `/module/<moduleId>`.
///
/// Modules without a [ToolModule.pageBuilder] render the honest stub below.
/// Opening a module records it in the recents list that drives the dock.
class ModulePage extends ConsumerStatefulWidget {
  const ModulePage({super.key, required this.moduleId});

  final String moduleId;

  @override
  ConsumerState<ModulePage> createState() => _ModulePageState();
}

class _ModulePageState extends ConsumerState<ModulePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(recentsProvider.notifier).markUsed(widget.moduleId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final module = ModuleRegistry.byId(widget.moduleId);

    if (module == null) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(title: const Text('Module')),
        body: const Center(child: Text('This module does not exist.')),
      );
    }

    final page = module.pageBuilder?.call(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(title: Text(module.title)),
      body: page ??
          Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(module.icon,
                      size: 64, color: Theme.of(context).colorScheme.primary),
                  const SizedBox(height: 16),
                  Text(module.title,
                      style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 8),
                  Text(
                    module.description,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 24),
                  Chip(label: Text(module.category)),
                  const SizedBox(height: 8),
                  Text(
                    'This module is registered in the tool registry but not '
                    'implemented yet.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),
    );
  }
}
