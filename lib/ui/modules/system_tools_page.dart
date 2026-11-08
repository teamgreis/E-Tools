import 'dart:async';

import 'package:battery_plus/battery_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensors_plus/sensors_plus.dart';

import '../modules/tool_widgets.dart';

/// Module 02 — System & Device.
///
/// Surfaces what Android actually exposes. OEM-restricted data (exact
/// battery health, thermal state, full process lists) is labelled, not
/// silently shown or promised.
class SystemToolsPage extends ConsumerStatefulWidget {
  const SystemToolsPage({super.key});

  @override
  ConsumerState<SystemToolsPage> createState() => _SystemToolsPageState();
}

class _SystemToolsPageState extends ConsumerState<SystemToolsPage> {
  String _deviceOutput = 'Not loaded';
  bool _sensorsActive = false;
  String _sensorOutput = 'Sensors paused';
  String _batteryOutput = 'Not loaded';
  StreamSubscription<AccelerometerEvent>? _accelSubscription;
  StreamSubscription<BatteryState>? _batterySubscription;

  @override
  void dispose() {
    _accelSubscription?.cancel();
    _batterySubscription?.cancel();
    super.dispose();
  }

  Future<void> _loadDeviceInfo() async {
    try {
      final info = await DeviceInfoPlugin().androidInfo;
      final buffer = StringBuffer()
        ..writeln('Brand         ${info.brand}')
        ..writeln('Manufacturer  ${info.manufacturer}')
        ..writeln('Model         ${info.model}')
        ..writeln('Device        ${info.device}')
        ..writeln('Board         ${info.board}')
        ..writeln('Hardware      ${info.hardware}')
        ..writeln(
            'Android       ${info.version.release} (API ${info.version.sdkInt})')
        ..writeln('Security patch ${info.version.securityPatch}')
        ..writeln('ABIs          ${info.supportedAbis.join(', ')}')
        ..writeln('Physical device ${info.isPhysicalDevice}')
        ..writeln('System features (selection):')
        ..writeln('  ${info.systemFeatures.take(6).join('\n  ')}');
      setState(() => _deviceOutput = buffer.toString());
    } catch (error) {
      setState(() => _deviceOutput = 'Failed: $error');
    }
  }

  void _toggleSensors() {
    if (_sensorsActive) {
      _accelSubscription?.cancel();
      _accelSubscription = null;
      setState(() {
        _sensorsActive = false;
        _sensorOutput = 'Sensors paused';
      });
      return;
    }
    setState(() {
      _sensorsActive = true;
      _sensorOutput = 'Accelerometer started…';
    });
    _accelSubscription = accelerometerEventStream(
      samplingPeriod: const Duration(milliseconds: 200),
    ).listen((event) {
      if (!mounted) return;
      setState(() {
        _sensorOutput = 'x ${event.x.toStringAsFixed(2)} m/s²\n'
            'y ${event.y.toStringAsFixed(2)} m/s²\n'
            'z ${event.z.toStringAsFixed(2)} m/s²';
      });
    });
  }

  Future<void> _loadBattery() async {
    final battery = Battery();
    try {
      final level = await battery.batteryLevel;
      setState(() => _batteryOutput = 'Battery level $level%');
    } catch (error) {
      setState(() => _batteryOutput = 'Failed: $error');
    }
    await _batterySubscription?.cancel();
    // ignore: unawaited_futures
    _batterySubscription = battery.onBatteryStateChanged.listen((state) {
      if (!mounted) return;
      setState(() => _batteryOutput += '\nState: ${state.name}');
    });
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.sizeOf(context);
    final metrics = MediaQuery.devicePixelRatioOf(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(title: const Text('System & Device')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 120),
          children: [
            ToolSection(
              title: 'Display',
              description: 'Current window metrics from the live layout.',
              child: ResultBox(
                text: 'Width    ${media.width.toStringAsFixed(0)} dp\n'
                    'Height   ${media.height.toStringAsFixed(0)} dp\n'
                    'Density  $metrics\n'
                    'Mode     ${media.width > media.height ? 'landscape' : 'portrait'}',
                height: 90,
              ),
            ),
            ToolSection(
              title: 'Device information',
              description: 'Manufacturer, model, Android version, ABIs.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GlassButton(
                    label: 'Load device info',
                    icon: Icons.perm_device_information,
                    onPressed: _loadDeviceInfo,
                  ),
                  const SizedBox(height: 10),
                  ResultBox(text: _deviceOutput, height: 220),
                ],
              ),
            ),
            ToolSection(
              title: 'Live sensors',
              description:
                  'Accelerometer stream. Some tablets expose fewer sensors — an empty stream means the hardware is absent.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GlassButton(
                    label: _sensorsActive ? 'Stop sensors' : 'Start sensors',
                    icon: _sensorsActive ? Icons.stop : Icons.sensors,
                    onPressed: _toggleSensors,
                  ),
                  const SizedBox(height: 10),
                  ResultBox(text: _sensorOutput, height: 120),
                ],
              ),
            ),
            ToolSection(
              title: 'Battery',
              description:
                  'Level and charging state. Exact battery health and thermal data are OEM-restricted and not claimed.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GlassButton(
                    label: 'Load battery',
                    icon: Icons.battery_full,
                    onPressed: _loadBattery,
                  ),
                  const SizedBox(height: 10),
                  ResultBox(text: _batteryOutput, height: 90),
                ],
              ),
            ),
            const ToolSection(
              title: 'Capabilities',
              description: 'Honest capability summary.',
              child: ResultBox(
                text: 'Device info: platform API\n'
                    'Sensors: sensors_plus streams\n'
                    'Battery level/state: platform API\n'
                    'Battery health, thermal, process list, full app inventory: not promised',
                height: 120,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
