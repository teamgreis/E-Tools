import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/tools/network_calculator.dart';
import '../../core/tools/network_probe.dart';
import '../modules/tool_widgets.dart';

/// Module 01 — Network & Connectivity.
///
/// Every tool is reachable from one page; each probe is an explicit user
/// action, shows timeouts/partial results, and labels platform limits
/// (e.g. ICMP ping is not available to unprivileged Android apps).
class NetworkToolsPage extends ConsumerStatefulWidget {
  const NetworkToolsPage({super.key});

  @override
  ConsumerState<NetworkToolsPage> createState() => _NetworkToolsPageState();
}

class _NetworkToolsPageState extends ConsumerState<NetworkToolsPage> {
  final _subnetController = TextEditingController(text: '192.168.1.10/24');
  final _probeHostController = TextEditingController(text: '192.168.1.1');
  final _probePortController = TextEditingController(text: '80');
  final _dnsController = TextEditingController(text: 'example.com');
  final _scanHostController = TextEditingController(text: '127.0.0.1');
  final _scanStartController = TextEditingController(text: '20');
  final _scanEndController = TextEditingController(text: '100');
  final _httpController = TextEditingController(text: 'https://example.com');
  final _tlsHostController = TextEditingController(text: 'example.com');

  String _subnetOutput = '';
  String _interfaceOutput = 'Not loaded';
  String _probeOutput = 'No probe yet';
  String _dnsOutput = 'No lookup yet';
  String _scanOutput = 'No scan yet';
  String _httpOutput = 'No request yet';
  String _tlsOutput = 'No inspection yet';
  String _publicIpOutput = 'Not fetched (explicit action required)';

  bool _busyProbe = false;
  bool _busyScan = false;
  bool _busyHttp = false;
  bool _busyTls = false;
  bool _busyPublicIp = false;

  Future<void> _loadInterfaces() async {
    try {
      final interfaces = await NetworkInterface.list(
        includeLoopback: true,
        includeLinkLocal: true,
      );
      final buffer = StringBuffer();
      for (final interface in interfaces) {
        buffer.writeln('${interface.name} (index ${interface.index})');
        for (final address in interface.addresses) {
          buffer.writeln('  ${address.address} ${address.type.name}');
        }
      }
      setState(() => _interfaceOutput = buffer.toString().trim());
    } catch (error) {
      setState(() => _interfaceOutput = 'Failed: $error');
    }
  }

  Future<void> _runSubnet() async {
    final info = subnetInfo(_subnetController.text);
    setState(() {
      _subnetOutput = info == null
          ? 'Invalid IPv4/CIDR input — e.g. 192.168.1.10/24'
          : formatSubnetInfo(info);
    });
  }

  Future<void> _runProbe() async {
    final host = _probeHostController.text.trim();
    final port = int.tryParse(_probePortController.text.trim()) ?? 80;
    setState(() => _busyProbe = true);
    final result = await tcpProbe(host, port, count: 4);
    if (!mounted) return;
    final buffer = StringBuffer();
    buffer.writeln('Target        $host:$port (TCP)');
    buffer.writeln('Probes        ${result.attempts}');
    buffer.writeln('Reachable     ${result.successes}');
    buffer.writeln(
        'RTT min/avg/max ${result.minMs}/${result.averageMs.round()}/${result.maxMs} ms');
    buffer.writeln(
        'Note: ICMP echo is not available to apps — reachability is measured via TCP connects.');
    buffer.writeln('Errors:');
    buffer.writeln(result.errors.isEmpty ? '  none' : result.errors.join('\n'));
    setState(() {
      _busyProbe = false;
      _probeOutput = buffer.toString();
    });
  }

  Future<void> _runDns() async {
    final host = _dnsController.text.trim();
    if (host.isEmpty) return;
    final result = await dnsLookup(host);
    if (!mounted) return;
    final buffer = StringBuffer();
    if (result.ok) {
      buffer.writeln(
          '${result.addresses.length} addresses (${result.durationMs} ms)');
      buffer.writeln(result.addresses.join('\n'));
    } else {
      buffer.writeln('DNS failed: ${result.error} (${result.durationMs} ms)');
    }
    setState(() => _dnsOutput = buffer.toString());
  }

  Future<void> _runScan() async {
    final host = _scanHostController.text.trim();
    final start = int.tryParse(_scanStartController.text.trim()) ?? 20;
    final end = int.tryParse(_scanEndController.text.trim()) ?? 100;
    setState(() => _busyScan = true);
    final result = await portScan(host, start, end);
    if (!mounted) return;
    final buffer = StringBuffer()
      ..writeln(
          '$host: scanned $start–$end (${result.scanned} ports) in ${result.durationMs} ms')
      ..writeln(
          'Open: ${result.openPorts.isEmpty ? 'none' : result.openPorts.join(', ')}');
    setState(() {
      _busyScan = false;
      _scanOutput = buffer.toString();
    });
  }

  Future<void> _runHttp() async {
    final url = _httpController.text.trim();
    setState(() => _busyHttp = true);
    final result = await httpCheck(url);
    if (!mounted) return;
    final buffer = StringBuffer();
    if (result.ok) {
      buffer.writeln('Status   ${result.statusCode} ${result.reason}');
      buffer.writeln('Time     ${result.timeMs} ms');
      buffer.writeln('Headers');
      buffer.writeln(result.headers.entries
          .map((e) => '  ${e.key}: ${e.value}')
          .join('\n'));
    } else {
      buffer.writeln(result.error ?? 'Request failed');
    }
    setState(() {
      _busyHttp = false;
      _httpOutput = buffer.toString();
    });
  }

  Future<void> _runTls() async {
    final host = _tlsHostController.text.trim();
    setState(() => _busyTls = true);
    final result = await tlsInspect(host);
    if (!mounted) return;
    final buffer = StringBuffer();
    if (result.ok) {
      buffer.writeln('Subject   ${result.subject}');
      buffer.writeln('Issuer    ${result.issuer}');
      buffer.writeln('Valid     ${result.validFrom} → ${result.validUntil}');
      buffer.writeln('Remaining ${result.daysRemaining} days');
      buffer.writeln('SHA-1     ${result.sha1}');
      buffer.writeln(
          'Note: cipher/chain validation is reported by the system trust store.');
    } else {
      buffer.writeln(result.error ?? 'Inspection failed');
    }
    setState(() {
      _busyTls = false;
      _tlsOutput = buffer.toString();
    });
  }

  Future<void> _runPublicIp() async {
    setState(() => _busyPublicIp = true);
    try {
      final ip = await publicIp();
      if (!mounted) return;
      setState(() => _publicIpOutput = 'Public IPv4: $ip');
    } catch (error) {
      setState(() => _publicIpOutput = 'Failed (needs internet): $error');
    } finally {
      if (mounted) setState(() => _busyPublicIp = false);
    }
  }

  @override
  void dispose() {
    _subnetController.dispose();
    _probeHostController.dispose();
    _probePortController.dispose();
    _dnsController.dispose();
    _scanHostController.dispose();
    _scanStartController.dispose();
    _scanEndController.dispose();
    _httpController.dispose();
    _tlsHostController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(title: const Text('Network & Connectivity')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 120),
          children: [
            ToolSection(
              title: 'Network interfaces',
              description: 'Local addresses of this device (offline).',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GlassButton(
                    label: 'List interfaces',
                    icon: Icons.list_alt,
                    onPressed: _loadInterfaces,
                  ),
                  const SizedBox(height: 10),
                  ResultBox(text: _interfaceOutput),
                ],
              ),
            ),
            ToolSection(
              title: 'Subnet calculator',
              description:
                  'IPv4 validation, CIDR, network/broadcast, usable range.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GlassField(
                    controller: _subnetController,
                    label: 'IPv4 / CIDR',
                    hint: '192.168.1.10/24',
                  ),
                  GlassButton(
                    label: 'Calculate',
                    icon: Icons.calculate_outlined,
                    onPressed: _runSubnet,
                  ),
                  const SizedBox(height: 10),
                  ResultBox(text: _subnetOutput),
                ],
              ),
            ),
            ToolSection(
              title: 'Reachability probe (TCP)',
              description:
                  'TCP connect RTT instead of ICMP ping — platform limit is shown.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GlassField(
                    controller: _probeHostController,
                    label: 'Host',
                  ),
                  GlassField(
                    controller: _probePortController,
                    label: 'TCP port',
                    keyboardType: TextInputType.number,
                  ),
                  GlassButton(
                    label: 'Probe 4×',
                    icon: Icons.network_check,
                    busy: _busyProbe,
                    onPressed: _runProbe,
                  ),
                  const SizedBox(height: 10),
                  ResultBox(text: _probeOutput),
                ],
              ),
            ),
            ToolSection(
              title: 'DNS lookup',
              description:
                  'A/AAAA records; DNS failures are distinguished from transport failures.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GlassField(controller: _dnsController, label: 'Hostname'),
                  GlassButton(
                    label: 'Resolve',
                    icon: Icons.dns_outlined,
                    onPressed: _runDns,
                  ),
                  const SizedBox(height: 10),
                  ResultBox(text: _dnsOutput),
                ],
              ),
            ),
            ToolSection(
              title: 'TCP port scan',
              description:
                  'Explicit action only. Scan networks you are authorized to test.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GlassField(controller: _scanHostController, label: 'Host'),
                  Row(
                    children: [
                      Expanded(
                        child: GlassField(
                          controller: _scanStartController,
                          label: 'From port',
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: GlassField(
                          controller: _scanEndController,
                          label: 'To port',
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  GlassButton(
                    label: 'Scan range',
                    icon: Icons.travel_explore,
                    busy: _busyScan,
                    onPressed: _runScan,
                  ),
                  const SizedBox(height: 10),
                  ResultBox(text: _scanOutput),
                ],
              ),
            ),
            ToolSection(
              title: 'HTTP check',
              description:
                  'Status, headers and timing. Redirects are not followed.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GlassField(controller: _httpController, label: 'URL'),
                  GlassButton(
                    label: 'Request',
                    icon: Icons.http,
                    busy: _busyHttp,
                    onPressed: _runHttp,
                  ),
                  const SizedBox(height: 10),
                  ResultBox(text: _httpOutput),
                ],
              ),
            ),
            ToolSection(
              title: 'TLS certificate',
              description: 'Peer certificate details for a host.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GlassField(controller: _tlsHostController, label: 'Host'),
                  GlassButton(
                    label: 'Inspect',
                    icon: Icons.lock_outline,
                    busy: _busyTls,
                    onPressed: _runTls,
                  ),
                  const SizedBox(height: 10),
                  ResultBox(text: _tlsOutput),
                ],
              ),
            ),
            ToolSection(
              title: 'Public IP',
              description:
                  'Your public IPv4 via api.ipify.org (network required).',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GlassButton(
                    label: 'Fetch public IP',
                    icon: Icons.public,
                    busy: _busyPublicIp,
                    onPressed: _runPublicIp,
                  ),
                  const SizedBox(height: 10),
                  ResultBox(text: _publicIpOutput),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
