import 'package:flutter/material.dart';

import 'tool_module.dart';

/// The central tool registry.
///
/// The registry is the single extension point of the app:
///
/// ```dart
/// ModuleRegistry.register(const ToolModule(
///   id: 'my_tool',
///   title: 'My Tool',
///   description: 'What it does',
///   icon: Icons.extension,
///   category: 'Development',
///   pageBuilder: (context) => const MyToolPage(),
/// ));
/// ```
///
/// Call [registerDefaults] once during startup (see `main.dart`) and call
/// [register] for any additionally installed module afterwards.
class ModuleRegistry {
  ModuleRegistry._();

  static final Map<String, ToolModule> _modules = <String, ToolModule>{};

  /// Registers or replaces a module.
  static void register(ToolModule module) {
    _modules[module.id] = module;
  }

  static ToolModule? byId(String id) => _modules[id];

  /// All modules, grouped by category, in stable registration order
  /// within each group.
  static List<ToolModule> get all {
    final ordered = <String>[];
    final grouped = <String, List<ToolModule>>{};
    for (final module in _modules.values) {
      grouped.putIfAbsent(module.category, () => <ToolModule>[]).add(module);
      if (!ordered.contains(module.category)) ordered.add(module.category);
    }
    return [
      for (final category in ordered) ...grouped[category]!,
    ];
  }

  static List<String> get categories {
    final categories = <String>[];
    for (final module in all) {
      if (!categories.contains(module.category)) {
        categories.add(module.category);
      }
    }
    return categories;
  }

  static List<ToolModule> byCategory(String category) {
    return all.where((module) => module.category == category).toList();
  }

  /// Registers the built-in module catalogue (16 planned scopes).
  static void registerDefaults() {
    const modules = <ToolModule>[
      ToolModule(
        id: 'network_connectivity',
        title: 'Network & Connectivity',
        description: 'IP, DNS, HTTP, TLS and network tests',
        icon: Icons.lan_outlined,
        category: 'Network',
        tags: ['ip', 'dns', 'ping', 'tls', 'http'],
      ),
      ToolModule(
        id: 'system_device',
        title: 'System & Device',
        description: 'Device information and sensor overview',
        icon: Icons.devices_outlined,
        category: 'System',
        tags: ['device', 'sensors', 'info'],
      ),
      ToolModule(
        id: 'developer_tools',
        title: 'Developer Tools',
        description: 'JSON, encoders, hashes and text utilities',
        icon: Icons.code,
        category: 'Development',
        tags: ['json', 'hash', 'encode', 'format'],
      ),
      ToolModule(
        id: 'server_administration',
        title: 'Server Administration',
        description: 'SSH, Docker, monitoring and APIs',
        icon: Icons.dns_outlined,
        category: 'Server',
        tags: ['ssh', 'docker', 'api', 'monitoring'],
      ),
      ToolModule(
        id: 'electrical_engineering',
        title: 'Electrical Engineering',
        description: 'Electrical calculations and circuit records',
        icon: Icons.electrical_services_outlined,
        category: 'Electrical',
        tags: ['circuit', 'calculation', 'ohm', 'power'],
      ),
      ToolModule(
        id: 'printing_3d',
        title: '3D Printing',
        description: 'Filament, cost and G-code inspection',
        icon: Icons.view_in_ar_outlined,
        category: 'Fabrication',
        tags: ['filament', 'gcode', 'slicer'],
      ),
      ToolModule(
        id: 'automation_workflow',
        title: 'Automation & Workflow',
        description: 'Build and manage repeatable workflows',
        icon: Icons.account_tree_outlined,
        category: 'Automation',
        tags: ['workflow', 'script', 'trigger'],
      ),
      ToolModule(
        id: 'security_privacy',
        title: 'Security & Privacy',
        description: 'Secrets, hashes and certificate checks',
        icon: Icons.shield_outlined,
        category: 'Security',
        tags: ['secret', 'certificate', 'hash', 'vault'],
      ),
      ToolModule(
        id: 'files_documents',
        title: 'Files & Documents',
        description: 'Inspect, compare and organize files',
        icon: Icons.folder_outlined,
        category: 'Files',
        tags: ['file', 'document', 'compare'],
      ),
      ToolModule(
        id: 'productivity',
        title: 'Productivity',
        description: 'Notes, tasks, timers and workspaces',
        icon: Icons.check_circle_outline,
        category: 'Productivity',
        tags: ['notes', 'tasks', 'timer'],
      ),
      ToolModule(
        id: 'barcode_scanner',
        title: 'Barcode & Scanner',
        description: 'Scan and generate QR codes and barcodes',
        icon: Icons.qr_code_scanner,
        category: 'Capture',
        tags: ['qr', 'barcode', 'scan'],
      ),
      ToolModule(
        id: 'diagnostics_troubleshooting',
        title: 'Diagnostics & Troubleshooting',
        description: 'Guided checks and diagnostic reports',
        icon: Icons.troubleshoot,
        category: 'Diagnostics',
        tags: ['diagnostic', 'report', 'checklist'],
      ),
      ToolModule(
        id: 'network_design',
        title: 'Network Design',
        description: 'IP ranges, VLANs, racks and cable planning',
        icon: Icons.hub_outlined,
        category: 'Network',
        tags: ['vlan', 'subnet', 'rack', 'design'],
      ),
      ToolModule(
        id: 'industrial_technology',
        title: 'Industrial Technology',
        description: 'Modbus, MQTT and OPC UA endpoints',
        icon: Icons.precision_manufacturing_outlined,
        category: 'Industrial',
        tags: ['modbus', 'mqtt', 'opcua', 'plc'],
      ),
      ToolModule(
        id: 'maintenance_operations',
        title: 'Maintenance & Operations',
        description: 'Maintenance tasks, records and equipment history',
        icon: Icons.handyman_outlined,
        category: 'Operations',
        tags: ['maintenance', 'service', 'equipment'],
      ),
      ToolModule(
        id: 'hardware_center',
        title: 'Hardware Center',
        description: 'USB adapters and measurement interfaces',
        icon: Icons.memory,
        category: 'Hardware',
        tags: ['usb', 'adapter', 'measurement', 'serial'],
      ),
    ];

    for (final module in modules) {
      register(module);
    }
  }
}
