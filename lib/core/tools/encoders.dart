/// Encoding/decoding helpers for the Developer Tools module.
///
/// Every function returns a result object instead of throwing, so malformed
/// input produces a useful error message in the UI.
library;

import 'dart:convert';

class TextResult {
  const TextResult({required this.ok, this.value = '', this.error});

  final bool ok;
  final String value;
  final String? error;
}

TextResult base64Encode(String input) {
  return TextResult(ok: true, value: base64.encode(utf8.encode(input)));
}

TextResult base64Decode(String input) {
  try {
    return TextResult(
        ok: true, value: utf8.decode(base64.decode(input.trim())));
  } catch (error) {
    return TextResult(ok: false, error: 'Invalid Base64: $error');
  }
}

TextResult urlEncode(String input) {
  return TextResult(ok: true, value: Uri.encodeComponent(input));
}

TextResult urlDecode(String input) {
  try {
    return TextResult(ok: true, value: Uri.decodeComponent(input.trim()));
  } catch (error) {
    return TextResult(ok: false, error: 'Invalid URL encoding: $error');
  }
}

TextResult hexEncode(String input) {
  final bytes = utf8.encode(input);
  final buffer = StringBuffer();
  for (final byte in bytes) {
    buffer.write(byte.toRadixString(16).padLeft(2, '0'));
    buffer.write(' ');
  }
  return TextResult(ok: true, value: buffer.toString().trim());
}

TextResult hexDecode(String input) {
  final cleaned = input.trim().replaceAll(RegExp(r'\s+'), '');
  if (cleaned.length % 2 != 0 || !RegExp(r'^[0-9a-fA-F]*$').hasMatch(cleaned)) {
    return const TextResult(
        ok: false, error: 'Expected an even hex byte stream');
  }
  final bytes = <int>[];
  for (var i = 0; i < cleaned.length; i += 2) {
    bytes.add(int.parse(cleaned.substring(i, i + 2), radix: 16));
  }
  return TextResult(ok: true, value: utf8.decode(bytes, allowMalformed: true));
}

TextResult htmlEscape(String input) {
  final escaped = const HtmlEscape(HtmlEscapeMode.element).convert(input);
  return TextResult(ok: true, value: escaped);
}

TextResult htmlUnescape(String input) {
  final replaced = input.replaceAllMapped(
    RegExp(r'&(#x[0-9a-fA-F]+|#[0-9]+|[a-zA-Z]+);'),
    (match) {
      final entity = match.group(1)!;
      final lower = entity.toLowerCase();
      if (lower.startsWith('#x')) {
        final code = int.tryParse(entity.substring(2), radix: 16);
        if (code != null) return String.fromCharCode(code);
      } else if (entity.startsWith('#')) {
        final code = int.tryParse(entity.substring(1));
        if (code != null) return String.fromCharCode(code);
      }
      const named = <String, String>{
        'lt': '<',
        'gt': '>',
        'quot': '"',
        'apos': "'",
        'amp': '&',
        'nbsp': ' ',
      };
      return named[lower] ?? match.group(0)!;
    },
  );
  return TextResult(ok: true, value: replaced);
}
