/// JWT inspection: decode only, never validates signatures (by design and
/// clearly labeled in the UI).
library;

import 'dart:convert';

class JwtResult {
  const JwtResult({
    required this.ok,
    this.header = '',
    this.payload = '',
    this.signatureLength = 0,
    this.error,
  });

  final bool ok;
  final String header;
  final String payload;
  final int signatureLength;
  final String? error;
}

String _base64UrlNormalize(String segment) {
  var normalized = segment.replaceAll('-', '+').replaceAll('_', '/');
  while (normalized.length % 4 != 0) {
    normalized += '=';
  }
  return normalized;
}

JwtResult decodeJwt(String token) {
  final trimmed = token.trim();
  if (trimmed.isEmpty) {
    return const JwtResult(ok: false, error: 'Empty token');
  }
  final parts = trimmed.split('.');
  if (parts.length < 2) {
    return const JwtResult(
      ok: false,
      error: 'A JWT needs header.payload[.signature]',
    );
  }
  try {
    final headerJson = utf8.decode(
      base64Url.decode(_base64UrlNormalize(parts[0])),
    );
    final payloadJson = utf8.decode(
      base64Url.decode(_base64UrlNormalize(parts[1])),
    );
    // Re-encode JSON for pretty output.
    final headerPretty = const JsonEncoder.withIndent('  ').convert(
      jsonDecode(headerJson) as Object?,
    );
    final payloadPretty = const JsonEncoder.withIndent('  ').convert(
      jsonDecode(payloadJson) as Object?,
    );
    return JwtResult(
      ok: true,
      header: headerPretty,
      payload: payloadPretty,
      signatureLength: parts.length > 2 ? parts[2].length : 0,
    );
  } catch (error) {
    return JwtResult(ok: false, error: 'Not a valid JWT: $error');
  }
}
