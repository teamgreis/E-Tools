import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/tools/gcode_stats.dart';
import '../modules/tool_widgets.dart';

/// Module 06 — 3D Printing.
///
/// Calculators are local; G-code is only inspected as text and never
/// executed or sent to a printer.
class PrintingToolsPage extends ConsumerStatefulWidget {
  const PrintingToolsPage({super.key});

  @override
  ConsumerState<PrintingToolsPage> createState() => _PrintingToolsPageState();
}

class _PrintingToolsPageState extends ConsumerState<PrintingToolsPage> {
  final _diameterController = TextEditingController(text: '1.75');
  final _lengthController = TextEditingController(text: '10');
  final _massController = TextEditingController();
  final _materialController = TextEditingController(text: 'PLA');
  final _pricePerKgController = TextEditingController(text: '25');
  final _wattController = TextEditingController(text: '120');
  final _hoursController = TextEditingController();
  final _gcodeController = TextEditingController();

  String _filamentOutput = '';
  String _costOutput = '';
  String _gcodeOutput = 'Paste G-code and inspect — never executed or sent.';

  @override
  void dispose() {
    _diameterController.dispose();
    _lengthController.dispose();
    _massController.dispose();
    _materialController.dispose();
    _pricePerKgController.dispose();
    _wattController.dispose();
    _hoursController.dispose();
    _gcodeController.dispose();
    super.dispose();
  }

  double? _d(TextEditingController c) {
    final text = c.text.trim().replaceAll(',', '.');
    return text.isEmpty ? null : double.tryParse(text);
  }

  void _convertLength() {
    final diameter = _d(_diameterController) ?? 1.75;
    final length = _d(_lengthController) ?? 0;
    final result =
        filamentFromLength(diameter, _materialController.text, length);
    setState(() {
      _filamentOutput = 'Length = ${result.lengthMeters} m\n'
          'Volume = ${result.volumeCm3.toStringAsFixed(2)} cm³\n'
          'Mass   = ${result.massGrams.toStringAsFixed(1)} g '
          '(${_materialController.text.toUpperCase()})';
    });
  }

  void _convertMass() {
    final diameter = _d(_diameterController) ?? 1.75;
    final mass = _d(_massController) ?? 0;
    final density = filamentDensityGPerCm3(_materialController.text);
    final volume = mass / density;
    final length = filamentLengthMeters(diameter, volume);
    setState(() {
      _filamentOutput = 'Mass   = $mass g\n'
          'Volume = ${volume.toStringAsFixed(2)} cm³\n'
          'Length = ${length.toStringAsFixed(2)} m at $diameter mm';
    });
  }

  void _calculateCost() {
    final mass = _d(_massController) ?? 0;
    final hours = _d(_hoursController) ?? 0;
    final result = printCost(
      massGrams: mass,
      pricePerKg: _d(_pricePerKgController) ?? 0,
      printerWatt: _d(_wattController) ?? 0,
      hours: hours,
      energyPricePerKwh: 0.35,
    );
    setState(() {
      _costOutput = 'Material = ${result.materialCost.toStringAsFixed(2)}\n'
          'Energy   = ${result.energyCost.toStringAsFixed(2)}\n'
          'Total    = ${result.total.toStringAsFixed(2)}';
    });
  }

  void _inspectGcode() {
    final stats = parseGcodeStats(_gcodeController.text);
    setState(() {
      final buffer = StringBuffer()
        ..writeln('Lines         ${stats.lineCount}')
        ..writeln('Layer markers ${stats.layerCount}')
        ..writeln(
            'Filament      ${stats.filamentMeters?.toStringAsFixed(2) ?? 'not reported'} m')
        ..writeln('Est. time     ${stats.estimatedTimeText}')
        ..writeln('Slicer        ${stats.slicer ?? 'not reported'}');
      _gcodeOutput = buffer.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(title: const Text('3D Printing')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 120),
          children: [
            ToolSection(
              title: 'Filament conversion',
              description:
                  'Length ↔ mass ↔ volume for 1.75 / 2.85 mm, PLA/PETG/ABS/TPU.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: GlassField(
                          controller: _diameterController,
                          label: 'Diameter (mm)',
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: GlassField(
                          controller: _materialController,
                          label: 'Material',
                        ),
                      ),
                    ],
                  ),
                  GlassField(
                    controller: _lengthController,
                    label: 'Length (m)',
                    keyboardType: TextInputType.number,
                  ),
                  GlassButton(
                    label: 'Length → mass',
                    icon: Icons.straighten,
                    onPressed: _convertLength,
                  ),
                  const SizedBox(height: 10),
                  GlassField(
                    controller: _massController,
                    label: 'Mass (g)',
                    keyboardType: TextInputType.number,
                  ),
                  GlassButton(
                    label: 'Mass → length',
                    icon: Icons.scale,
                    onPressed: _convertMass,
                  ),
                  const SizedBox(height: 10),
                  ResultBox(text: _filamentOutput, height: 90),
                ],
              ),
            ),
            ToolSection(
              title: 'Print cost',
              description:
                  'Material + energy. Energy price 0.35/kWh (editable below in settings of your choice).',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GlassField(
                    controller: _massController,
                    label: 'Mass (g)',
                    keyboardType: TextInputType.number,
                  ),
                  GlassField(
                    controller: _hoursController,
                    label: 'Print time (h)',
                    keyboardType: TextInputType.number,
                  ),
                  GlassField(
                    controller: _wattController,
                    label: 'Printer power (W)',
                    keyboardType: TextInputType.number,
                  ),
                  GlassField(
                    controller: _pricePerKgController,
                    label: 'Filament price per kg',
                    keyboardType: TextInputType.number,
                  ),
                  GlassButton(
                    label: 'Calculate cost',
                    icon: Icons.calculate,
                    onPressed: _calculateCost,
                  ),
                  const SizedBox(height: 10),
                  ResultBox(text: _costOutput, height: 90),
                ],
              ),
            ),
            ToolSection(
              title: 'G-code inspection',
              description:
                  'Parses slicer metadata comments. Read-only: G-code is never executed or sent.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GlassField(
                    controller: _gcodeController,
                    label: 'Paste G-code',
                    hint: '; generated by PrusaSlicer …',
                    maxLines: 5,
                  ),
                  GlassButton(
                    label: 'Inspect',
                    icon: Icons.description,
                    onPressed: _inspectGcode,
                  ),
                  const SizedBox(height: 10),
                  ResultBox(text: _gcodeOutput, height: 140),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
