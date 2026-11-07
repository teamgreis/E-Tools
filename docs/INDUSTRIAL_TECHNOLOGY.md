# Industrial Technology — Detailed Specification

## Purpose

Provide read-oriented diagnostics and documentation for automation and industrial networks. This module is not a safety controller, PLC programming environment or replacement for vendor engineering software.

## Protocol roadmap

### Modbus TCP
- Configure host, port, unit ID, timeout and polling interval.
- Read coils, discrete inputs, holding registers and input registers.
- Support register maps, byte/word order, signedness, scaling and engineering units.
- Show raw register values beside interpreted values.
- Writes disabled by default and implemented only as a separate, explicit operation with target confirmation.

### Modbus RTU
- Use a supported USB-RS485/serial adapter.
- Configure baud rate, data bits, parity, stop bits and slave ID.
- Handle serial permission, port claim, disconnect and timeout.
- Validate CRC and expose communication errors.
- Start with read-only functions.

### MQTT
- Broker profiles with TLS, certificate validation and secure credentials.
- Subscribe to explicitly selected topics and display timestamped payloads.
- Topic filters, retained-message indicator and bounded message history.
- Publishing requires explicit confirmation and visible topic/payload preview.

### OPC UA
- Endpoint discovery by user-entered endpoint.
- Certificate trust workflow; never silently trust unknown certificates.
- Browse permitted namespaces/nodes and read values.
- Show status code, source/server timestamp and data type.
- Writes and method calls excluded from initial implementation.

### BACnet/IP and CAN
- Evaluate only after Android transport and adapter support is proven.
- Restrict discovery to the selected interface/network and provide timeouts/rate limits.
- CAN requires a supported adapter SDK/driver; USB recognition alone is insufficient.

## Common UX

- Saved device profiles without plaintext secrets.
- Connection test and read-only mode indicator.
- Register/node/topic explorer.
- Live values with pause/resume and configurable polling.
- Raw and decoded views, units and timestamps.
- Export selected values as CSV/JSON.
- Audit log for all state-changing operations.

## Safety and security

- Default to read-only.
- Clearly display endpoint identity before every write/command.
- Require explicit confirmation for state changes and retain an audit record.
- Validate ranges and payload lengths; apply timeouts and reconnect backoff.
- Use TLS and certificate validation where protocol supports it.
- Do not expose control actions as safety-rated functions.
