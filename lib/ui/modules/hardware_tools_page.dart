import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories.dart';
import '../modules/tool_widgets.dart';

/// Module 16 — Hardware Center.
///
/// USB Host enumeration needs native Android code (planned); this release
/// gives honest current capabilities: live interface/link state from the
/// platform, plus user-maintained adapter compatibility reports — a green
/// "supported" state is never claimed from VID/PID alone.
class HardwareToolsPage extends ConsumerStatefulWidget {
  const HardwareToolsPage({super.key});

  @override
  ConsumerState<HardwareToolsPage> createState() => _HardwareToolsPageState();
}

class _HardwareToolsPageState extends ConsumerState<HardwareToolsPage> {
  final _tabletController = TextEditingController();
  final _adapterController = TextEditingController();
  final _resultController = TextEditingController(text: 'works');
  String _interfaces = 'Not loaded';

  @override
  void dispose() {
    _tabletController.dispose();
    _adapterController.dispose();
    _resultController.dispose();
    super.dispose();
  }

  Future<void> _loadInterfaces() async {
    try {
      final interfaces = await NetworkInterface.list(
        includeLoopback: false,
        includeLinkLocal: true,
      );
      final buffer = StringBuffer();
      for (final interface in interfaces) {
        buffer.writeln('${interface.name} (index ${interface.index})');
        for (final address in interface.addresses) {
          buffer.writeln('  ${address.address} ${address.type.name}');
        }
      }
      if (!mounted) return;
      setState(() => _interfaces = buffer.toString().trim());
    } catch (error) {
      if (mounted) setState(() => _interfaces = 'Failed: $error');
    }
  }

  void _addReport() {
    final tablet = _tabletController.text.trim();
    final adapter = _adapterController.text.trim();
    final result = _resultController.text.trim();
    if (tablet.isEmpty || adapter.isEmpty) return;
    ref.read(compatibilityRepositoryProvider).addReport(
          tablet: tablet,
          adapter: adapter,
          result: result,
        );
    _tabletController.clear();
    _adapterController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(title: const Text('Hardware Center')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 120),
          children: [
            ToolSection(
              title: 'Interfaces & link state',
              description: 'What the OS exposes for this device right now.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GlassButton(
                    label: 'Load interfaces',
                    icon: Icons.settings_ethernet,
                    onPressed: _loadInterfaces,
                  ),
                  const SizedBox(height: 10),
                  ResultBox(text: _interfaces, height: 150),
                ],
              ),
            ),
            ToolSection(
              title: 'Compatibility reports (user-maintained)',
              description:
                  'Your device + adapter + observed result. VID/PID alone is never shown as "supported".',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GlassField(
                    controller: _tabletController,
                    label: 'Tablet model / Android',
                  ),
                  GlassField(
                    controller: _adapterController,
                    label: 'Adapter (chipset)',
                  ),
                  GlassField(
                    controller: _resultController,
                    label: 'Observed result (works / partial / fails)',
                  ),
                  GlassButton(
                    label: 'Save report',
                    icon: Icons.save_alt,
                    onPressed: _addReport,
                  ),
                  const SizedBox(height: 10),
                  ref.watch(compatibilityReportsStreamProvider).when(
                        data: (reports) => ResultBox(
                          text: reports.isEmpty
                              ? 'No reports yet'
                              : reports
                                  .map((r) =>
                                      '${r.tablet} × ${r.adapter} → ${r.result}')
                                  .join('\n'),
                          height: 140,
                          copyLabel: 'Reports',
                        ),
                        loading: () => const ResultBox(text: 'Loading…'),
                        error: (error, _) =>
                            ResultBox(text: 'DB error: $error'),
                      ),
                ],
              ),
            ),
            const ToolSection(
              title: 'Platform note',
              description: 'What this build can and cannot see.',
              child: ResultBox(
                text: 'USB enumeration, VID/PID, driver/interface details, '
                    'power-delivery data and adapter test flows need native '
                    'USB Host integration — planned scope, not features of '
                    'this build.',
                height: 110,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
