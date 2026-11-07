# Maintenance & Operations — Detailed Specification

## Asset model

Assets include site, building, room, machine, cabinet, distribution board, network rack, switch, access point, sensor and replaceable component. Each asset has a stable ID, type, label, location, manufacturer/model, serial/asset number, status, attachments and parent relationship.

## Work orders

- Create work orders with title, asset, priority, description and due date.
- States: open, assigned, in progress, waiting, completed and cancelled.
- Add checklist items, notes, photos, readings, used parts and time spent.
- Capture completion notes and optional operator sign-off.
- Preserve a timestamped change history.

## Preventive maintenance

- Calendar and interval-based schedules.
- Recurring checklist templates.
- Due/overdue dashboard and local notifications.
- Defer/skip actions require a reason and history entry.
- Offline work packs for sites without connectivity.

## Fault and downtime tracking

- Fault code, symptom, severity, start/end time and affected asset.
- Root-cause hypothesis separated from confirmed cause.
- Corrective action, parts used and verification result.
- Downtime duration and operational impact.
- Link repeat incidents to prior work orders.

## QR/NFC workflow

- Generate durable asset identifiers and labels.
- Scan to open the local asset record.
- If the record is not on the device, show a safe unresolved state; do not open arbitrary URLs.
- NFC is optional and dependent on device hardware and tag support.

## Reporting and data

- PDF service reports and CSV asset/work-order exports.
- Attachments stored locally with explicit backup/export behavior.
- Search by asset ID, serial number, site, fault and work-order ID.
- Versioned import/export and future CMMS integration.

## Acceptance

All core workflows must function offline. Data entry must be fast on a tablet, support camera attachments only with permission, and make incomplete/synced/unsynced states visible.
