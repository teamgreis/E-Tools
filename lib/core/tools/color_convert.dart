/// Color conversion helpers (hex / RGB / HSL) for Developer Tools.
library;

import 'dart:math' as math;

class RgbColor {
  const RgbColor(this.r, this.g, this.b);
  final int r;
  final int g;
  final int b;
}

class HslColor {
  const HslColor(this.h, this.s, this.l);
  final double h; // 0–360
  final double s; // 0–1
  final double l; // 0–1
}

RgbColor? hexToRgb(String hex) {
  var cleaned = hex.trim().replaceAll('#', '');
  if (cleaned.length == 3) {
    cleaned = cleaned.split('').map((c) => '$c$c').join();
  }
  if (cleaned.length != 6 || !RegExp(r'^[0-9a-fA-F]{6}$').hasMatch(cleaned)) {
    return null;
  }
  final value = int.parse(cleaned, radix: 16);
  return RgbColor((value >> 16) & 0xFF, (value >> 8) & 0xFF, value & 0xFF);
}

String rgbToHex(int r, int g, int b) {
  String component(int value) =>
      value.clamp(0, 255).toRadixString(16).padLeft(2, '0');
  return '#${component(r)}${component(g)}${component(b)}'.toUpperCase();
}

HslColor rgbToHsl(int r, int g, int b) {
  final rf = r / 255;
  final gf = g / 255;
  final bf = b / 255;
  final max = math.max(rf, math.max(gf, bf));
  final min = math.min(rf, math.min(gf, bf));
  final delta = max - min;

  final l = (max + min) / 2;
  var h = 0.0;
  var s = 0.0;
  if (delta != 0) {
    s = delta / (1 - (2 * l - 1).abs());
    if (max == rf) {
      h = ((gf - bf) / delta) % 6;
    } else if (max == gf) {
      h = (bf - rf) / delta + 2;
    } else {
      h = (rf - gf) / delta + 4;
    }
    h *= 60;
    if (h < 0) h += 360;
  }
  return HslColor(h, s, l);
}

RgbColor hslToRgb(double h, double s, double l) {
  final hh = ((h % 360) + 360) % 360 / 360;
  final ss = s.clamp(0.0, 1.0);
  final ll = l.clamp(0.0, 1.0);
  if (ss == 0) {
    final gray = (ll * 255).round();
    return RgbColor(gray, gray, gray);
  }
  final q = ll < 0.5 ? ll * (1 + ss) : ll + ss - ll * ss;
  final p = 2 * ll - q;
  double hue(double t) {
    var tt = t;
    if (tt < 0) tt += 1;
    if (tt > 1) tt -= 1;
    if (tt < 1 / 6) return p + (q - p) * 6 * tt;
    if (tt < 1 / 2) return q;
    if (tt < 2 / 3) return p + (q - p) * (2 / 3 - tt) * 6;
    return p;
  }

  return RgbColor(
    (hue(hh + 1 / 3) * 255).round(),
    (hue(hh) * 255).round(),
    (hue(hh - 1 / 3) * 255).round(),
  );
}
