import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/app_database.dart';
import '../core/tools/maintenance_logic.dart';
import 'package:drift/drift.dart' show Value;

/// Repository layer: the UI never touches drift directly.
class MaintenanceRepository {
  MaintenanceRepository(this._db);

  final AppDatabase _db;

  Stream<List<Asset>> watchAssets() {
    return _db.select(_db.assets).watch();
  }

  Stream<List<ServiceNote>> watchNotes(int assetId) {
    return (_db.select(_db.serviceNotes)
          ..where((tbl) => tbl.assetId.equals(assetId)))
        .watch();
  }

  Future<int> addAsset({
    required String name,
    required String location,
    required int intervalDays,
  }) {
    return _db.into(_db.assets).insert(
          AssetsCompanion.insert(
            name: name,
            location: Value(location),
            intervalDays: Value(intervalDays),
            lastService: DateTime.now(),
          ),
        );
  }

  /// Logs a performed service: resets the interval and adds a note.
  Future<void> logService(int assetId, {String note = 'service performed'}) {
    final now = DateTime.now();
    return _db.transaction(() async {
      await (_db.update(_db.assets)..where((tbl) => tbl.id.equals(assetId)))
          .write(AssetsCompanion(lastService: Value(now)));
      await _db.into(_db.serviceNotes).insert(
            ServiceNotesCompanion.insert(
              assetId: assetId,
              timestamp: now,
              note: note,
            ),
          );
    });
  }

  /// Deletes an asset together with its notes. The cascade is enforced in
  /// application code (portable across SQLite builds) *and* by the FK
  /// constraint in the schema.
  Future<void> deleteAsset(int assetId) {
    return _db.transaction(() async {
      await (_db.delete(_db.serviceNotes)
            ..where((tbl) => tbl.assetId.equals(assetId)))
          .go();
      await (_db.delete(_db.assets)..where((tbl) => tbl.id.equals(assetId)))
          .go();
    });
  }
}

class CompatibilityRepository {
  CompatibilityRepository(this._db);

  final AppDatabase _db;

  Stream<List<CompatibilityReport>> watchReports() {
    return _db.select(_db.compatibilityReports).watch();
  }

  Future<int> addReport({
    required String tablet,
    required String adapter,
    required String result,
  }) {
    return _db.into(_db.compatibilityReports).insert(
          CompatibilityReportsCompanion.insert(
            tablet: tablet,
            adapter: adapter,
            result: result,
          ),
        );
  }
}

/// Providers for the database layer.
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase();
});

final maintenanceRepositoryProvider = Provider<MaintenanceRepository>(
  (ref) => MaintenanceRepository(ref.watch(appDatabaseProvider)),
);

final compatibilityRepositoryProvider = Provider<CompatibilityRepository>(
  (ref) => CompatibilityRepository(ref.watch(appDatabaseProvider)),
);

final assetsStreamProvider = StreamProvider<List<Asset>>(
  (ref) => ref.watch(maintenanceRepositoryProvider).watchAssets(),
);

final compatibilityReportsStreamProvider =
    StreamProvider<List<CompatibilityReport>>(
  (ref) => ref.watch(compatibilityRepositoryProvider).watchReports(),
);

/// Maps DB rows to the maintenance assessment model.
List<MaintenanceAssessment> assessAssets(
  List<Asset> assets,
  DateTime now,
) {
  final assessments = assets
      .map((asset) => assessAsset(
            ServiceAsset(
              id: '${asset.id}',
              name: asset.name,
              location: asset.location,
              intervalDays: asset.intervalDays,
              lastService: asset.lastService,
            ),
            now,
          ))
      .toList()
    ..sort((a, b) => a.daysLeft.compareTo(b.daysLeft));
  return assessments;
}
