import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/tools/network_probe.dart';
import '../../core/tools/workflow_engine.dart';
import '../modules/tool_widgets.dart';

/// Module 07 — Automation & Workflow.
///
/// Bounded, data-only workflows: no code execution, explicit steps, dry-run
/// first. HTTP steps hit exactly the URL the user configured.
class AutomationToolsPage extends ConsumerStatefulWidget {
  const AutomationToolsPage({super.key});

  @override
  ConsumerState<AutomationToolsPage> createState() =>
      _AutomationToolsPageState();
}

class _AutomationToolsPageState extends ConsumerState<AutomationToolsPage> {
  final List<WorkflowStep> _steps = [];
  final _urlController = TextEditingController();
  final _messageController = TextEditingController();
  final _nameController = TextEditingController(text: 'Uptime check');

  String _runOutput = 'Dry-run or run to see the log.';

  @override
  void dispose() {
    _urlController.dispose();
    _messageController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _addHttpStep() {
    if (_urlController.text.trim().isEmpty) return;
    setState(() {
      _steps.add(WorkflowStep(
        type: WorkflowStepType.httpRequest,
        url: _urlController.text.trim(),
      ));
    });
    _urlController.clear();
  }

  void _addWaitStep() {
    setState(() {
      _steps.add(const WorkflowStep(type: WorkflowStepType.wait, seconds: 1));
    });
  }

  void _addLogStep() {
    setState(() {
      _steps.add(WorkflowStep(
        type: WorkflowStepType.log,
        message: _messageController.text.trim().isEmpty
            ? 'check performed'
            : _messageController.text.trim(),
      ));
    });
  }

  Future<void> _run({required bool dryRun}) async {
    final workflow = Workflow(
      id: 'wf',
      name: _nameController.text.trim().isEmpty
          ? 'Workflow'
          : _nameController.text.trim(),
      steps: _steps,
    );
    final result = await runWorkflow(
      workflow,
      httpRunner: (url) async {
        final check = await httpCheck(url);
        return check.ok;
      },
      dryRun: dryRun,
    );
    if (!mounted) return;
    setState(() {
      final buffer = StringBuffer()
        ..writeln(dryRun ? 'DRY RUN' : 'RUN')
        ..writeln('Workflow: ${workflow.name}')
        ..writeln('Result: ${result.ok ? 'ok' : 'failed'} '
            'in ${result.duration.inMilliseconds} ms')
        ..writeln('Steps: ${result.log.length} log entries');
      for (final entry in result.log) {
        buffer.writeln('${entry.ok ? '✓' : '✗'} ${entry.text}');
      }
      _runOutput = buffer.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(title: const Text('Automation & Workflow')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 120),
          children: [
            ToolSection(
              title: 'Workflow steps',
              description:
                  'Bounded steps only: HTTP GET, wait, log. Dry-run first; runs never auto-send credentials.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GlassField(
                      controller: _nameController, label: 'Workflow name'),
                  GlassField(
                    controller: _urlController,
                    label: 'HTTP step URL',
                    hint: 'https://status.example.com/api',
                  ),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      GlassButton(
                        label: '+ HTTP',
                        icon: Icons.http,
                        onPressed: _addHttpStep,
                      ),
                      GlassButton(
                        label: '+ wait 1s',
                        icon: Icons.timer,
                        onPressed: _addWaitStep,
                      ),
                      GlassButton(
                        label: '+ log',
                        icon: Icons.note_add,
                        onPressed: _addLogStep,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ResultBox(
                    text: _steps.isEmpty
                        ? 'No steps yet'
                        : _steps
                            .asMap()
                            .entries
                            .map((entry) =>
                                '${entry.key + 1}. ${_describe(entry.value)}')
                            .join('\n'),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      GlassButton(
                        label: 'Dry run',
                        icon: Icons.play_disabled,
                        onPressed:
                            _steps.isEmpty ? null : () => _run(dryRun: true),
                      ),
                      GlassButton(
                        label: 'Run',
                        icon: Icons.play_arrow,
                        onPressed:
                            _steps.isEmpty ? null : () => _run(dryRun: false),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            ToolSection(
              title: 'Run history',
              description: 'Latest run output (session only).',
              child: ResultBox(text: _runOutput, height: 240),
            ),
            const ToolSection(
              title: 'Limits',
              description: 'Explicitly out of scope in this release.',
              child: ResultBox(
                text:
                    'No arbitrary code execution · no visual node builder yet · '
                    'no schedules/background runs · no credentials storage',
                height: 80,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _describe(WorkflowStep step) {
    switch (step.type) {
      case WorkflowStepType.httpRequest:
        return 'HTTP GET ${step.url}';
      case WorkflowStepType.wait:
        return 'wait ${step.seconds}s';
      case WorkflowStepType.log:
        return 'log: ${step.message}';
    }
  }
}
