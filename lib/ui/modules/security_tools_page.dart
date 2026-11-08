import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../core/tools/hashing.dart';
import '../../core/tools/network_probe.dart';
import '../../core/tools/security_gen.dart';
import '../modules/tool_widgets.dart';

/// Module 08 — Security & Privacy.
///
/// Everything runs locally. Secrets live in the platform keystore
/// (Android Keystore / iOS Keychain) via flutter_secure_storage — never in
/// plain preferences and never sent anywhere.
class SecurityToolsPage extends ConsumerStatefulWidget {
  const SecurityToolsPage({super.key});

  @override
  ConsumerState<SecurityToolsPage> createState() => _SecurityToolsPageState();
}

class _SecurityToolsPageState extends ConsumerState<SecurityToolsPage> {
  final _storage = const FlutterSecureStorage();
  final _secretKeyController = TextEditingController();
  final _secretValueController = TextEditingController();
  final _hashController = TextEditingController();
  final _hmacKeyController = TextEditingController();
  final _hmacMessageController = TextEditingController();
  final _tlsHostController = TextEditingController(text: 'example.com');
  final _urlController = TextEditingController(text: 'https://example.com');

  double _passwordLength = 20;
  bool _upper = true;
  bool _digits = true;
  bool _symbols = true;
  String _passwordOutput = 'Generate a password';
  String _vaultOutput = 'Vault empty or locked';
  String _hashOutput = '';
  String _hmacOutput = '';
  String _tlsOutput = 'No inspection yet';
  String _urlOutput = '';

  @override
  void dispose() {
    _secretKeyController.dispose();
    _secretValueController.dispose();
    _hashController.dispose();
    _hmacKeyController.dispose();
    _hmacMessageController.dispose();
    _tlsHostController.dispose();
    _urlController.dispose();
    super.dispose();
  }

  Future<void> _loadVault() async {
    try {
      final all = await _storage.readAll();
      if (!mounted) return;
      setState(() {
        _vaultOutput = all.isEmpty
            ? 'Vault empty'
            : all.entries
                .map((e) => '${e.key}: ${'•' * (e.value.length.clamp(0, 24))}')
                .join('\n');
      });
    } catch (error) {
      if (!mounted) return;
      setState(() => _vaultOutput = 'Vault access failed: $error');
    }
  }

  Future<void> _saveSecret() async {
    final key = _secretKeyController.text.trim();
    final value = _secretValueController.text;
    if (key.isEmpty || value.isEmpty) return;
    await _storage.write(key: key, value: value);
    _secretValueController.clear();
    await _loadVault();
  }

  Future<void> _deleteAllSecrets() async {
    await _storage.deleteAll();
    await _loadVault();
  }

  void _generatePassword() {
    final policy = PasswordPolicy(
      length: _passwordLength.round(),
      useUpper: _upper,
      useDigits: _digits,
      useSymbols: _symbols,
    );
    final password = generatePassword(policy);
    final entropy = passwordEntropyBits(policy);
    if (!mounted) return;
    setState(() {
      _passwordOutput = '$password\n\n'
          'Entropy: ${entropy.toStringAsFixed(0)} bits — ${strengthLabel(entropy)}\n'
          'Alphabet: ${policy.alphabet.length} characters\n'
          'Generated locally — never uploaded.';
    });
  }

  void _generatePassphrase() {
    final passphrase = generatePassphrase(4);
    if (!mounted) return;
    setState(() {
      _passwordOutput = '$passphrase\n\n'
          'Passphrase: 4 syllables, locally generated, never uploaded.';
    });
  }

  void _runHash() {
    final result = hashText('SHA-256', _hashController.text);
    if (!mounted) return;
    setState(() => _hashOutput = result.hex);
  }

  void _runHmac() {
    final result =
        hmacSha256Hex(_hmacKeyController.text, _hmacMessageController.text);
    if (!mounted) return;
    setState(() => _hmacOutput = result);
  }

  Future<void> _runTls() async {
    final result = await tlsInspect(_tlsHostController.text.trim());
    if (!mounted) return;
    setState(() {
      _tlsOutput = result.ok
          ? 'Issuer    ${result.issuer}\n'
              'Valid     until ${result.validUntil} (${result.daysRemaining} days)'
          : result.error ?? 'failed';
    });
  }

  void _inspectUrl() {
    final url = _urlController.text.trim();
    final uri = Uri.tryParse(url);
    if (!mounted) return;
    setState(() {
      if (uri == null || !uri.hasScheme || !uri.hasAuthority) {
        _urlOutput = 'Not a well-formed URL';
        return;
      }
      final risks = <String>[];
      if (uri.scheme != 'https') risks.add('not HTTPS');
      final host = uri.host;
      if (RegExp(r'^\d+\.\d+\.\d+\.\d+$').hasMatch(host)) {
        risks.add('raw IP host');
      }
      if (host.split('.').length > 3 && host.length > 30) {
        risks.add('long host (possible lookalike)');
      }
      if (uri.userInfo.isNotEmpty) {
        risks.add('userinfo in URL (phishing pattern)');
      }
      _urlOutput = risks.isEmpty
          ? 'No offline heuristics flagged this URL'
          : 'Offline heuristics: ${risks.join(', ')}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(title: const Text('Security & Privacy')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 120),
          children: [
            ToolSection(
              title: 'Password & passphrase',
              description:
                  'Local generation with entropy estimate — never sent to a service.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Length: ${_passwordLength.round()}'),
                  Slider(
                    value: _passwordLength,
                    min: 8,
                    max: 64,
                    divisions: 56,
                    label: '${_passwordLength.round()}',
                    onChanged: (value) =>
                        setState(() => _passwordLength = value),
                  ),
                  Wrap(
                    spacing: 12,
                    children: [
                      FilterChip(
                        label: const Text('A–Z'),
                        selected: _upper,
                        onSelected: (v) => setState(() => _upper = v),
                      ),
                      FilterChip(
                        label: const Text('0–9'),
                        selected: _digits,
                        onSelected: (v) => setState(() => _digits = v),
                      ),
                      FilterChip(
                        label: const Text('!@#'),
                        selected: _symbols,
                        onSelected: (v) => setState(() => _symbols = v),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 10,
                    children: [
                      GlassButton(
                        label: 'Password',
                        icon: Icons.password,
                        onPressed: _generatePassword,
                      ),
                      GlassButton(
                        label: 'Passphrase',
                        icon: Icons.abc,
                        onPressed: _generatePassphrase,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ResultBox(text: _passwordOutput, height: 150),
                ],
              ),
            ),
            ToolSection(
              title: 'Local secret vault',
              description:
                  'Platform keystore (Android Keystore). Stays on device.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GlassField(
                    controller: _secretKeyController,
                    label: 'Key',
                  ),
                  GlassField(
                    controller: _secretValueController,
                    label: 'Secret value',
                  ),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      GlassButton(
                        label: 'Save',
                        icon: Icons.lock,
                        onPressed: _saveSecret,
                      ),
                      GlassButton(
                        label: 'Load keys',
                        icon: Icons.visibility,
                        onPressed: _loadVault,
                      ),
                      GlassButton(
                        label: 'Delete all',
                        icon: Icons.delete_forever,
                        onPressed: _deleteAllSecrets,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ResultBox(text: _vaultOutput, height: 110),
                ],
              ),
            ),
            ToolSection(
              title: 'Hash & HMAC',
              description:
                  'Integrity only — not encryption, not password storage.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GlassField(
                      controller: _hashController,
                      label: 'Text to hash',
                      maxLines: 2),
                  GlassButton(
                    label: 'SHA-256',
                    icon: Icons.tag,
                    onPressed: _runHash,
                  ),
                  const SizedBox(height: 10),
                  ResultBox(text: _hashOutput, height: 90),
                  GlassField(controller: _hmacKeyController, label: 'HMAC key'),
                  GlassField(
                      controller: _hmacMessageController,
                      label: 'Message',
                      maxLines: 2),
                  GlassButton(
                    label: 'HMAC-SHA256',
                    icon: Icons.vpn_key,
                    onPressed: _runHmac,
                  ),
                  const SizedBox(height: 10),
                  ResultBox(text: _hmacOutput, height: 90),
                ],
              ),
            ),
            ToolSection(
              title: 'Certificate inspection',
              description: 'Peer certificate for a host.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GlassField(controller: _tlsHostController, label: 'Host'),
                  GlassButton(
                    label: 'Inspect',
                    icon: Icons.verified_user_outlined,
                    onPressed: _runTls,
                  ),
                  const SizedBox(height: 10),
                  ResultBox(text: _tlsOutput, height: 100),
                ],
              ),
            ),
            ToolSection(
              title: 'URL inspection',
              description:
                  'Offline heuristics only — no remote reputation lookup.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GlassField(controller: _urlController, label: 'URL'),
                  GlassButton(
                    label: 'Check heuristically',
                    icon: Icons.travel_explore,
                    onPressed: _inspectUrl,
                  ),
                  const SizedBox(height: 10),
                  ResultBox(text: _urlOutput, height: 90),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
