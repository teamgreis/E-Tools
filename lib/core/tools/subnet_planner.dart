/// Subnet planning: split a network into equal or VLSM subnets (module 13).
library;

class PlannedSubnet {
  const PlannedSubnet({
    required this.network,
    required this.prefix,
    required this.usableHosts,
  });

  final String network;
  final int prefix;
  final int usableHosts;

  @override
  String toString() => '$network/$prefix';
}

int _toInt(String ipv4) {
  final parts = ipv4.split('.');
  var value = 0;
  for (final part in parts) {
    value = (value << 8) | (int.parse(part) & 0xFF);
  }
  return value & 0xFFFFFFFF;
}

String _toIp(int value) {
  return '${(value >> 24) & 0xFF}.${(value >> 16) & 0xFF}.'
      '${(value >> 8) & 0xFF}.${value & 0xFF}';
}

/// Splits `base/prefix` into `count` equal subnets. Returns null when the
/// base block is too small or the input is invalid.
List<PlannedSubnet>? splitIntoEqualSubnets(String base, int prefix, int count) {
  final ipPart = base.split('/').first;
  final basePrefix =
      int.tryParse(base.contains('/') ? base.split('/')[1] : '$prefix');
  if (basePrefix == null || basePrefix < 0 || basePrefix > 32 || count < 1) {
    return null;
  }
  final extraBits = _log2Ceil(count);
  final newPrefix = basePrefix + extraBits;
  if (newPrefix > 32) return null;

  final step = 1 << (32 - newPrefix);
  final network = _toInt(ipPart) & (0xFFFFFFFF << (32 - basePrefix));
  final usable =
      newPrefix >= 31 ? (newPrefix == 32 ? 1 : 2) : (1 << (32 - newPrefix)) - 2;

  return List.generate(1 << extraBits, (index) {
    return PlannedSubnet(
      network: _toIp(network + index * step),
      prefix: newPrefix,
      usableHosts: usable,
    );
  });
}

/// VLSM: allocates subnets for a list of required host counts (largest
/// first), each just big enough.
List<PlannedSubnet>? allocateVlsm(
    String base, int prefix, List<int> hostCounts) {
  final sorted = [...hostCounts]..sort((a, b) => b.compareTo(a));
  final basePrefix = prefix;
  var current =
      _toInt(base.split('/').first) & (0xFFFFFFFF << (32 - basePrefix));
  final result = <PlannedSubnet>[];
  for (final hosts in sorted) {
    if (hosts <= 0) return null;
    var neededPrefix = 32;
    while (neededPrefix > 0) {
      final capacity = neededPrefix >= 31
          ? (neededPrefix == 32 ? 1 : 2)
          : (1 << (32 - neededPrefix)) - 2;
      if (capacity >= hosts) break;
      neededPrefix--;
    }
    if (neededPrefix < basePrefix) continue; // skip unusable requests
    final step = 1 << (32 - neededPrefix);
    result.add(PlannedSubnet(
      network: _toIp(current),
      prefix: neededPrefix,
      usableHosts: neededPrefix >= 31
          ? (neededPrefix == 32 ? 1 : 2)
          : (1 << (32 - neededPrefix)) - 2,
    ));
    current += step;
  }
  return result;
}

int _log2Ceil(int value) {
  var bits = 0;
  var v = value - 1;
  while (v > 0) {
    v >>= 1;
    bits++;
  }
  return bits;
}

/// Basic IPv6 validation (groups of 1–4 hex digits, "::" at most once).
bool isValidIpv6(String input) {
  final trimmed = input.trim();
  if (!trimmed.contains(':')) return false;
  if (trimmed.countMatches('::') > 1) return false;
  final parts = trimmed.split(':');
  if (parts.length > 9) return false;
  var nonEmpty = 0;
  for (final part in parts) {
    if (part.isEmpty) continue;
    nonEmpty++;
    if (part.length > 4 || !RegExp(r'^[0-9a-fA-F]+$').hasMatch(part)) {
      return false;
    }
  }
  if (nonEmpty == 0) return false;
  final hasCompression = trimmed.contains('::');
  if (hasCompression) return nonEmpty <= 7;
  return nonEmpty == 8;
}

extension _CountExtension on String {
  int countMatches(String pattern) {
    return split(pattern).length - 1;
  }
}
