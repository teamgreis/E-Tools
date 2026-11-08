/// Hashing helpers for the Developer Tools module.
///
/// These are hashes for integrity/comparison — NOT password storage and
/// NOT encryption; the UI labels this explicitly.
library;

import 'dart:convert';

import 'package:crypto/crypto.dart';

class HashResult {
  const HashResult(
      {required this.algorithm, required this.hex, required this.base64});

  final String algorithm;
  final String hex;
  final String base64;
}

final Map<String, Hash> _hashers = {
  'MD5': md5,
  'SHA-1': sha1,
  'SHA-256': sha256,
  'SHA-512': sha512,
};

List<String> get availableHashAlgorithms => _hashers.keys.toList();

HashResult hashText(String algorithm, String input) {
  final hasher = _hashers[algorithm] ?? sha256;
  final bytes = utf8.encode(input);
  final digest = hasher.convert(bytes);
  return HashResult(
    algorithm: algorithm,
    hex: digest.toString(),
    base64: base64.encode(digest.bytes),
  );
}

String hashTextHex(String algorithm, String input) =>
    hashText(algorithm, input).hex;

/// HMAC-SHA256 in hex (availability label: message authentication, not
/// signature verification of third-party data).
String hmacSha256Hex(String key, String message) {
  final hmac = Hmac(sha256, utf8.encode(key));
  return hmac.convert(utf8.encode(message)).toString();
}
