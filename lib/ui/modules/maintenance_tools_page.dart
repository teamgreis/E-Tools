import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/tools/maintenance_logic.dart';
import '../../data/app_database.dart';
import '../../data/repositories.dart';
import '../modules/tool_widgets.dart';

/// Module 15 — Maintenance & Operations.
///
/// Assets persist in the local Drift database (survive app restarts); the
/// schedule reassesses on every read.
class MaintenanceToolsPage extends ConsumerWidget {
  const MaintenanceToolsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final assetsAsync = ref.watch(assetsStreamProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(title: const Text('Maintenance & Operations')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 120),
          children: [
            const _AddAssetSection(),
            ToolSection(
              title: 'Schedule',
              description:
                  'Sorted by due date; overdue surfaces first. Persisted locally.',
              child: assetsAsync.when(
                data: (assets) {
                  if (assets.isEmpty) {
                    return const ResultBox(text: 'No assets yet');
                  }
                  final assessments = assessAssets(assets, DateTime.now());
                  return ResultBox(
                    text: assessments
                        .map((a) =>
                            '${statusLabel(a.status).padRight(9)} #${a.asset.id} — due in ${a.daysLeft}d')
                        .join('\n'),
                    height: 180,
                  );
                },
                loading: () => const Center(
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
                error: (error, _) => ResultBox(text: 'DB error: $error'),
              ),
            ),
            _AssetActionsSection(assets: assetsAsync.value ?? const <Asset>[]),
            _NotesSection(assets: assetsAsync.value ?? const <Asset>[]),
          ],
        ),
      ),
    );
  }
}

class _AddAssetSection extends ConsumerStatefulWidget {
  const _AddAssetSection();

  @override
  ConsumerState<_AddAssetSection> createState() => _AddAssetSectionState();
}

class _AddAssetSectionState extends ConsumerState<_AddAssetSection> {
  final _nameController = TextEditingController();
  final _locationController = TextEditingController();
  final _intervalController = TextEditingController(text: '90');

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    _intervalController.dispose();
    super.dispose();
  }

  Future<void> _add() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;
    await ref.read(maintenanceRepositoryProvider).addAsset(
          name: name,
          location: _locationController.text.trim(),
          intervalDays: int.tryParse(_intervalController.text.trim()) ?? 90,
        );
    _nameController.clear();
    _locationController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return ToolSection(
      title: 'Asset inventory',
      description: 'Persisted in the local database — survives app restarts.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GlassField(controller: _nameController, label: 'Name'),
          GlassField(controller: _locationController, label: 'Location'),
          GlassField(
            controller: _intervalController,
            label: 'Service interval (days)',
            keyboardType: TextInputType.number,
          ),
          GlassButton(
            label: 'Add asset',
            icon: Icons.add,
            onPressed: _add,
          ),
        ],
      ),
    );
  }
}

class _AssetActionsSection extends ConsumerWidget {
  const _AssetActionsSection({required this.assets});

  final List<Asset> assets;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (assets.isEmpty) return const SizedBox.shrink();
    final first = assets.first;
    return ToolSection(
      title: 'Log service',
      description: 'Resets the interval and writes a service note.',
      child: GlassButton(
        label: 'Service performed on #${first.id}',
        icon: Icons.build_circle,
        onPressed: () =>
            ref.read(maintenanceRepositoryProvider).logService(first.id),
      ),
    );
  }
}

class _NotesSection extends ConsumerWidget {
  const _NotesSection({required this.assets});

  final List<Asset> assets;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (assets.isEmpty) return const SizedBox.shrink();
    final first = assets.first;
    return ToolSection(
      title: 'Service notes (latest)',
      description: 'Notes for the first asset.',
      child: StreamBuilder(
        stream: ref.read(maintenanceRepositoryProvider).watchNotes(first.id),
        builder: (context, snapshot) {
          final notes = snapshot.data;
          if (notes == null || notes.isEmpty) {
            return const ResultBox(text: 'No notes yet');
          }
          return ResultBox(
            text: notes.reversed
                .map((n) => '${n.timestamp.toIso8601String()}\n${n.note}')
                .join('\n---\n'),
            height: 130,
          );
        },
      ),
    );
  }
}
