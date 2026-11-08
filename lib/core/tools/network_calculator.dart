/// Pure IPv4/CIDR logic for the Network module.
///
/// All functions are synchronous and side-effect free so they can be unit
/// tested without Flutter or a network connection.
library;

class Ipv4ParseResult {
  const Ipv4ParseResult({
    required this.isValid,
    this.address,
    this.cidr,
    this.error,
  });

  final bool isValid;
  final int? address;
  final int? cidr;
  final String? error;
}

class SubnetInfo {
  const SubnetInfo({
    required this.network,
    required this.broadcast,
    required this.firstHost,
    required this.lastHost,
    required this.hostCount,
    required this.netmask,
    required this.wildcard,
    required this.ipClass,
    required this.isPrivate,
  });

  final String network;
  final String broadcast;
  final String firstHost;
  final String lastHost;
  final int hostCount;
  final String netmask;
  final String wildcard;
  final String ipClass;
  final bool isPrivate;
}

/// Parses a dotted IPv4 string into a 32-bit integer, or returns an error.
Ipv4ParseResult parseIpv4(String input) {
  final trimmed = input.trim();
  if (trimmed.isEmpty) {
    return const Ipv4ParseResult(isValid: false, error: 'Empty address');
  }
  final parts = trimmed.split('.');
  if (parts.length != 4) {
    return const Ipv4ParseResult(
      isValid: false,
      error: 'Expected 4 octets (e.g. 192.168.1.10)',
    );
  }
  var value = 0;
  for (final part in parts) {
    final octet = int.tryParse(part);
    if (octet == null || octet < 0 || octet > 255 || part.length > 3) {
      return const Ipv4ParseResult(
        isValid: false,
        error: 'Octets must be 0–255 integers',
      );
    }
    value = (value << 8) | octet;
  }
  return Ipv4ParseResult(isValid: true, address: value);
}

String formatIpv4(int value) {
  final a = (value >> 24) & 0xFF;
  final b = (value >> 16) & 0xFF;
  final c = (value >> 8) & 0xFF;
  final d = value & 0xFF;
  return '$a.$b.$c.$d';
}

String cidrToNetmask(int cidr) {
  if (cidr < 0 || cidr > 32) {
    throw ArgumentError.value(cidr, 'cidr', 'Must be 0–32');
  }
  if (cidr == 0) return '0.0.0.0';
  return formatIpv4(0xFFFFFFFF << (32 - cidr) & 0xFFFFFFFF);
}

String ipClass(String ipv4) {
  final parsed = parseIpv4(ipv4);
  if (!parsed.isValid) return 'invalid';
  final first = (parsed.address! >> 24) & 0xFF;
  if (first < 128) return 'A';
  if (first < 192) return 'B';
  if (first < 224) return 'C';
  if (first < 240) return 'D (multicast)';
  return 'E (reserved)';
}

bool isPrivateIpv4(String ipv4) {
  final parsed = parseIpv4(ipv4);
  if (!parsed.isValid) return false;
  final ip = parsed.address!;
  final a = (ip >> 24) & 0xFF;
  final b = (ip >> 16) & 0xFF;
  return a == 10 || (a == 172 && b >= 16 && b <= 31) || (a == 192 && b == 168);
}

/// Computes the full subnet picture for `ip/cidr` (e.g. `192.168.1.10/24`).
SubnetInfo? subnetInfo(String input) {
  final trimmed = input.trim();
  final slash = trimmed.lastIndexOf('/');
  final ipPart = slash >= 0 ? trimmed.substring(0, slash) : trimmed;
  final cidrPart = slash >= 0 ? trimmed.substring(slash + 1) : '24';
  final parsed = parseIpv4(ipPart);
  final cidr = int.tryParse(cidrPart);
  if (!parsed.isValid) return null;
  if (cidr == null || cidr < 0 || cidr > 32) return null;

  final ip = parsed.address!;
  final mask = cidr == 0 ? 0 : (0xFFFFFFFF << (32 - cidr)) & 0xFFFFFFFF;
  final network = ip & mask;
  final broadcast = network | (~mask & 0xFFFFFFFF);
  final totalHosts = cidr >= 31 ? (cidr == 32 ? 1 : 2) : (1 << (32 - cidr)) - 2;

  return SubnetInfo(
    network: formatIpv4(network),
    broadcast: formatIpv4(broadcast),
    firstHost: formatIpv4(network + 1),
    lastHost: formatIpv4(broadcast - 1),
    hostCount: totalHosts,
    netmask: cidrToNetmask(cidr),
    wildcard: formatIpv4(~mask & 0xFFFFFFFF),
    ipClass: ipClass(ipPart),
    isPrivate: isPrivateIpv4(ipPart),
  );
}

/// Formats a [SubnetInfo] as plain text for the tool output box.
String formatSubnetInfo(SubnetInfo info) {
  final buffer = StringBuffer()
    ..writeln('Network      ${info.network}')
    ..writeln('Netmask      ${info.netmask}')
    ..writeln('Wildcard     ${info.wildcard}')
    ..writeln('Broadcast    ${info.broadcast}')
    ..writeln('Host range   ${info.firstHost} – ${info.lastHost}')
    ..writeln('Usable hosts ${info.hostCount}')
    ..writeln('IP class     ${info.ipClass}')
    ..writeln('Private      ${info.isPrivate ? 'yes (RFC 1918)' : 'no'}');
  return buffer.toString();
}
