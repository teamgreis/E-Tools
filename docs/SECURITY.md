# Security and Privacy Requirements

## Defaults

- Local-first; no mandatory account or cloud service.
- No unnecessary telemetry. Any diagnostics upload must be explicit and previewable.
- Store credentials and tokens only in platform-backed secure storage.
- Never log secrets, authorization headers, private keys or raw sensitive payloads.
- Verify TLS certificates; no insecure certificate bypass in production.
- Verify SSH host keys and warn on changed keys.
- Request permissions only at the point of use and explain why.

## Network and server tools

- Only probe systems and networks the user is authorized to access.
- Make scans explicit and bounded; provide target, scope and cancellation.
- Require confirmation for destructive server actions, container deletion, restarts and other service-impacting operations.
- Never expose an unauthenticated Docker socket or embed shared administrator credentials.
- Use least-privilege server accounts and scoped API tokens.

## Automation

- No arbitrary code execution in the initial release.
- Bound loops, retries, runtime and request size.
- Enforce timeouts and cancellation.
- Show workflow actions and target integrations before activation.
- Keep execution logs redacted and provide a dry-run mode where practical.

## Files and scanning

- Prefer Android Storage Access Framework over broad storage permissions.
- Camera permission is requested only when scanner is opened.
- Scanned URLs are displayed for review and never opened automatically.
- Preview batch file operations before applying them.

## Data lifecycle

- Define retention limits for history and diagnostic logs.
- Provide export and deletion controls.
- Avoid persisting clipboard contents by default.
- Document exactly what leaves the device for each online tool.

## Engineering safety

Electrical and electronics calculators must show units, assumptions and warnings. They are reference helpers, not a substitute for professional design, code compliance or safe measurement procedures.


## Field and industrial safety

- Network discovery and active tests must be user-initiated, bounded and limited to authorized targets.
- Industrial protocol clients default to read-only. State-changing commands require a separate confirmation step and an audit record.
- Never treat a USB device as supported merely because it enumerates.
- Never connect general-purpose tablet adapters to mains voltage or hazardous circuits.
- Electrical calculations are estimates and must expose assumptions; they are not compliance certification.
- External instrument data must identify the instrument and interface as its source. Manual entries must remain distinguishable.
- Do not silently trust OPC UA certificates, TLS certificates or SSH host keys.
