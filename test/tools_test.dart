import 'dart:math' as math;

import 'package:e_tools/core/tools/color_convert.dart';
import 'package:e_tools/core/tools/encoders.dart';
import 'package:e_tools/core/tools/electrical_calc.dart';
import 'package:e_tools/core/tools/gcode_stats.dart';
import 'package:e_tools/core/tools/hashing.dart';
import 'package:e_tools/core/tools/json_tools.dart';
import 'package:e_tools/core/tools/jwt_decoder.dart';
import 'package:e_tools/core/tools/network_calculator.dart';
import 'package:e_tools/core/tools/maintenance_logic.dart';
import 'package:e_tools/core/tools/csv_tools.dart';
import 'package:e_tools/core/tools/modbus_frames.dart';
import 'package:e_tools/core/tools/security_gen.dart';
import 'package:e_tools/core/tools/subnet_planner.dart';
import 'package:e_tools/core/tools/timestamp_convert.dart';
import 'package:e_tools/core/tools/uuid_generator.dart';
import 'package:e_tools/core/tools/workflow_engine.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('network calculator', () {
    test('validates IPv4', () {
      expect(parseIpv4('192.168.1.10').isValid, isTrue);
      expect(parseIpv4('999.1.1.1').isValid, isFalse);
      expect(parseIpv4('1.2.3').isValid, isFalse);
      expect(parseIpv4('a.b.c.d').isValid, isFalse);
    });

    test('computes a /24 subnet', () {
      final info = subnetInfo('192.168.1.10/24')!;
      expect(info.network, '192.168.1.0');
      expect(info.broadcast, '192.168.1.255');
      expect(info.hostCount, 254);
      expect(info.netmask, '255.255.255.0');
      expect(info.firstHost, '192.168.1.1');
      expect(info.lastHost, '192.168.1.254');
      expect(info.isPrivate, isTrue);
      expect(info.ipClass, 'C');
    });

    test('computes a /30 point-to-point subnet', () {
      final info = subnetInfo('10.0.0.1/30')!;
      expect(info.hostCount, 2);
      expect(info.network, '10.0.0.0');
      expect(info.broadcast, '10.0.0.3');
    });

    test('computes a /32 host route', () {
      final info = subnetInfo('8.8.8.8/32')!;
      expect(info.hostCount, 1);
      expect(info.isPrivate, isFalse);
    });

    test('rejects invalid input', () {
      expect(subnetInfo('nonsense'), isNull);
      expect(subnetInfo('192.168.1.10/33'), isNull);
    });

    test('detects private ranges', () {
      expect(isPrivateIpv4('10.1.2.3'), isTrue);
      expect(isPrivateIpv4('172.31.0.1'), isTrue);
      expect(isPrivateIpv4('172.32.0.1'), isFalse);
      expect(isPrivateIpv4('8.8.8.8'), isFalse);
    });
  });

  group('encoders', () {
    test('base64 round trip', () {
      final encoded = base64Encode('Hello');
      expect(encoded.ok, isTrue);
      expect(encoded.value, 'SGVsbG8=');
      final decoded = base64Decode(encoded.value);
      expect(decoded.ok, isTrue);
      expect(decoded.value, 'Hello');
    });

    test('url encode/decode', () {
      expect(urlEncode('a b&c').value, 'a%20b%26c');
      expect(urlDecode('a%20b%26c').value, 'a b&c');
      expect(urlDecode('%%not-valid').ok, isFalse);
    });

    test('hex encode/decode', () {
      expect(hexEncode('AB').value, '41 42');
      expect(hexDecode('41 42').value, 'AB');
      expect(hexDecode('4').ok, isFalse);
      expect(hexDecode('zz').ok, isFalse);
    });

    test('html escape/unescape', () {
      // HtmlEscapeMode.element escapes <, > and & (quotes stay literal).
      final escaped = htmlEscape('<a href="x">&</a>');
      expect(escaped.value, '&lt;a href="x"&gt;&amp;&lt;/a&gt;');
      expect(htmlUnescape(escaped.value).value, '<a href="x">&</a>');
      expect(htmlUnescape('&#65;').value, 'A');
    });
  });

  group('hashing', () {
    test('sha256 of known input', () {
      expect(
        hashTextHex('SHA-256', 'abc'),
        'ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad',
      );
    });

    test('md5 legacy label', () {
      expect(hashTextHex('MD5', ''), 'd41d8cd98f00b204e9800998ecf8427e');
    });

    test('hmac', () {
      // Vector verified against the crypto package implementation itself.
      expect(
        hmacSha256Hex('key', 'The quick brown fox jumps over the lazy dog'),
        'f7bc83f430538424b13298e6aa6fb143ef4d59a14946175997479dbc2d1a3cd8',
      );
    });
  });

  group('jwt decoder', () {
    test('decodes header and payload without verifying signature', () {
      final token = 'eyJhbGciOiJIUzI1NiJ9.'
          'eyJzdWIiOiIxMjM0NSIsIm5hbWUiOiJFbGlhbiJ9.'
          'c2lnbmF0dXJlLW5vdC12ZXJpZmllZC1oZXJl';
      final result = decodeJwt(token);
      expect(result.ok, isTrue);
      expect(result.header.contains('HS256'), isTrue);
      expect(result.payload.contains('Elian'), isTrue);
    });

    test('rejects non-jwt', () {
      expect(decodeJwt('not-a-token').ok, isFalse);
    });
  });

  group('color conversion', () {
    test('hex to rgb', () {
      final rgb = hexToRgb('#7656D6')!;
      expect(rgb.r, 118);
      expect(rgb.g, 86);
      expect(rgb.b, 214);
    });

    test('short hex expansion', () {
      final rgb = hexToRgb('#fff')!;
      expect(rgb.r, 255);
      expect(rgb.b, 255);
    });

    test('rgb to hsl and back', () {
      final rgb = hexToRgb('#7656D6')!;
      final hsl = rgbToHsl(rgb.r, rgb.g, rgb.b);
      expect(hsl.h.round(), moreOrLessEquals(255, epsilon: 2));
      final back = hslToRgb(hsl.h, hsl.s, hsl.l);
      expect((back.r - rgb.r).abs(), lessThanOrEqualTo(2));
    });

    test('grays stay gray', () {
      final rgb = hslToRgb(0, 0, 0.5);
      expect(rgb.r, rgb.g);
      expect(rgb.g, rgb.b);
    });

    test('rgb to hex clamps', () {
      expect(rgbToHex(300, -5, 255), '#FF00FF');
      expect(rgbToHex(0, 255, 255), '#00FFFF');
    });
  });

  group('timestamps', () {
    test('epoch to utc', () {
      final result = timestampFromEpoch(1735689600);
      expect(result.ok, isTrue);
      expect(result.utc, '2025-01-01 00:00:00');
      expect(result.iso, '2025-01-01T00:00:00.000Z');
    });

    test('iso to epoch', () {
      final result = timestampFromIso('2025-01-01T00:00:00Z');
      expect(result.epochSeconds, 1735689600);
    });

    test('bad input reports errors', () {
      expect(timestampFromIso('nope').ok, isFalse);
    });
  });

  group('uuid', () {
    test('generates v4 and validates', () {
      for (var i = 0; i < 50; i++) {
        final uuid = generateUuidV4();
        expect(isUuidV4(uuid), isTrue, reason: uuid);
      }
    });
  });

  group('json tools', () {
    test('formats valid json', () {
      final result = jsonFormat('{"a":1,"b":[2,3]}');
      expect(result.ok, isTrue);
      expect(result.value.contains('  "a"'), isTrue);
    });

    test('minifies', () {
      final result = jsonFormat('{ "a": 1 }', minify: true);
      expect(result.value, '{"a":1}');
    });

    test('reports line/column for malformed json', () {
      final result = jsonFormat('{\n  "a": ,\n}');
      expect(result.ok, isFalse);
      expect(result.error, contains('Line 2'));
    });
  });

  group('electrical calculations', () {
    test('ohm law from V and R', () {
      final solution = solveOhm(v: 24, r: 8)!;
      expect(solution.currentA, 3);
      expect(solution.powerW, 72);
    });

    test('ohm law from P and R', () {
      final solution = solveOhm(p: 100, r: 10)!;
      expect(solution.voltageV, closeTo(31.62, 0.01));
      expect(solution.currentA, closeTo(3.16, 0.01));
    });

    test('ohm law rejects single input', () {
      expect(solveOhm(v: 12), isNull);
    });

    test('single phase ac', () {
      final solution = singlePhaseAc(230, 10, 0.9)!;
      expect(solution.apparentPowerVa, 2300);
      expect(solution.activePowerW, closeTo(2070, 0.001));
    });

    test('three phase ac', () {
      final solution = threePhaseAc(400, 10, 0.9)!;
      expect(solution.apparentPowerVa, closeTo(6928.2, 0.1));
      expect(solution.activePowerW, closeTo(6235.4, 0.1));
    });

    test('voltage drop with assumptions', () {
      final result = voltageDropCopper(
        currentA: 16,
        lengthMeters: 25,
        crossSectionMm2: 2.5,
        systemVoltageV: 230,
      );
      expect(result.dropV, closeTo(5.6, 0.001));
      expect(result.dropPercent, closeTo(2.435, 0.01));
      expect(result.assumptions.length, 5);
    });

    test('cable sizing suggests a standard section', () {
      expect(suggestCrossSectionMm2(18), 2.5);
      expect(suggestCrossSectionMm2(0), isNull);
    });

    test('energy cost', () {
      final result = energyCost(powerW: 120, hours: 5, pricePerKwh: 0.35);
      expect(result.kwh, closeTo(0.6, 0.001));
      expect(result.total, closeTo(0.21, 0.001));
    });
  });

  group('gcode and filament', () {
    test('parses slicer metadata', () {
      final gcode = '''
; generated by PrusaSlicer 2.7.0
; estimated printing time (normal mode) = 1h 2m 3s
; filament used [mm] = 5321.5
G1 X1 Y1
;LAYER:1
G1 X2 Y2
;LAYER:2
G1 X3 Y3
''';
      final stats = parseGcodeStats(gcode);
      expect(stats.layerCount, 2);
      expect(stats.filamentMeters, closeTo(5.3215, 0.001));
      expect(stats.estimatedSeconds, 1 * 3600 + 2 * 60 + 3);
      expect(stats.estimatedTimeText, '1h 2m 3s');
      expect(stats.slicer, isNotNull);
    });

    test('missing metadata is reported as not reported', () {
      final stats = parseGcodeStats('G1 X0 Y0\n');
      expect(stats.filamentMeters, isNull);
      expect(stats.estimatedSeconds, isNull);
      expect(stats.estimatedTimeText, 'not reported');
    });

    test('length to mass for PLA 1.75mm', () {
      final result = filamentFromLength(1.75, 'PLA', 10);
      expect(result.volumeCm3, closeTo(24.05, 0.1));
      expect(result.massGrams, closeTo(29.8, 0.2));
    });

    test('mass back to length round trip', () {
      final result = filamentFromLength(2.85, 'PETG', 3);
      final length = filamentLengthMeters(2.85, result.massGrams / 1.27);
      expect(length, closeTo(3, 0.01));
    });

    test('print cost adds material and energy', () {
      final result = printCost(
        massGrams: 100,
        pricePerKg: 25,
        printerWatt: 120,
        hours: 4,
        energyPricePerKwh: 0.35,
      );
      expect(result.materialCost, closeTo(2.5, 0.001));
      expect(result.energyCost, closeTo(0.168, 0.001));
      expect(result.total, closeTo(2.668, 0.001));
    });
  });

  group('workflow engine', () {
    test('dry run does not execute http', () async {
      final workflow = const Workflow(
        id: 'w',
        name: 'test',
        steps: [
          WorkflowStep(
            type: WorkflowStepType.httpRequest,
            url: 'https://example.com',
          ),
        ],
      );
      var called = false;
      final result = await runWorkflow(
        workflow,
        httpRunner: (url) async {
          called = true;
          return true;
        },
        dryRun: true,
      );
      expect(called, isFalse);
      expect(result.ok, isTrue);
      expect(result.log.length, 1);
    });

    test('http failure fails the run closed', () async {
      final workflow = const Workflow(
        id: 'w',
        name: 'test',
        steps: [
          WorkflowStep(
            type: WorkflowStepType.httpRequest,
            url: 'https://example.com',
          ),
          WorkflowStep(type: WorkflowStepType.log, message: 'done'),
        ],
      );
      final result = await runWorkflow(
        workflow,
        httpRunner: (url) async => false,
      );
      expect(result.ok, isFalse);
      expect(result.log.length, 3);
    });

    test('log steps never touch the network', () async {
      var called = false;
      final result = await runWorkflow(
        const Workflow(
          id: 'w',
          name: 'test',
          steps: [
            WorkflowStep(type: WorkflowStepType.log, message: 'hello'),
            WorkflowStep(type: WorkflowStepType.wait, seconds: 0),
          ],
        ),
        httpRunner: (url) async {
          called = true;
          return true;
        },
      );
      expect(called, isFalse);
      expect(result.ok, isTrue);
    });
  });

  group('security generation', () {
    test('password respects length and policy', () {
      final policy = const PasswordPolicy(length: 24, avoidAmbiguous: false);
      final password = generatePassword(policy);
      expect(password.length, 24);
      expect(
        passwordEntropyBits(policy),
        closeTo(
          24 * math.log(policy.alphabet.length) / math.log(2),
          0.01,
        ),
      );
    });

    test('password avoids ambiguous characters when requested', () {
      const policy = PasswordPolicy(length: 64, avoidAmbiguous: true);
      final password = generatePassword(policy);
      expect(RegExp(r'[O0OlI|]').hasMatch(password), isFalse);
    });

    test('strength labels', () {
      expect(strengthLabel(30), 'weak');
      expect(strengthLabel(50), 'fair');
      expect(strengthLabel(70), 'strong');
      expect(strengthLabel(90), 'excellent');
    });

    test('passphrase has the requested words', () {
      final passphrase = generatePassphrase(5);
      expect(passphrase.split('-').length, 5);
    });
  });

  group('csv tools', () {
    test('analyzes a clean csv', () {
      final summary = analyzeCsv('name,role\nAlice,tech\nBob,ops\n');
      expect(summary.error, isNull);
      expect(summary.rowCount, 3);
      expect(summary.columnCount, 2);
      expect(summary.raggedRows, 0);
    });

    test('detects ragged rows and quotes', () {
      final summary = analyzeCsv('a,b,c\n"x,y",2\n1\n');
      expect(summary.raggedRows, 2);
      expect(summary.columnCount, 3);
    });

    test('rename preview applies find/replace and numbering', () {
      final previews = previewRename(
        ['IMG_1.jpg', 'IMG_2.jpg'],
        find: 'IMG',
        replace: 'photo',
        numberPrefix: true,
      );
      expect(previews[0].renamed, '001_photo_1.jpg');
      expect(previews[1].renamed, '002_photo_2.jpg');
    });
  });

  group('subnet planner', () {
    test('splits /24 into 4 equal subnets', () {
      final subnets = splitIntoEqualSubnets('192.168.1.0', 24, 4)!;
      expect(subnets.length, 4);
      expect(subnets.first.network, '192.168.1.0');
      expect(subnets.first.prefix, 26);
      expect(subnets.first.usableHosts, 62);
      expect(subnets.last.network, '192.168.1.192');
    });

    test('rejects impossible splits', () {
      expect(splitIntoEqualSubnets('10.0.0.0', 24, 0), isNull);
      expect(splitIntoEqualSubnets('10.0.0.0', 30, 16), isNull);
    });

    test('vlsm allocates largest first', () {
      final subnets = allocateVlsm('10.0.0.0', 24, [10, 100, 2])!;
      expect(subnets.length, 3);
      expect(subnets.first.usableHosts, greaterThanOrEqualTo(100));
      expect(subnets.first.prefix, 25);
      expect(subnets.last.prefix, 31);
    });

    test('ipv6 validation', () {
      expect(isValidIpv6('2001:db8::1'), isTrue);
      expect(isValidIpv6('::1'), isTrue);
      expect(isValidIpv6('2001::db8::1'), isFalse);
      expect(isValidIpv6('192.168.1.1'), isFalse);
    });
  });

  group('modbus frames', () {
    test('builds a read request', () {
      final frame = buildReadRegisters(
        transactionId: 0x0102,
        unitId: 17,
        functionCode: 3,
        startAddress: 0x0010,
        quantity: 2,
      );
      expect(frame.length, 12);
      expect(frame[0], 0x01);
      expect(frame[1], 0x02);
      expect(frame[6], 17);
      expect(frame[7], 3);
      expect(frame[11], 2);
    });

    test('rejects invalid parameters', () {
      expect(
        () => buildReadRegisters(
          transactionId: 1,
          unitId: 1,
          functionCode: 5,
          startAddress: 0,
          quantity: 1,
        ),
        throwsArgumentError,
      );
      expect(
        () => buildReadRegisters(
          transactionId: 1,
          unitId: 1,
          functionCode: 3,
          startAddress: 0,
          quantity: 200,
        ),
        throwsArgumentError,
      );
    });

    test('parses a read response', () {
      final frame = <int>[
        0,
        1,
        0,
        0,
        0,
        9,
        1,
        3,
        4,
        0x12,
        0x34,
        0x56,
        0x78,
      ];
      final response = parseReadRegisters(frame);
      expect(response.ok, isTrue);
      expect(response.registers, [0x1234, 0x5678]);
    });

    test('parses an exception response', () {
      final frame = <int>[0, 1, 0, 0, 0, 3, 1, 0x83, 2];
      final response = parseReadRegisters(frame);
      expect(response.ok, isFalse);
      expect(response.exceptionCode, 2);
      expect(modbusExceptionName(2), 'illegal data address');
    });
  });

  group('maintenance logic', () {
    test('status transitions by due date', () {
      final now = DateTime(2026, 1, 1);
      final soon = Asset(
        id: 'a',
        name: 'pump',
        location: 'hall',
        intervalDays: 30,
        lastService: DateTime(2025, 12, 5),
      );
      expect(assessAsset(soon, now).status, MaintenanceStatus.dueSoon);
      final overdue = Asset(
        id: 'b',
        name: 'fan',
        location: 'hall',
        intervalDays: 30,
        lastService: DateTime(2025, 11, 15),
      );
      expect(assessAsset(overdue, now).status, MaintenanceStatus.overdue);
      expect(assessAsset(overdue, now).daysLeft, lessThan(0));
      final ok = Asset(
        id: 'c',
        name: 'compressor',
        location: 'hall',
        intervalDays: 365,
        lastService: DateTime(2025, 12, 20),
      );
      expect(assessAsset(ok, now).status, MaintenanceStatus.ok);
    });
  });
}
