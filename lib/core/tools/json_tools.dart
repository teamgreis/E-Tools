/// JSON format/validate/minify helpers.
library;

import 'dart:convert';

class JsonResult {
  const JsonResult({required this.ok, this.value = '', this.error});

  final bool ok;
  final String value;
  final String? error;
}

JsonResult jsonFormat(String input, {bool minify = false}) {
  final trimmed = input.trim();
  if (trimmed.isEmpty) {
    return const JsonResult(ok: false, error: 'Empty input');
  }
  try {
    final decoded = jsonDecode(trimmed);
    return minify
        ? JsonResult(ok: true, value: jsonEncode(decoded))
        : JsonResult(
            ok: true,
            value: const JsonEncoder.withIndent('  ').convert(decoded),
          );
  } on FormatException catch (error) {
    return JsonResult(ok: false, error: _friendlyJsonError(error));
  } catch (error) {
    return JsonResult(ok: false, error: 'Invalid JSON: $error');
  }
}

String _friendlyJsonError(FormatException error) {
  final offset = error.offset;
  final source = error.source;
  var line = 1;
  var column = 1;
  if (offset != null && source is String) {
    for (var i = 0; i < offset && i < source.length; i++) {
      if (source.codeUnitAt(i) == 0x0A) {
        line++;
        column = 1;
      } else {
        column++;
      }
    }
    return 'Line $line, column $column: ${error.message}';
  }
  return error.message;
}
