import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/tools/color_convert.dart';
import '../../core/tools/encoders.dart';
import '../../core/tools/hashing.dart';
import '../../core/tools/json_tools.dart';
import '../../core/tools/jwt_decoder.dart';
import '../../core/tools/timestamp_convert.dart';
import '../../core/tools/uuid_generator.dart';
import '../modules/tool_widgets.dart';

/// Module 03 — Developer Tools.
///
/// Text tools run locally: nothing is uploaded, inputs stay on device.
class DevToolsPage extends ConsumerStatefulWidget {
  const DevToolsPage({super.key});

  @override
  ConsumerState<DevToolsPage> createState() => _DevToolsPageState();
}

class _DevToolsPageState extends ConsumerState<DevToolsPage> {
  final _jsonController = TextEditingController();
  final _encodeController = TextEditingController();
  final _hashController = TextEditingController();
  final _jwtController = TextEditingController();
  final _epochController = TextEditingController(text: '1735689600');
  final _isoController = TextEditingController(text: '2025-01-01T00:00:00Z');
  final _colorController = TextEditingController(text: '#7656D6');
  final _regexPatternController =
      TextEditingController(text: r'\b\w+@\w+\.\w+\b');
  final _regexSampleController = TextEditingController(
    text: 'contact: dev@example.com, admin@example.org',
  );

  String _jsonOutput = 'Enter JSON and validate';
  String _encodeOutput = '';
  String _encodeMode = 'Base64 encode';
  String _hashOutput = '';
  String _hashAlgorithm = 'SHA-256';
  String _jwtOutput = '';
  String _timestampOutput = '';
  String _colorOutput = '';
  String _regexOutput = '';
  final List<String> _uuids = [];

  static const _encodeModes = [
    'Base64 encode',
    'Base64 decode',
    'URL encode',
    'URL decode',
    'Hex encode',
    'Hex decode',
    'HTML escape',
    'HTML unescape',
  ];

  @override
  void dispose() {
    _jsonController.dispose();
    _encodeController.dispose();
    _hashController.dispose();
    _jwtController.dispose();
    _epochController.dispose();
    _isoController.dispose();
    _colorController.dispose();
    _regexPatternController.dispose();
    _regexSampleController.dispose();
    super.dispose();
  }

  void _runJson(bool minify) {
    final result = jsonFormat(_jsonController.text, minify: minify);
    setState(() {
      _jsonOutput = result.ok ? result.value : 'Invalid JSON\n${result.error}';
    });
  }

  void _runEncode() {
    final input = _encodeController.text;
    final result = switch (_encodeMode) {
      'Base64 encode' => base64Encode(input),
      'Base64 decode' => base64Decode(input),
      'URL encode' => urlEncode(input),
      'URL decode' => urlDecode(input),
      'Hex encode' => hexEncode(input),
      'Hex decode' => hexDecode(input),
      'HTML escape' => htmlEscape(input),
      'HTML unescape' => htmlUnescape(input),
      _ => const TextResult(ok: false, error: 'Unknown mode'),
    };
    setState(() {
      _encodeOutput = result.ok ? result.value : 'Error: ${result.error}';
    });
  }

  void _runHash() {
    final result = hashText(_hashAlgorithm, _hashController.text);
    setState(() {
      _hashOutput = '${result.algorithm}\n'
          'hex     ${result.hex}\n'
          'base64  ${result.base64}\n'
          '— hash for comparison, not encryption, not password storage.';
    });
  }

  void _runJwt() {
    final result = decodeJwt(_jwtController.text);
    if (!mounted) return;
    setState(() {
      _jwtOutput = result.ok
          ? 'Header (base64url-decoded)\n${result.header}\n\n'
              'Payload\n${result.payload}\n\n'
              'Signature: ${result.signatureLength} chars — NOT verified here'
          : 'Error: ${result.error}';
    });
  }

  void _runEpoch() {
    final epoch = int.tryParse(_epochController.text.trim());
    if (epoch == null) {
      setState(() => _timestampOutput = 'Not an integer timestamp');
      return;
    }
    final result = timestampFromEpoch(epoch);
    setState(() {
      _timestampOutput = result.ok
          ? 'UTC    ${result.utc}\nLocal  ${result.local}\nISO    ${result.iso}\nAge    ${result.relative}'
          : 'Error: ${result.error}';
    });
  }

  void _runIso() {
    final result = timestampFromIso(_isoController.text);
    setState(() {
      _timestampOutput = result.ok
          ? 'Epoch  ${result.epochSeconds}\nUTC    ${result.utc}\nLocal  ${result.local}\nISO    ${result.iso}'
          : 'Error: ${result.error}';
    });
  }

  void _runColor() {
    final rgb = hexToRgb(_colorController.text);
    if (rgb == null) {
      setState(() => _colorOutput = 'Invalid hex (#RRGGBB or #RGB)');
      return;
    }
    final hsl = rgbToHsl(rgb.r, rgb.g, rgb.b);
    setState(() {
      _colorOutput = 'RGB  ${rgb.r}, ${rgb.g}, ${rgb.b}\n'
          'HSL  ${hsl.h.round()}°, ${(hsl.s * 100).round()}%, ${(hsl.l * 100).round()}%\n'
          'HEX  ${rgbToHex(rgb.r, rgb.g, rgb.b)}';
    });
  }

  void _runRegex() {
    try {
      final pattern = RegExp(_regexPatternController.text);
      final matches = pattern.allMatches(_regexSampleController.text).toList();
      setState(() {
        _regexOutput = matches.isEmpty
            ? 'No matches (${matches.length})'
            : '${matches.length} match(es)\n${matches.map((m) => '  ${m.group(0)}').join('\n')}';
      });
    } catch (error) {
      setState(() => _regexOutput = 'Invalid pattern: $error');
    }
  }

  void _generateUuid() {
    setState(() {
      _uuids.insert(0, generateUuidV4());
      if (_uuids.length > 5) _uuids.removeLast();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(title: const Text('Developer Tools')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 120),
          children: [
            ToolSection(
              title: 'JSON',
              description:
                  'Validate, pretty-print or minify. Malformed input reports line and column.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GlassField(
                    controller: _jsonController,
                    label: 'JSON input',
                    hint: '{"key": "value"}',
                    maxLines: 4,
                  ),
                  Wrap(
                    spacing: 10,
                    children: [
                      GlassButton(
                        label: 'Format',
                        icon: Icons.data_object,
                        onPressed: () => _runJson(false),
                      ),
                      GlassButton(
                        label: 'Minify',
                        icon: Icons.compress,
                        onPressed: () => _runJson(true),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ResultBox(text: _jsonOutput, height: 180),
                ],
              ),
            ),
            ToolSection(
              title: 'Encoders',
              description: 'Base64, URL, hex and HTML entity conversions.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownButtonFormField<String>(
                    initialValue: _encodeMode,
                    decoration: const InputDecoration(
                      labelText: 'Mode',
                      border: OutlineInputBorder(),
                    ),
                    items: [
                      for (final mode in _encodeModes)
                        DropdownMenuItem(value: mode, child: Text(mode)),
                    ],
                    onChanged: (value) =>
                        setState(() => _encodeMode = value ?? _encodeMode),
                  ),
                  const SizedBox(height: 10),
                  GlassField(
                      controller: _encodeController,
                      label: 'Input',
                      maxLines: 3),
                  GlassButton(
                    label: 'Convert',
                    icon: Icons.swap_horiz,
                    onPressed: _runEncode,
                  ),
                  const SizedBox(height: 10),
                  ResultBox(text: _encodeOutput, height: 140),
                ],
              ),
            ),
            ToolSection(
              title: 'Hashes',
              description:
                  'MD5 (legacy), SHA-1, SHA-256, SHA-512. Integrity only.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownButtonFormField<String>(
                    initialValue: _hashAlgorithm,
                    decoration: const InputDecoration(
                      labelText: 'Algorithm',
                      border: OutlineInputBorder(),
                    ),
                    items: [
                      for (final algorithm in availableHashAlgorithms)
                        DropdownMenuItem(
                            value: algorithm, child: Text(algorithm)),
                    ],
                    onChanged: (value) => setState(
                        () => _hashAlgorithm = value ?? _hashAlgorithm),
                  ),
                  const SizedBox(height: 10),
                  GlassField(
                      controller: _hashController, label: 'Input', maxLines: 3),
                  GlassButton(
                    label: 'Hash',
                    icon: Icons.tag,
                    onPressed: _runHash,
                  ),
                  const SizedBox(height: 10),
                  ResultBox(text: _hashOutput, height: 140),
                ],
              ),
            ),
            ToolSection(
              title: 'JWT inspection',
              description:
                  'Decodes header and payload. Signature validation is explicitly NOT performed.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GlassField(
                    controller: _jwtController,
                    label: 'JWT',
                    hint: 'xxxxx.yyyyy.zzzzz',
                    maxLines: 3,
                  ),
                  GlassButton(
                    label: 'Decode',
                    icon: Icons.vpn_key_outlined,
                    onPressed: _runJwt,
                  ),
                  const SizedBox(height: 10),
                  ResultBox(text: _jwtOutput, height: 200),
                ],
              ),
            ),
            ToolSection(
              title: 'UUID v4',
              description:
                  'Cryptographically strong random UUIDs, generated locally.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GlassButton(
                    label: 'Generate',
                    icon: Icons.casino,
                    onPressed: _generateUuid,
                  ),
                  const SizedBox(height: 10),
                  if (_uuids.isNotEmpty)
                    ResultBox(text: _uuids.join('\n'), height: 110),
                ],
              ),
            ),
            ToolSection(
              title: 'Timestamps',
              description: 'Unix epoch ↔ ISO 8601 ↔ local and UTC time.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GlassField(
                    controller: _epochController,
                    label: 'Unix epoch (seconds)',
                    keyboardType: TextInputType.number,
                  ),
                  GlassButton(
                    label: 'Convert epoch',
                    icon: Icons.schedule,
                    onPressed: _runEpoch,
                  ),
                  const SizedBox(height: 10),
                  GlassField(controller: _isoController, label: 'ISO 8601'),
                  GlassButton(
                    label: 'Convert ISO',
                    icon: Icons.event,
                    onPressed: _runIso,
                  ),
                  const SizedBox(height: 10),
                  ResultBox(text: _timestampOutput, height: 130),
                ],
              ),
            ),
            ToolSection(
              title: 'Color conversion',
              description: 'Hex ↔ RGB ↔ HSL conversion.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GlassField(controller: _colorController, label: 'Hex color'),
                  GlassButton(
                    label: 'Convert',
                    icon: Icons.palette_outlined,
                    onPressed: _runColor,
                  ),
                  const SizedBox(height: 10),
                  ResultBox(text: _colorOutput, height: 100),
                ],
              ),
            ),
            ToolSection(
              title: 'Regex tester',
              description: 'Test patterns against sample text. Fully offline.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GlassField(
                      controller: _regexPatternController, label: 'Pattern'),
                  GlassField(
                    controller: _regexSampleController,
                    label: 'Sample text',
                    maxLines: 2,
                  ),
                  GlassButton(
                    label: 'Test',
                    icon: Icons.manage_search,
                    onPressed: _runRegex,
                  ),
                  const SizedBox(height: 10),
                  ResultBox(text: _regexOutput, height: 110),
                ],
              ),
            ),
            const ToolSection(
              title: 'Planned, not yet implemented',
              description:
                  'Honest scope: these tools are on the spec but not in the app yet.',
              child: ResultBox(
                text: 'XML/YAML inspection · HTML/CSS/JS/SQL formatters · '
                    'Markdown preview · text diff · API request tester',
                height: 90,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
