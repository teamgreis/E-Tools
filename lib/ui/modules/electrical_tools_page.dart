import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/tools/electrical_calc.dart';
import '../modules/tool_widgets.dart';

/// Module 05 — Electrical Engineering.
///
/// All outputs are indicative engineering aids: assumptions, units and the
/// pointer to standards/manufacturer data are part of every result.
class ElectricalToolsPage extends ConsumerStatefulWidget {
  const ElectricalToolsPage({super.key});

  @override
  ConsumerState<ElectricalToolsPage> createState() =>
      _ElectricalToolsPageState();
}

class _ElectricalToolsPageState extends ConsumerState<ElectricalToolsPage> {
  final _ohmV = TextEditingController();
  final _ohmI = TextEditingController();
  final _ohmR = TextEditingController();
  final _ohmP = TextEditingController();
  final _acVoltage = TextEditingController(text: '230');
  final _acCurrent = TextEditingController();
  final _acPf = TextEditingController(text: '0.9');
  final _vdCurrent = TextEditingController();
  final _vdLength = TextEditingController();
  final _vdSection = TextEditingController(text: '2.5');
  final _vdVoltage = TextEditingController(text: '230');
  final _csCurrent = TextEditingController();
  final _energyPower = TextEditingController();
  final _energyHours = TextEditingController();
  final _energyPrice = TextEditingController(text: '0.35');

  String _ohmOutput = 'Enter any two of V, I, R, P';
  String _acOutput = '';
  String _threePhaseOutput = '';
  String _vdOutput = '';
  String _csOutput = '';
  String _energyOutput = '';

  @override
  void dispose() {
    _ohmV.dispose();
    _ohmI.dispose();
    _ohmR.dispose();
    _ohmP.dispose();
    _acVoltage.dispose();
    _acCurrent.dispose();
    _acPf.dispose();
    _vdCurrent.dispose();
    _vdLength.dispose();
    _vdSection.dispose();
    _vdVoltage.dispose();
    _csCurrent.dispose();
    _energyPower.dispose();
    _energyHours.dispose();
    _energyPrice.dispose();
    super.dispose();
  }

  double? _d(TextEditingController c) {
    final text = c.text.trim().replaceAll(',', '.');
    return text.isEmpty ? null : double.tryParse(text);
  }

  void _solveOhm() {
    final solution = solveOhm(
      v: _d(_ohmV),
      i: _d(_ohmI),
      r: _d(_ohmR),
      p: _d(_ohmP),
    );
    setState(() {
      _ohmOutput = solution == null
          ? 'Invalid input — provide exactly two independent values'
          : 'V = ${_num(solution.voltageV)} V\n'
              'I = ${_num(solution.currentA)} A\n'
              'R = ${_num(solution.resistanceOhm)} Ω\n'
              'P = ${_num(solution.powerW)} W';
    });
  }

  void _solveAc({required bool threePhase}) {
    final voltage = _d(_acVoltage) ?? 230;
    final current = _d(_acCurrent) ?? 0;
    final pf = _d(_acPf) ?? 0;
    final solution = threePhase
        ? threePhaseAc(voltage, current, pf)
        : singlePhaseAc(voltage, current, pf);
    final text = solution == null
        ? 'Invalid input (V > 0, I ≥ 0, 0 < cos φ ≤ 1)'
        : 'P   = ${_num(solution.activePowerW)} W (active)\n'
            'S   = ${_num(solution.apparentPowerVa)} VA (apparent)\n'
            'Q   = ${_num(solution.reactivePowerVar)} var (reactive)\n'
            'cos φ = ${solution.powerFactor}';
    setState(() {
      if (threePhase) {
        _threePhaseOutput = text;
      } else {
        _acOutput = text;
      }
    });
  }

  void _solveVoltageDrop() {
    final result = voltageDropCopper(
      currentA: _d(_vdCurrent) ?? 0,
      lengthMeters: _d(_vdLength) ?? 0,
      crossSectionMm2: _d(_vdSection) ?? 1,
      systemVoltageV: _d(_vdVoltage) ?? 230,
    );
    setState(() {
      _vdOutput = 'ΔU = ${_num(result.dropV)} V\n'
          'ΔU  = ${result.dropPercent.toStringAsFixed(2)} %\n'
          'Assumptions:\n${result.assumptions.map((a) => '  • $a').join('\n')}';
    });
  }

  void _solveCableSizing() {
    final current = _d(_csCurrent);
    final section = current == null ? null : suggestCrossSectionMm2(current);
    String text;
    if (section == null || current == null) {
      text =
          'No standard section covers the input — split the circuit or consult standards.';
    } else {
      text = 'Indicative section: $section mm² for ${_num(current)} A\n'
          'Indicative rating: ${indicativeRatingA(section)} A\n'
          'Not a substitute for standards-based sizing.';
    }
    setState(() => _csOutput = text);
  }

  void _solveEnergy() {
    final result = energyCost(
      powerW: _d(_energyPower) ?? 0,
      hours: _d(_energyHours) ?? 0,
      pricePerKwh: _d(_energyPrice) ?? 0,
    );
    setState(() {
      _energyOutput = 'Energy = ${_num(result.kwh)} kWh\n'
          'Cost = ${result.total.toStringAsFixed(2)} (currency as configured)';
    });
  }

  String _num(double value) => value == value.roundToDouble()
      ? value.toStringAsFixed(0)
      : value.toStringAsFixed(3);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(title: const Text('Electrical Engineering')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 120),
          children: [
            const ToolSection(
              title: 'Safety',
              description:
                  'All results are indicative engineering aids — not certification of an installation and no substitute for qualified personnel or approved test equipment.',
              child: ResultBox(
                text:
                    'Show every assumption · verify against current standards · '
                    'never connect a general-purpose tablet to hazardous circuits',
                height: 70,
              ),
            ),
            ToolSection(
              title: 'Ohm’s law',
              description: 'Any two of V, I, R, P — the rest is derived.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GlassField(controller: _ohmV, label: 'Voltage U (V)'),
                  GlassField(controller: _ohmI, label: 'Current I (A)'),
                  GlassField(controller: _ohmR, label: 'Resistance R (Ω)'),
                  GlassField(controller: _ohmP, label: 'Power P (W)'),
                  GlassButton(
                    label: 'Solve',
                    icon: Icons.calculate_outlined,
                    onPressed: _solveOhm,
                  ),
                  const SizedBox(height: 10),
                  ResultBox(text: _ohmOutput),
                ],
              ),
            ),
            ToolSection(
              title: 'Single-phase AC',
              description: 'P = V · I · cos φ; S and Q derived.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GlassField(controller: _acVoltage, label: 'Voltage (V)'),
                  GlassField(controller: _acCurrent, label: 'Current (A)'),
                  GlassField(controller: _acPf, label: 'Power factor cos φ'),
                  GlassButton(
                    label: 'Calculate',
                    icon: Icons.bolt,
                    onPressed: () => _solveAc(threePhase: false),
                  ),
                  const SizedBox(height: 10),
                  ResultBox(text: _acOutput),
                ],
              ),
            ),
            ToolSection(
              title: 'Three-phase AC',
              description: 'P = √3 · V · I · cos φ (line values).',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GlassField(controller: _acVoltage, label: 'Line voltage (V)'),
                  GlassField(controller: _acCurrent, label: 'Line current (A)'),
                  GlassField(controller: _acPf, label: 'Power factor cos φ'),
                  GlassButton(
                    label: 'Calculate',
                    icon: Icons.bolt,
                    onPressed: () => _solveAc(threePhase: true),
                  ),
                  const SizedBox(height: 10),
                  ResultBox(text: _threePhaseOutput),
                ],
              ),
            ),
            ToolSection(
              title: 'Voltage drop (copper)',
              description: 'Estimate with explicit assumptions.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GlassField(controller: _vdCurrent, label: 'Current (A)'),
                  GlassField(
                      controller: _vdLength, label: 'One-way length (m)'),
                  GlassField(
                      controller: _vdSection, label: 'Cross-section (mm²)'),
                  GlassField(
                      controller: _vdVoltage, label: 'System voltage (V)'),
                  GlassButton(
                    label: 'Estimate drop',
                    icon: Icons.trending_down,
                    onPressed: _solveVoltageDrop,
                  ),
                  const SizedBox(height: 10),
                  ResultBox(text: _vdOutput, height: 200),
                ],
              ),
            ),
            ToolSection(
              title: 'Cable sizing (indicative)',
              description: 'Next standard cross-section — aid only.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GlassField(
                      controller: _csCurrent, label: 'Design current (A)'),
                  GlassButton(
                    label: 'Suggest section',
                    icon: Icons.straighten,
                    onPressed: _solveCableSizing,
                  ),
                  const SizedBox(height: 10),
                  ResultBox(text: _csOutput),
                ],
              ),
            ),
            ToolSection(
              title: 'Energy cost',
              description: 'kWh and cost from power, duration and price.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GlassField(controller: _energyPower, label: 'Power (W)'),
                  GlassField(controller: _energyHours, label: 'Hours'),
                  GlassField(controller: _energyPrice, label: 'Price per kWh'),
                  GlassButton(
                    label: 'Calculate',
                    icon: Icons.euro,
                    onPressed: _solveEnergy,
                  ),
                  const SizedBox(height: 10),
                  ResultBox(text: _energyOutput, height: 80),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
