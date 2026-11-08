import 'package:e_tools/core/tools/color_convert.dart';
import 'package:e_tools/core/tools/encoders.dart';
import 'package:e_tools/core/tools/hashing.dart';
import 'package:e_tools/core/tools/json_tools.dart';
import 'package:e_tools/core/tools/jwt_decoder.dart';
import 'package:e_tools/core/tools/network_calculator.dart';
import 'package:e_tools/core/tools/timestamp_convert.dart';
import 'package:e_tools/core/tools/uuid_generator.dart';
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
}
