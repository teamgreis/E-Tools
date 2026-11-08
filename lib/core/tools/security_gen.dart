/// Password/passphrase generation and local strength estimation.
///
/// Strength is computed locally (entropy only) — nothing is ever sent to a
/// remote service.
library;

import 'dart:math';

const String _lower = 'abcdefghijklmnopqrstuvwxyz';
const String _upper = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
const String _digits = '0123456789';
const String _symbols = '!@#\$%^&*()-_=+[]{};:,.<>?/|~';
const String _ambiguous = 'O0Ol1I|`\'"';

class PasswordPolicy {
  const PasswordPolicy({
    this.length = 20,
    this.useLower = true,
    this.useUpper = true,
    this.useDigits = true,
    this.useSymbols = true,
    this.avoidAmbiguous = true,
  });

  final int length;
  final bool useLower;
  final bool useUpper;
  final bool useDigits;
  final bool useSymbols;
  final bool avoidAmbiguous;

  String get alphabet {
    final buffer = StringBuffer();
    if (useLower) buffer.write(_lower);
    if (useUpper) buffer.write(_upper);
    if (useDigits) buffer.write(_digits);
    if (useSymbols) buffer.write(_symbols);
    var chars = buffer.toString();
    if (avoidAmbiguous) {
      chars = chars.split('').where((c) => !_ambiguous.contains(c)).join();
    }
    return chars.isEmpty ? _lower : chars;
  }
}

final Random _random = Random.secure();

String generatePassword(PasswordPolicy policy) {
  final alphabet = policy.alphabet;
  final length = policy.length.clamp(4, 128);
  return List.generate(
    length,
    (_) => alphabet[_random.nextInt(alphabet.length)],
  ).join();
}

double passwordEntropyBits(PasswordPolicy policy) {
  final alphabetSize = policy.alphabet.length;
  return policy.length * (log(alphabetSize) / log(2));
}

String strengthLabel(double entropyBits) {
  if (entropyBits < 40) return 'weak';
  if (entropyBits < 60) return 'fair';
  if (entropyBits < 80) return 'strong';
  return 'excellent';
}

/// D26-style wordlist-free passphrase: syllables, easy to type on tablets.
const List<String> _syllables = [
  'ban',
  'dor',
  'fel',
  'gar',
  'hin',
  'jor',
  'kal',
  'lum',
  'mir',
  'nov',
  'pel',
  'qui',
  'ros',
  'sab',
  'tor',
  'vel',
  'wyn',
  'zeph',
  'arc',
  'bram',
  'cor',
  'dun',
  'eth',
  'fyr',
  'gil',
  'hal',
  'ith',
  'kel',
  'loth',
  'mor',
];

String generatePassphrase(int wordCount, {String separator = '-'}) {
  final count = wordCount.clamp(3, 10);
  return List.generate(
    count,
    (_) => _syllables[_random.nextInt(_syllables.length)],
  ).join(separator);
}
