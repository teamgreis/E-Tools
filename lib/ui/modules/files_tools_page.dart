import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/tools/csv_tools.dart';
import '../modules/tool_widgets.dart';

/// Module 09 — Files & Documents.
///
/// Scoped access via the system file picker (SAF on Android): no broad
/// storage permission, files are read in place and never uploaded.
class FilesToolsPage extends ConsumerStatefulWidget {
  const FilesToolsPage({super.key});

  @override
  ConsumerState<FilesToolsPage> createState() => _FilesToolsPageState();
}

class _FilesToolsPageState extends ConsumerState<FilesToolsPage> {
  final _csvController = TextEditingController(
    text: 'name,role,site\nAlice,tech,Hamburg\nBob,ops,Berlin',
  );
  final _renameController = TextEditingController(
    text: 'IMG_2043.jpg,IMG_2044.jpg,report.pdf',
  );
  final _findController = TextEditingController(text: 'IMG');
  final _replaceController = TextEditingController(text: 'photo');
  bool _numberPrefix = true;

  String _csvOutput = '';
  String _fileOutput = 'No file picked';
  String _renameOutput = '';

  @override
  void dispose() {
    _csvController.dispose();
    _renameController.dispose();
    _findController.dispose();
    _replaceController.dispose();
    super.dispose();
  }

  void _analyzeCsv() {
    final summary = analyzeCsv(_csvController.text);
    if (!mounted) return;
    setState(() {
      _csvOutput = summary.error != null
          ? summary.error!
          : 'rows: ${summary.rowCount} (incl. header)\n'
              'columns: ${summary.columnCount}\n'
              'ragged rows: ${summary.raggedRows}\n'
              '--- preview ---\n${summary.preview.join('\n')}';
    });
  }

  Future<void> _pickFile() async {
    final files = await FilePicker.pickFiles();
    if (files.isEmpty) {
      if (mounted) setState(() => _fileOutput = 'No file picked');
      return;
    }
    final file = files.first;
    final path = file.path;
    if (path == null) {
      if (mounted) setState(() => _fileOutput = 'No readable path (scoped)');
      return;
    }
    final io = File(path);
    final stat = await io.stat();
    final bytes = await io.readAsBytes();
    final head = bytes
        .take(16)
        .map((b) => b.toRadixString(16).padLeft(2, '0'))
        .join(' ');
    if (!mounted) return;
    setState(() {
      _fileOutput = 'name     ${file.name}\n'
          'size     ${stat.size} bytes\n'
          'modified ${stat.modified.toIso8601String()}\n'
          'bytes    ${bytes.length}\n'
          'first 16 $head…\n'
          '(hashes and scoped metadata stay local; nothing uploaded)';
    });
  }

  void _previewRename() {
    final names = _renameController.text
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
    final previews = previewRename(
      names,
      find: _findController.text,
      replace: _replaceController.text,
      numberPrefix: _numberPrefix,
    );
    if (!mounted) return;
    setState(() {
      _renameOutput =
          previews.map((p) => '${p.original}  →  ${p.renamed}').join('\n');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(title: const Text('Files & Documents')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 120),
          children: [
            ToolSection(
              title: 'File metadata',
              description:
                  'Pick one file via the system picker (SAF — no broad permission).',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GlassButton(
                    label: 'Pick file',
                    icon: Icons.folder_open,
                    onPressed: _pickFile,
                  ),
                  const SizedBox(height: 10),
                  ResultBox(text: _fileOutput, height: 170),
                ],
              ),
            ),
            ToolSection(
              title: 'CSV inspection',
              description: 'Detects delimiter, ragged rows and previews rows.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GlassField(
                      controller: _csvController,
                      label: 'CSV input',
                      maxLines: 5),
                  GlassButton(
                    label: 'Analyze',
                    icon: Icons.table_chart,
                    onPressed: _analyzeCsv,
                  ),
                  const SizedBox(height: 10),
                  ResultBox(text: _csvOutput, height: 150),
                ],
              ),
            ),
            ToolSection(
              title: 'Batch rename preview',
              description:
                  'Find/replace with optional numbering. Preview only — no writes yet.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GlassField(
                    controller: _renameController,
                    label: 'File names (comma separated)',
                    maxLines: 2,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: GlassField(
                          controller: _findController,
                          label: 'Find',
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: GlassField(
                          controller: _replaceController,
                          label: 'Replace',
                        ),
                      ),
                    ],
                  ),
                  SwitchListTile(
                    title: const Text('Number prefix'),
                    value: _numberPrefix,
                    onChanged: (value) => setState(() => _numberPrefix = value),
                  ),
                  GlassButton(
                    label: 'Preview',
                    icon: Icons.drive_file_rename_outline,
                    onPressed: _previewRename,
                  ),
                  const SizedBox(height: 10),
                  ResultBox(text: _renameOutput, height: 130),
                ],
              ),
            ),
            const ToolSection(
              title: 'Planned, not implemented',
              description: 'Honest scope.',
              child: ResultBox(
                text: 'ZIP listing · PDF viewer · text editor · share/export\n'
                    '(SAF write operations require the confirm-then-write flow)',
                height: 80,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
