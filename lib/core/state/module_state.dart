import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../modules/module_registry.dart';

/// Favorites and recents state for the module dock.
///
/// Both lists persist in `SharedPreferences` when a store was injected in
/// `main`; without it (tests) they stay in memory.

class FavoritesNotifier extends StateNotifier<List<String>> {
  FavoritesNotifier([SharedPreferences? prefs])
      : _prefs = prefs,
        super(prefs?.getStringList(LocalStore.favoritesKey)?.take(3).toList() ??
            const <String>[]);

  final SharedPreferences? _prefs;

  static const int maxFavorites = 3;

  bool get isFull => state.length >= maxFavorites;
  bool contains(String id) => state.contains(id);

  /// Adds a module to the favorites. Ignored when already present or full.
  void add(String id) {
    if (contains(id) || isFull) return;
    state = [...state, id];
    _persist();
  }

  void remove(String id) {
    if (!contains(id)) return;
    state = state.where((element) => element != id).toList();
    _persist();
  }

  void replace(String oldId, String newId) {
    if (!contains(oldId) || contains(newId)) return;
    state = [
      for (final id in state)
        if (id == oldId) newId else id,
    ];
    _persist();
  }

  void _persist() {
    _prefs?.setStringList(LocalStore.favoritesKey, state);
  }
}

class RecentsNotifier extends StateNotifier<List<String>> {
  RecentsNotifier([SharedPreferences? prefs])
      : _prefs = prefs,
        super(prefs?.getStringList(LocalStore.recentsKey)?.take(8).toList() ??
            const <String>[]);

  final SharedPreferences? _prefs;

  static const int maxRecents = 8;

  /// Marks a module as most recently used (moves it to the front).
  void markUsed(String id) {
    if (ModuleRegistry.byId(id) == null) return;
    state = [
      id,
      ...state.where((element) => element != id),
    ].take(maxRecents).toList();
    _persist();
  }

  void _persist() {
    _prefs?.setStringList(LocalStore.recentsKey, state);
  }
}

/// Storage keys for the persisted dock state.
abstract final class LocalStore {
  static const String favoritesKey = 'etools.favorites.v1';
  static const String recentsKey = 'etools.recents.v1';
}

final StateNotifierProvider<FavoritesNotifier, List<String>> favoritesProvider =
    StateNotifierProvider<FavoritesNotifier, List<String>>(
  (ref) => FavoritesNotifier(),
);

final StateNotifierProvider<RecentsNotifier, List<String>> recentsProvider =
    StateNotifierProvider<RecentsNotifier, List<String>>(
  (ref) => RecentsNotifier(),
);
