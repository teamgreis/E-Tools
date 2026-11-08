import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/tools/network_probe.dart';
import '../modules/tool_widgets.dart';

/// Module 04 — Server Administration.
///
/// Offline-first connection profiles and explicit, user-initiated checks.
/// Passwords are never stored here; anything that can change or delete data
/// requires explicit confirmation and is not bundled in this release.
class ServerToolsPage extends ConsumerStatefulWidget {
  const ServerToolsPage({super.key});

  @override
  ConsumerState<ServerToolsPage> createState() => _ServerToolsPageState();
}

class _ServerToolsPageState extends ConsumerState<ServerToolsPage> {
  final List<_ServerProfile> _servers = [];
  final _nameController = TextEditingController();
  final _hostController = TextEditingController();
  final _portController = TextEditingController(text: '22');
  final _kindController = TextEditingController(text: 'SSH');

  String _checkOutput = 'No check yet';
  String _historyOutput = 'No maintenance entries yet';
  _ServerProfile? _selected;

  @override
  void dispose() {
    _nameController.dispose();
    _hostController.dispose();
    _portController.dispose();
    _kindController.dispose();
    super.dispose();
  }

  void _addServer() {
    final name = _nameController.text.trim();
    final host = _hostController.text.trim();
    final port = int.tryParse(_portController.text.trim()) ?? 22;
    if (name.isEmpty || host.isEmpty) return;
    setState(() {
      _servers.add(_ServerProfile(
        name: name,
        host: host,
        port: port,
        kind: _kindController.text.trim(),
      ));
      _selected ??= _servers.last;
    });
    _nameController.clear();
    _hostController.clear();
  }

  Future<void> _checkSelected() async {
    final server = _selected;
    if (server == null) return;
    final buffer = StringBuffer();
    buffer.writeln(
        '${server.name} — ${server.host}:${server.port} (${server.kind})');

    final probe = await tcpProbe(server.host, server.port, count: 2);
    buffer.writeln('TCP reachable: ${probe.successes}/${probe.attempts}');
    if (probe.errors.isNotEmpty) {
      buffer.writeln('last error: ${probe.errors.last}');
    }
    buffer.writeln(
        'HTTP/API checks remain an explicit action in the Network module.');
    setState(() => _checkOutput = buffer.toString());
  }

  void _addMaintenanceEntry() {
    final server = _selected;
    if (server == null) return;
    final now = DateTime.now();
    setState(() {
      _historyOutput =
          '${now.toIso8601String()} — service note for ${server.name}\n'
          '$_historyOutput';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(title: const Text('Server Administration')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 120),
          children: [
            ToolSection(
              title: 'Server inventory',
              description:
                  'Local profiles only — no passwords stored, no background connect. Destructive actions are not part of this release.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GlassField(controller: _nameController, label: 'Name'),
                  GlassField(controller: _hostController, label: 'Host'),
                  Row(
                    children: [
                      Expanded(
                        child: GlassField(
                          controller: _portController,
                          label: 'Port',
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: GlassField(
                          controller: _kindController,
                          label: 'Kind (SSH/HTTP/…)',
                        ),
                      ),
                    ],
                  ),
                  GlassButton(
                    label: 'Add profile',
                    icon: Icons.add,
                    onPressed: _addServer,
                  ),
                  const SizedBox(height: 10),
                  if (_servers.isEmpty)
                    const ResultBox(
                        text: 'No servers yet — add a profile above.')
                  else
                    ResultBox(
                      text: _servers
                          .map((s) =>
                              '${s.name} · ${s.host}:${s.port} · ${s.kind}')
                          .join('\n'),
                    ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    initialValue: _selected == null
                        ? null
                        : '${_selected!.name}|${_selected!.host}|${_selected!.port}|${_selected!.kind}',
                    decoration: const InputDecoration(
                      labelText: 'Active server',
                      border: OutlineInputBorder(),
                    ),
                    items: [
                      for (final server in _servers)
                        DropdownMenuItem(
                          value:
                              '${server.name}|${server.host}|${server.port}|${server.kind}',
                          child: Text('${server.name} (${server.host})'),
                        ),
                    ],
                    onChanged: (value) {
                      final parts = value?.split('|');
                      if (parts == null || parts.length != 4) return;
                      setState(() {
                        _selected = _ServerProfile(
                          name: parts[0],
                          host: parts[1],
                          port: int.tryParse(parts[2]) ?? 22,
                          kind: parts[3],
                        );
                      });
                    },
                  ),
                ],
              ),
            ),
            ToolSection(
              title: 'Reachability',
              description: 'Explicit TCP probe against the active profile.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GlassButton(
                    label: 'Probe active server',
                    icon: Icons.network_check,
                    onPressed: _selected == null ? null : _checkSelected,
                  ),
                  const SizedBox(height: 10),
                  ResultBox(text: _checkOutput),
                ],
              ),
            ),
            ToolSection(
              title: 'Maintenance history',
              description: 'Local service notes per active profile.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GlassButton(
                    label: 'Add note "service performed"',
                    icon: Icons.build,
                    onPressed: _selected == null ? null : _addMaintenanceEntry,
                  ),
                  const SizedBox(height: 10),
                  ResultBox(text: _historyOutput),
                ],
              ),
            ),
            const ToolSection(
              title: 'Security notes',
              description: 'Explicit boundaries of this module.',
              child: ResultBox(
                text: '• Passwords/keys are never stored in the profile\n'
                    '• No unauthenticated Docker socket is exposed\n'
                    '• Destructive server actions require explicit confirmation '
                    '(not bundled yet)\n'
                    '• SSH terminal, agent metrics and Docker lifecycle are '
                    'planned scope, not features',
                height: 110,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ServerProfile {
  _ServerProfile({
    required this.name,
    required this.host,
    required this.port,
    required this.kind,
  });

  final String name;
  final String host;
  final int port;
  final String kind;
}
