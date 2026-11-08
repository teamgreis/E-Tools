import 'package:flutter/material.dart';

import '../../ui/modules/automation_tools_page.dart';
import '../../ui/modules/barcode_tools_page.dart';
import '../../ui/modules/diagnostics_tools_page.dart';
import '../../ui/modules/devtools_page.dart';
import '../../ui/modules/electrical_tools_page.dart';
import '../../ui/modules/files_tools_page.dart';
import '../../ui/modules/hardware_tools_page.dart';
import '../../ui/modules/industrial_tools_page.dart';
import '../../ui/modules/maintenance_tools_page.dart';
import '../../ui/modules/network_design_tools_page.dart';
import '../../ui/modules/network_tools_page.dart';
import '../../ui/modules/printing_tools_page.dart';
import '../../ui/modules/productivity_tools_page.dart';
import '../../ui/modules/security_tools_page.dart';
import '../../ui/modules/server_tools_page.dart';
import '../../ui/modules/system_tools_page.dart';
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
  ///
  /// The first three modules ship with a real tool page; the rest render an
  /// honest "registered but not implemented" stub.
  static void registerDefaults() {
    final modules = <ToolModule>[
      ToolModule(
        id: 'network_connectivity',
        title: 'Network & Connectivity',
        description: 'IP, DNS, HTTP, TLS and network tests',
        icon: Icons.lan_outlined,
        category: 'Network',
        tags: ['ip', 'dns', 'ping', 'tls', 'http'],
        pageBuilder: (context) => const NetworkToolsPage(),
      ),
      ToolModule(
        id: 'system_device',
        title: 'System & Device',
        description: 'Device information and sensor overview',
        icon: Icons.devices_outlined,
        category: 'System',
        tags: ['device', 'sensors', 'info'],
        pageBuilder: (context) => const SystemToolsPage(),
      ),
      ToolModule(
        id: 'developer_tools',
        title: 'Developer Tools',
        description: 'JSON, encoders, hashes and text utilities',
        icon: Icons.code,
        category: 'Development',
        tags: ['json', 'hash', 'encode', 'format'],
        pageBuilder: (context) => const DevToolsPage(),
      ),
      ToolModule(
        id: 'server_administration',
        title: 'Server Administration',
        description: 'SSH profiles, reachability and notes',
        icon: Icons.dns_outlined,
        category: 'Server',
        tags: ['ssh', 'profile', 'maintenance'],
        pageBuilder: (context) => const ServerToolsPage(),
      ),
      ToolModule(
        id: 'electrical_engineering',
        title: 'Electrical Engineering',
        description: 'Calculations and circuit records (indicative aids)',
        icon: Icons.electrical_services_outlined,
        category: 'Electrical',
        tags: ['circuit', 'calculation', 'ohm', 'power'],
        pageBuilder: (context) => const ElectricalToolsPage(),
      ),
      ToolModule(
        id: 'printing_3d',
        title: '3D Printing',
        description: 'Filament, cost and G-code inspection',
        icon: Icons.view_in_ar_outlined,
        category: 'Fabrication',
        tags: ['filament', 'gcode', 'slicer'],
        pageBuilder: (context) => const PrintingToolsPage(),
      ),
      ToolModule(
        id: 'automation_workflow',
        title: 'Automation & Workflow',
        description: 'Bounded, repeatable workflows (no code execution)',
        icon: Icons.account_tree_outlined,
        category: 'Automation',
        tags: ['workflow', 'http', 'dry-run'],
        pageBuilder: (context) => const AutomationToolsPage(),
      ),
      ToolModule(
        id: 'security_privacy',
        title: 'Security & Privacy',
        description: 'Secrets, hashes and certificate checks',
        icon: Icons.shield_outlined,
        category: 'Security',
        tags: ['secret', 'certificate', 'hash', 'vault'],
        pageBuilder: (context) => const SecurityToolsPage(),
      ),
      ToolModule(
        id: 'files_documents',
        title: 'Files & Documents',
        description: 'Inspect, compare and organize files',
        icon: Icons.folder_outlined,
        category: 'Files',
        tags: ['file', 'document', 'compare'],
        pageBuilder: (context) => const FilesToolsPage(),
      ),
      ToolModule(
        id: 'productivity',
        title: 'Productivity',
        description: 'Notes, tasks, timers and workspaces',
        icon: Icons.check_circle_outline,
        category: 'Productivity',
        tags: ['notes', 'tasks', 'timer'],
        pageBuilder: (context) => const ProductivityToolsPage(),
      ),
      ToolModule(
        id: 'barcode_scanner',
        title: 'Barcode & Scanner',
        description: 'Scan and generate QR codes and barcodes',
        icon: Icons.qr_code_scanner,
        category: 'Capture',
        tags: ['qr', 'barcode', 'scan'],
        pageBuilder: (context) => const BarcodeToolsPage(),
      ),
      ToolModule(
        id: 'diagnostics_troubleshooting',
        title: 'Diagnostics & Troubleshooting',
        description: 'Guided checks and diagnostic reports',
        icon: Icons.troubleshoot,
        category: 'Diagnostics',
        tags: ['diagnostic', 'report', 'checklist'],
        pageBuilder: (context) => const DiagnosticsToolsPage(),
      ),
      ToolModule(
        id: 'network_design',
        title: 'Network Design',
        description: 'IP ranges, VLANs, racks and cable planning',
        icon: Icons.hub_outlined,
        category: 'Network',
        tags: ['vlan', 'subnet', 'rack', 'design'],
        pageBuilder: (context) => const NetworkDesignToolsPage(),
      ),
      ToolModule(
        id: 'industrial_technology',
        title: 'Industrial Technology',
        description: 'Modbus, MQTT and OPC UA endpoints',
        icon: Icons.precision_manufacturing_outlined,
        category: 'Industrial',
        tags: ['modbus', 'mqtt', 'opcua', 'plc'],
        pageBuilder: (context) => const IndustrialToolsPage(),
      ),
      ToolModule(
        id: 'maintenance_operations',
        title: 'Maintenance & Operations',
        description: 'Maintenance tasks, records and equipment history',
        icon: Icons.handyman_outlined,
        category: 'Operations',
        tags: ['maintenance', 'service', 'equipment'],
        pageBuilder: (context) => const MaintenanceToolsPage(),
      ),
      ToolModule(
        id: 'hardware_center',
        title: 'Hardware Center',
        description: 'USB adapters and measurement interfaces',
        icon: Icons.memory,
        category: 'Hardware',
        tags: ['usb', 'adapter', 'measurement', 'serial'],
        pageBuilder: (context) => const HardwareToolsPage(),
      ),
    ];

    for (final module in modules) {
      register(module);
    }
  }
}
