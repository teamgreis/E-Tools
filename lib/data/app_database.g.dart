// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $SitesTable extends Sites with TableInfo<$SitesTable, Site> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SitesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _locationMeta =
      const VerificationMeta('location');
  @override
  late final GeneratedColumn<String> location = GeneratedColumn<String>(
      'location', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [id, name, location, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sites';
  @override
  VerificationContext validateIntegrity(Insertable<Site> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('location')) {
      context.handle(_locationMeta,
          location.isAcceptableOrUnknown(data['location']!, _locationMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Site map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Site(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      location: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}location'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $SitesTable createAlias(String alias) {
    return $SitesTable(attachedDatabase, alias);
  }
}

class Site extends DataClass implements Insertable<Site> {
  final int id;
  final String name;
  final String location;
  final DateTime createdAt;
  const Site(
      {required this.id,
      required this.name,
      required this.location,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['location'] = Variable<String>(location);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  SitesCompanion toCompanion(bool nullToAbsent) {
    return SitesCompanion(
      id: Value(id),
      name: Value(name),
      location: Value(location),
      createdAt: Value(createdAt),
    );
  }

  factory Site.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Site(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      location: serializer.fromJson<String>(json['location']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'location': serializer.toJson<String>(location),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Site copyWith(
          {int? id, String? name, String? location, DateTime? createdAt}) =>
      Site(
        id: id ?? this.id,
        name: name ?? this.name,
        location: location ?? this.location,
        createdAt: createdAt ?? this.createdAt,
      );
  Site copyWithCompanion(SitesCompanion data) {
    return Site(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      location: data.location.present ? data.location.value : this.location,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Site(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('location: $location, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, location, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Site &&
          other.id == this.id &&
          other.name == this.name &&
          other.location == this.location &&
          other.createdAt == this.createdAt);
}

class SitesCompanion extends UpdateCompanion<Site> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> location;
  final Value<DateTime> createdAt;
  const SitesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.location = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  SitesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.location = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Site> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? location,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (location != null) 'location': location,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  SitesCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String>? location,
      Value<DateTime>? createdAt}) {
    return SitesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      location: location ?? this.location,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (location.present) {
      map['location'] = Variable<String>(location.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SitesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('location: $location, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $AssetsTable extends Assets with TableInfo<$AssetsTable, Asset> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AssetsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _locationMeta =
      const VerificationMeta('location');
  @override
  late final GeneratedColumn<String> location = GeneratedColumn<String>(
      'location', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _intervalDaysMeta =
      const VerificationMeta('intervalDays');
  @override
  late final GeneratedColumn<int> intervalDays = GeneratedColumn<int>(
      'interval_days', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(90));
  static const VerificationMeta _lastServiceMeta =
      const VerificationMeta('lastService');
  @override
  late final GeneratedColumn<DateTime> lastService = GeneratedColumn<DateTime>(
      'last_service', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, location, intervalDays, lastService, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'assets';
  @override
  VerificationContext validateIntegrity(Insertable<Asset> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('location')) {
      context.handle(_locationMeta,
          location.isAcceptableOrUnknown(data['location']!, _locationMeta));
    }
    if (data.containsKey('interval_days')) {
      context.handle(
          _intervalDaysMeta,
          intervalDays.isAcceptableOrUnknown(
              data['interval_days']!, _intervalDaysMeta));
    }
    if (data.containsKey('last_service')) {
      context.handle(
          _lastServiceMeta,
          lastService.isAcceptableOrUnknown(
              data['last_service']!, _lastServiceMeta));
    } else if (isInserting) {
      context.missing(_lastServiceMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Asset map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Asset(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      location: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}location'])!,
      intervalDays: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}interval_days'])!,
      lastService: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}last_service'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $AssetsTable createAlias(String alias) {
    return $AssetsTable(attachedDatabase, alias);
  }
}

class Asset extends DataClass implements Insertable<Asset> {
  final int id;
  final String name;
  final String location;
  final int intervalDays;
  final DateTime lastService;
  final DateTime createdAt;
  const Asset(
      {required this.id,
      required this.name,
      required this.location,
      required this.intervalDays,
      required this.lastService,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['location'] = Variable<String>(location);
    map['interval_days'] = Variable<int>(intervalDays);
    map['last_service'] = Variable<DateTime>(lastService);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  AssetsCompanion toCompanion(bool nullToAbsent) {
    return AssetsCompanion(
      id: Value(id),
      name: Value(name),
      location: Value(location),
      intervalDays: Value(intervalDays),
      lastService: Value(lastService),
      createdAt: Value(createdAt),
    );
  }

  factory Asset.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Asset(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      location: serializer.fromJson<String>(json['location']),
      intervalDays: serializer.fromJson<int>(json['intervalDays']),
      lastService: serializer.fromJson<DateTime>(json['lastService']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'location': serializer.toJson<String>(location),
      'intervalDays': serializer.toJson<int>(intervalDays),
      'lastService': serializer.toJson<DateTime>(lastService),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Asset copyWith(
          {int? id,
          String? name,
          String? location,
          int? intervalDays,
          DateTime? lastService,
          DateTime? createdAt}) =>
      Asset(
        id: id ?? this.id,
        name: name ?? this.name,
        location: location ?? this.location,
        intervalDays: intervalDays ?? this.intervalDays,
        lastService: lastService ?? this.lastService,
        createdAt: createdAt ?? this.createdAt,
      );
  Asset copyWithCompanion(AssetsCompanion data) {
    return Asset(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      location: data.location.present ? data.location.value : this.location,
      intervalDays: data.intervalDays.present
          ? data.intervalDays.value
          : this.intervalDays,
      lastService:
          data.lastService.present ? data.lastService.value : this.lastService,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Asset(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('location: $location, ')
          ..write('intervalDays: $intervalDays, ')
          ..write('lastService: $lastService, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, location, intervalDays, lastService, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Asset &&
          other.id == this.id &&
          other.name == this.name &&
          other.location == this.location &&
          other.intervalDays == this.intervalDays &&
          other.lastService == this.lastService &&
          other.createdAt == this.createdAt);
}

class AssetsCompanion extends UpdateCompanion<Asset> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> location;
  final Value<int> intervalDays;
  final Value<DateTime> lastService;
  final Value<DateTime> createdAt;
  const AssetsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.location = const Value.absent(),
    this.intervalDays = const Value.absent(),
    this.lastService = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  AssetsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.location = const Value.absent(),
    this.intervalDays = const Value.absent(),
    required DateTime lastService,
    this.createdAt = const Value.absent(),
  })  : name = Value(name),
        lastService = Value(lastService);
  static Insertable<Asset> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? location,
    Expression<int>? intervalDays,
    Expression<DateTime>? lastService,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (location != null) 'location': location,
      if (intervalDays != null) 'interval_days': intervalDays,
      if (lastService != null) 'last_service': lastService,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  AssetsCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String>? location,
      Value<int>? intervalDays,
      Value<DateTime>? lastService,
      Value<DateTime>? createdAt}) {
    return AssetsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      location: location ?? this.location,
      intervalDays: intervalDays ?? this.intervalDays,
      lastService: lastService ?? this.lastService,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (location.present) {
      map['location'] = Variable<String>(location.value);
    }
    if (intervalDays.present) {
      map['interval_days'] = Variable<int>(intervalDays.value);
    }
    if (lastService.present) {
      map['last_service'] = Variable<DateTime>(lastService.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AssetsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('location: $location, ')
          ..write('intervalDays: $intervalDays, ')
          ..write('lastService: $lastService, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $ServiceNotesTable extends ServiceNotes
    with TableInfo<$ServiceNotesTable, ServiceNote> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ServiceNotesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _assetIdMeta =
      const VerificationMeta('assetId');
  @override
  late final GeneratedColumn<int> assetId = GeneratedColumn<int>(
      'asset_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES assets (id) ON DELETE CASCADE'));
  static const VerificationMeta _timestampMeta =
      const VerificationMeta('timestamp');
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
      'timestamp', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
      'note', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, assetId, timestamp, note];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'service_notes';
  @override
  VerificationContext validateIntegrity(Insertable<ServiceNote> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('asset_id')) {
      context.handle(_assetIdMeta,
          assetId.isAcceptableOrUnknown(data['asset_id']!, _assetIdMeta));
    } else if (isInserting) {
      context.missing(_assetIdMeta);
    }
    if (data.containsKey('timestamp')) {
      context.handle(_timestampMeta,
          timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta));
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
          _noteMeta, note.isAcceptableOrUnknown(data['note']!, _noteMeta));
    } else if (isInserting) {
      context.missing(_noteMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ServiceNote map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ServiceNote(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      assetId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}asset_id'])!,
      timestamp: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}timestamp'])!,
      note: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}note'])!,
    );
  }

  @override
  $ServiceNotesTable createAlias(String alias) {
    return $ServiceNotesTable(attachedDatabase, alias);
  }
}

class ServiceNote extends DataClass implements Insertable<ServiceNote> {
  final int id;
  final int assetId;
  final DateTime timestamp;
  final String note;
  const ServiceNote(
      {required this.id,
      required this.assetId,
      required this.timestamp,
      required this.note});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['asset_id'] = Variable<int>(assetId);
    map['timestamp'] = Variable<DateTime>(timestamp);
    map['note'] = Variable<String>(note);
    return map;
  }

  ServiceNotesCompanion toCompanion(bool nullToAbsent) {
    return ServiceNotesCompanion(
      id: Value(id),
      assetId: Value(assetId),
      timestamp: Value(timestamp),
      note: Value(note),
    );
  }

  factory ServiceNote.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ServiceNote(
      id: serializer.fromJson<int>(json['id']),
      assetId: serializer.fromJson<int>(json['assetId']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
      note: serializer.fromJson<String>(json['note']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'assetId': serializer.toJson<int>(assetId),
      'timestamp': serializer.toJson<DateTime>(timestamp),
      'note': serializer.toJson<String>(note),
    };
  }

  ServiceNote copyWith(
          {int? id, int? assetId, DateTime? timestamp, String? note}) =>
      ServiceNote(
        id: id ?? this.id,
        assetId: assetId ?? this.assetId,
        timestamp: timestamp ?? this.timestamp,
        note: note ?? this.note,
      );
  ServiceNote copyWithCompanion(ServiceNotesCompanion data) {
    return ServiceNote(
      id: data.id.present ? data.id.value : this.id,
      assetId: data.assetId.present ? data.assetId.value : this.assetId,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
      note: data.note.present ? data.note.value : this.note,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ServiceNote(')
          ..write('id: $id, ')
          ..write('assetId: $assetId, ')
          ..write('timestamp: $timestamp, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, assetId, timestamp, note);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ServiceNote &&
          other.id == this.id &&
          other.assetId == this.assetId &&
          other.timestamp == this.timestamp &&
          other.note == this.note);
}

class ServiceNotesCompanion extends UpdateCompanion<ServiceNote> {
  final Value<int> id;
  final Value<int> assetId;
  final Value<DateTime> timestamp;
  final Value<String> note;
  const ServiceNotesCompanion({
    this.id = const Value.absent(),
    this.assetId = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.note = const Value.absent(),
  });
  ServiceNotesCompanion.insert({
    this.id = const Value.absent(),
    required int assetId,
    required DateTime timestamp,
    required String note,
  })  : assetId = Value(assetId),
        timestamp = Value(timestamp),
        note = Value(note);
  static Insertable<ServiceNote> custom({
    Expression<int>? id,
    Expression<int>? assetId,
    Expression<DateTime>? timestamp,
    Expression<String>? note,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (assetId != null) 'asset_id': assetId,
      if (timestamp != null) 'timestamp': timestamp,
      if (note != null) 'note': note,
    });
  }

  ServiceNotesCompanion copyWith(
      {Value<int>? id,
      Value<int>? assetId,
      Value<DateTime>? timestamp,
      Value<String>? note}) {
    return ServiceNotesCompanion(
      id: id ?? this.id,
      assetId: assetId ?? this.assetId,
      timestamp: timestamp ?? this.timestamp,
      note: note ?? this.note,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (assetId.present) {
      map['asset_id'] = Variable<int>(assetId.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ServiceNotesCompanion(')
          ..write('id: $id, ')
          ..write('assetId: $assetId, ')
          ..write('timestamp: $timestamp, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }
}

class $CompatibilityReportsTable extends CompatibilityReports
    with TableInfo<$CompatibilityReportsTable, CompatibilityReport> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CompatibilityReportsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _tabletMeta = const VerificationMeta('tablet');
  @override
  late final GeneratedColumn<String> tablet = GeneratedColumn<String>(
      'tablet', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _adapterMeta =
      const VerificationMeta('adapter');
  @override
  late final GeneratedColumn<String> adapter = GeneratedColumn<String>(
      'adapter', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _resultMeta = const VerificationMeta('result');
  @override
  late final GeneratedColumn<String> result = GeneratedColumn<String>(
      'result', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, tablet, adapter, result, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'compatibility_reports';
  @override
  VerificationContext validateIntegrity(
      Insertable<CompatibilityReport> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('tablet')) {
      context.handle(_tabletMeta,
          tablet.isAcceptableOrUnknown(data['tablet']!, _tabletMeta));
    } else if (isInserting) {
      context.missing(_tabletMeta);
    }
    if (data.containsKey('adapter')) {
      context.handle(_adapterMeta,
          adapter.isAcceptableOrUnknown(data['adapter']!, _adapterMeta));
    } else if (isInserting) {
      context.missing(_adapterMeta);
    }
    if (data.containsKey('result')) {
      context.handle(_resultMeta,
          result.isAcceptableOrUnknown(data['result']!, _resultMeta));
    } else if (isInserting) {
      context.missing(_resultMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CompatibilityReport map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CompatibilityReport(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      tablet: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tablet'])!,
      adapter: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}adapter'])!,
      result: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}result'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $CompatibilityReportsTable createAlias(String alias) {
    return $CompatibilityReportsTable(attachedDatabase, alias);
  }
}

class CompatibilityReport extends DataClass
    implements Insertable<CompatibilityReport> {
  final int id;
  final String tablet;
  final String adapter;
  final String result;
  final DateTime createdAt;
  const CompatibilityReport(
      {required this.id,
      required this.tablet,
      required this.adapter,
      required this.result,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['tablet'] = Variable<String>(tablet);
    map['adapter'] = Variable<String>(adapter);
    map['result'] = Variable<String>(result);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  CompatibilityReportsCompanion toCompanion(bool nullToAbsent) {
    return CompatibilityReportsCompanion(
      id: Value(id),
      tablet: Value(tablet),
      adapter: Value(adapter),
      result: Value(result),
      createdAt: Value(createdAt),
    );
  }

  factory CompatibilityReport.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CompatibilityReport(
      id: serializer.fromJson<int>(json['id']),
      tablet: serializer.fromJson<String>(json['tablet']),
      adapter: serializer.fromJson<String>(json['adapter']),
      result: serializer.fromJson<String>(json['result']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'tablet': serializer.toJson<String>(tablet),
      'adapter': serializer.toJson<String>(adapter),
      'result': serializer.toJson<String>(result),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  CompatibilityReport copyWith(
          {int? id,
          String? tablet,
          String? adapter,
          String? result,
          DateTime? createdAt}) =>
      CompatibilityReport(
        id: id ?? this.id,
        tablet: tablet ?? this.tablet,
        adapter: adapter ?? this.adapter,
        result: result ?? this.result,
        createdAt: createdAt ?? this.createdAt,
      );
  CompatibilityReport copyWithCompanion(CompatibilityReportsCompanion data) {
    return CompatibilityReport(
      id: data.id.present ? data.id.value : this.id,
      tablet: data.tablet.present ? data.tablet.value : this.tablet,
      adapter: data.adapter.present ? data.adapter.value : this.adapter,
      result: data.result.present ? data.result.value : this.result,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CompatibilityReport(')
          ..write('id: $id, ')
          ..write('tablet: $tablet, ')
          ..write('adapter: $adapter, ')
          ..write('result: $result, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, tablet, adapter, result, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CompatibilityReport &&
          other.id == this.id &&
          other.tablet == this.tablet &&
          other.adapter == this.adapter &&
          other.result == this.result &&
          other.createdAt == this.createdAt);
}

class CompatibilityReportsCompanion
    extends UpdateCompanion<CompatibilityReport> {
  final Value<int> id;
  final Value<String> tablet;
  final Value<String> adapter;
  final Value<String> result;
  final Value<DateTime> createdAt;
  const CompatibilityReportsCompanion({
    this.id = const Value.absent(),
    this.tablet = const Value.absent(),
    this.adapter = const Value.absent(),
    this.result = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  CompatibilityReportsCompanion.insert({
    this.id = const Value.absent(),
    required String tablet,
    required String adapter,
    required String result,
    this.createdAt = const Value.absent(),
  })  : tablet = Value(tablet),
        adapter = Value(adapter),
        result = Value(result);
  static Insertable<CompatibilityReport> custom({
    Expression<int>? id,
    Expression<String>? tablet,
    Expression<String>? adapter,
    Expression<String>? result,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tablet != null) 'tablet': tablet,
      if (adapter != null) 'adapter': adapter,
      if (result != null) 'result': result,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  CompatibilityReportsCompanion copyWith(
      {Value<int>? id,
      Value<String>? tablet,
      Value<String>? adapter,
      Value<String>? result,
      Value<DateTime>? createdAt}) {
    return CompatibilityReportsCompanion(
      id: id ?? this.id,
      tablet: tablet ?? this.tablet,
      adapter: adapter ?? this.adapter,
      result: result ?? this.result,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (tablet.present) {
      map['tablet'] = Variable<String>(tablet.value);
    }
    if (adapter.present) {
      map['adapter'] = Variable<String>(adapter.value);
    }
    if (result.present) {
      map['result'] = Variable<String>(result.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CompatibilityReportsCompanion(')
          ..write('id: $id, ')
          ..write('tablet: $tablet, ')
          ..write('adapter: $adapter, ')
          ..write('result: $result, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $SitesTable sites = $SitesTable(this);
  late final $AssetsTable assets = $AssetsTable(this);
  late final $ServiceNotesTable serviceNotes = $ServiceNotesTable(this);
  late final $CompatibilityReportsTable compatibilityReports =
      $CompatibilityReportsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [sites, assets, serviceNotes, compatibilityReports];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules(
        [
          WritePropagation(
            on: TableUpdateQuery.onTableName('assets',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('service_notes', kind: UpdateKind.delete),
            ],
          ),
        ],
      );
}

typedef $$SitesTableCreateCompanionBuilder = SitesCompanion Function({
  Value<int> id,
  required String name,
  Value<String> location,
  Value<DateTime> createdAt,
});
typedef $$SitesTableUpdateCompanionBuilder = SitesCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String> location,
  Value<DateTime> createdAt,
});

class $$SitesTableFilterComposer extends Composer<_$AppDatabase, $SitesTable> {
  $$SitesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get location => $composableBuilder(
      column: $table.location, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$SitesTableOrderingComposer
    extends Composer<_$AppDatabase, $SitesTable> {
  $$SitesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get location => $composableBuilder(
      column: $table.location, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$SitesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SitesTable> {
  $$SitesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get location =>
      $composableBuilder(column: $table.location, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$SitesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SitesTable,
    Site,
    $$SitesTableFilterComposer,
    $$SitesTableOrderingComposer,
    $$SitesTableAnnotationComposer,
    $$SitesTableCreateCompanionBuilder,
    $$SitesTableUpdateCompanionBuilder,
    (Site, BaseReferences<_$AppDatabase, $SitesTable, Site>),
    Site,
    PrefetchHooks Function()> {
  $$SitesTableTableManager(_$AppDatabase db, $SitesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SitesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SitesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SitesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> location = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              SitesCompanion(
            id: id,
            name: name,
            location: location,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            Value<String> location = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              SitesCompanion.insert(
            id: id,
            name: name,
            location: location,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$SitesTable, Site>(table),
                    BaseReferences<_$AppDatabase, $SitesTable, Site>(
                        db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SitesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SitesTable,
    Site,
    $$SitesTableFilterComposer,
    $$SitesTableOrderingComposer,
    $$SitesTableAnnotationComposer,
    $$SitesTableCreateCompanionBuilder,
    $$SitesTableUpdateCompanionBuilder,
    (Site, BaseReferences<_$AppDatabase, $SitesTable, Site>),
    Site,
    PrefetchHooks Function()>;
typedef $$AssetsTableCreateCompanionBuilder = AssetsCompanion Function({
  Value<int> id,
  required String name,
  Value<String> location,
  Value<int> intervalDays,
  required DateTime lastService,
  Value<DateTime> createdAt,
});
typedef $$AssetsTableUpdateCompanionBuilder = AssetsCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String> location,
  Value<int> intervalDays,
  Value<DateTime> lastService,
  Value<DateTime> createdAt,
});

final class $$AssetsTableReferences
    extends BaseReferences<_$AppDatabase, $AssetsTable, Asset> {
  $$AssetsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ServiceNotesTable, List<ServiceNote>>
      _serviceNotesRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.serviceNotes,
              aliasName: 'assets__id__service_notes__asset_id');

  $$ServiceNotesTableProcessedTableManager get serviceNotesRefs {
    final manager = $$ServiceNotesTableTableManager($_db, $_db.serviceNotes)
        .filter((f) => f.assetId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_serviceNotesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$AssetsTableFilterComposer
    extends Composer<_$AppDatabase, $AssetsTable> {
  $$AssetsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get location => $composableBuilder(
      column: $table.location, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get intervalDays => $composableBuilder(
      column: $table.intervalDays, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastService => $composableBuilder(
      column: $table.lastService, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  Expression<bool> serviceNotesRefs(
      Expression<bool> Function($$ServiceNotesTableFilterComposer f) f) {
    final $$ServiceNotesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.serviceNotes,
        getReferencedColumn: (t) => t.assetId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ServiceNotesTableFilterComposer(
              $db: $db,
              $table: $db.serviceNotes,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$AssetsTableOrderingComposer
    extends Composer<_$AppDatabase, $AssetsTable> {
  $$AssetsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get location => $composableBuilder(
      column: $table.location, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get intervalDays => $composableBuilder(
      column: $table.intervalDays,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastService => $composableBuilder(
      column: $table.lastService, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$AssetsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AssetsTable> {
  $$AssetsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get location =>
      $composableBuilder(column: $table.location, builder: (column) => column);

  GeneratedColumn<int> get intervalDays => $composableBuilder(
      column: $table.intervalDays, builder: (column) => column);

  GeneratedColumn<DateTime> get lastService => $composableBuilder(
      column: $table.lastService, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> serviceNotesRefs<T extends Object>(
      Expression<T> Function($$ServiceNotesTableAnnotationComposer a) f) {
    final $$ServiceNotesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.serviceNotes,
        getReferencedColumn: (t) => t.assetId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ServiceNotesTableAnnotationComposer(
              $db: $db,
              $table: $db.serviceNotes,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$AssetsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AssetsTable,
    Asset,
    $$AssetsTableFilterComposer,
    $$AssetsTableOrderingComposer,
    $$AssetsTableAnnotationComposer,
    $$AssetsTableCreateCompanionBuilder,
    $$AssetsTableUpdateCompanionBuilder,
    (Asset, $$AssetsTableReferences),
    Asset,
    PrefetchHooks Function({bool serviceNotesRefs})> {
  $$AssetsTableTableManager(_$AppDatabase db, $AssetsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AssetsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AssetsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AssetsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> location = const Value.absent(),
            Value<int> intervalDays = const Value.absent(),
            Value<DateTime> lastService = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              AssetsCompanion(
            id: id,
            name: name,
            location: location,
            intervalDays: intervalDays,
            lastService: lastService,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            Value<String> location = const Value.absent(),
            Value<int> intervalDays = const Value.absent(),
            required DateTime lastService,
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              AssetsCompanion.insert(
            id: id,
            name: name,
            location: location,
            intervalDays: intervalDays,
            lastService: lastService,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$AssetsTable, Asset>(table),
                    $$AssetsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({serviceNotesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (serviceNotesRefs) db.serviceNotes],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (serviceNotesRefs)
                    await $_getPrefetchedDataByColumns<Asset, $AssetsTable,
                            ServiceNote, $ServiceNotesTable>(
                        currentTable: table,
                        referencedTable:
                            $$AssetsTableReferences._serviceNotesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$AssetsTableReferences(db, table, p0)
                                .serviceNotesRefs,
                        currentColumn: 'id',
                        referencedColumn: 'asset_id',
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$AssetsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AssetsTable,
    Asset,
    $$AssetsTableFilterComposer,
    $$AssetsTableOrderingComposer,
    $$AssetsTableAnnotationComposer,
    $$AssetsTableCreateCompanionBuilder,
    $$AssetsTableUpdateCompanionBuilder,
    (Asset, $$AssetsTableReferences),
    Asset,
    PrefetchHooks Function({bool serviceNotesRefs})>;
typedef $$ServiceNotesTableCreateCompanionBuilder = ServiceNotesCompanion
    Function({
  Value<int> id,
  required int assetId,
  required DateTime timestamp,
  required String note,
});
typedef $$ServiceNotesTableUpdateCompanionBuilder = ServiceNotesCompanion
    Function({
  Value<int> id,
  Value<int> assetId,
  Value<DateTime> timestamp,
  Value<String> note,
});

final class $$ServiceNotesTableReferences
    extends BaseReferences<_$AppDatabase, $ServiceNotesTable, ServiceNote> {
  $$ServiceNotesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $AssetsTable _assetIdTable(_$AppDatabase db) =>
      db.assets.createAlias('service_notes__asset_id__assets__id');

  $$AssetsTableProcessedTableManager get assetId {
    final $_column = $_itemColumn<int>('asset_id')!;

    final manager = $$AssetsTableTableManager($_db, $_db.assets)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_assetIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$ServiceNotesTableFilterComposer
    extends Composer<_$AppDatabase, $ServiceNotesTable> {
  $$ServiceNotesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
      column: $table.timestamp, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnFilters(column));

  $$AssetsTableFilterComposer get assetId {
    final $$AssetsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.assetId,
        referencedTable: $db.assets,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AssetsTableFilterComposer(
              $db: $db,
              $table: $db.assets,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ServiceNotesTableOrderingComposer
    extends Composer<_$AppDatabase, $ServiceNotesTable> {
  $$ServiceNotesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
      column: $table.timestamp, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnOrderings(column));

  $$AssetsTableOrderingComposer get assetId {
    final $$AssetsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.assetId,
        referencedTable: $db.assets,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AssetsTableOrderingComposer(
              $db: $db,
              $table: $db.assets,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ServiceNotesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ServiceNotesTable> {
  $$ServiceNotesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  $$AssetsTableAnnotationComposer get assetId {
    final $$AssetsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.assetId,
        referencedTable: $db.assets,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AssetsTableAnnotationComposer(
              $db: $db,
              $table: $db.assets,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ServiceNotesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ServiceNotesTable,
    ServiceNote,
    $$ServiceNotesTableFilterComposer,
    $$ServiceNotesTableOrderingComposer,
    $$ServiceNotesTableAnnotationComposer,
    $$ServiceNotesTableCreateCompanionBuilder,
    $$ServiceNotesTableUpdateCompanionBuilder,
    (ServiceNote, $$ServiceNotesTableReferences),
    ServiceNote,
    PrefetchHooks Function({bool assetId})> {
  $$ServiceNotesTableTableManager(_$AppDatabase db, $ServiceNotesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ServiceNotesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ServiceNotesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ServiceNotesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> assetId = const Value.absent(),
            Value<DateTime> timestamp = const Value.absent(),
            Value<String> note = const Value.absent(),
          }) =>
              ServiceNotesCompanion(
            id: id,
            assetId: assetId,
            timestamp: timestamp,
            note: note,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int assetId,
            required DateTime timestamp,
            required String note,
          }) =>
              ServiceNotesCompanion.insert(
            id: id,
            assetId: assetId,
            timestamp: timestamp,
            note: note,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$ServiceNotesTable, ServiceNote>(table),
                    $$ServiceNotesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({assetId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (assetId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.assetId,
                    referencedTable:
                        $$ServiceNotesTableReferences._assetIdTable(db),
                    referencedColumn:
                        $$ServiceNotesTableReferences._assetIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$ServiceNotesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ServiceNotesTable,
    ServiceNote,
    $$ServiceNotesTableFilterComposer,
    $$ServiceNotesTableOrderingComposer,
    $$ServiceNotesTableAnnotationComposer,
    $$ServiceNotesTableCreateCompanionBuilder,
    $$ServiceNotesTableUpdateCompanionBuilder,
    (ServiceNote, $$ServiceNotesTableReferences),
    ServiceNote,
    PrefetchHooks Function({bool assetId})>;
typedef $$CompatibilityReportsTableCreateCompanionBuilder
    = CompatibilityReportsCompanion Function({
  Value<int> id,
  required String tablet,
  required String adapter,
  required String result,
  Value<DateTime> createdAt,
});
typedef $$CompatibilityReportsTableUpdateCompanionBuilder
    = CompatibilityReportsCompanion Function({
  Value<int> id,
  Value<String> tablet,
  Value<String> adapter,
  Value<String> result,
  Value<DateTime> createdAt,
});

class $$CompatibilityReportsTableFilterComposer
    extends Composer<_$AppDatabase, $CompatibilityReportsTable> {
  $$CompatibilityReportsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get tablet => $composableBuilder(
      column: $table.tablet, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get adapter => $composableBuilder(
      column: $table.adapter, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get result => $composableBuilder(
      column: $table.result, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$CompatibilityReportsTableOrderingComposer
    extends Composer<_$AppDatabase, $CompatibilityReportsTable> {
  $$CompatibilityReportsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get tablet => $composableBuilder(
      column: $table.tablet, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get adapter => $composableBuilder(
      column: $table.adapter, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get result => $composableBuilder(
      column: $table.result, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$CompatibilityReportsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CompatibilityReportsTable> {
  $$CompatibilityReportsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get tablet =>
      $composableBuilder(column: $table.tablet, builder: (column) => column);

  GeneratedColumn<String> get adapter =>
      $composableBuilder(column: $table.adapter, builder: (column) => column);

  GeneratedColumn<String> get result =>
      $composableBuilder(column: $table.result, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$CompatibilityReportsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CompatibilityReportsTable,
    CompatibilityReport,
    $$CompatibilityReportsTableFilterComposer,
    $$CompatibilityReportsTableOrderingComposer,
    $$CompatibilityReportsTableAnnotationComposer,
    $$CompatibilityReportsTableCreateCompanionBuilder,
    $$CompatibilityReportsTableUpdateCompanionBuilder,
    (
      CompatibilityReport,
      BaseReferences<_$AppDatabase, $CompatibilityReportsTable,
          CompatibilityReport>
    ),
    CompatibilityReport,
    PrefetchHooks Function()> {
  $$CompatibilityReportsTableTableManager(
      _$AppDatabase db, $CompatibilityReportsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CompatibilityReportsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CompatibilityReportsTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CompatibilityReportsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> tablet = const Value.absent(),
            Value<String> adapter = const Value.absent(),
            Value<String> result = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              CompatibilityReportsCompanion(
            id: id,
            tablet: tablet,
            adapter: adapter,
            result: result,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String tablet,
            required String adapter,
            required String result,
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              CompatibilityReportsCompanion.insert(
            id: id,
            tablet: tablet,
            adapter: adapter,
            result: result,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$CompatibilityReportsTable,
                        CompatibilityReport>(table),
                    BaseReferences<_$AppDatabase, $CompatibilityReportsTable,
                        CompatibilityReport>(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CompatibilityReportsTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $CompatibilityReportsTable,
        CompatibilityReport,
        $$CompatibilityReportsTableFilterComposer,
        $$CompatibilityReportsTableOrderingComposer,
        $$CompatibilityReportsTableAnnotationComposer,
        $$CompatibilityReportsTableCreateCompanionBuilder,
        $$CompatibilityReportsTableUpdateCompanionBuilder,
        (
          CompatibilityReport,
          BaseReferences<_$AppDatabase, $CompatibilityReportsTable,
              CompatibilityReport>
        ),
        CompatibilityReport,
        PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$SitesTableTableManager get sites =>
      $$SitesTableTableManager(_db, _db.sites);
  $$AssetsTableTableManager get assets =>
      $$AssetsTableTableManager(_db, _db.assets);
  $$ServiceNotesTableTableManager get serviceNotes =>
      $$ServiceNotesTableTableManager(_db, _db.serviceNotes);
  $$CompatibilityReportsTableTableManager get compatibilityReports =>
      $$CompatibilityReportsTableTableManager(_db, _db.compatibilityReports);
}
