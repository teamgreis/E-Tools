/// Bounded workflow engine for module 07.
///
/// Initial release: no arbitrary code execution. Steps are data:
/// `httpRequest` (explicit, user-provided URL), `wait`, `log`.
/// Destructive side effects require an explicit confirm in the UI.
library;

enum WorkflowStepType { httpRequest, wait, log }

class WorkflowStep {
  const WorkflowStep({
    required this.type,
    this.url = '',
    this.seconds = 1,
    this.message = '',
  });

  final WorkflowStepType type;
  final String url;
  final int seconds;
  final String message;
}

class Workflow {
  const Workflow({
    required this.id,
    required this.name,
    required this.steps,
  });

  final String id;
  final String name;
  final List<WorkflowStep> steps;
}

class RunLogEntry {
  const RunLogEntry({required this.text, required this.ok});

  final String text;
  final bool ok;
}

class WorkflowRunResult {
  WorkflowRunResult({
    required this.ok,
    required this.log,
    required this.duration,
  });

  final bool ok;
  final List<RunLogEntry> log;
  final Duration duration;
}

/// Executes a workflow with a bounded runner.
///
/// [httpRunner] performs the HTTP step — the app injects the real network
/// call, tests inject a fake. If no runner is supplied, HTTP steps fail
/// closed (no accidental network access).
Future<WorkflowRunResult> runWorkflow(
  Workflow workflow, {
  required Future<bool> Function(String url) httpRunner,
  bool dryRun = false,
  Duration stepTimeout = const Duration(seconds: 30),
}) async {
  final stopwatch = Stopwatch()..start();
  final log = <RunLogEntry>[];
  var ok = true;

  for (var index = 0; index < workflow.steps.length; index++) {
    final step = workflow.steps[index];
    switch (step.type) {
      case WorkflowStepType.log:
        log.add(RunLogEntry(text: 'log: ${step.message}', ok: true));
      case WorkflowStepType.wait:
        log.add(RunLogEntry(
          text: 'wait ${step.seconds}s${dryRun ? ' (dry run)' : ''}',
          ok: true,
        ));
        if (!dryRun) {
          await Future<void>.delayed(
              Duration(seconds: step.seconds.clamp(0, 60)));
        }
      case WorkflowStepType.httpRequest:
        if (dryRun) {
          log.add(RunLogEntry(
            text: 'http GET ${step.url} (dry run — not executed)',
            ok: true,
          ));
          break;
        }
        if (step.url.isEmpty) {
          log.add(const RunLogEntry(text: 'http step without URL', ok: false));
          ok = false;
          break;
        }
        log.add(RunLogEntry(text: 'http GET ${step.url}', ok: true));
        final success = await httpRunner(step.url).timeout(
          stepTimeout,
          onTimeout: () => false,
        );
        log.add(RunLogEntry(
          text: success ? 'http ok' : 'http failed or timed out',
          ok: success,
        ));
        if (!success) ok = false;
    }
  }

  stopwatch.stop();
  return WorkflowRunResult(ok: ok, log: log, duration: stopwatch.elapsed);
}
