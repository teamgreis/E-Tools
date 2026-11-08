/// UUID v4 generation (cryptographically strong random source).
library;

import 'dart:math';

final Random _random = Random.secure();

String generateUuidV4() {
  final bytes = List<int>.generate(16, (_) => _random.nextInt(256));
  bytes[6] = (bytes[6] & 0x0F) | 0x40; // version 4
  bytes[8] = (bytes[8] & 0x3F) | 0x80; // variant
  String hexSegment(int start, int end) {
    final buffer = StringBuffer();
    for (var i = start; i < end; i++) {
      buffer.write(bytes[i].toRadixString(16).padLeft(2, '0'));
    }
    return buffer.toString();
  }

  return '${hexSegment(0, 4)}-${hexSegment(4, 6)}-${hexSegment(6, 8)}-'
      '${hexSegment(8, 10)}-${hexSegment(10, 16)}';
}

bool isUuidV4(String value) {
  return RegExp(
    r'^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$',
    caseSensitive: false,
  ).hasMatch(value.trim());
}
