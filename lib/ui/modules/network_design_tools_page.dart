import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/tools/subnet_planner.dart';
import '../modules/tool_widgets.dart';

/// Module 13 — Network Design.
///
/// Deterministic planning math: equal splits, VLSM allocation and basic
/// IPv6 validation. No RF measurement is claimed.
class NetworkDesignToolsPage extends ConsumerStatefulWidget {
  const NetworkDesignToolsPage({super.key});

  @override
  ConsumerState<NetworkDesignToolsPage> createState() =>
      _NetworkDesignToolsPageState();
}

class _NetworkDesignToolsPageState
    extends ConsumerState<NetworkDesignToolsPage> {
  final _baseController = TextEditingController(text: '10.10.0.0/22');
  final _prefixController = TextEditingController(text: '22');
  final _splitController = TextEditingController(text: '16');
  final _vlsmController = TextEditingController(text: '100, 50, 25, 10');
  final _ipv6Controller = TextEditingController(text: '2001:db8::1');

  String _splitOutput = '';
  String _vlsmOutput = '';
  String _ipv6Output = '';

  @override
  void dispose() {
    _baseController.dispose();
    _prefixController.dispose();
    _splitController.dispose();
    _vlsmController.dispose();
    _ipv6Controller.dispose();
    super.dispose();
  }

  void _split() {
    final base = _baseController.text.trim();
    final prefix = int.tryParse(_prefixController.text.trim()) ?? 0;
    final count = int.tryParse(_splitController.text.trim()) ?? 0;
    final subnets = splitIntoEqualSubnets(base, prefix, count);
    if (!mounted) return;
    setState(() {
      _splitOutput = subnets == null
          ? 'Invalid input — check base/prefix/count (base block too small?)'
          : subnets.map((s) => s.toString()).join('\n');
    });
  }

  void _vlsm() {
    final base = _baseController.text.trim();
    final prefix = int.tryParse(_prefixController.text.trim()) ?? 24;
    final hosts = _vlsmController.text
        .split(',')
        .map((e) => int.tryParse(e.trim()) ?? 0)
        .toList();
    final subnets = allocateVlsm(base, prefix, hosts);
    if (!mounted) return;
    setState(() {
      _vlsmOutput = subnets == null
          ? 'Invalid input'
          : subnets
              .map((s) => '${s.network}/${s.prefix}  (${s.usableHosts} hosts)')
              .join('\n');
    });
  }

  void _checkIpv6() {
    final input = _ipv6Controller.text.trim();
    if (!mounted) return;
    setState(() {
      _ipv6Output = isValidIpv6(input)
          ? '$input is a well-formed-looking IPv6 address'
          : '$input does not parse as IPv6';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(title: const Text('Network Design')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 120),
          children: [
            ToolSection(
              title: 'Equal subnet split',
              description: 'Split a base block into N equal subnets.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GlassField(
                      controller: _baseController, label: 'Base network'),
                  Row(
                    children: [
                      Expanded(
                        child: GlassField(
                          controller: _prefixController,
                          label: 'Prefix',
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: GlassField(
                          controller: _splitController,
                          label: 'Count',
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  GlassButton(
                    label: 'Split',
                    icon: Icons.call_split,
                    onPressed: _split,
                  ),
                  const SizedBox(height: 10),
                  ResultBox(text: _splitOutput, height: 200),
                ],
              ),
            ),
            ToolSection(
              title: 'VLSM allocation',
              description: 'Allocate by required host counts (largest first).',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GlassField(
                    controller: _vlsmController,
                    label: 'Host counts (comma separated)',
                  ),
                  GlassButton(
                    label: 'Allocate',
                    icon: Icons.account_tree,
                    onPressed: _vlsm,
                  ),
                  const SizedBox(height: 10),
                  ResultBox(text: _vlsmOutput, height: 170),
                ],
              ),
            ),
            ToolSection(
              title: 'IPv6 validation',
              description: 'Structure check only — no connectivity implied.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GlassField(
                      controller: _ipv6Controller, label: 'IPv6 address'),
                  GlassButton(
                    label: 'Validate',
                    icon: Icons.check,
                    onPressed: _checkIpv6,
                  ),
                  const SizedBox(height: 10),
                  ResultBox(text: _ipv6Output, height: 70),
                ],
              ),
            ),
            const ToolSection(
              title: 'Planned, not implemented',
              description: 'Honest scope.',
              child: ResultBox(
                text: 'Visual topology editor · rack/patch-panel elevations · '
                    'site surveys (no calibrated RF claim) · plan-vs-observed diff',
                height: 90,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
