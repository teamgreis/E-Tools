/// Smart diagnostics sequence (module 12): facts vs. hypotheses.
///
/// Runs: resolve → addresses → TCP reachability → HTTP → TLS, and builds a
/// structured report. Measured facts are separated from suggested causes.
library;

import 'network_probe.dart';

class DiagnosticFinding {
  const DiagnosticFinding({required this.isFact, required this.text});

  final bool isFact;
  final String text;

  @override
  String toString() => '${isFact ? 'FACT' : 'HINT'}: $text';
}

class DiagnosticReport {
  DiagnosticReport({required this.host, required this.findings});

  final String host;
  final List<DiagnosticFinding> findings;

  List<DiagnosticFinding> get facts => findings.where((f) => f.isFact).toList();
  List<DiagnosticFinding> get hints =>
      findings.where((f) => !f.isFact).toList();

  String format() {
    final buffer = StringBuffer()..writeln('Host: $host\n');
    buffer.writeln('MEASURED FACTS');
    for (final fact in facts) {
      buffer.writeln('  • $fact');
    }
    buffer.writeln('SUGGESTED CAUSES (hypotheses)');
    for (final hint in hints) {
      buffer.writeln('  ? $hint');
    }
    if (hints.isEmpty) buffer.writeln('  ? none — all checks passed');
    return buffer.toString();
  }
}

/// Runs the sequence against a host. TCP/HTTP/TLS steps are explicit.
Future<DiagnosticReport> runDiagnostics(
  String host, {
  int port = 443,
  bool includeHttp = true,
}) async {
  final findings = <DiagnosticFinding>[];

  // 1. resolve
  final dns = await dnsLookup(host);
  if (dns.ok) {
    findings.add(DiagnosticFinding(
      isFact: true,
      text: 'resolved to ${dns.addresses.join(", ")} (${dns.durationMs} ms)',
    ));
  } else {
    findings.add(DiagnosticFinding(
      isFact: true,
      text: 'DNS resolution failed: ${dns.error}',
    ));
    findings.add(const DiagnosticFinding(
      isFact: false,
      text: 'check DNS server, spelling, or offline state',
    ));
    return DiagnosticReport(host: host, findings: findings);
  }

  // 2. TCP reachability
  final probe = await tcpProbe(host, port, count: 2);
  if (probe.successes > 0) {
    findings.add(DiagnosticFinding(
      isFact: true,
      text: 'TCP :$port reachable (${probe.averageMs.round()} ms avg)',
    ));
  } else {
    findings.add(DiagnosticFinding(
      isFact: true,
      text:
          'TCP :$port not reachable: ${probe.errors.isNotEmpty ? probe.errors.first : 'no response'}',
    ));
    findings.add(const DiagnosticFinding(
      isFact: false,
      text: 'firewall, service down, or wrong port',
    ));
  }

  // 3. HTTP
  if (includeHttp && probe.successes > 0) {
    final http = await httpCheck('https://$host:$port/');
    if (http.ok) {
      findings.add(DiagnosticFinding(
        isFact: true,
        text: 'HTTP ${http.statusCode} in ${http.timeMs} ms',
      ));
    } else {
      findings.add(DiagnosticFinding(
        isFact: true,
        text: 'HTTP failed: ${http.error}',
      ));
    }
  }

  // 4. TLS
  final tls = await tlsInspect(host, port: port);
  if (tls.ok) {
    findings.add(DiagnosticFinding(
      isFact: true,
      text:
          'TLS certificate valid until ${tls.validUntil} (${tls.daysRemaining} days)',
    ));
  } else {
    findings.add(DiagnosticFinding(
      isFact: true,
      text: 'TLS inspection failed: ${tls.error}',
    ));
  }

  return DiagnosticReport(host: host, findings: findings);
}
