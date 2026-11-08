import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/tools/maintenance_logic.dart';
import '../modules/tool_widgets.dart';

/// Module 15 — Maintenance & Operations.
///
/// Session-scoped asset inventory with preventive maintenance scheduling
/// (interval → next due → status). Records stay local.
class MaintenanceToolsPage extends ConsumerStatefulWidget {
  const MaintenanceToolsPage({super.key});

  @override
  ConsumerState<MaintenanceToolsPage> createState() =>
      _MaintenanceToolsPageState();
}

class _MaintenanceToolsPageState extends ConsumerState<MaintenanceToolsPage> {
  final List<Asset> _assets = [];
  final _idController = TextEditingController();
  final _nameController = TextEditingController();
  final _locationController = TextEditingController();
  final _intervalController = TextEditingController(text: '90');
  final List<String> _workOrders = [];

  @override
  void dispose() {
    _idController.dispose();
    _nameController.dispose();
    _locationController.dispose();
    _intervalController.dispose();
    super.dispose();
  }

  void _addAsset() {
    final id = _idController.text.trim();
    final name = _nameController.text.trim();
    final interval = int.tryParse(_intervalController.text.trim()) ?? 90;
    if (id.isEmpty || name.isEmpty) return;
    setState(() {
      _assets.add(Asset(
        id: id,
        name: name,
        location: _locationController.text.trim(),
        intervalDays: interval,
        lastService: DateTime.now(),
      ));
    });
    _idController.clear();
    _nameController.clear();
  }

  void _completeService() {
    final id = _idController.text.trim();
    if (id.isEmpty) return;
    setState(() {
      final index = _assets.indexWhere((a) => a.id == id);
      if (index >= 0) {
        _assets[index] = Asset(
          id: _assets[index].id,
          name: _assets[index].name,
          location: _assets[index].location,
          intervalDays: _assets[index].intervalDays,
          lastService: DateTime.now(),
        );
        _workOrders.insert(
            0, '${DateTime.now().toIso8601String()} — service on $id');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final assessments = _assets.map((a) => assessAsset(a, now)).toList()
      ..sort((a, b) => a.daysLeft.compareTo(b.daysLeft));

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(title: const Text('Maintenance & Operations')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 120),
          children: [
            ToolSection(
              title: 'Asset inventory',
              description: 'Add assets with a service interval.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GlassField(controller: _idController, label: 'Asset ID'),
                  GlassField(controller: _nameController, label: 'Name'),
                  GlassField(
                      controller: _locationController, label: 'Location'),
                  GlassField(
                    controller: _intervalController,
                    label: 'Service interval (days)',
                    keyboardType: TextInputType.number,
                  ),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      GlassButton(
                        label: 'Add asset',
                        icon: Icons.add,
                        onPressed: _addAsset,
                      ),
                      GlassButton(
                        label: 'Log service (by ID)',
                        icon: Icons.build_circle,
                        onPressed: _completeService,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            ToolSection(
              title: 'Schedule',
              description: 'Sorted by due date; overdue surfaces first.',
              child: ResultBox(
                text: assessments.isEmpty
                    ? 'No assets yet'
                    : assessments
                        .map((a) =>
                            '${statusLabel(a.status).padRight(9)} ${a.asset.id} ${a.asset.name} — due in ${a.daysLeft}d')
                        .join('\n'),
                height: 180,
              ),
            ),
            ToolSection(
              title: 'Work order history',
              description: 'Session-only service notes.',
              child: ResultBox(
                text: _workOrders.isEmpty
                    ? 'No work orders yet'
                    : _workOrders.take(8).join('\n'),
                height: 130,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
