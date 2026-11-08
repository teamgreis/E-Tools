/// CSV inspection and batch-rename preview (pure logic, module 09).
library;

import 'dart:convert';

class CsvSummary {
  const CsvSummary({
    required this.rowCount,
    required this.columnCount,
    required this.preview,
    required this.raggedRows,
    required this.error,
  });

  final int rowCount;
  final int columnCount;
  final List<String> preview;
  final int raggedRows;
  final String? error;
}

/// Parses simple CSV (comma/semicolon, quoted fields allowed) and returns
/// a summary: consistent column count, ragged-row diagnostics and a preview.
CsvSummary analyzeCsv(String input, {String delimiter = ','}) {
  final trimmed = input.trim();
  if (trimmed.isEmpty) {
    return const CsvSummary(
      rowCount: 0,
      columnCount: 0,
      preview: [],
      raggedRows: 0,
      error: 'Empty input',
    );
  }
  final lines = const LineSplitter().convert(trimmed);
  final columnCounts = <int>[];
  final rows = <List<String>>[];
  var ragged = 0;
  for (final line in lines) {
    if (line.trim().isEmpty) continue;
    final fields = _parseCsvLine(line, delimiter);
    columnCounts.add(fields.length);
    rows.add(fields);
    if (fields.length != columnCounts.first) ragged++;
  }
  final columns = columnCounts.isEmpty ? 0 : columnCounts.first;
  final preview = <String>[];
  final header = rows.isEmpty ? <String>[] : rows.first;
  preview.add(header.join(' | '));
  for (final row in rows.skip(1).take(5)) {
    preview.add(row.join(' | '));
  }
  return CsvSummary(
    rowCount: rows.length,
    columnCount: columns,
    preview: preview,
    raggedRows: ragged,
    error: null,
  );
}

List<String> _parseCsvLine(String line, String delimiter) {
  final fields = <String>[];
  final buffer = StringBuffer();
  var inQuotes = false;
  for (var i = 0; i < line.length; i++) {
    final char = line[i];
    if (char == '"') {
      if (inQuotes && i + 1 < line.length && line[i + 1] == '"') {
        buffer.write('"');
        i++;
      } else {
        inQuotes = !inQuotes;
      }
    } else if (char == delimiter && !inQuotes) {
      fields.add(buffer.toString().trim());
      buffer.clear();
    } else {
      buffer.write(char);
    }
  }
  fields.add(buffer.toString().trim());
  return fields;
}

/// Preview of a batch rename: applies pattern `{name}{ext}` replacement.
class RenamePreview {
  const RenamePreview({required this.original, required this.renamed});

  final String original;
  final String renamed;
}

List<RenamePreview> previewRename(
  List<String> fileNames, {
  required String find,
  required String replace,
  bool caseSensitive = true,
  int startNumber = 1,
  bool numberPrefix = false,
}) {
  final result = <RenamePreview>[];
  for (var i = 0; i < fileNames.length; i++) {
    final name = fileNames[i];
    final dot = name.lastIndexOf('.');
    final base = dot >= 0 ? name.substring(0, dot) : name;
    final ext = dot >= 0 ? name.substring(dot) : '';
    var renamed = base;
    if (find.isNotEmpty) {
      renamed = caseSensitive
          ? renamed.replaceAll(find, replace)
          : renamed.replaceAll(
              RegExp(RegExp.escape(find), caseSensitive: false),
              replace,
            );
    }
    if (numberPrefix) {
      renamed = '${(startNumber + i).toString().padLeft(3, '0')}_$renamed';
    }
    result.add(RenamePreview(original: name, renamed: '$renamed$ext'));
  }
  return result;
}
