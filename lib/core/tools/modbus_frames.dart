/// Minimal read-only Modbus TCP client frames (module 14).
///
/// Function code 0x03 (read holding registers) / 0x04 (read input
/// registers), unit id + MBAP header. Writes are intentionally NOT
/// implemented: this release is read-only.
library;

class ModbusRequest {
  const ModbusRequest({required this.transactionId, required this.unitId});

  final int transactionId;
  final int unitId;
}

/// Builds a read-registers request frame (MBAP + PDU).
List<int> buildReadRegisters({
  required int transactionId,
  required int unitId,
  required int functionCode, // 3 or 4
  required int startAddress,
  required int quantity,
}) {
  if (functionCode != 3 && functionCode != 4) {
    throw ArgumentError.value(functionCode, 'functionCode', '3 or 4');
  }
  if (startAddress < 0 || startAddress > 0xFFFF) {
    throw ArgumentError.value(startAddress, 'startAddress', '0–65535');
  }
  if (quantity < 1 || quantity > 125) {
    throw ArgumentError.value(quantity, 'quantity', '1–125');
  }
  final frame = <int>[
    (transactionId >> 8) & 0xFF,
    transactionId & 0xFF,
    0, 0, // protocol id
    0, 6, // length
    unitId & 0xFF,
    functionCode,
    (startAddress >> 8) & 0xFF,
    startAddress & 0xFF,
    (quantity >> 8) & 0xFF,
    quantity & 0xFF,
  ];
  return frame;
}

class ModbusResponse {
  const ModbusResponse({
    required this.transactionId,
    required this.ok,
    this.registers = const [],
    this.exceptionCode,
  });

  final int transactionId;
  final bool ok;
  final List<int> registers; // raw 16-bit values
  final int? exceptionCode;
}

const Map<int, String> modbusExceptionNames = {
  1: 'illegal function',
  2: 'illegal data address',
  3: 'illegal data value',
  4: 'slave device failure',
  6: 'device busy',
};

String modbusExceptionName(int code) =>
    modbusExceptionNames[code] ?? 'unknown exception $code';

/// Parses a read-registers response frame from raw bytes.
ModbusResponse parseReadRegisters(List<int> bytes) {
  if (bytes.length < 8) {
    return const ModbusResponse(
      transactionId: 0,
      ok: false,
      exceptionCode: -1,
    );
  }
  final transactionId = (bytes[0] << 8) | bytes[1];
  final functionCode = bytes[7];
  if ((functionCode & 0x80) != 0) {
    final exceptionCode = bytes.length > 8 ? bytes[8] : -1;
    return ModbusResponse(
      transactionId: transactionId,
      ok: false,
      exceptionCode: exceptionCode,
    );
  }
  final byteCount = bytes[8];
  final registers = <int>[];
  for (var i = 0; i < byteCount ~/ 2; i++) {
    final offset = 9 + i * 2;
    if (offset + 1 >= bytes.length) break;
    registers.add((bytes[offset] << 8) | bytes[offset + 1]);
  }
  // unitId is echoed; value access kept for future use.
  return ModbusResponse(
    transactionId: transactionId,
    ok: true,
    registers: registers,
  );
}

/// Applies scaling/offset for display (e.g. temperature ×0.1).
double scaleRegister(int raw, {double factor = 1, double offset = 0}) {
  return raw * factor + offset;
}
