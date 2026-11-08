/// Pure electrical-engineering math for module 05.
///
/// IMPORTANT: every result is an indicative engineering aid. The UI shows
/// assumptions and units and points to current standards/manufacturer data;
/// nothing here certifies an installation.
library;

class OhmSolution {
  const OhmSolution({
    required this.voltageV,
    required this.currentA,
    required this.resistanceOhm,
    required this.powerW,
  });

  final double voltageV;
  final double currentA;
  final double resistanceOhm;
  final double powerW;
}

/// Solves the missing quantities from any two of V, I, R, P.
/// Returns null when fewer than two (independent) values are given.
OhmSolution? solveOhm({double? v, double? i, double? r, double? p}) {
  if (v != null && i != null) {
    final power = v * i;
    return OhmSolution(
      voltageV: v,
      currentA: i,
      resistanceOhm: v / i,
      powerW: power,
    );
  }
  if (v != null && r != null) {
    final current = v / r;
    return OhmSolution(
      voltageV: v,
      currentA: current,
      resistanceOhm: r,
      powerW: v * current,
    );
  }
  if (v != null && p != null) {
    final current = p / v;
    return OhmSolution(
      voltageV: v,
      currentA: current,
      resistanceOhm: v / current,
      powerW: p,
    );
  }
  if (i != null && r != null) {
    return OhmSolution(
      voltageV: i * r,
      currentA: i,
      resistanceOhm: r,
      powerW: i * r * i,
    );
  }
  if (i != null && p != null) {
    return OhmSolution(
      voltageV: p / i,
      currentA: i,
      resistanceOhm: p / (i * i),
      powerW: p,
    );
  }
  if (r != null && p != null) {
    final current = _sqrt(p / r);
    return OhmSolution(
      voltageV: current * r,
      currentA: current,
      resistanceOhm: r,
      powerW: p,
    );
  }
  return null;
}

class AcSolution {
  const AcSolution({
    required this.activePowerW,
    required this.apparentPowerVa,
    required this.reactivePowerVar,
    required this.powerFactor,
  });

  final double activePowerW;
  final double apparentPowerVa;
  final double reactivePowerVar;
  final double powerFactor;
}

/// Single-phase AC: P = V·I·cos φ, S = V·I, Q = √(S²−P²).
AcSolution? singlePhaseAc(
    double voltageV, double currentA, double powerFactor) {
  if (voltageV <= 0 || currentA < 0 || powerFactor <= 0 || powerFactor > 1) {
    return null;
  }
  final s = voltageV * currentA;
  final p = s * powerFactor;
  final q = _sqrt((s * s - p * p).clamp(0, double.infinity));
  return AcSolution(
    activePowerW: p,
    apparentPowerVa: s,
    reactivePowerVar: q,
    powerFactor: powerFactor,
  );
}

/// Three-phase AC: P = √3 · V · I · cos φ (line values).
AcSolution? threePhaseAc(double voltageV, double currentA, double powerFactor) {
  if (voltageV <= 0 || currentA < 0 || powerFactor <= 0 || powerFactor > 1) {
    return null;
  }
  final s = _sqrt3 * voltageV * currentA;
  final p = s * powerFactor;
  final q = _sqrt((s * s - p * p).clamp(0, double.infinity));
  return AcSolution(
    activePowerW: p,
    apparentPowerVa: s,
    reactivePowerVar: q,
    powerFactor: powerFactor,
  );
}

class VoltageDropResult {
  const VoltageDropResult({
    required this.dropV,
    required this.dropPercent,
    required this.assumptions,
  });

  final double dropV;
  final double dropPercent;
  final List<String> assumptions;
}

/// Voltage-drop estimate for a copper conductor, explicit assumptions:
/// ρ = 0.0175 Ω·mm²/m (20 °C), round-trip length, DC/single-phase, no
/// derating for temperature/installation method.
VoltageDropResult voltageDropCopper({
  required double currentA,
  required double lengthMeters,
  required double crossSectionMm2,
  required double systemVoltageV,
}) {
  const rho = 0.0175; // Ω·mm²/m, copper 20 °C
  final r = rho * lengthMeters * 2 / crossSectionMm2;
  final drop = currentA * r;
  return VoltageDropResult(
    dropV: drop,
    dropPercent: systemVoltageV > 0 ? drop / systemVoltageV * 100 : 0,
    assumptions: [
      'ρ = 0.0175 Ω·mm²/m (copper, 20 °C)',
      'round-trip conductor (2 × length)',
      'DC / single-phase, no reactive component',
      'no derating (temperature, installation method, grouping)',
      'verify against current standards and manufacturer data',
    ],
  );
}

/// Indicative cable sizing: picks the next standard cross-section whose
/// simplified current-carrying approximation covers the load.
/// VALUES ARE INDICATIVE — not a substitute for standards-based sizing.
const List<double> standardCrossSections = [
  1.5,
  2.5,
  4,
  6,
  10,
  16,
  25,
  35,
  50,
  70,
  95
];

/// Simplistic rating table (A) for method B2-ish conditions; deliberately
/// coarse so the UI must display it as an aid.
double indicativeRatingA(double crossSectionMm2) {
  if (crossSectionMm2 <= 1.5) return 15.5;
  if (crossSectionMm2 <= 2.5) return 21;
  if (crossSectionMm2 <= 4) return 28;
  if (crossSectionMm2 <= 6) return 36;
  if (crossSectionMm2 <= 10) return 50;
  if (crossSectionMm2 <= 16) return 68;
  if (crossSectionMm2 <= 25) return 89;
  if (crossSectionMm2 <= 35) return 110;
  if (crossSectionMm2 <= 50) return 134;
  if (crossSectionMm2 <= 70) return 171;
  return 207;
}

double? suggestCrossSectionMm2(double designCurrentA) {
  if (designCurrentA <= 0) return null;
  for (final section in standardCrossSections) {
    if (indicativeRatingA(section) >= designCurrentA) return section;
  }
  return null; // out of table range
}

class EnergyCostResult {
  const EnergyCostResult({
    required this.kwh,
    required this.total,
  });

  final double kwh;
  final double total;
}

EnergyCostResult energyCost({
  required double powerW,
  required double hours,
  required double pricePerKwh,
}) {
  final kwh = powerW * hours / 1000;
  return EnergyCostResult(kwh: kwh, total: kwh * pricePerKwh);
}

double _sqrt(double value) => value <= 0 ? 0 : _babylonian(value);

double _babylonian(double value) {
  var x = value;
  var y = (x + 1) / 2;
  while (y < x) {
    x = y;
    y = (x + value / x) / 2;
  }
  return x;
}

const double _sqrt3 = 1.7320508075688772;
