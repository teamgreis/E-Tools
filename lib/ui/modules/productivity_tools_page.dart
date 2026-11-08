import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../modules/tool_widgets.dart';

/// Module 10 — Productivity.
///
/// Session-scoped tools: notes are session-only in this release and
/// clipboard actions are explicit.
class ProductivityToolsPage extends ConsumerStatefulWidget {
  const ProductivityToolsPage({super.key});

  @override
  ConsumerState<ProductivityToolsPage> createState() =>
      _ProductivityToolsPageState();
}

class _ProductivityToolsPageState extends ConsumerState<ProductivityToolsPage> {
  final _noteController = TextEditingController();
  final _textController = TextEditingController();
  final List<String> _notes = [];
  Stopwatch _stopwatch = Stopwatch();
  Timer? _ticker;
  String _timeText = '00:00.00';
  String _countOutput = '';

  @override
  void dispose() {
    _ticker?.cancel();
    _noteController.dispose();
    _textController.dispose();
    super.dispose();
  }

  void _tick() {
    final elapsed = _stopwatch.elapsed;
    final minutes = elapsed.inMinutes.toString().padLeft(2, '0');
    final seconds = (elapsed.inSeconds % 60).toString().padLeft(2, '0');
    final hundredths =
        (elapsed.inMilliseconds % 1000 ~/ 10).toString().padLeft(2, '0');
    if (mounted) setState(() => _timeText = '$minutes:$seconds.$hundredths');
  }

  void _toggleStopwatch() {
    setState(() {
      if (_stopwatch.isRunning) {
        _stopwatch.stop();
        _ticker?.cancel();
      } else {
        _stopwatch.start();
        _ticker =
            Timer.periodic(const Duration(milliseconds: 50), (_) => _tick());
      }
    });
  }

  void _resetStopwatch() {
    setState(() {
      _stopwatch = Stopwatch();
      _ticker?.cancel();
      _timeText = '00:00.00';
    });
  }

  void _addNote() {
    final text = _noteController.text.trim();
    if (text.isEmpty) return;
    setState(() => _notes.add(text));
    _noteController.clear();
  }

  void _countText() {
    final text = _textController.text;
    final words =
        text.trim().isEmpty ? 0 : text.trim().split(RegExp(r'\s+')).length;
    if (!mounted) return;
    setState(() {
      _countOutput = 'Characters: ${text.length}\n'
          'Without spaces: ${text.replaceAll(' ', '').length}\n'
          'Words: $words\n'
          'Lines: ${text.split('\n').length}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(title: const Text('Productivity')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 120),
          children: [
            ToolSection(
              title: 'Stopwatch',
              description: 'With live lap-style display (session only).',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _timeText,
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    children: [
                      GlassButton(
                        label: _stopwatch.isRunning ? 'Stop' : 'Start',
                        icon: _stopwatch.isRunning
                            ? Icons.pause
                            : Icons.play_arrow,
                        onPressed: _toggleStopwatch,
                      ),
                      GlassButton(
                        label: 'Reset',
                        icon: Icons.restart_alt,
                        onPressed: _resetStopwatch,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            ToolSection(
              title: 'Text statistics',
              description: 'Characters, words, lines — local and instant.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GlassField(
                      controller: _textController, label: 'Text', maxLines: 4),
                  GlassButton(
                    label: 'Count',
                    icon: Icons.numbers,
                    onPressed: _countText,
                  ),
                  const SizedBox(height: 10),
                  ResultBox(text: _countOutput, height: 80),
                ],
              ),
            ),
            ToolSection(
              title: 'Clipboard',
              description: 'Explicit actions only — privacy-aware handling.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GlassButton(
                    label: 'Copy time $_timeText',
                    icon: Icons.content_copy,
                    onPressed: () =>
                        copyToClipboard(context, _timeText, 'Time'),
                  ),
                ],
              ),
            ),
            ToolSection(
              title: 'Notes (session)',
              description: 'Volatile notes — persistence is planned scope.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GlassField(
                      controller: _noteController, label: 'Note', maxLines: 2),
                  GlassButton(
                    label: 'Add note',
                    icon: Icons.note_add,
                    onPressed: _addNote,
                  ),
                  const SizedBox(height: 10),
                  ResultBox(
                    text: _notes.isEmpty
                        ? 'No notes yet'
                        : _notes
                            .asMap()
                            .entries
                            .map((e) => '${e.key + 1}. ${e.value}')
                            .join('\n'),
                    height: 150,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
