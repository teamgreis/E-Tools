import 'package:e_tools/core/modules/module_registry.dart';
import 'package:e_tools/core/settings/app_settings.dart';
import 'package:e_tools/core/state/module_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Persistence for favorites and recents. Injected here so the notifiers
  // stay synchronous; without an injection they keep state in memory.
  final prefs = await SharedPreferences.getInstance();

  // The central tool registry: registering a module here is all it takes
  // for it to appear in the dashboard, the menu and the dock.
  ModuleRegistry.registerDefaults();

  runApp(
    ProviderScope(
      overrides: [
        appSettingsProvider.overrideWith((ref) => AppSettingsNotifier(prefs)),
        favoritesProvider.overrideWith((ref) => FavoritesNotifier(prefs)),
        recentsProvider.overrideWith((ref) => RecentsNotifier(prefs)),
      ],
      child: const EToolsApp(),
    ),
  );
}
