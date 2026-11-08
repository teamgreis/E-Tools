import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/tools/diagnostics_sequence.dart';
import '../modules/tool_widgets.dart';

/// Module 12 — Diagnostics & Troubleshooting.
///
/// Runs the documented smart sequence: resolve → addresses → TCP → HTTP →
/// TLS, and separates measured facts from hypotheses.
class DiagnosticsToolsPage extends ConsumerStatefulWidget {
  const DiagnosticsToolsPage({super.key});

  @override
  ConsumerState<DiagnosticsToolsPage> createState() =>
      _DiagnosticsToolsPageState();
}

class _DiagnosticsToolsPageState extends ConsumerState<DiagnosticsToolsPage> {
  final _hostController = TextEditingController(text: 'example.com');
  final _portController = TextEditingController(text: '443');
  bool _busy = false;
  String _reportOutput = 'No diagnostics run yet — explicit action.';

  Future<void> _run() async {
    final host = _hostController.text.trim();
    final port = int.tryParse(_portController.text.trim()) ?? 443;
    if (host.isEmpty) return;
    setState(() => _busy = true);
    final report = await runDiagnostics(host, port: port);
    if (!mounted) return;
    setState(() {
      _busy = false;
      _reportOutput = report.format();
    });
  }

  @override
  void dispose() {
    _hostController.dispose();
    _portController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(title: const Text('Diagnostics & Troubleshooting')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 120),
          children: [
            ToolSection(
              title: 'Smart diagnostics',
              description:
                  'resolve → addresses → TCP reachability → HTTP → TLS, facts separated from hypotheses.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GlassField(controller: _hostController, label: 'Host'),
                  GlassField(
                    controller: _portController,
                    label: 'Port',
                    keyboardType: TextInputType.number,
                  ),
                  GlassButton(
                    label: 'Run diagnostics',
                    icon: Icons.health_and_safety,
                    busy: _busy,
                    onPressed: _run,
                  ),
                  const SizedBox(height: 10),
                  ResultBox(text: _reportOutput, height: 320),
                ],
              ),
            ),
            const ToolSection(
              title: 'Evidence discipline',
              description: 'How to read the report.',
              child: ResultBox(
                text: 'FACT = measured by this device just now\n'
                    'HINT = hypothesis, not a measurement\n'
                    'Timeouts and partial failures are always shown\n'
                    'Only test systems you are authorized to test',
                height: 110,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
