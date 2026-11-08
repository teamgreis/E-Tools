import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Global app settings, persisted in `SharedPreferences`.
///
/// The glass sliders drive the live look of every `GlassSurface`:
/// [glassBlur] 0.0 = fully transparent, 1.0 = maximum blur.
/// [glassTint] 0.0 = crystal clear, 1.0 = milky/frosted.
class AppSettings {
  const AppSettings({
    this.glassBlur = 0.65,
    this.glassTint = 0.55,
    this.hapticsEnabled = true,
    this.reducedMotion = false,
  });

  final double glassBlur;
  final double glassTint;
  final bool hapticsEnabled;
  final bool reducedMotion;

  AppSettings copyWith({
    double? glassBlur,
    double? glassTint,
    bool? hapticsEnabled,
    bool? reducedMotion,
  }) {
    return AppSettings(
      glassBlur: glassBlur ?? this.glassBlur,
      glassTint: glassTint ?? this.glassTint,
      hapticsEnabled: hapticsEnabled ?? this.hapticsEnabled,
      reducedMotion: reducedMotion ?? this.reducedMotion,
    );
  }
}

class AppSettingsNotifier extends StateNotifier<AppSettings> {
  AppSettingsNotifier([SharedPreferences? prefs])
      : _prefs = prefs,
        super(AppSettings(
          glassBlur: prefs?.getDouble(_kBlur) ?? const AppSettings().glassBlur,
          glassTint: prefs?.getDouble(_kTint) ?? const AppSettings().glassTint,
          hapticsEnabled: prefs?.getBool(_kHaptics) ?? true,
          reducedMotion: prefs?.getBool(_kMotion) ?? false,
        ));

  final SharedPreferences? _prefs;

  static const _kBlur = 'etools.settings.glassBlur';
  static const _kTint = 'etools.settings.glassTint';
  static const _kHaptics = 'etools.settings.haptics';
  static const _kMotion = 'etools.settings.reducedMotion';

  void setGlassBlur(double value) {
    final clamped = value.clamp(0.0, 1.0);
    state = state.copyWith(glassBlur: clamped);
    _prefs?.setDouble(_kBlur, clamped);
  }

  void setGlassTint(double value) {
    final clamped = value.clamp(0.0, 1.0);
    state = state.copyWith(glassTint: clamped);
    _prefs?.setDouble(_kTint, clamped);
  }

  void setHapticsEnabled(bool value) {
    state = state.copyWith(hapticsEnabled: value);
    _prefs?.setBool(_kHaptics, value);
  }

  void setReducedMotion(bool value) {
    state = state.copyWith(reducedMotion: value);
    _prefs?.setBool(_kMotion, value);
  }
}

final StateNotifierProvider<AppSettingsNotifier, AppSettings>
    appSettingsProvider =
    StateNotifierProvider<AppSettingsNotifier, AppSettings>(
  (ref) => AppSettingsNotifier(),
);
