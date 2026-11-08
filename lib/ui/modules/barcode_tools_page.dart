import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../modules/tool_widgets.dart';

/// Module 11 — Barcode & Scanner.
///
/// Camera opens only when the scanner is started; payloads are never
/// auto-opened. QR generation for URL, text and Wi-Fi works offline.
class BarcodeToolsPage extends ConsumerStatefulWidget {
  const BarcodeToolsPage({super.key});

  @override
  ConsumerState<BarcodeToolsPage> createState() => _BarcodeToolsPageState();
}

class _BarcodeToolsPageState extends ConsumerState<BarcodeToolsPage> {
  final _qrController = TextEditingController(text: 'https://example.com');
  final _wifiSsidController = TextEditingController();
  final _wifiPasswordController = TextEditingController();
  final _wifiSecurityController = TextEditingController(text: 'WPA');
  final List<String> _scanHistory = [];
  String _qrKind = 'text';
  bool _scanning = false;
  bool _torch = false;
  MobileScannerController? _scannerController;

  @override
  void dispose() {
    _qrController.dispose();
    _wifiSsidController.dispose();
    _wifiPasswordController.dispose();
    _wifiSecurityController.dispose();
    _scannerController?.dispose();
    super.dispose();
  }

  String get _qrData {
    switch (_qrKind) {
      case 'url':
        return _qrController.text.trim();
      case 'wifi':
        final ssid = _wifiSsidController.text.trim();
        final password = _wifiPasswordController.text;
        final security = _wifiSecurityController.text.trim().isEmpty
            ? 'WPA'
            : _wifiSecurityController.text.trim();
        return 'WIFI:T:$security;S:$ssid;P:$password;;';
      case 'text':
        return _qrController.text;
      default:
        return _qrController.text;
    }
  }

  void _startScan() {
    setState(() => _scanning = true);
    _scannerController ??= MobileScannerController();
  }

  void _stopScan() {
    setState(() => _scanning = false);
    _scannerController?.dispose();
    _scannerController = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(title: const Text('Barcode & Scanner')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 120),
          children: [
            ToolSection(
              title: 'QR generation',
              description: 'Offline generation — nothing is sent.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SegmentedButton<String>(
                    segments: const [
                      ButtonSegment(value: 'text', label: Text('Text')),
                      ButtonSegment(value: 'url', label: Text('URL')),
                      ButtonSegment(value: 'wifi', label: Text('Wi-Fi')),
                    ],
                    selected: {_qrKind},
                    onSelectionChanged: (selection) =>
                        setState(() => _qrKind = selection.first),
                  ),
                  const SizedBox(height: 10),
                  if (_qrKind == 'wifi') ...[
                    GlassField(controller: _wifiSsidController, label: 'SSID'),
                    GlassField(
                        controller: _wifiPasswordController, label: 'Password'),
                    GlassField(
                        controller: _wifiSecurityController,
                        label: 'Security (WPA/WEP/nopass)'),
                  ] else
                    GlassField(
                        controller: _qrController,
                        label: 'Content',
                        maxLines: 2),
                  const SizedBox(height: 10),
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: QrImageView(
                        data: _qrData.isEmpty ? 'empty' : _qrData,
                        version: QrVersions.auto,
                        size: 180,
                        backgroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ToolSection(
              title: 'Scanner',
              description:
                  'Camera opens on demand. Scanned payloads are shown, never auto-opened.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 10,
                    children: [
                      GlassButton(
                        label: _scanning ? 'Stop' : 'Start scanner',
                        icon: _scanning ? Icons.stop : Icons.qr_code_scanner,
                        onPressed: _scanning ? _stopScan : _startScan,
                      ),
                      if (_scanning)
                        GlassButton(
                          label: _torch ? 'Torch off' : 'Torch on',
                          icon: Icons.flash_on,
                          onPressed: () {
                            _scannerController?.toggleTorch();
                            setState(() => _torch = !_torch);
                          },
                        ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  if (_scanning)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: SizedBox(
                        height: 260,
                        child: MobileScanner(
                          controller: _scannerController,
                          onDetect: (capture) {
                            final values = capture.barcodes
                                .map((b) => b.rawValue ?? '?')
                                .where((v) => v.isNotEmpty);
                            if (values.isNotEmpty && mounted) {
                              setState(() {
                                for (final value in values) {
                                  _scanHistory.insert(0, value);
                                }
                              });
                            }
                          },
                        ),
                      ),
                    )
                  else
                    const ResultBox(
                      text: 'Scanner stopped — start it to scan.',
                      height: 80,
                    ),
                  const SizedBox(height: 10),
                  ResultBox(
                    text: _scanHistory.isEmpty
                        ? 'No scans yet'
                        : _scanHistory.take(8).join('\n---\n'),
                    height: 140,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
