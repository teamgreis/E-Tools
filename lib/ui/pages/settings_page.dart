import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/motion/haptics.dart';
import '../../core/settings/app_settings.dart';
import '../glass/glass_controls.dart';
import '../glass/glass_surface.dart';

/// Settings page: the live glass controls plus haptics and motion.
///
/// The two sliders drive every `GlassSurface` in the app in real time:
/// 0 = fully transparent, 1 = maximum blur / fully frosted.
class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(appSettingsProvider);
    final notifier = ref.read(appSettingsProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(title: const Text('Settings')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 120),
          children: [
            // Live preview of the current glass look.
            Center(
              child: GlassSurface(
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 22,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Glas-Vorschau',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Unschärfe ${(settings.glassBlur * 100).round()}% · '
                      'Deckkraft ${(settings.glassTint * 100).round()}%',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            _GlassSlider(
              label: 'Glas-Unschärfe',
              description: '0 = komplett durchsichtig · 100 = maximaler Blur',
              value: settings.glassBlur,
              onChanged: (value) {
                notifier.setGlassBlur(value);
                AppHaptics.tick(ref);
              },
            ),
            _GlassSlider(
              label: 'Glas-Deckkraft',
              description: 'Milchigkeit der Glasflächen',
              value: settings.glassTint,
              onChanged: (value) {
                notifier.setGlassTint(value);
                AppHaptics.tick(ref);
              },
            ),
            const SizedBox(height: 8),
            GlassSurface(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shadow: false,
              child: Column(
                children: [
                  SwitchListTile(
                    title: const Text('Haptik'),
                    subtitle: const Text('Vibration bei Eingaben'),
                    value: settings.hapticsEnabled,
                    onChanged: (value) {
                      notifier.setHapticsEnabled(value);
                      AppHaptics.tap(ref);
                    },
                  ),
                  SwitchListTile(
                    title: const Text('Reduzierte Bewegung'),
                    subtitle: const Text('Deaktiviert Spring-Animationen'),
                    value: settings.reducedMotion,
                    onChanged: (value) {
                      notifier.setReducedMotion(value);
                      AppHaptics.tap(ref);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: GlassIconButton(
                icon: Icons.restart_alt,
                tooltip: 'Zurücksetzen',
                onTap: () {
                  notifier.setGlassBlur(0.65);
                  notifier.setGlassTint(0.55);
                  notifier.setHapticsEnabled(true);
                  notifier.setReducedMotion(false);
                  AppHaptics.stateChange(ref);
                },
                size: 52,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GlassSlider extends StatelessWidget {
  const _GlassSlider({
    required this.label,
    required this.description,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final String description;
  final double value;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    final percent = (value * 100).round();
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 2),
          Text(
            description,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          Slider(
            value: value,
            label: '$percent%',
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
