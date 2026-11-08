import 'package:drift/drift.dart' show Value, Variable;
import 'package:drift/native.dart';
import 'package:e_tools/data/app_database.dart';
import 'package:e_tools/data/repositories.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  test('creates all tables on open (migration onCreate)', () async {
    final tables = await db.customSelect(
        'SELECT name FROM sqlite_master WHERE type = ?',
        variables: [Variable.withString('table')]).get();
    final names = tables.map((row) => row.data['name'] as String).toList();
    expect(
        names,
        containsAll(
            ['sites', 'assets', 'service_notes', 'compatibility_reports']));
  });

  test('reports schema version 1', () async {
    expect(db.schemaVersion, 1);
  });

  test('assets CRUD returns rows via repository', () async {
    final repository = MaintenanceRepository(db);
    final id = await repository.addAsset(
      name: 'Pump 1',
      location: 'Hall A',
      intervalDays: 90,
    );
    final assets = await db.select(db.assets).get();
    expect(assets.length, 1);
    expect(assets.first.name, 'Pump 1');
    expect(assets.first.intervalDays, 90);

    await repository.logService(id, note: 'oil changed');
    final notes = await db.select(db.serviceNotes).get();
    expect(notes.length, 1);
    expect(notes.first.note, 'oil changed');
    final updated = await db.select(db.assets).getSingle();
    expect(updated.lastService.difference(notes.first.timestamp).inSeconds,
        lessThanOrEqualTo(1));
  });

  test('assessment maps DB rows to ok/due-soon/overdue', () async {
    final repository = MaintenanceRepository(db);
    await repository.addAsset(
      name: 'Fresh',
      location: '',
      intervalDays: 365,
    );
    await db.into(db.assets).insert(
          AssetsCompanion.insert(
            name: 'Due soon',
            intervalDays: const Value(30),
            lastService: DateTime.now().subtract(const Duration(days: 26)),
          ),
        );
    await db.into(db.assets).insert(
          AssetsCompanion.insert(
            name: 'Overdue',
            intervalDays: const Value(30),
            lastService: DateTime.now().subtract(const Duration(days: 40)),
          ),
        );
    final assets = await db.select(db.assets).get();
    final assessments = assessAssets(assets, DateTime.now());
    final byName = {for (final a in assessments) a.asset.name: a.status.name};
    expect(byName['Fresh'], 'ok');
    expect(byName['Due soon'], 'dueSoon');
    expect(byName['Overdue'], 'overdue');
  });

  test('deleting an asset cascades to its notes', () async {
    final repository = MaintenanceRepository(db);
    final id = await repository.addAsset(
      name: 'Compressor',
      location: 'Hall B',
      intervalDays: 60,
    );
    await repository.logService(id);
    expect(await db.select(db.serviceNotes).get(), hasLength(1));
    await repository.deleteAsset(id);
    expect(await db.select(db.assets).get(), isEmpty);
    expect(await db.select(db.serviceNotes).get(), isEmpty);
  });

  test('compatibility reports persist', () async {
    final repository = CompatibilityRepository(db);
    await repository.addReport(
      tablet: 'Galaxy Tab S9',
      adapter: 'UGREEN USB-C Ethernet (ASIX)',
      result: 'works',
    );
    final reports = await db.select(db.compatibilityReports).get();
    expect(reports.length, 1);
    expect(reports.first.result, 'works');
  });
}
