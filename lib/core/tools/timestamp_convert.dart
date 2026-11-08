/// Timestamp conversion helpers.
library;

class TimestampResult {
  const TimestampResult({
    required this.ok,
    this.utc = '',
    this.local = '',
    this.epochSeconds,
    this.iso = '',
    this.relative = '',
    this.error,
  });

  final bool ok;
  final String utc;
  final String local;
  final int? epochSeconds;
  final String iso;
  final String relative;
  final String? error;
}

TimestampResult timestampFromEpoch(int epoch) {
  try {
    final dateTime =
        DateTime.fromMillisecondsSinceEpoch(epoch * 1000, isUtc: true);
    return TimestampResult(
      ok: true,
      utc: _format(dateTime),
      local: _format(dateTime.toLocal()),
      epochSeconds: epoch,
      iso: dateTime.toIso8601String(),
      relative: _relative(dateTime),
    );
  } catch (error) {
    return TimestampResult(ok: false, error: 'Out of range: $error');
  }
}

TimestampResult timestampFromIso(String iso) {
  try {
    final dateTime = DateTime.parse(iso.trim());
    return TimestampResult(
      ok: true,
      utc: _format(dateTime.toUtc()),
      local: _format(dateTime.toLocal()),
      epochSeconds: dateTime.millisecondsSinceEpoch ~/ 1000,
      iso: dateTime.toIso8601String(),
      relative: _relative(dateTime),
    );
  } catch (error) {
    return TimestampResult(
        ok: false, error: 'Not an ISO 8601 timestamp: $error');
  }
}

TimestampResult timestampNow() {
  final now = DateTime.now();
  return TimestampResult(
    ok: true,
    utc: _format(now.toUtc()),
    local: _format(now),
    epochSeconds: now.millisecondsSinceEpoch ~/ 1000,
    iso: now.toIso8601String(),
    relative: _relative(now),
  );
}

String _format(DateTime dateTime) {
  final local = dateTime;
  String two(int value) => value.toString().padLeft(2, '0');
  return '${local.year}-${two(local.month)}-${two(local.day)} '
      '${two(local.hour)}:${two(local.minute)}:${two(local.second)}';
}

String _relative(DateTime dateTime) {
  final diff = DateTime.now().difference(dateTime);
  if (diff.inDays > 365) return '${(diff.inDays / 365).floor()} years ago';
  if (diff.inDays > 30) return '${(diff.inDays / 30).floor()} months ago';
  if (diff.inDays > 0) return '${diff.inDays} days ago';
  if (diff.inHours > 0) return '${diff.inHours} hours ago';
  if (diff.inMinutes > 0) return '${diff.inMinutes} minutes ago';
  return '${diff.inSeconds} seconds ago';
}
