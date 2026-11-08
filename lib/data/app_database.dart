import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

/// Field / asset record of a site (maintenance module).
class Sites extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get location => text().withDefault(const Constant(''))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

/// Asset with a preventive service interval.
class Assets extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get location => text().withDefault(const Constant(''))();
  IntColumn get intervalDays => integer().withDefault(const Constant(90))();
  DateTimeColumn get lastService => dateTime()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

/// Local service/maintenance note per asset.
class ServiceNotes extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get assetId =>
      integer().references(Assets, #id, onDelete: KeyAction.cascade)();
  DateTimeColumn get timestamp => dateTime()();
  TextColumn get note => text()();
}

/// User-maintained adapter compatibility report (hardware module).
class CompatibilityReports extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get tablet => text()();
  TextColumn get adapter => text()();
  TextColumn get result => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

/// The local, offline-first database. Versioned via [schemaVersion];
/// migrations run in [migration].
@DriftDatabase(tables: [Sites, Assets, ServiceNotes, CompatibilityReports])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
        onUpgrade: (m, from, to) async {
          // Future schema changes land here; keep each step tested in
          // test/database_test.dart.
        },
      );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'etools.sqlite'));
    return NativeDatabase(file);
  });
}
