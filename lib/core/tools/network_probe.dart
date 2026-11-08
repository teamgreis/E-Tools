/// Async network probes for the Network & Connectivity module.
///
/// Platform reality on Android:
/// - ICMP echo ("ping") is not available to unprivileged apps, so
///   reachability is measured via real TCP connects and labelled as such.
/// - Every result includes errors/timeouts instead of failing silently.
library;

import 'dart:async';
import 'dart:convert';

import 'dart:io';

class TcpProbeResult {
  TcpProbeResult({
    required this.attempts,
    required this.successes,
    required this.rttsMs,
    required this.errors,
  });

  final int attempts;
  final int successes;
  final List<int> rttsMs;
  final List<String> errors;

  double get averageMs =>
      rttsMs.isEmpty ? 0 : rttsMs.reduce((a, b) => a + b) / rttsMs.length;
  int get minMs => rttsMs.isEmpty ? 0 : rttsMs.reduce((a, b) => a < b ? a : b);
  int get maxMs => rttsMs.isEmpty ? 0 : rttsMs.reduce((a, b) => a > b ? a : b);
}

Future<TcpProbeResult> tcpProbe(
  String host,
  int port, {
  int count = 4,
  Duration timeout = const Duration(seconds: 2),
}) async {
  final rtts = <int>[];
  final errors = <String>[];
  for (var i = 0; i < count; i++) {
    final stopwatch = Stopwatch()..start();
    try {
      final socket = await Socket.connect(host, port, timeout: timeout);
      socket.destroy();
      stopwatch.stop();
      rtts.add(stopwatch.elapsedMilliseconds);
    } on SocketException catch (error) {
      stopwatch.stop();
      errors.add('${error.message} (${error.osError?.errorCode ?? '?'})');
    } on TimeoutException {
      stopwatch.stop();
      errors.add('timeout after ${timeout.inMilliseconds} ms');
    }
  }
  return TcpProbeResult(
    attempts: count,
    successes: rtts.length,
    rttsMs: rtts,
    errors: errors,
  );
}

class DnsResult {
  DnsResult(
      {required this.ok,
      this.addresses = const [],
      this.error,
      this.durationMs = 0});

  final bool ok;
  final List<String> addresses;
  final String? error;
  final int durationMs;
}

Future<DnsResult> dnsLookup(String host) async {
  final stopwatch = Stopwatch()..start();
  try {
    final addresses = await InternetAddress.lookup(host);
    stopwatch.stop();
    if (addresses.isEmpty) {
      return DnsResult(ok: false, error: 'No records found (NXDOMAIN?)');
    }
    return DnsResult(
      ok: true,
      addresses: addresses.map((a) => '${a.address} (${a.type.name})').toList(),
      durationMs: stopwatch.elapsedMilliseconds,
    );
  } on SocketException catch (error) {
    stopwatch.stop();
    final code = error.osError?.errorCode ?? 0;
    // 7 = too many MX? here: typical Android resolver NXDOMAIN codes.
    final kind = code == 7 || code == 11001
        ? 'DNS failure (host does not resolve)'
        : 'DNS lookup failed';
    return DnsResult(
      ok: false,
      error: '$kind: ${error.message}',
      durationMs: stopwatch.elapsedMilliseconds,
    );
  }
}

class PortScanResult {
  PortScanResult({
    required this.host,
    required this.scanned,
    required this.openPorts,
    required this.durationMs,
  });

  final String host;
  final int scanned;
  final List<int> openPorts;
  final int durationMs;
}

Future<PortScanResult> portScan(
  String host,
  int startPort,
  int endPort, {
  int concurrency = 24,
}) async {
  final stopwatch = Stopwatch()..start();
  final open = <int>[];
  final queue = <int>[for (var p = startPort; p <= endPort; p++) p];

  Future<void> worker() async {
    while (queue.isNotEmpty) {
      final port = queue.removeAt(0);
      try {
        final socket = await Socket.connect(host, port,
            timeout: const Duration(seconds: 1));
        socket.destroy();
        open.add(port);
      } catch (_) {
        // Closed or filtered: expected for most ports.
      }
    }
  }

  // Explicit user action only; bounded concurrency to protect the device.
  await Future.wait(<Future<void>>[
    for (var i = 0; i < concurrency; i++) worker(),
  ]);
  stopwatch.stop();
  return PortScanResult(
    host: host,
    scanned: endPort - startPort + 1,
    openPorts: open..sort(),
    durationMs: stopwatch.elapsedMilliseconds,
  );
}

class HttpCheckResult {
  HttpCheckResult({
    required this.ok,
    this.statusCode,
    this.reason,
    this.timeMs,
    this.headers = const {},
    this.error,
  });

  final bool ok;
  final int? statusCode;
  final String? reason;
  final int? timeMs;
  final Map<String, String> headers;
  final String? error;
}

Future<HttpCheckResult> httpCheck(String url) async {
  final stopwatch = Stopwatch()..start();
  final client = HttpClient();
  try {
    final request = await client.getUrl(Uri.parse(url));
    request.followRedirects = false;
    final response = await request.close();
    await response.drain<void>();
    stopwatch.stop();
    final headers = <String, String>{};
    response.headers.forEach((name, values) {
      headers[name] = values.join(', ');
    });
    return HttpCheckResult(
      ok: true,
      statusCode: response.statusCode,
      reason: response.reasonPhrase,
      timeMs: stopwatch.elapsedMilliseconds,
      headers: headers,
    );
  } catch (error) {
    stopwatch.stop();
    return HttpCheckResult(
        ok: false,
        error: 'Request failed: $error',
        timeMs: stopwatch.elapsedMilliseconds);
  } finally {
    client.close(force: true);
  }
}

class TlsInfoResult {
  const TlsInfoResult({
    required this.ok,
    this.subject,
    this.issuer,
    this.validFrom,
    this.validUntil,
    this.daysRemaining,
    this.sha1,
    this.error,
  });

  final bool ok;
  final String? subject;
  final String? issuer;
  final DateTime? validFrom;
  final DateTime? validUntil;
  final int? daysRemaining;
  final String? sha1;
  final String? error;
}

Future<TlsInfoResult> tlsInspect(String host, {int port = 443}) async {
  try {
    final client = HttpClient();
    final socket = await SecureSocket.connect(
      host,
      port,
      timeout: const Duration(seconds: 8),
      onBadCertificate: (_) => true, // inspection only; reported in UI
    );
    final certificate = socket.peerCertificate;
    socket.destroy();
    client.close(force: true);
    if (certificate == null) {
      return const TlsInfoResult(ok: false, error: 'No certificate presented');
    }
    final now = DateTime.now();
    return TlsInfoResult(
      ok: true,
      subject: certificate.subject.toString(),
      issuer: certificate.issuer.toString(),
      validFrom: certificate.startValidity,
      validUntil: certificate.endValidity,
      daysRemaining: certificate.endValidity.difference(now).inDays,
      sha1: certificate.sha1.toString(),
    );
  } catch (error) {
    return TlsInfoResult(ok: false, error: 'TLS inspection failed: $error');
  }
}

Future<String> publicIp() async {
  final client = HttpClient();
  try {
    final request = await client.getUrl(Uri.parse('https://api.ipify.org'));
    final response = await request.close();
    final body = await response.transform(utf8.decoder).join();
    if (response.statusCode != 200) {
      throw HttpException('HTTP ${response.statusCode}');
    }
    return body.trim();
  } finally {
    client.close(force: true);
  }
}
