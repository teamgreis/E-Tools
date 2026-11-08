import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/tools/modbus_frames.dart';
import '../modules/tool_widgets.dart';

/// Module 14 — Industrial Technology.
///
/// Read-only Modbus TCP client (function codes 3/4) with scaling and a
/// register table. Writes and commands are intentionally not implemented;
/// USB-RS485/RTU, MQTT, OPC UA and CAN need adapter hardware and are
/// labelled planned scope.
class IndustrialToolsPage extends ConsumerStatefulWidget {
  const IndustrialToolsPage({super.key});

  @override
  ConsumerState<IndustrialToolsPage> createState() =>
      _IndustrialToolsPageState();
}

class _IndustrialToolsPageState extends ConsumerState<IndustrialToolsPage> {
  final _hostController = TextEditingController(text: '192.168.1.50');
  final _portController = TextEditingController(text: '502');
  final _unitController = TextEditingController(text: '1');
  final _addressController = TextEditingController(text: '0');
  final _quantityController = TextEditingController(text: '10');
  final _scaleController = TextEditingController(text: '1');
  final _offsetController = TextEditingController(text: '0');

  bool _busy = false;
  String _output = 'No poll yet — explicit action only.';

  @override
  void dispose() {
    _hostController.dispose();
    _portController.dispose();
    _unitController.dispose();
    _addressController.dispose();
    _quantityController.dispose();
    _scaleController.dispose();
    _offsetController.dispose();
    super.dispose();
  }

  Future<void> _poll() async {
    final host = _hostController.text.trim();
    final port = int.tryParse(_portController.text.trim()) ?? 502;
    final unitId = int.tryParse(_unitController.text.trim()) ?? 1;
    final address = int.tryParse(_addressController.text.trim()) ?? 0;
    final quantity = int.tryParse(_quantityController.text.trim()) ?? 1;
    final factor = double.tryParse(_scaleController.text) ?? 1;
    final offset = double.tryParse(_offsetController.text) ?? 0;

    setState(() => _busy = true);
    Socket? socket;
    try {
      socket =
          await Socket.connect(host, port, timeout: const Duration(seconds: 5));
      final request = buildReadRegisters(
        transactionId: 1,
        unitId: unitId,
        functionCode: 3,
        startAddress: address,
        quantity: quantity,
      );
      socket.add(Uint8List.fromList(request));
      final response = await _readResponse(socket, quantity);
      final parsed = parseReadRegisters(response);
      if (!mounted) return;
      final buffer = StringBuffer();
      if (!parsed.ok) {
        buffer.writeln('Modbus exception ${parsed.exceptionCode} '
            '(${modbusExceptionName(parsed.exceptionCode ?? -1)})');
      } else {
        buffer.writeln('Read ${parsed.registers.length} registers from '
            'unit $unitId @ $address');
        buffer.writeln('addr | raw    | scaled');
        for (var i = 0; i < parsed.registers.length; i++) {
          buffer.writeln(
              '${(address + i).toString().padLeft(5)} | ${parsed.registers[i].toString().padLeft(6)} | '
              '${scaleRegister(parsed.registers[i], factor: factor, offset: offset).toStringAsFixed(2)}');
        }
      }
      setState(() => _output = buffer.toString());
    } catch (error) {
      if (mounted) setState(() => _output = 'Modbus TCP failed: $error');
    } finally {
      socket?.destroy();
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<List<int>> _readResponse(Socket socket, int quantity) async {
    final completer = Completer<List<int>>();
    final bytes = <int>[];
    late StreamSubscription<List<int>> subscription;
    subscription = socket.listen((data) {
      bytes.addAll(data);
      // MBAP(7) + FC(1) + byteCount(1) + data
      final expected = 9 + quantity * 2;
      if (bytes.length >= expected) {
        subscription.cancel();
        completer.complete(bytes);
      }
    });
    return completer.future.timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        subscription.cancel();
        return bytes;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(title: const Text('Industrial Technology')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 120),
          children: [
            ToolSection(
              title: 'Modbus TCP (read-only)',
              description:
                  'Function code 3, holding registers. No writes, no commands.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                          controller: _unitController,
                          label: 'Unit ID',
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: GlassField(
                          controller: _addressController,
                          label: 'Start address',
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: GlassField(
                          controller: _quantityController,
                          label: 'Quantity (1–125)',
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: GlassField(
                          controller: _scaleController,
                          label: 'Scale factor',
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: GlassField(
                          controller: _offsetController,
                          label: 'Offset',
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  GlassButton(
                    label: 'Read registers',
                    icon: Icons.download,
                    busy: _busy,
                    onPressed: _poll,
                  ),
                  const SizedBox(height: 10),
                  ResultBox(text: _output, height: 240),
                ],
              ),
            ),
            const ToolSection(
              title: 'Safety',
              description: 'Explicit scope boundaries.',
              child: ResultBox(
                text: 'Read-only operations only. No writes, commands or '
                    'control actions. No safety-rated control capability is '
                    'implied. USB-RS485/RTU, serial console, MQTT, OPC UA and '
                    'CAN are planned adapter-dependent scope.',
                height: 120,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
