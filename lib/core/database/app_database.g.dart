// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $UserProfilesTable extends UserProfiles
    with TableInfo<$UserProfilesTable, UserProfile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dateOfBirthMeta = const VerificationMeta(
    'dateOfBirth',
  );
  @override
  late final GeneratedColumn<DateTime> dateOfBirth = GeneratedColumn<DateTime>(
    'date_of_birth',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _heightCmMeta = const VerificationMeta(
    'heightCm',
  );
  @override
  late final GeneratedColumn<double> heightCm = GeneratedColumn<double>(
    'height_cm',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _weightKgMeta = const VerificationMeta(
    'weightKg',
  );
  @override
  late final GeneratedColumn<double> weightKg = GeneratedColumn<double>(
    'weight_kg',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bloodGroupMeta = const VerificationMeta(
    'bloodGroup',
  );
  @override
  late final GeneratedColumn<String> bloodGroup = GeneratedColumn<String>(
    'blood_group',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _avgCycleLengthMeta = const VerificationMeta(
    'avgCycleLength',
  );
  @override
  late final GeneratedColumn<int> avgCycleLength = GeneratedColumn<int>(
    'avg_cycle_length',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(28),
  );
  static const VerificationMeta _avgPeriodLengthMeta = const VerificationMeta(
    'avgPeriodLength',
  );
  @override
  late final GeneratedColumn<int> avgPeriodLength = GeneratedColumn<int>(
    'avg_period_length',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(5),
  );
  static const VerificationMeta _primaryGoalMeta = const VerificationMeta(
    'primaryGoal',
  );
  @override
  late final GeneratedColumn<String> primaryGoal = GeneratedColumn<String>(
    'primary_goal',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _isSyncedMeta = const VerificationMeta(
    'isSynced',
  );
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
    'is_synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    email,
    dateOfBirth,
    heightCm,
    weightKg,
    bloodGroup,
    avgCycleLength,
    avgPeriodLength,
    primaryGoal,
    createdAt,
    updatedAt,
    isSynced,
    isDeleted,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_profiles';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserProfile> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    }
    if (data.containsKey('date_of_birth')) {
      context.handle(
        _dateOfBirthMeta,
        dateOfBirth.isAcceptableOrUnknown(
          data['date_of_birth']!,
          _dateOfBirthMeta,
        ),
      );
    }
    if (data.containsKey('height_cm')) {
      context.handle(
        _heightCmMeta,
        heightCm.isAcceptableOrUnknown(data['height_cm']!, _heightCmMeta),
      );
    }
    if (data.containsKey('weight_kg')) {
      context.handle(
        _weightKgMeta,
        weightKg.isAcceptableOrUnknown(data['weight_kg']!, _weightKgMeta),
      );
    }
    if (data.containsKey('blood_group')) {
      context.handle(
        _bloodGroupMeta,
        bloodGroup.isAcceptableOrUnknown(data['blood_group']!, _bloodGroupMeta),
      );
    }
    if (data.containsKey('avg_cycle_length')) {
      context.handle(
        _avgCycleLengthMeta,
        avgCycleLength.isAcceptableOrUnknown(
          data['avg_cycle_length']!,
          _avgCycleLengthMeta,
        ),
      );
    }
    if (data.containsKey('avg_period_length')) {
      context.handle(
        _avgPeriodLengthMeta,
        avgPeriodLength.isAcceptableOrUnknown(
          data['avg_period_length']!,
          _avgPeriodLengthMeta,
        ),
      );
    }
    if (data.containsKey('primary_goal')) {
      context.handle(
        _primaryGoalMeta,
        primaryGoal.isAcceptableOrUnknown(
          data['primary_goal']!,
          _primaryGoalMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('is_synced')) {
      context.handle(
        _isSyncedMeta,
        isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta),
      );
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserProfile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserProfile(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      ),
      dateOfBirth: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date_of_birth'],
      ),
      heightCm: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}height_cm'],
      ),
      weightKg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}weight_kg'],
      ),
      bloodGroup: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}blood_group'],
      ),
      avgCycleLength: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}avg_cycle_length'],
      )!,
      avgPeriodLength: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}avg_period_length'],
      )!,
      primaryGoal: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}primary_goal'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      isSynced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_synced'],
      )!,
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
    );
  }

  @override
  $UserProfilesTable createAlias(String alias) {
    return $UserProfilesTable(attachedDatabase, alias);
  }
}

class UserProfile extends DataClass implements Insertable<UserProfile> {
  final String id;
  final String name;
  final String? email;
  final DateTime? dateOfBirth;
  final double? heightCm;
  final double? weightKg;
  final String? bloodGroup;
  final int avgCycleLength;
  final int avgPeriodLength;
  final String? primaryGoal;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isSynced;
  final bool isDeleted;
  const UserProfile({
    required this.id,
    required this.name,
    this.email,
    this.dateOfBirth,
    this.heightCm,
    this.weightKg,
    this.bloodGroup,
    required this.avgCycleLength,
    required this.avgPeriodLength,
    this.primaryGoal,
    required this.createdAt,
    required this.updatedAt,
    required this.isSynced,
    required this.isDeleted,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    if (!nullToAbsent || dateOfBirth != null) {
      map['date_of_birth'] = Variable<DateTime>(dateOfBirth);
    }
    if (!nullToAbsent || heightCm != null) {
      map['height_cm'] = Variable<double>(heightCm);
    }
    if (!nullToAbsent || weightKg != null) {
      map['weight_kg'] = Variable<double>(weightKg);
    }
    if (!nullToAbsent || bloodGroup != null) {
      map['blood_group'] = Variable<String>(bloodGroup);
    }
    map['avg_cycle_length'] = Variable<int>(avgCycleLength);
    map['avg_period_length'] = Variable<int>(avgPeriodLength);
    if (!nullToAbsent || primaryGoal != null) {
      map['primary_goal'] = Variable<String>(primaryGoal);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['is_synced'] = Variable<bool>(isSynced);
    map['is_deleted'] = Variable<bool>(isDeleted);
    return map;
  }

  UserProfilesCompanion toCompanion(bool nullToAbsent) {
    return UserProfilesCompanion(
      id: Value(id),
      name: Value(name),
      email: email == null && nullToAbsent
          ? const Value.absent()
          : Value(email),
      dateOfBirth: dateOfBirth == null && nullToAbsent
          ? const Value.absent()
          : Value(dateOfBirth),
      heightCm: heightCm == null && nullToAbsent
          ? const Value.absent()
          : Value(heightCm),
      weightKg: weightKg == null && nullToAbsent
          ? const Value.absent()
          : Value(weightKg),
      bloodGroup: bloodGroup == null && nullToAbsent
          ? const Value.absent()
          : Value(bloodGroup),
      avgCycleLength: Value(avgCycleLength),
      avgPeriodLength: Value(avgPeriodLength),
      primaryGoal: primaryGoal == null && nullToAbsent
          ? const Value.absent()
          : Value(primaryGoal),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      isSynced: Value(isSynced),
      isDeleted: Value(isDeleted),
    );
  }

  factory UserProfile.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserProfile(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      email: serializer.fromJson<String?>(json['email']),
      dateOfBirth: serializer.fromJson<DateTime?>(json['dateOfBirth']),
      heightCm: serializer.fromJson<double?>(json['heightCm']),
      weightKg: serializer.fromJson<double?>(json['weightKg']),
      bloodGroup: serializer.fromJson<String?>(json['bloodGroup']),
      avgCycleLength: serializer.fromJson<int>(json['avgCycleLength']),
      avgPeriodLength: serializer.fromJson<int>(json['avgPeriodLength']),
      primaryGoal: serializer.fromJson<String?>(json['primaryGoal']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'email': serializer.toJson<String?>(email),
      'dateOfBirth': serializer.toJson<DateTime?>(dateOfBirth),
      'heightCm': serializer.toJson<double?>(heightCm),
      'weightKg': serializer.toJson<double?>(weightKg),
      'bloodGroup': serializer.toJson<String?>(bloodGroup),
      'avgCycleLength': serializer.toJson<int>(avgCycleLength),
      'avgPeriodLength': serializer.toJson<int>(avgPeriodLength),
      'primaryGoal': serializer.toJson<String?>(primaryGoal),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'isSynced': serializer.toJson<bool>(isSynced),
      'isDeleted': serializer.toJson<bool>(isDeleted),
    };
  }

  UserProfile copyWith({
    String? id,
    String? name,
    Value<String?> email = const Value.absent(),
    Value<DateTime?> dateOfBirth = const Value.absent(),
    Value<double?> heightCm = const Value.absent(),
    Value<double?> weightKg = const Value.absent(),
    Value<String?> bloodGroup = const Value.absent(),
    int? avgCycleLength,
    int? avgPeriodLength,
    Value<String?> primaryGoal = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isSynced,
    bool? isDeleted,
  }) => UserProfile(
    id: id ?? this.id,
    name: name ?? this.name,
    email: email.present ? email.value : this.email,
    dateOfBirth: dateOfBirth.present ? dateOfBirth.value : this.dateOfBirth,
    heightCm: heightCm.present ? heightCm.value : this.heightCm,
    weightKg: weightKg.present ? weightKg.value : this.weightKg,
    bloodGroup: bloodGroup.present ? bloodGroup.value : this.bloodGroup,
    avgCycleLength: avgCycleLength ?? this.avgCycleLength,
    avgPeriodLength: avgPeriodLength ?? this.avgPeriodLength,
    primaryGoal: primaryGoal.present ? primaryGoal.value : this.primaryGoal,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    isSynced: isSynced ?? this.isSynced,
    isDeleted: isDeleted ?? this.isDeleted,
  );
  UserProfile copyWithCompanion(UserProfilesCompanion data) {
    return UserProfile(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      email: data.email.present ? data.email.value : this.email,
      dateOfBirth: data.dateOfBirth.present
          ? data.dateOfBirth.value
          : this.dateOfBirth,
      heightCm: data.heightCm.present ? data.heightCm.value : this.heightCm,
      weightKg: data.weightKg.present ? data.weightKg.value : this.weightKg,
      bloodGroup: data.bloodGroup.present
          ? data.bloodGroup.value
          : this.bloodGroup,
      avgCycleLength: data.avgCycleLength.present
          ? data.avgCycleLength.value
          : this.avgCycleLength,
      avgPeriodLength: data.avgPeriodLength.present
          ? data.avgPeriodLength.value
          : this.avgPeriodLength,
      primaryGoal: data.primaryGoal.present
          ? data.primaryGoal.value
          : this.primaryGoal,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserProfile(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('email: $email, ')
          ..write('dateOfBirth: $dateOfBirth, ')
          ..write('heightCm: $heightCm, ')
          ..write('weightKg: $weightKg, ')
          ..write('bloodGroup: $bloodGroup, ')
          ..write('avgCycleLength: $avgCycleLength, ')
          ..write('avgPeriodLength: $avgPeriodLength, ')
          ..write('primaryGoal: $primaryGoal, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isSynced: $isSynced, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    email,
    dateOfBirth,
    heightCm,
    weightKg,
    bloodGroup,
    avgCycleLength,
    avgPeriodLength,
    primaryGoal,
    createdAt,
    updatedAt,
    isSynced,
    isDeleted,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserProfile &&
          other.id == this.id &&
          other.name == this.name &&
          other.email == this.email &&
          other.dateOfBirth == this.dateOfBirth &&
          other.heightCm == this.heightCm &&
          other.weightKg == this.weightKg &&
          other.bloodGroup == this.bloodGroup &&
          other.avgCycleLength == this.avgCycleLength &&
          other.avgPeriodLength == this.avgPeriodLength &&
          other.primaryGoal == this.primaryGoal &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.isSynced == this.isSynced &&
          other.isDeleted == this.isDeleted);
}

class UserProfilesCompanion extends UpdateCompanion<UserProfile> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> email;
  final Value<DateTime?> dateOfBirth;
  final Value<double?> heightCm;
  final Value<double?> weightKg;
  final Value<String?> bloodGroup;
  final Value<int> avgCycleLength;
  final Value<int> avgPeriodLength;
  final Value<String?> primaryGoal;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<bool> isSynced;
  final Value<bool> isDeleted;
  final Value<int> rowid;
  const UserProfilesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.email = const Value.absent(),
    this.dateOfBirth = const Value.absent(),
    this.heightCm = const Value.absent(),
    this.weightKg = const Value.absent(),
    this.bloodGroup = const Value.absent(),
    this.avgCycleLength = const Value.absent(),
    this.avgPeriodLength = const Value.absent(),
    this.primaryGoal = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UserProfilesCompanion.insert({
    required String id,
    required String name,
    this.email = const Value.absent(),
    this.dateOfBirth = const Value.absent(),
    this.heightCm = const Value.absent(),
    this.weightKg = const Value.absent(),
    this.bloodGroup = const Value.absent(),
    this.avgCycleLength = const Value.absent(),
    this.avgPeriodLength = const Value.absent(),
    this.primaryGoal = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name);
  static Insertable<UserProfile> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? email,
    Expression<DateTime>? dateOfBirth,
    Expression<double>? heightCm,
    Expression<double>? weightKg,
    Expression<String>? bloodGroup,
    Expression<int>? avgCycleLength,
    Expression<int>? avgPeriodLength,
    Expression<String>? primaryGoal,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<bool>? isSynced,
    Expression<bool>? isDeleted,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (email != null) 'email': email,
      if (dateOfBirth != null) 'date_of_birth': dateOfBirth,
      if (heightCm != null) 'height_cm': heightCm,
      if (weightKg != null) 'weight_kg': weightKg,
      if (bloodGroup != null) 'blood_group': bloodGroup,
      if (avgCycleLength != null) 'avg_cycle_length': avgCycleLength,
      if (avgPeriodLength != null) 'avg_period_length': avgPeriodLength,
      if (primaryGoal != null) 'primary_goal': primaryGoal,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (isSynced != null) 'is_synced': isSynced,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UserProfilesCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String?>? email,
    Value<DateTime?>? dateOfBirth,
    Value<double?>? heightCm,
    Value<double?>? weightKg,
    Value<String?>? bloodGroup,
    Value<int>? avgCycleLength,
    Value<int>? avgPeriodLength,
    Value<String?>? primaryGoal,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<bool>? isSynced,
    Value<bool>? isDeleted,
    Value<int>? rowid,
  }) {
    return UserProfilesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      heightCm: heightCm ?? this.heightCm,
      weightKg: weightKg ?? this.weightKg,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      avgCycleLength: avgCycleLength ?? this.avgCycleLength,
      avgPeriodLength: avgPeriodLength ?? this.avgPeriodLength,
      primaryGoal: primaryGoal ?? this.primaryGoal,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isSynced: isSynced ?? this.isSynced,
      isDeleted: isDeleted ?? this.isDeleted,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (dateOfBirth.present) {
      map['date_of_birth'] = Variable<DateTime>(dateOfBirth.value);
    }
    if (heightCm.present) {
      map['height_cm'] = Variable<double>(heightCm.value);
    }
    if (weightKg.present) {
      map['weight_kg'] = Variable<double>(weightKg.value);
    }
    if (bloodGroup.present) {
      map['blood_group'] = Variable<String>(bloodGroup.value);
    }
    if (avgCycleLength.present) {
      map['avg_cycle_length'] = Variable<int>(avgCycleLength.value);
    }
    if (avgPeriodLength.present) {
      map['avg_period_length'] = Variable<int>(avgPeriodLength.value);
    }
    if (primaryGoal.present) {
      map['primary_goal'] = Variable<String>(primaryGoal.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserProfilesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('email: $email, ')
          ..write('dateOfBirth: $dateOfBirth, ')
          ..write('heightCm: $heightCm, ')
          ..write('weightKg: $weightKg, ')
          ..write('bloodGroup: $bloodGroup, ')
          ..write('avgCycleLength: $avgCycleLength, ')
          ..write('avgPeriodLength: $avgPeriodLength, ')
          ..write('primaryGoal: $primaryGoal, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isSynced: $isSynced, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CyclesTable extends Cycles with TableInfo<$CyclesTable, Cycle> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CyclesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startDateMeta = const VerificationMeta(
    'startDate',
  );
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
    'start_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endDateMeta = const VerificationMeta(
    'endDate',
  );
  @override
  late final GeneratedColumn<DateTime> endDate = GeneratedColumn<DateTime>(
    'end_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cycleLengthMeta = const VerificationMeta(
    'cycleLength',
  );
  @override
  late final GeneratedColumn<int> cycleLength = GeneratedColumn<int>(
    'cycle_length',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _periodLengthMeta = const VerificationMeta(
    'periodLength',
  );
  @override
  late final GeneratedColumn<int> periodLength = GeneratedColumn<int>(
    'period_length',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isPredictedMeta = const VerificationMeta(
    'isPredicted',
  );
  @override
  late final GeneratedColumn<bool> isPredicted = GeneratedColumn<bool>(
    'is_predicted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_predicted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _isSyncedMeta = const VerificationMeta(
    'isSynced',
  );
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
    'is_synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    startDate,
    endDate,
    cycleLength,
    periodLength,
    isPredicted,
    createdAt,
    updatedAt,
    isSynced,
    isDeleted,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cycles';
  @override
  VerificationContext validateIntegrity(
    Insertable<Cycle> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('start_date')) {
      context.handle(
        _startDateMeta,
        startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta),
      );
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('end_date')) {
      context.handle(
        _endDateMeta,
        endDate.isAcceptableOrUnknown(data['end_date']!, _endDateMeta),
      );
    }
    if (data.containsKey('cycle_length')) {
      context.handle(
        _cycleLengthMeta,
        cycleLength.isAcceptableOrUnknown(
          data['cycle_length']!,
          _cycleLengthMeta,
        ),
      );
    }
    if (data.containsKey('period_length')) {
      context.handle(
        _periodLengthMeta,
        periodLength.isAcceptableOrUnknown(
          data['period_length']!,
          _periodLengthMeta,
        ),
      );
    }
    if (data.containsKey('is_predicted')) {
      context.handle(
        _isPredictedMeta,
        isPredicted.isAcceptableOrUnknown(
          data['is_predicted']!,
          _isPredictedMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('is_synced')) {
      context.handle(
        _isSyncedMeta,
        isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta),
      );
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Cycle map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Cycle(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      startDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_date'],
      )!,
      endDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}end_date'],
      ),
      cycleLength: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cycle_length'],
      ),
      periodLength: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}period_length'],
      ),
      isPredicted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_predicted'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      isSynced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_synced'],
      )!,
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
    );
  }

  @override
  $CyclesTable createAlias(String alias) {
    return $CyclesTable(attachedDatabase, alias);
  }
}

class Cycle extends DataClass implements Insertable<Cycle> {
  final String id;
  final String userId;
  final DateTime startDate;
  final DateTime? endDate;
  final int? cycleLength;
  final int? periodLength;
  final bool isPredicted;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isSynced;
  final bool isDeleted;
  const Cycle({
    required this.id,
    required this.userId,
    required this.startDate,
    this.endDate,
    this.cycleLength,
    this.periodLength,
    required this.isPredicted,
    required this.createdAt,
    required this.updatedAt,
    required this.isSynced,
    required this.isDeleted,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['start_date'] = Variable<DateTime>(startDate);
    if (!nullToAbsent || endDate != null) {
      map['end_date'] = Variable<DateTime>(endDate);
    }
    if (!nullToAbsent || cycleLength != null) {
      map['cycle_length'] = Variable<int>(cycleLength);
    }
    if (!nullToAbsent || periodLength != null) {
      map['period_length'] = Variable<int>(periodLength);
    }
    map['is_predicted'] = Variable<bool>(isPredicted);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['is_synced'] = Variable<bool>(isSynced);
    map['is_deleted'] = Variable<bool>(isDeleted);
    return map;
  }

  CyclesCompanion toCompanion(bool nullToAbsent) {
    return CyclesCompanion(
      id: Value(id),
      userId: Value(userId),
      startDate: Value(startDate),
      endDate: endDate == null && nullToAbsent
          ? const Value.absent()
          : Value(endDate),
      cycleLength: cycleLength == null && nullToAbsent
          ? const Value.absent()
          : Value(cycleLength),
      periodLength: periodLength == null && nullToAbsent
          ? const Value.absent()
          : Value(periodLength),
      isPredicted: Value(isPredicted),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      isSynced: Value(isSynced),
      isDeleted: Value(isDeleted),
    );
  }

  factory Cycle.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Cycle(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      startDate: serializer.fromJson<DateTime>(json['startDate']),
      endDate: serializer.fromJson<DateTime?>(json['endDate']),
      cycleLength: serializer.fromJson<int?>(json['cycleLength']),
      periodLength: serializer.fromJson<int?>(json['periodLength']),
      isPredicted: serializer.fromJson<bool>(json['isPredicted']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'startDate': serializer.toJson<DateTime>(startDate),
      'endDate': serializer.toJson<DateTime?>(endDate),
      'cycleLength': serializer.toJson<int?>(cycleLength),
      'periodLength': serializer.toJson<int?>(periodLength),
      'isPredicted': serializer.toJson<bool>(isPredicted),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'isSynced': serializer.toJson<bool>(isSynced),
      'isDeleted': serializer.toJson<bool>(isDeleted),
    };
  }

  Cycle copyWith({
    String? id,
    String? userId,
    DateTime? startDate,
    Value<DateTime?> endDate = const Value.absent(),
    Value<int?> cycleLength = const Value.absent(),
    Value<int?> periodLength = const Value.absent(),
    bool? isPredicted,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isSynced,
    bool? isDeleted,
  }) => Cycle(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    startDate: startDate ?? this.startDate,
    endDate: endDate.present ? endDate.value : this.endDate,
    cycleLength: cycleLength.present ? cycleLength.value : this.cycleLength,
    periodLength: periodLength.present ? periodLength.value : this.periodLength,
    isPredicted: isPredicted ?? this.isPredicted,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    isSynced: isSynced ?? this.isSynced,
    isDeleted: isDeleted ?? this.isDeleted,
  );
  Cycle copyWithCompanion(CyclesCompanion data) {
    return Cycle(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
      cycleLength: data.cycleLength.present
          ? data.cycleLength.value
          : this.cycleLength,
      periodLength: data.periodLength.present
          ? data.periodLength.value
          : this.periodLength,
      isPredicted: data.isPredicted.present
          ? data.isPredicted.value
          : this.isPredicted,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Cycle(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('cycleLength: $cycleLength, ')
          ..write('periodLength: $periodLength, ')
          ..write('isPredicted: $isPredicted, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isSynced: $isSynced, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    startDate,
    endDate,
    cycleLength,
    periodLength,
    isPredicted,
    createdAt,
    updatedAt,
    isSynced,
    isDeleted,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Cycle &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate &&
          other.cycleLength == this.cycleLength &&
          other.periodLength == this.periodLength &&
          other.isPredicted == this.isPredicted &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.isSynced == this.isSynced &&
          other.isDeleted == this.isDeleted);
}

class CyclesCompanion extends UpdateCompanion<Cycle> {
  final Value<String> id;
  final Value<String> userId;
  final Value<DateTime> startDate;
  final Value<DateTime?> endDate;
  final Value<int?> cycleLength;
  final Value<int?> periodLength;
  final Value<bool> isPredicted;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<bool> isSynced;
  final Value<bool> isDeleted;
  final Value<int> rowid;
  const CyclesCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.cycleLength = const Value.absent(),
    this.periodLength = const Value.absent(),
    this.isPredicted = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CyclesCompanion.insert({
    required String id,
    required String userId,
    required DateTime startDate,
    this.endDate = const Value.absent(),
    this.cycleLength = const Value.absent(),
    this.periodLength = const Value.absent(),
    this.isPredicted = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       userId = Value(userId),
       startDate = Value(startDate);
  static Insertable<Cycle> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<DateTime>? startDate,
    Expression<DateTime>? endDate,
    Expression<int>? cycleLength,
    Expression<int>? periodLength,
    Expression<bool>? isPredicted,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<bool>? isSynced,
    Expression<bool>? isDeleted,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (cycleLength != null) 'cycle_length': cycleLength,
      if (periodLength != null) 'period_length': periodLength,
      if (isPredicted != null) 'is_predicted': isPredicted,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (isSynced != null) 'is_synced': isSynced,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CyclesCompanion copyWith({
    Value<String>? id,
    Value<String>? userId,
    Value<DateTime>? startDate,
    Value<DateTime?>? endDate,
    Value<int?>? cycleLength,
    Value<int?>? periodLength,
    Value<bool>? isPredicted,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<bool>? isSynced,
    Value<bool>? isDeleted,
    Value<int>? rowid,
  }) {
    return CyclesCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      cycleLength: cycleLength ?? this.cycleLength,
      periodLength: periodLength ?? this.periodLength,
      isPredicted: isPredicted ?? this.isPredicted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isSynced: isSynced ?? this.isSynced,
      isDeleted: isDeleted ?? this.isDeleted,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<DateTime>(endDate.value);
    }
    if (cycleLength.present) {
      map['cycle_length'] = Variable<int>(cycleLength.value);
    }
    if (periodLength.present) {
      map['period_length'] = Variable<int>(periodLength.value);
    }
    if (isPredicted.present) {
      map['is_predicted'] = Variable<bool>(isPredicted.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CyclesCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('cycleLength: $cycleLength, ')
          ..write('periodLength: $periodLength, ')
          ..write('isPredicted: $isPredicted, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isSynced: $isSynced, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DailyLogsTable extends DailyLogs
    with TableInfo<$DailyLogsTable, DailyLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DailyLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cycleIdMeta = const VerificationMeta(
    'cycleId',
  );
  @override
  late final GeneratedColumn<String> cycleId = GeneratedColumn<String>(
    'cycle_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _flowIntensityMeta = const VerificationMeta(
    'flowIntensity',
  );
  @override
  late final GeneratedColumn<String> flowIntensity = GeneratedColumn<String>(
    'flow_intensity',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _painLevelMeta = const VerificationMeta(
    'painLevel',
  );
  @override
  late final GeneratedColumn<int> painLevel = GeneratedColumn<int>(
    'pain_level',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _moodMeta = const VerificationMeta('mood');
  @override
  late final GeneratedColumn<String> mood = GeneratedColumn<String>(
    'mood',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sleepHoursMeta = const VerificationMeta(
    'sleepHours',
  );
  @override
  late final GeneratedColumn<double> sleepHours = GeneratedColumn<double>(
    'sleep_hours',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _waterIntakeMeta = const VerificationMeta(
    'waterIntake',
  );
  @override
  late final GeneratedColumn<String> waterIntake = GeneratedColumn<String>(
    'water_intake',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _stressLevelMeta = const VerificationMeta(
    'stressLevel',
  );
  @override
  late final GeneratedColumn<int> stressLevel = GeneratedColumn<int>(
    'stress_level',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _activityLevelMeta = const VerificationMeta(
    'activityLevel',
  );
  @override
  late final GeneratedColumn<String> activityLevel = GeneratedColumn<String>(
    'activity_level',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _remediesMeta = const VerificationMeta(
    'remedies',
  );
  @override
  late final GeneratedColumn<String> remedies = GeneratedColumn<String>(
    'remedies',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _painAfter1HrMeta = const VerificationMeta(
    'painAfter1Hr',
  );
  @override
  late final GeneratedColumn<int> painAfter1Hr = GeneratedColumn<int>(
    'pain_after1_hr',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _isSyncedMeta = const VerificationMeta(
    'isSynced',
  );
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
    'is_synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    cycleId,
    date,
    flowIntensity,
    painLevel,
    mood,
    sleepHours,
    waterIntake,
    stressLevel,
    activityLevel,
    remedies,
    painAfter1Hr,
    notes,
    createdAt,
    updatedAt,
    isSynced,
    isDeleted,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'daily_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<DailyLog> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('cycle_id')) {
      context.handle(
        _cycleIdMeta,
        cycleId.isAcceptableOrUnknown(data['cycle_id']!, _cycleIdMeta),
      );
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('flow_intensity')) {
      context.handle(
        _flowIntensityMeta,
        flowIntensity.isAcceptableOrUnknown(
          data['flow_intensity']!,
          _flowIntensityMeta,
        ),
      );
    }
    if (data.containsKey('pain_level')) {
      context.handle(
        _painLevelMeta,
        painLevel.isAcceptableOrUnknown(data['pain_level']!, _painLevelMeta),
      );
    }
    if (data.containsKey('mood')) {
      context.handle(
        _moodMeta,
        mood.isAcceptableOrUnknown(data['mood']!, _moodMeta),
      );
    }
    if (data.containsKey('sleep_hours')) {
      context.handle(
        _sleepHoursMeta,
        sleepHours.isAcceptableOrUnknown(data['sleep_hours']!, _sleepHoursMeta),
      );
    }
    if (data.containsKey('water_intake')) {
      context.handle(
        _waterIntakeMeta,
        waterIntake.isAcceptableOrUnknown(
          data['water_intake']!,
          _waterIntakeMeta,
        ),
      );
    }
    if (data.containsKey('stress_level')) {
      context.handle(
        _stressLevelMeta,
        stressLevel.isAcceptableOrUnknown(
          data['stress_level']!,
          _stressLevelMeta,
        ),
      );
    }
    if (data.containsKey('activity_level')) {
      context.handle(
        _activityLevelMeta,
        activityLevel.isAcceptableOrUnknown(
          data['activity_level']!,
          _activityLevelMeta,
        ),
      );
    }
    if (data.containsKey('remedies')) {
      context.handle(
        _remediesMeta,
        remedies.isAcceptableOrUnknown(data['remedies']!, _remediesMeta),
      );
    }
    if (data.containsKey('pain_after1_hr')) {
      context.handle(
        _painAfter1HrMeta,
        painAfter1Hr.isAcceptableOrUnknown(
          data['pain_after1_hr']!,
          _painAfter1HrMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('is_synced')) {
      context.handle(
        _isSyncedMeta,
        isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta),
      );
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DailyLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DailyLog(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      cycleId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cycle_id'],
      ),
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      flowIntensity: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}flow_intensity'],
      ),
      painLevel: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}pain_level'],
      ),
      mood: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mood'],
      ),
      sleepHours: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}sleep_hours'],
      ),
      waterIntake: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}water_intake'],
      ),
      stressLevel: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}stress_level'],
      ),
      activityLevel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}activity_level'],
      ),
      remedies: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}remedies'],
      ),
      painAfter1Hr: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}pain_after1_hr'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      isSynced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_synced'],
      )!,
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
    );
  }

  @override
  $DailyLogsTable createAlias(String alias) {
    return $DailyLogsTable(attachedDatabase, alias);
  }
}

class DailyLog extends DataClass implements Insertable<DailyLog> {
  final String id;
  final String userId;
  final String? cycleId;
  final DateTime date;
  final String? flowIntensity;
  final int? painLevel;
  final String? mood;
  final double? sleepHours;
  final String? waterIntake;
  final int? stressLevel;
  final String? activityLevel;
  final String? remedies;
  final int? painAfter1Hr;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isSynced;
  final bool isDeleted;
  const DailyLog({
    required this.id,
    required this.userId,
    this.cycleId,
    required this.date,
    this.flowIntensity,
    this.painLevel,
    this.mood,
    this.sleepHours,
    this.waterIntake,
    this.stressLevel,
    this.activityLevel,
    this.remedies,
    this.painAfter1Hr,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
    required this.isSynced,
    required this.isDeleted,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    if (!nullToAbsent || cycleId != null) {
      map['cycle_id'] = Variable<String>(cycleId);
    }
    map['date'] = Variable<DateTime>(date);
    if (!nullToAbsent || flowIntensity != null) {
      map['flow_intensity'] = Variable<String>(flowIntensity);
    }
    if (!nullToAbsent || painLevel != null) {
      map['pain_level'] = Variable<int>(painLevel);
    }
    if (!nullToAbsent || mood != null) {
      map['mood'] = Variable<String>(mood);
    }
    if (!nullToAbsent || sleepHours != null) {
      map['sleep_hours'] = Variable<double>(sleepHours);
    }
    if (!nullToAbsent || waterIntake != null) {
      map['water_intake'] = Variable<String>(waterIntake);
    }
    if (!nullToAbsent || stressLevel != null) {
      map['stress_level'] = Variable<int>(stressLevel);
    }
    if (!nullToAbsent || activityLevel != null) {
      map['activity_level'] = Variable<String>(activityLevel);
    }
    if (!nullToAbsent || remedies != null) {
      map['remedies'] = Variable<String>(remedies);
    }
    if (!nullToAbsent || painAfter1Hr != null) {
      map['pain_after1_hr'] = Variable<int>(painAfter1Hr);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['is_synced'] = Variable<bool>(isSynced);
    map['is_deleted'] = Variable<bool>(isDeleted);
    return map;
  }

  DailyLogsCompanion toCompanion(bool nullToAbsent) {
    return DailyLogsCompanion(
      id: Value(id),
      userId: Value(userId),
      cycleId: cycleId == null && nullToAbsent
          ? const Value.absent()
          : Value(cycleId),
      date: Value(date),
      flowIntensity: flowIntensity == null && nullToAbsent
          ? const Value.absent()
          : Value(flowIntensity),
      painLevel: painLevel == null && nullToAbsent
          ? const Value.absent()
          : Value(painLevel),
      mood: mood == null && nullToAbsent ? const Value.absent() : Value(mood),
      sleepHours: sleepHours == null && nullToAbsent
          ? const Value.absent()
          : Value(sleepHours),
      waterIntake: waterIntake == null && nullToAbsent
          ? const Value.absent()
          : Value(waterIntake),
      stressLevel: stressLevel == null && nullToAbsent
          ? const Value.absent()
          : Value(stressLevel),
      activityLevel: activityLevel == null && nullToAbsent
          ? const Value.absent()
          : Value(activityLevel),
      remedies: remedies == null && nullToAbsent
          ? const Value.absent()
          : Value(remedies),
      painAfter1Hr: painAfter1Hr == null && nullToAbsent
          ? const Value.absent()
          : Value(painAfter1Hr),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      isSynced: Value(isSynced),
      isDeleted: Value(isDeleted),
    );
  }

  factory DailyLog.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DailyLog(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      cycleId: serializer.fromJson<String?>(json['cycleId']),
      date: serializer.fromJson<DateTime>(json['date']),
      flowIntensity: serializer.fromJson<String?>(json['flowIntensity']),
      painLevel: serializer.fromJson<int?>(json['painLevel']),
      mood: serializer.fromJson<String?>(json['mood']),
      sleepHours: serializer.fromJson<double?>(json['sleepHours']),
      waterIntake: serializer.fromJson<String?>(json['waterIntake']),
      stressLevel: serializer.fromJson<int?>(json['stressLevel']),
      activityLevel: serializer.fromJson<String?>(json['activityLevel']),
      remedies: serializer.fromJson<String?>(json['remedies']),
      painAfter1Hr: serializer.fromJson<int?>(json['painAfter1Hr']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'cycleId': serializer.toJson<String?>(cycleId),
      'date': serializer.toJson<DateTime>(date),
      'flowIntensity': serializer.toJson<String?>(flowIntensity),
      'painLevel': serializer.toJson<int?>(painLevel),
      'mood': serializer.toJson<String?>(mood),
      'sleepHours': serializer.toJson<double?>(sleepHours),
      'waterIntake': serializer.toJson<String?>(waterIntake),
      'stressLevel': serializer.toJson<int?>(stressLevel),
      'activityLevel': serializer.toJson<String?>(activityLevel),
      'remedies': serializer.toJson<String?>(remedies),
      'painAfter1Hr': serializer.toJson<int?>(painAfter1Hr),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'isSynced': serializer.toJson<bool>(isSynced),
      'isDeleted': serializer.toJson<bool>(isDeleted),
    };
  }

  DailyLog copyWith({
    String? id,
    String? userId,
    Value<String?> cycleId = const Value.absent(),
    DateTime? date,
    Value<String?> flowIntensity = const Value.absent(),
    Value<int?> painLevel = const Value.absent(),
    Value<String?> mood = const Value.absent(),
    Value<double?> sleepHours = const Value.absent(),
    Value<String?> waterIntake = const Value.absent(),
    Value<int?> stressLevel = const Value.absent(),
    Value<String?> activityLevel = const Value.absent(),
    Value<String?> remedies = const Value.absent(),
    Value<int?> painAfter1Hr = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isSynced,
    bool? isDeleted,
  }) => DailyLog(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    cycleId: cycleId.present ? cycleId.value : this.cycleId,
    date: date ?? this.date,
    flowIntensity: flowIntensity.present
        ? flowIntensity.value
        : this.flowIntensity,
    painLevel: painLevel.present ? painLevel.value : this.painLevel,
    mood: mood.present ? mood.value : this.mood,
    sleepHours: sleepHours.present ? sleepHours.value : this.sleepHours,
    waterIntake: waterIntake.present ? waterIntake.value : this.waterIntake,
    stressLevel: stressLevel.present ? stressLevel.value : this.stressLevel,
    activityLevel: activityLevel.present
        ? activityLevel.value
        : this.activityLevel,
    remedies: remedies.present ? remedies.value : this.remedies,
    painAfter1Hr: painAfter1Hr.present ? painAfter1Hr.value : this.painAfter1Hr,
    notes: notes.present ? notes.value : this.notes,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    isSynced: isSynced ?? this.isSynced,
    isDeleted: isDeleted ?? this.isDeleted,
  );
  DailyLog copyWithCompanion(DailyLogsCompanion data) {
    return DailyLog(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      cycleId: data.cycleId.present ? data.cycleId.value : this.cycleId,
      date: data.date.present ? data.date.value : this.date,
      flowIntensity: data.flowIntensity.present
          ? data.flowIntensity.value
          : this.flowIntensity,
      painLevel: data.painLevel.present ? data.painLevel.value : this.painLevel,
      mood: data.mood.present ? data.mood.value : this.mood,
      sleepHours: data.sleepHours.present
          ? data.sleepHours.value
          : this.sleepHours,
      waterIntake: data.waterIntake.present
          ? data.waterIntake.value
          : this.waterIntake,
      stressLevel: data.stressLevel.present
          ? data.stressLevel.value
          : this.stressLevel,
      activityLevel: data.activityLevel.present
          ? data.activityLevel.value
          : this.activityLevel,
      remedies: data.remedies.present ? data.remedies.value : this.remedies,
      painAfter1Hr: data.painAfter1Hr.present
          ? data.painAfter1Hr.value
          : this.painAfter1Hr,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DailyLog(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('cycleId: $cycleId, ')
          ..write('date: $date, ')
          ..write('flowIntensity: $flowIntensity, ')
          ..write('painLevel: $painLevel, ')
          ..write('mood: $mood, ')
          ..write('sleepHours: $sleepHours, ')
          ..write('waterIntake: $waterIntake, ')
          ..write('stressLevel: $stressLevel, ')
          ..write('activityLevel: $activityLevel, ')
          ..write('remedies: $remedies, ')
          ..write('painAfter1Hr: $painAfter1Hr, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isSynced: $isSynced, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    cycleId,
    date,
    flowIntensity,
    painLevel,
    mood,
    sleepHours,
    waterIntake,
    stressLevel,
    activityLevel,
    remedies,
    painAfter1Hr,
    notes,
    createdAt,
    updatedAt,
    isSynced,
    isDeleted,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DailyLog &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.cycleId == this.cycleId &&
          other.date == this.date &&
          other.flowIntensity == this.flowIntensity &&
          other.painLevel == this.painLevel &&
          other.mood == this.mood &&
          other.sleepHours == this.sleepHours &&
          other.waterIntake == this.waterIntake &&
          other.stressLevel == this.stressLevel &&
          other.activityLevel == this.activityLevel &&
          other.remedies == this.remedies &&
          other.painAfter1Hr == this.painAfter1Hr &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.isSynced == this.isSynced &&
          other.isDeleted == this.isDeleted);
}

class DailyLogsCompanion extends UpdateCompanion<DailyLog> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String?> cycleId;
  final Value<DateTime> date;
  final Value<String?> flowIntensity;
  final Value<int?> painLevel;
  final Value<String?> mood;
  final Value<double?> sleepHours;
  final Value<String?> waterIntake;
  final Value<int?> stressLevel;
  final Value<String?> activityLevel;
  final Value<String?> remedies;
  final Value<int?> painAfter1Hr;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<bool> isSynced;
  final Value<bool> isDeleted;
  final Value<int> rowid;
  const DailyLogsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.cycleId = const Value.absent(),
    this.date = const Value.absent(),
    this.flowIntensity = const Value.absent(),
    this.painLevel = const Value.absent(),
    this.mood = const Value.absent(),
    this.sleepHours = const Value.absent(),
    this.waterIntake = const Value.absent(),
    this.stressLevel = const Value.absent(),
    this.activityLevel = const Value.absent(),
    this.remedies = const Value.absent(),
    this.painAfter1Hr = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DailyLogsCompanion.insert({
    required String id,
    required String userId,
    this.cycleId = const Value.absent(),
    required DateTime date,
    this.flowIntensity = const Value.absent(),
    this.painLevel = const Value.absent(),
    this.mood = const Value.absent(),
    this.sleepHours = const Value.absent(),
    this.waterIntake = const Value.absent(),
    this.stressLevel = const Value.absent(),
    this.activityLevel = const Value.absent(),
    this.remedies = const Value.absent(),
    this.painAfter1Hr = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       userId = Value(userId),
       date = Value(date);
  static Insertable<DailyLog> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? cycleId,
    Expression<DateTime>? date,
    Expression<String>? flowIntensity,
    Expression<int>? painLevel,
    Expression<String>? mood,
    Expression<double>? sleepHours,
    Expression<String>? waterIntake,
    Expression<int>? stressLevel,
    Expression<String>? activityLevel,
    Expression<String>? remedies,
    Expression<int>? painAfter1Hr,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<bool>? isSynced,
    Expression<bool>? isDeleted,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (cycleId != null) 'cycle_id': cycleId,
      if (date != null) 'date': date,
      if (flowIntensity != null) 'flow_intensity': flowIntensity,
      if (painLevel != null) 'pain_level': painLevel,
      if (mood != null) 'mood': mood,
      if (sleepHours != null) 'sleep_hours': sleepHours,
      if (waterIntake != null) 'water_intake': waterIntake,
      if (stressLevel != null) 'stress_level': stressLevel,
      if (activityLevel != null) 'activity_level': activityLevel,
      if (remedies != null) 'remedies': remedies,
      if (painAfter1Hr != null) 'pain_after1_hr': painAfter1Hr,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (isSynced != null) 'is_synced': isSynced,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DailyLogsCompanion copyWith({
    Value<String>? id,
    Value<String>? userId,
    Value<String?>? cycleId,
    Value<DateTime>? date,
    Value<String?>? flowIntensity,
    Value<int?>? painLevel,
    Value<String?>? mood,
    Value<double?>? sleepHours,
    Value<String?>? waterIntake,
    Value<int?>? stressLevel,
    Value<String?>? activityLevel,
    Value<String?>? remedies,
    Value<int?>? painAfter1Hr,
    Value<String?>? notes,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<bool>? isSynced,
    Value<bool>? isDeleted,
    Value<int>? rowid,
  }) {
    return DailyLogsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      cycleId: cycleId ?? this.cycleId,
      date: date ?? this.date,
      flowIntensity: flowIntensity ?? this.flowIntensity,
      painLevel: painLevel ?? this.painLevel,
      mood: mood ?? this.mood,
      sleepHours: sleepHours ?? this.sleepHours,
      waterIntake: waterIntake ?? this.waterIntake,
      stressLevel: stressLevel ?? this.stressLevel,
      activityLevel: activityLevel ?? this.activityLevel,
      remedies: remedies ?? this.remedies,
      painAfter1Hr: painAfter1Hr ?? this.painAfter1Hr,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isSynced: isSynced ?? this.isSynced,
      isDeleted: isDeleted ?? this.isDeleted,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (cycleId.present) {
      map['cycle_id'] = Variable<String>(cycleId.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (flowIntensity.present) {
      map['flow_intensity'] = Variable<String>(flowIntensity.value);
    }
    if (painLevel.present) {
      map['pain_level'] = Variable<int>(painLevel.value);
    }
    if (mood.present) {
      map['mood'] = Variable<String>(mood.value);
    }
    if (sleepHours.present) {
      map['sleep_hours'] = Variable<double>(sleepHours.value);
    }
    if (waterIntake.present) {
      map['water_intake'] = Variable<String>(waterIntake.value);
    }
    if (stressLevel.present) {
      map['stress_level'] = Variable<int>(stressLevel.value);
    }
    if (activityLevel.present) {
      map['activity_level'] = Variable<String>(activityLevel.value);
    }
    if (remedies.present) {
      map['remedies'] = Variable<String>(remedies.value);
    }
    if (painAfter1Hr.present) {
      map['pain_after1_hr'] = Variable<int>(painAfter1Hr.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DailyLogsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('cycleId: $cycleId, ')
          ..write('date: $date, ')
          ..write('flowIntensity: $flowIntensity, ')
          ..write('painLevel: $painLevel, ')
          ..write('mood: $mood, ')
          ..write('sleepHours: $sleepHours, ')
          ..write('waterIntake: $waterIntake, ')
          ..write('stressLevel: $stressLevel, ')
          ..write('activityLevel: $activityLevel, ')
          ..write('remedies: $remedies, ')
          ..write('painAfter1Hr: $painAfter1Hr, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isSynced: $isSynced, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DailySymptomsTable extends DailySymptoms
    with TableInfo<$DailySymptomsTable, DailySymptom> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DailySymptomsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dailyLogIdMeta = const VerificationMeta(
    'dailyLogId',
  );
  @override
  late final GeneratedColumn<String> dailyLogId = GeneratedColumn<String>(
    'daily_log_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _symptomNameMeta = const VerificationMeta(
    'symptomName',
  );
  @override
  late final GeneratedColumn<String> symptomName = GeneratedColumn<String>(
    'symptom_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _severityMeta = const VerificationMeta(
    'severity',
  );
  @override
  late final GeneratedColumn<int> severity = GeneratedColumn<int>(
    'severity',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _isSyncedMeta = const VerificationMeta(
    'isSynced',
  );
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
    'is_synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    dailyLogId,
    symptomName,
    severity,
    createdAt,
    isSynced,
    isDeleted,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'daily_symptoms';
  @override
  VerificationContext validateIntegrity(
    Insertable<DailySymptom> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('daily_log_id')) {
      context.handle(
        _dailyLogIdMeta,
        dailyLogId.isAcceptableOrUnknown(
          data['daily_log_id']!,
          _dailyLogIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_dailyLogIdMeta);
    }
    if (data.containsKey('symptom_name')) {
      context.handle(
        _symptomNameMeta,
        symptomName.isAcceptableOrUnknown(
          data['symptom_name']!,
          _symptomNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_symptomNameMeta);
    }
    if (data.containsKey('severity')) {
      context.handle(
        _severityMeta,
        severity.isAcceptableOrUnknown(data['severity']!, _severityMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('is_synced')) {
      context.handle(
        _isSyncedMeta,
        isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta),
      );
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DailySymptom map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DailySymptom(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      dailyLogId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}daily_log_id'],
      )!,
      symptomName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}symptom_name'],
      )!,
      severity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}severity'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      isSynced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_synced'],
      )!,
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
    );
  }

  @override
  $DailySymptomsTable createAlias(String alias) {
    return $DailySymptomsTable(attachedDatabase, alias);
  }
}

class DailySymptom extends DataClass implements Insertable<DailySymptom> {
  final String id;
  final String dailyLogId;
  final String symptomName;
  final int? severity;
  final DateTime createdAt;
  final bool isSynced;
  final bool isDeleted;
  const DailySymptom({
    required this.id,
    required this.dailyLogId,
    required this.symptomName,
    this.severity,
    required this.createdAt,
    required this.isSynced,
    required this.isDeleted,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['daily_log_id'] = Variable<String>(dailyLogId);
    map['symptom_name'] = Variable<String>(symptomName);
    if (!nullToAbsent || severity != null) {
      map['severity'] = Variable<int>(severity);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['is_synced'] = Variable<bool>(isSynced);
    map['is_deleted'] = Variable<bool>(isDeleted);
    return map;
  }

  DailySymptomsCompanion toCompanion(bool nullToAbsent) {
    return DailySymptomsCompanion(
      id: Value(id),
      dailyLogId: Value(dailyLogId),
      symptomName: Value(symptomName),
      severity: severity == null && nullToAbsent
          ? const Value.absent()
          : Value(severity),
      createdAt: Value(createdAt),
      isSynced: Value(isSynced),
      isDeleted: Value(isDeleted),
    );
  }

  factory DailySymptom.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DailySymptom(
      id: serializer.fromJson<String>(json['id']),
      dailyLogId: serializer.fromJson<String>(json['dailyLogId']),
      symptomName: serializer.fromJson<String>(json['symptomName']),
      severity: serializer.fromJson<int?>(json['severity']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'dailyLogId': serializer.toJson<String>(dailyLogId),
      'symptomName': serializer.toJson<String>(symptomName),
      'severity': serializer.toJson<int?>(severity),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'isSynced': serializer.toJson<bool>(isSynced),
      'isDeleted': serializer.toJson<bool>(isDeleted),
    };
  }

  DailySymptom copyWith({
    String? id,
    String? dailyLogId,
    String? symptomName,
    Value<int?> severity = const Value.absent(),
    DateTime? createdAt,
    bool? isSynced,
    bool? isDeleted,
  }) => DailySymptom(
    id: id ?? this.id,
    dailyLogId: dailyLogId ?? this.dailyLogId,
    symptomName: symptomName ?? this.symptomName,
    severity: severity.present ? severity.value : this.severity,
    createdAt: createdAt ?? this.createdAt,
    isSynced: isSynced ?? this.isSynced,
    isDeleted: isDeleted ?? this.isDeleted,
  );
  DailySymptom copyWithCompanion(DailySymptomsCompanion data) {
    return DailySymptom(
      id: data.id.present ? data.id.value : this.id,
      dailyLogId: data.dailyLogId.present
          ? data.dailyLogId.value
          : this.dailyLogId,
      symptomName: data.symptomName.present
          ? data.symptomName.value
          : this.symptomName,
      severity: data.severity.present ? data.severity.value : this.severity,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DailySymptom(')
          ..write('id: $id, ')
          ..write('dailyLogId: $dailyLogId, ')
          ..write('symptomName: $symptomName, ')
          ..write('severity: $severity, ')
          ..write('createdAt: $createdAt, ')
          ..write('isSynced: $isSynced, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    dailyLogId,
    symptomName,
    severity,
    createdAt,
    isSynced,
    isDeleted,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DailySymptom &&
          other.id == this.id &&
          other.dailyLogId == this.dailyLogId &&
          other.symptomName == this.symptomName &&
          other.severity == this.severity &&
          other.createdAt == this.createdAt &&
          other.isSynced == this.isSynced &&
          other.isDeleted == this.isDeleted);
}

class DailySymptomsCompanion extends UpdateCompanion<DailySymptom> {
  final Value<String> id;
  final Value<String> dailyLogId;
  final Value<String> symptomName;
  final Value<int?> severity;
  final Value<DateTime> createdAt;
  final Value<bool> isSynced;
  final Value<bool> isDeleted;
  final Value<int> rowid;
  const DailySymptomsCompanion({
    this.id = const Value.absent(),
    this.dailyLogId = const Value.absent(),
    this.symptomName = const Value.absent(),
    this.severity = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DailySymptomsCompanion.insert({
    required String id,
    required String dailyLogId,
    required String symptomName,
    this.severity = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       dailyLogId = Value(dailyLogId),
       symptomName = Value(symptomName);
  static Insertable<DailySymptom> custom({
    Expression<String>? id,
    Expression<String>? dailyLogId,
    Expression<String>? symptomName,
    Expression<int>? severity,
    Expression<DateTime>? createdAt,
    Expression<bool>? isSynced,
    Expression<bool>? isDeleted,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (dailyLogId != null) 'daily_log_id': dailyLogId,
      if (symptomName != null) 'symptom_name': symptomName,
      if (severity != null) 'severity': severity,
      if (createdAt != null) 'created_at': createdAt,
      if (isSynced != null) 'is_synced': isSynced,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DailySymptomsCompanion copyWith({
    Value<String>? id,
    Value<String>? dailyLogId,
    Value<String>? symptomName,
    Value<int?>? severity,
    Value<DateTime>? createdAt,
    Value<bool>? isSynced,
    Value<bool>? isDeleted,
    Value<int>? rowid,
  }) {
    return DailySymptomsCompanion(
      id: id ?? this.id,
      dailyLogId: dailyLogId ?? this.dailyLogId,
      symptomName: symptomName ?? this.symptomName,
      severity: severity ?? this.severity,
      createdAt: createdAt ?? this.createdAt,
      isSynced: isSynced ?? this.isSynced,
      isDeleted: isDeleted ?? this.isDeleted,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (dailyLogId.present) {
      map['daily_log_id'] = Variable<String>(dailyLogId.value);
    }
    if (symptomName.present) {
      map['symptom_name'] = Variable<String>(symptomName.value);
    }
    if (severity.present) {
      map['severity'] = Variable<int>(severity.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DailySymptomsCompanion(')
          ..write('id: $id, ')
          ..write('dailyLogId: $dailyLogId, ')
          ..write('symptomName: $symptomName, ')
          ..write('severity: $severity, ')
          ..write('createdAt: $createdAt, ')
          ..write('isSynced: $isSynced, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RemindersTable extends Reminders
    with TableInfo<$RemindersTable, Reminder> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RemindersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timeOfDayMeta = const VerificationMeta(
    'timeOfDay',
  );
  @override
  late final GeneratedColumn<String> timeOfDay = GeneratedColumn<String>(
    'time_of_day',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _daysBeforeMeta = const VerificationMeta(
    'daysBefore',
  );
  @override
  late final GeneratedColumn<int> daysBefore = GeneratedColumn<int>(
    'days_before',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _isEnabledMeta = const VerificationMeta(
    'isEnabled',
  );
  @override
  late final GeneratedColumn<bool> isEnabled = GeneratedColumn<bool>(
    'is_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _isSyncedMeta = const VerificationMeta(
    'isSynced',
  );
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
    'is_synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    type,
    timeOfDay,
    daysBefore,
    isEnabled,
    createdAt,
    updatedAt,
    isSynced,
    isDeleted,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reminders';
  @override
  VerificationContext validateIntegrity(
    Insertable<Reminder> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('time_of_day')) {
      context.handle(
        _timeOfDayMeta,
        timeOfDay.isAcceptableOrUnknown(data['time_of_day']!, _timeOfDayMeta),
      );
    } else if (isInserting) {
      context.missing(_timeOfDayMeta);
    }
    if (data.containsKey('days_before')) {
      context.handle(
        _daysBeforeMeta,
        daysBefore.isAcceptableOrUnknown(data['days_before']!, _daysBeforeMeta),
      );
    }
    if (data.containsKey('is_enabled')) {
      context.handle(
        _isEnabledMeta,
        isEnabled.isAcceptableOrUnknown(data['is_enabled']!, _isEnabledMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('is_synced')) {
      context.handle(
        _isSyncedMeta,
        isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta),
      );
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Reminder map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Reminder(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      timeOfDay: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}time_of_day'],
      )!,
      daysBefore: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}days_before'],
      )!,
      isEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_enabled'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      isSynced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_synced'],
      )!,
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
    );
  }

  @override
  $RemindersTable createAlias(String alias) {
    return $RemindersTable(attachedDatabase, alias);
  }
}

class Reminder extends DataClass implements Insertable<Reminder> {
  final String id;
  final String userId;
  final String type;
  final String timeOfDay;
  final int daysBefore;
  final bool isEnabled;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isSynced;
  final bool isDeleted;
  const Reminder({
    required this.id,
    required this.userId,
    required this.type,
    required this.timeOfDay,
    required this.daysBefore,
    required this.isEnabled,
    required this.createdAt,
    required this.updatedAt,
    required this.isSynced,
    required this.isDeleted,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['type'] = Variable<String>(type);
    map['time_of_day'] = Variable<String>(timeOfDay);
    map['days_before'] = Variable<int>(daysBefore);
    map['is_enabled'] = Variable<bool>(isEnabled);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['is_synced'] = Variable<bool>(isSynced);
    map['is_deleted'] = Variable<bool>(isDeleted);
    return map;
  }

  RemindersCompanion toCompanion(bool nullToAbsent) {
    return RemindersCompanion(
      id: Value(id),
      userId: Value(userId),
      type: Value(type),
      timeOfDay: Value(timeOfDay),
      daysBefore: Value(daysBefore),
      isEnabled: Value(isEnabled),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      isSynced: Value(isSynced),
      isDeleted: Value(isDeleted),
    );
  }

  factory Reminder.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Reminder(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      type: serializer.fromJson<String>(json['type']),
      timeOfDay: serializer.fromJson<String>(json['timeOfDay']),
      daysBefore: serializer.fromJson<int>(json['daysBefore']),
      isEnabled: serializer.fromJson<bool>(json['isEnabled']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'type': serializer.toJson<String>(type),
      'timeOfDay': serializer.toJson<String>(timeOfDay),
      'daysBefore': serializer.toJson<int>(daysBefore),
      'isEnabled': serializer.toJson<bool>(isEnabled),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'isSynced': serializer.toJson<bool>(isSynced),
      'isDeleted': serializer.toJson<bool>(isDeleted),
    };
  }

  Reminder copyWith({
    String? id,
    String? userId,
    String? type,
    String? timeOfDay,
    int? daysBefore,
    bool? isEnabled,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isSynced,
    bool? isDeleted,
  }) => Reminder(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    type: type ?? this.type,
    timeOfDay: timeOfDay ?? this.timeOfDay,
    daysBefore: daysBefore ?? this.daysBefore,
    isEnabled: isEnabled ?? this.isEnabled,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    isSynced: isSynced ?? this.isSynced,
    isDeleted: isDeleted ?? this.isDeleted,
  );
  Reminder copyWithCompanion(RemindersCompanion data) {
    return Reminder(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      type: data.type.present ? data.type.value : this.type,
      timeOfDay: data.timeOfDay.present ? data.timeOfDay.value : this.timeOfDay,
      daysBefore: data.daysBefore.present
          ? data.daysBefore.value
          : this.daysBefore,
      isEnabled: data.isEnabled.present ? data.isEnabled.value : this.isEnabled,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Reminder(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('type: $type, ')
          ..write('timeOfDay: $timeOfDay, ')
          ..write('daysBefore: $daysBefore, ')
          ..write('isEnabled: $isEnabled, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isSynced: $isSynced, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    type,
    timeOfDay,
    daysBefore,
    isEnabled,
    createdAt,
    updatedAt,
    isSynced,
    isDeleted,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Reminder &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.type == this.type &&
          other.timeOfDay == this.timeOfDay &&
          other.daysBefore == this.daysBefore &&
          other.isEnabled == this.isEnabled &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.isSynced == this.isSynced &&
          other.isDeleted == this.isDeleted);
}

class RemindersCompanion extends UpdateCompanion<Reminder> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String> type;
  final Value<String> timeOfDay;
  final Value<int> daysBefore;
  final Value<bool> isEnabled;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<bool> isSynced;
  final Value<bool> isDeleted;
  final Value<int> rowid;
  const RemindersCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.type = const Value.absent(),
    this.timeOfDay = const Value.absent(),
    this.daysBefore = const Value.absent(),
    this.isEnabled = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RemindersCompanion.insert({
    required String id,
    required String userId,
    required String type,
    required String timeOfDay,
    this.daysBefore = const Value.absent(),
    this.isEnabled = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       userId = Value(userId),
       type = Value(type),
       timeOfDay = Value(timeOfDay);
  static Insertable<Reminder> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? type,
    Expression<String>? timeOfDay,
    Expression<int>? daysBefore,
    Expression<bool>? isEnabled,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<bool>? isSynced,
    Expression<bool>? isDeleted,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (type != null) 'type': type,
      if (timeOfDay != null) 'time_of_day': timeOfDay,
      if (daysBefore != null) 'days_before': daysBefore,
      if (isEnabled != null) 'is_enabled': isEnabled,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (isSynced != null) 'is_synced': isSynced,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RemindersCompanion copyWith({
    Value<String>? id,
    Value<String>? userId,
    Value<String>? type,
    Value<String>? timeOfDay,
    Value<int>? daysBefore,
    Value<bool>? isEnabled,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<bool>? isSynced,
    Value<bool>? isDeleted,
    Value<int>? rowid,
  }) {
    return RemindersCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      timeOfDay: timeOfDay ?? this.timeOfDay,
      daysBefore: daysBefore ?? this.daysBefore,
      isEnabled: isEnabled ?? this.isEnabled,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isSynced: isSynced ?? this.isSynced,
      isDeleted: isDeleted ?? this.isDeleted,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (timeOfDay.present) {
      map['time_of_day'] = Variable<String>(timeOfDay.value);
    }
    if (daysBefore.present) {
      map['days_before'] = Variable<int>(daysBefore.value);
    }
    if (isEnabled.present) {
      map['is_enabled'] = Variable<bool>(isEnabled.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RemindersCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('type: $type, ')
          ..write('timeOfDay: $timeOfDay, ')
          ..write('daysBefore: $daysBefore, ')
          ..write('isEnabled: $isEnabled, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isSynced: $isSynced, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AiInsightsTable extends AiInsights
    with TableInfo<$AiInsightsTable, AiInsight> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AiInsightsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cyclePhaseMeta = const VerificationMeta(
    'cyclePhase',
  );
  @override
  late final GeneratedColumn<String> cyclePhase = GeneratedColumn<String>(
    'cycle_phase',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _headlineMeta = const VerificationMeta(
    'headline',
  );
  @override
  late final GeneratedColumn<String> headline = GeneratedColumn<String>(
    'headline',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _insightTextMeta = const VerificationMeta(
    'insightText',
  );
  @override
  late final GeneratedColumn<String> insightText = GeneratedColumn<String>(
    'insight_text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _generatedDateMeta = const VerificationMeta(
    'generatedDate',
  );
  @override
  late final GeneratedColumn<DateTime> generatedDate =
      GeneratedColumn<DateTime>(
        'generated_date',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _isSyncedMeta = const VerificationMeta(
    'isSynced',
  );
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
    'is_synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    category,
    cyclePhase,
    headline,
    insightText,
    generatedDate,
    createdAt,
    isSynced,
    isDeleted,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ai_insights';
  @override
  VerificationContext validateIntegrity(
    Insertable<AiInsight> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('cycle_phase')) {
      context.handle(
        _cyclePhaseMeta,
        cyclePhase.isAcceptableOrUnknown(data['cycle_phase']!, _cyclePhaseMeta),
      );
    }
    if (data.containsKey('headline')) {
      context.handle(
        _headlineMeta,
        headline.isAcceptableOrUnknown(data['headline']!, _headlineMeta),
      );
    }
    if (data.containsKey('insight_text')) {
      context.handle(
        _insightTextMeta,
        insightText.isAcceptableOrUnknown(
          data['insight_text']!,
          _insightTextMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_insightTextMeta);
    }
    if (data.containsKey('generated_date')) {
      context.handle(
        _generatedDateMeta,
        generatedDate.isAcceptableOrUnknown(
          data['generated_date']!,
          _generatedDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_generatedDateMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('is_synced')) {
      context.handle(
        _isSyncedMeta,
        isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta),
      );
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AiInsight map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AiInsight(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      cyclePhase: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cycle_phase'],
      ),
      headline: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}headline'],
      ),
      insightText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}insight_text'],
      )!,
      generatedDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}generated_date'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      isSynced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_synced'],
      )!,
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
    );
  }

  @override
  $AiInsightsTable createAlias(String alias) {
    return $AiInsightsTable(attachedDatabase, alias);
  }
}

class AiInsight extends DataClass implements Insertable<AiInsight> {
  final String id;
  final String userId;
  final String category;
  final String? cyclePhase;
  final String? headline;
  final String insightText;
  final DateTime generatedDate;
  final DateTime createdAt;
  final bool isSynced;
  final bool isDeleted;
  const AiInsight({
    required this.id,
    required this.userId,
    required this.category,
    this.cyclePhase,
    this.headline,
    required this.insightText,
    required this.generatedDate,
    required this.createdAt,
    required this.isSynced,
    required this.isDeleted,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['category'] = Variable<String>(category);
    if (!nullToAbsent || cyclePhase != null) {
      map['cycle_phase'] = Variable<String>(cyclePhase);
    }
    if (!nullToAbsent || headline != null) {
      map['headline'] = Variable<String>(headline);
    }
    map['insight_text'] = Variable<String>(insightText);
    map['generated_date'] = Variable<DateTime>(generatedDate);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['is_synced'] = Variable<bool>(isSynced);
    map['is_deleted'] = Variable<bool>(isDeleted);
    return map;
  }

  AiInsightsCompanion toCompanion(bool nullToAbsent) {
    return AiInsightsCompanion(
      id: Value(id),
      userId: Value(userId),
      category: Value(category),
      cyclePhase: cyclePhase == null && nullToAbsent
          ? const Value.absent()
          : Value(cyclePhase),
      headline: headline == null && nullToAbsent
          ? const Value.absent()
          : Value(headline),
      insightText: Value(insightText),
      generatedDate: Value(generatedDate),
      createdAt: Value(createdAt),
      isSynced: Value(isSynced),
      isDeleted: Value(isDeleted),
    );
  }

  factory AiInsight.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AiInsight(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      category: serializer.fromJson<String>(json['category']),
      cyclePhase: serializer.fromJson<String?>(json['cyclePhase']),
      headline: serializer.fromJson<String?>(json['headline']),
      insightText: serializer.fromJson<String>(json['insightText']),
      generatedDate: serializer.fromJson<DateTime>(json['generatedDate']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'category': serializer.toJson<String>(category),
      'cyclePhase': serializer.toJson<String?>(cyclePhase),
      'headline': serializer.toJson<String?>(headline),
      'insightText': serializer.toJson<String>(insightText),
      'generatedDate': serializer.toJson<DateTime>(generatedDate),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'isSynced': serializer.toJson<bool>(isSynced),
      'isDeleted': serializer.toJson<bool>(isDeleted),
    };
  }

  AiInsight copyWith({
    String? id,
    String? userId,
    String? category,
    Value<String?> cyclePhase = const Value.absent(),
    Value<String?> headline = const Value.absent(),
    String? insightText,
    DateTime? generatedDate,
    DateTime? createdAt,
    bool? isSynced,
    bool? isDeleted,
  }) => AiInsight(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    category: category ?? this.category,
    cyclePhase: cyclePhase.present ? cyclePhase.value : this.cyclePhase,
    headline: headline.present ? headline.value : this.headline,
    insightText: insightText ?? this.insightText,
    generatedDate: generatedDate ?? this.generatedDate,
    createdAt: createdAt ?? this.createdAt,
    isSynced: isSynced ?? this.isSynced,
    isDeleted: isDeleted ?? this.isDeleted,
  );
  AiInsight copyWithCompanion(AiInsightsCompanion data) {
    return AiInsight(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      category: data.category.present ? data.category.value : this.category,
      cyclePhase: data.cyclePhase.present
          ? data.cyclePhase.value
          : this.cyclePhase,
      headline: data.headline.present ? data.headline.value : this.headline,
      insightText: data.insightText.present
          ? data.insightText.value
          : this.insightText,
      generatedDate: data.generatedDate.present
          ? data.generatedDate.value
          : this.generatedDate,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AiInsight(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('category: $category, ')
          ..write('cyclePhase: $cyclePhase, ')
          ..write('headline: $headline, ')
          ..write('insightText: $insightText, ')
          ..write('generatedDate: $generatedDate, ')
          ..write('createdAt: $createdAt, ')
          ..write('isSynced: $isSynced, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    category,
    cyclePhase,
    headline,
    insightText,
    generatedDate,
    createdAt,
    isSynced,
    isDeleted,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AiInsight &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.category == this.category &&
          other.cyclePhase == this.cyclePhase &&
          other.headline == this.headline &&
          other.insightText == this.insightText &&
          other.generatedDate == this.generatedDate &&
          other.createdAt == this.createdAt &&
          other.isSynced == this.isSynced &&
          other.isDeleted == this.isDeleted);
}

class AiInsightsCompanion extends UpdateCompanion<AiInsight> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String> category;
  final Value<String?> cyclePhase;
  final Value<String?> headline;
  final Value<String> insightText;
  final Value<DateTime> generatedDate;
  final Value<DateTime> createdAt;
  final Value<bool> isSynced;
  final Value<bool> isDeleted;
  final Value<int> rowid;
  const AiInsightsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.category = const Value.absent(),
    this.cyclePhase = const Value.absent(),
    this.headline = const Value.absent(),
    this.insightText = const Value.absent(),
    this.generatedDate = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AiInsightsCompanion.insert({
    required String id,
    required String userId,
    required String category,
    this.cyclePhase = const Value.absent(),
    this.headline = const Value.absent(),
    required String insightText,
    required DateTime generatedDate,
    this.createdAt = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       userId = Value(userId),
       category = Value(category),
       insightText = Value(insightText),
       generatedDate = Value(generatedDate);
  static Insertable<AiInsight> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? category,
    Expression<String>? cyclePhase,
    Expression<String>? headline,
    Expression<String>? insightText,
    Expression<DateTime>? generatedDate,
    Expression<DateTime>? createdAt,
    Expression<bool>? isSynced,
    Expression<bool>? isDeleted,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (category != null) 'category': category,
      if (cyclePhase != null) 'cycle_phase': cyclePhase,
      if (headline != null) 'headline': headline,
      if (insightText != null) 'insight_text': insightText,
      if (generatedDate != null) 'generated_date': generatedDate,
      if (createdAt != null) 'created_at': createdAt,
      if (isSynced != null) 'is_synced': isSynced,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AiInsightsCompanion copyWith({
    Value<String>? id,
    Value<String>? userId,
    Value<String>? category,
    Value<String?>? cyclePhase,
    Value<String?>? headline,
    Value<String>? insightText,
    Value<DateTime>? generatedDate,
    Value<DateTime>? createdAt,
    Value<bool>? isSynced,
    Value<bool>? isDeleted,
    Value<int>? rowid,
  }) {
    return AiInsightsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      category: category ?? this.category,
      cyclePhase: cyclePhase ?? this.cyclePhase,
      headline: headline ?? this.headline,
      insightText: insightText ?? this.insightText,
      generatedDate: generatedDate ?? this.generatedDate,
      createdAt: createdAt ?? this.createdAt,
      isSynced: isSynced ?? this.isSynced,
      isDeleted: isDeleted ?? this.isDeleted,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (cyclePhase.present) {
      map['cycle_phase'] = Variable<String>(cyclePhase.value);
    }
    if (headline.present) {
      map['headline'] = Variable<String>(headline.value);
    }
    if (insightText.present) {
      map['insight_text'] = Variable<String>(insightText.value);
    }
    if (generatedDate.present) {
      map['generated_date'] = Variable<DateTime>(generatedDate.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AiInsightsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('category: $category, ')
          ..write('cyclePhase: $cyclePhase, ')
          ..write('headline: $headline, ')
          ..write('insightText: $insightText, ')
          ..write('generatedDate: $generatedDate, ')
          ..write('createdAt: $createdAt, ')
          ..write('isSynced: $isSynced, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $UserProfilesTable userProfiles = $UserProfilesTable(this);
  late final $CyclesTable cycles = $CyclesTable(this);
  late final $DailyLogsTable dailyLogs = $DailyLogsTable(this);
  late final $DailySymptomsTable dailySymptoms = $DailySymptomsTable(this);
  late final $RemindersTable reminders = $RemindersTable(this);
  late final $AiInsightsTable aiInsights = $AiInsightsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    userProfiles,
    cycles,
    dailyLogs,
    dailySymptoms,
    reminders,
    aiInsights,
  ];
}

typedef $$UserProfilesTableCreateCompanionBuilder =
    UserProfilesCompanion Function({
      required String id,
      required String name,
      Value<String?> email,
      Value<DateTime?> dateOfBirth,
      Value<double?> heightCm,
      Value<double?> weightKg,
      Value<String?> bloodGroup,
      Value<int> avgCycleLength,
      Value<int> avgPeriodLength,
      Value<String?> primaryGoal,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<bool> isSynced,
      Value<bool> isDeleted,
      Value<int> rowid,
    });
typedef $$UserProfilesTableUpdateCompanionBuilder =
    UserProfilesCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String?> email,
      Value<DateTime?> dateOfBirth,
      Value<double?> heightCm,
      Value<double?> weightKg,
      Value<String?> bloodGroup,
      Value<int> avgCycleLength,
      Value<int> avgPeriodLength,
      Value<String?> primaryGoal,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<bool> isSynced,
      Value<bool> isDeleted,
      Value<int> rowid,
    });

class $$UserProfilesTableFilterComposer
    extends Composer<_$AppDatabase, $UserProfilesTable> {
  $$UserProfilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dateOfBirth => $composableBuilder(
    column: $table.dateOfBirth,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get heightCm => $composableBuilder(
    column: $table.heightCm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get weightKg => $composableBuilder(
    column: $table.weightKg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bloodGroup => $composableBuilder(
    column: $table.bloodGroup,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get avgCycleLength => $composableBuilder(
    column: $table.avgCycleLength,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get avgPeriodLength => $composableBuilder(
    column: $table.avgPeriodLength,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get primaryGoal => $composableBuilder(
    column: $table.primaryGoal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UserProfilesTableOrderingComposer
    extends Composer<_$AppDatabase, $UserProfilesTable> {
  $$UserProfilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dateOfBirth => $composableBuilder(
    column: $table.dateOfBirth,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get heightCm => $composableBuilder(
    column: $table.heightCm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get weightKg => $composableBuilder(
    column: $table.weightKg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bloodGroup => $composableBuilder(
    column: $table.bloodGroup,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get avgCycleLength => $composableBuilder(
    column: $table.avgCycleLength,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get avgPeriodLength => $composableBuilder(
    column: $table.avgPeriodLength,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get primaryGoal => $composableBuilder(
    column: $table.primaryGoal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UserProfilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserProfilesTable> {
  $$UserProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<DateTime> get dateOfBirth => $composableBuilder(
    column: $table.dateOfBirth,
    builder: (column) => column,
  );

  GeneratedColumn<double> get heightCm =>
      $composableBuilder(column: $table.heightCm, builder: (column) => column);

  GeneratedColumn<double> get weightKg =>
      $composableBuilder(column: $table.weightKg, builder: (column) => column);

  GeneratedColumn<String> get bloodGroup => $composableBuilder(
    column: $table.bloodGroup,
    builder: (column) => column,
  );

  GeneratedColumn<int> get avgCycleLength => $composableBuilder(
    column: $table.avgCycleLength,
    builder: (column) => column,
  );

  GeneratedColumn<int> get avgPeriodLength => $composableBuilder(
    column: $table.avgPeriodLength,
    builder: (column) => column,
  );

  GeneratedColumn<String> get primaryGoal => $composableBuilder(
    column: $table.primaryGoal,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);
}

class $$UserProfilesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UserProfilesTable,
          UserProfile,
          $$UserProfilesTableFilterComposer,
          $$UserProfilesTableOrderingComposer,
          $$UserProfilesTableAnnotationComposer,
          $$UserProfilesTableCreateCompanionBuilder,
          $$UserProfilesTableUpdateCompanionBuilder,
          (
            UserProfile,
            BaseReferences<_$AppDatabase, $UserProfilesTable, UserProfile>,
          ),
          UserProfile,
          PrefetchHooks Function()
        > {
  $$UserProfilesTableTableManager(_$AppDatabase db, $UserProfilesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserProfilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<DateTime?> dateOfBirth = const Value.absent(),
                Value<double?> heightCm = const Value.absent(),
                Value<double?> weightKg = const Value.absent(),
                Value<String?> bloodGroup = const Value.absent(),
                Value<int> avgCycleLength = const Value.absent(),
                Value<int> avgPeriodLength = const Value.absent(),
                Value<String?> primaryGoal = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UserProfilesCompanion(
                id: id,
                name: name,
                email: email,
                dateOfBirth: dateOfBirth,
                heightCm: heightCm,
                weightKg: weightKg,
                bloodGroup: bloodGroup,
                avgCycleLength: avgCycleLength,
                avgPeriodLength: avgPeriodLength,
                primaryGoal: primaryGoal,
                createdAt: createdAt,
                updatedAt: updatedAt,
                isSynced: isSynced,
                isDeleted: isDeleted,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String?> email = const Value.absent(),
                Value<DateTime?> dateOfBirth = const Value.absent(),
                Value<double?> heightCm = const Value.absent(),
                Value<double?> weightKg = const Value.absent(),
                Value<String?> bloodGroup = const Value.absent(),
                Value<int> avgCycleLength = const Value.absent(),
                Value<int> avgPeriodLength = const Value.absent(),
                Value<String?> primaryGoal = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UserProfilesCompanion.insert(
                id: id,
                name: name,
                email: email,
                dateOfBirth: dateOfBirth,
                heightCm: heightCm,
                weightKg: weightKg,
                bloodGroup: bloodGroup,
                avgCycleLength: avgCycleLength,
                avgPeriodLength: avgPeriodLength,
                primaryGoal: primaryGoal,
                createdAt: createdAt,
                updatedAt: updatedAt,
                isSynced: isSynced,
                isDeleted: isDeleted,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UserProfilesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UserProfilesTable,
      UserProfile,
      $$UserProfilesTableFilterComposer,
      $$UserProfilesTableOrderingComposer,
      $$UserProfilesTableAnnotationComposer,
      $$UserProfilesTableCreateCompanionBuilder,
      $$UserProfilesTableUpdateCompanionBuilder,
      (
        UserProfile,
        BaseReferences<_$AppDatabase, $UserProfilesTable, UserProfile>,
      ),
      UserProfile,
      PrefetchHooks Function()
    >;
typedef $$CyclesTableCreateCompanionBuilder =
    CyclesCompanion Function({
      required String id,
      required String userId,
      required DateTime startDate,
      Value<DateTime?> endDate,
      Value<int?> cycleLength,
      Value<int?> periodLength,
      Value<bool> isPredicted,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<bool> isSynced,
      Value<bool> isDeleted,
      Value<int> rowid,
    });
typedef $$CyclesTableUpdateCompanionBuilder =
    CyclesCompanion Function({
      Value<String> id,
      Value<String> userId,
      Value<DateTime> startDate,
      Value<DateTime?> endDate,
      Value<int?> cycleLength,
      Value<int?> periodLength,
      Value<bool> isPredicted,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<bool> isSynced,
      Value<bool> isDeleted,
      Value<int> rowid,
    });

class $$CyclesTableFilterComposer
    extends Composer<_$AppDatabase, $CyclesTable> {
  $$CyclesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cycleLength => $composableBuilder(
    column: $table.cycleLength,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get periodLength => $composableBuilder(
    column: $table.periodLength,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isPredicted => $composableBuilder(
    column: $table.isPredicted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CyclesTableOrderingComposer
    extends Composer<_$AppDatabase, $CyclesTable> {
  $$CyclesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cycleLength => $composableBuilder(
    column: $table.cycleLength,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get periodLength => $composableBuilder(
    column: $table.periodLength,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isPredicted => $composableBuilder(
    column: $table.isPredicted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CyclesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CyclesTable> {
  $$CyclesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<DateTime> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => column);

  GeneratedColumn<int> get cycleLength => $composableBuilder(
    column: $table.cycleLength,
    builder: (column) => column,
  );

  GeneratedColumn<int> get periodLength => $composableBuilder(
    column: $table.periodLength,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isPredicted => $composableBuilder(
    column: $table.isPredicted,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);
}

class $$CyclesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CyclesTable,
          Cycle,
          $$CyclesTableFilterComposer,
          $$CyclesTableOrderingComposer,
          $$CyclesTableAnnotationComposer,
          $$CyclesTableCreateCompanionBuilder,
          $$CyclesTableUpdateCompanionBuilder,
          (Cycle, BaseReferences<_$AppDatabase, $CyclesTable, Cycle>),
          Cycle,
          PrefetchHooks Function()
        > {
  $$CyclesTableTableManager(_$AppDatabase db, $CyclesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CyclesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CyclesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CyclesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<DateTime> startDate = const Value.absent(),
                Value<DateTime?> endDate = const Value.absent(),
                Value<int?> cycleLength = const Value.absent(),
                Value<int?> periodLength = const Value.absent(),
                Value<bool> isPredicted = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CyclesCompanion(
                id: id,
                userId: userId,
                startDate: startDate,
                endDate: endDate,
                cycleLength: cycleLength,
                periodLength: periodLength,
                isPredicted: isPredicted,
                createdAt: createdAt,
                updatedAt: updatedAt,
                isSynced: isSynced,
                isDeleted: isDeleted,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String userId,
                required DateTime startDate,
                Value<DateTime?> endDate = const Value.absent(),
                Value<int?> cycleLength = const Value.absent(),
                Value<int?> periodLength = const Value.absent(),
                Value<bool> isPredicted = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CyclesCompanion.insert(
                id: id,
                userId: userId,
                startDate: startDate,
                endDate: endDate,
                cycleLength: cycleLength,
                periodLength: periodLength,
                isPredicted: isPredicted,
                createdAt: createdAt,
                updatedAt: updatedAt,
                isSynced: isSynced,
                isDeleted: isDeleted,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CyclesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CyclesTable,
      Cycle,
      $$CyclesTableFilterComposer,
      $$CyclesTableOrderingComposer,
      $$CyclesTableAnnotationComposer,
      $$CyclesTableCreateCompanionBuilder,
      $$CyclesTableUpdateCompanionBuilder,
      (Cycle, BaseReferences<_$AppDatabase, $CyclesTable, Cycle>),
      Cycle,
      PrefetchHooks Function()
    >;
typedef $$DailyLogsTableCreateCompanionBuilder =
    DailyLogsCompanion Function({
      required String id,
      required String userId,
      Value<String?> cycleId,
      required DateTime date,
      Value<String?> flowIntensity,
      Value<int?> painLevel,
      Value<String?> mood,
      Value<double?> sleepHours,
      Value<String?> waterIntake,
      Value<int?> stressLevel,
      Value<String?> activityLevel,
      Value<String?> remedies,
      Value<int?> painAfter1Hr,
      Value<String?> notes,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<bool> isSynced,
      Value<bool> isDeleted,
      Value<int> rowid,
    });
typedef $$DailyLogsTableUpdateCompanionBuilder =
    DailyLogsCompanion Function({
      Value<String> id,
      Value<String> userId,
      Value<String?> cycleId,
      Value<DateTime> date,
      Value<String?> flowIntensity,
      Value<int?> painLevel,
      Value<String?> mood,
      Value<double?> sleepHours,
      Value<String?> waterIntake,
      Value<int?> stressLevel,
      Value<String?> activityLevel,
      Value<String?> remedies,
      Value<int?> painAfter1Hr,
      Value<String?> notes,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<bool> isSynced,
      Value<bool> isDeleted,
      Value<int> rowid,
    });

class $$DailyLogsTableFilterComposer
    extends Composer<_$AppDatabase, $DailyLogsTable> {
  $$DailyLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cycleId => $composableBuilder(
    column: $table.cycleId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get flowIntensity => $composableBuilder(
    column: $table.flowIntensity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get painLevel => $composableBuilder(
    column: $table.painLevel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mood => $composableBuilder(
    column: $table.mood,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get sleepHours => $composableBuilder(
    column: $table.sleepHours,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get waterIntake => $composableBuilder(
    column: $table.waterIntake,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get stressLevel => $composableBuilder(
    column: $table.stressLevel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get activityLevel => $composableBuilder(
    column: $table.activityLevel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get remedies => $composableBuilder(
    column: $table.remedies,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get painAfter1Hr => $composableBuilder(
    column: $table.painAfter1Hr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DailyLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $DailyLogsTable> {
  $$DailyLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cycleId => $composableBuilder(
    column: $table.cycleId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get flowIntensity => $composableBuilder(
    column: $table.flowIntensity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get painLevel => $composableBuilder(
    column: $table.painLevel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mood => $composableBuilder(
    column: $table.mood,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get sleepHours => $composableBuilder(
    column: $table.sleepHours,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get waterIntake => $composableBuilder(
    column: $table.waterIntake,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get stressLevel => $composableBuilder(
    column: $table.stressLevel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get activityLevel => $composableBuilder(
    column: $table.activityLevel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get remedies => $composableBuilder(
    column: $table.remedies,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get painAfter1Hr => $composableBuilder(
    column: $table.painAfter1Hr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DailyLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DailyLogsTable> {
  $$DailyLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get cycleId =>
      $composableBuilder(column: $table.cycleId, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get flowIntensity => $composableBuilder(
    column: $table.flowIntensity,
    builder: (column) => column,
  );

  GeneratedColumn<int> get painLevel =>
      $composableBuilder(column: $table.painLevel, builder: (column) => column);

  GeneratedColumn<String> get mood =>
      $composableBuilder(column: $table.mood, builder: (column) => column);

  GeneratedColumn<double> get sleepHours => $composableBuilder(
    column: $table.sleepHours,
    builder: (column) => column,
  );

  GeneratedColumn<String> get waterIntake => $composableBuilder(
    column: $table.waterIntake,
    builder: (column) => column,
  );

  GeneratedColumn<int> get stressLevel => $composableBuilder(
    column: $table.stressLevel,
    builder: (column) => column,
  );

  GeneratedColumn<String> get activityLevel => $composableBuilder(
    column: $table.activityLevel,
    builder: (column) => column,
  );

  GeneratedColumn<String> get remedies =>
      $composableBuilder(column: $table.remedies, builder: (column) => column);

  GeneratedColumn<int> get painAfter1Hr => $composableBuilder(
    column: $table.painAfter1Hr,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);
}

class $$DailyLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DailyLogsTable,
          DailyLog,
          $$DailyLogsTableFilterComposer,
          $$DailyLogsTableOrderingComposer,
          $$DailyLogsTableAnnotationComposer,
          $$DailyLogsTableCreateCompanionBuilder,
          $$DailyLogsTableUpdateCompanionBuilder,
          (DailyLog, BaseReferences<_$AppDatabase, $DailyLogsTable, DailyLog>),
          DailyLog,
          PrefetchHooks Function()
        > {
  $$DailyLogsTableTableManager(_$AppDatabase db, $DailyLogsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DailyLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DailyLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DailyLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String?> cycleId = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<String?> flowIntensity = const Value.absent(),
                Value<int?> painLevel = const Value.absent(),
                Value<String?> mood = const Value.absent(),
                Value<double?> sleepHours = const Value.absent(),
                Value<String?> waterIntake = const Value.absent(),
                Value<int?> stressLevel = const Value.absent(),
                Value<String?> activityLevel = const Value.absent(),
                Value<String?> remedies = const Value.absent(),
                Value<int?> painAfter1Hr = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DailyLogsCompanion(
                id: id,
                userId: userId,
                cycleId: cycleId,
                date: date,
                flowIntensity: flowIntensity,
                painLevel: painLevel,
                mood: mood,
                sleepHours: sleepHours,
                waterIntake: waterIntake,
                stressLevel: stressLevel,
                activityLevel: activityLevel,
                remedies: remedies,
                painAfter1Hr: painAfter1Hr,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
                isSynced: isSynced,
                isDeleted: isDeleted,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String userId,
                Value<String?> cycleId = const Value.absent(),
                required DateTime date,
                Value<String?> flowIntensity = const Value.absent(),
                Value<int?> painLevel = const Value.absent(),
                Value<String?> mood = const Value.absent(),
                Value<double?> sleepHours = const Value.absent(),
                Value<String?> waterIntake = const Value.absent(),
                Value<int?> stressLevel = const Value.absent(),
                Value<String?> activityLevel = const Value.absent(),
                Value<String?> remedies = const Value.absent(),
                Value<int?> painAfter1Hr = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DailyLogsCompanion.insert(
                id: id,
                userId: userId,
                cycleId: cycleId,
                date: date,
                flowIntensity: flowIntensity,
                painLevel: painLevel,
                mood: mood,
                sleepHours: sleepHours,
                waterIntake: waterIntake,
                stressLevel: stressLevel,
                activityLevel: activityLevel,
                remedies: remedies,
                painAfter1Hr: painAfter1Hr,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
                isSynced: isSynced,
                isDeleted: isDeleted,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DailyLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DailyLogsTable,
      DailyLog,
      $$DailyLogsTableFilterComposer,
      $$DailyLogsTableOrderingComposer,
      $$DailyLogsTableAnnotationComposer,
      $$DailyLogsTableCreateCompanionBuilder,
      $$DailyLogsTableUpdateCompanionBuilder,
      (DailyLog, BaseReferences<_$AppDatabase, $DailyLogsTable, DailyLog>),
      DailyLog,
      PrefetchHooks Function()
    >;
typedef $$DailySymptomsTableCreateCompanionBuilder =
    DailySymptomsCompanion Function({
      required String id,
      required String dailyLogId,
      required String symptomName,
      Value<int?> severity,
      Value<DateTime> createdAt,
      Value<bool> isSynced,
      Value<bool> isDeleted,
      Value<int> rowid,
    });
typedef $$DailySymptomsTableUpdateCompanionBuilder =
    DailySymptomsCompanion Function({
      Value<String> id,
      Value<String> dailyLogId,
      Value<String> symptomName,
      Value<int?> severity,
      Value<DateTime> createdAt,
      Value<bool> isSynced,
      Value<bool> isDeleted,
      Value<int> rowid,
    });

class $$DailySymptomsTableFilterComposer
    extends Composer<_$AppDatabase, $DailySymptomsTable> {
  $$DailySymptomsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dailyLogId => $composableBuilder(
    column: $table.dailyLogId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get symptomName => $composableBuilder(
    column: $table.symptomName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get severity => $composableBuilder(
    column: $table.severity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DailySymptomsTableOrderingComposer
    extends Composer<_$AppDatabase, $DailySymptomsTable> {
  $$DailySymptomsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dailyLogId => $composableBuilder(
    column: $table.dailyLogId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get symptomName => $composableBuilder(
    column: $table.symptomName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get severity => $composableBuilder(
    column: $table.severity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DailySymptomsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DailySymptomsTable> {
  $$DailySymptomsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get dailyLogId => $composableBuilder(
    column: $table.dailyLogId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get symptomName => $composableBuilder(
    column: $table.symptomName,
    builder: (column) => column,
  );

  GeneratedColumn<int> get severity =>
      $composableBuilder(column: $table.severity, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);
}

class $$DailySymptomsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DailySymptomsTable,
          DailySymptom,
          $$DailySymptomsTableFilterComposer,
          $$DailySymptomsTableOrderingComposer,
          $$DailySymptomsTableAnnotationComposer,
          $$DailySymptomsTableCreateCompanionBuilder,
          $$DailySymptomsTableUpdateCompanionBuilder,
          (
            DailySymptom,
            BaseReferences<_$AppDatabase, $DailySymptomsTable, DailySymptom>,
          ),
          DailySymptom,
          PrefetchHooks Function()
        > {
  $$DailySymptomsTableTableManager(_$AppDatabase db, $DailySymptomsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DailySymptomsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DailySymptomsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DailySymptomsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> dailyLogId = const Value.absent(),
                Value<String> symptomName = const Value.absent(),
                Value<int?> severity = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DailySymptomsCompanion(
                id: id,
                dailyLogId: dailyLogId,
                symptomName: symptomName,
                severity: severity,
                createdAt: createdAt,
                isSynced: isSynced,
                isDeleted: isDeleted,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String dailyLogId,
                required String symptomName,
                Value<int?> severity = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DailySymptomsCompanion.insert(
                id: id,
                dailyLogId: dailyLogId,
                symptomName: symptomName,
                severity: severity,
                createdAt: createdAt,
                isSynced: isSynced,
                isDeleted: isDeleted,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DailySymptomsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DailySymptomsTable,
      DailySymptom,
      $$DailySymptomsTableFilterComposer,
      $$DailySymptomsTableOrderingComposer,
      $$DailySymptomsTableAnnotationComposer,
      $$DailySymptomsTableCreateCompanionBuilder,
      $$DailySymptomsTableUpdateCompanionBuilder,
      (
        DailySymptom,
        BaseReferences<_$AppDatabase, $DailySymptomsTable, DailySymptom>,
      ),
      DailySymptom,
      PrefetchHooks Function()
    >;
typedef $$RemindersTableCreateCompanionBuilder =
    RemindersCompanion Function({
      required String id,
      required String userId,
      required String type,
      required String timeOfDay,
      Value<int> daysBefore,
      Value<bool> isEnabled,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<bool> isSynced,
      Value<bool> isDeleted,
      Value<int> rowid,
    });
typedef $$RemindersTableUpdateCompanionBuilder =
    RemindersCompanion Function({
      Value<String> id,
      Value<String> userId,
      Value<String> type,
      Value<String> timeOfDay,
      Value<int> daysBefore,
      Value<bool> isEnabled,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<bool> isSynced,
      Value<bool> isDeleted,
      Value<int> rowid,
    });

class $$RemindersTableFilterComposer
    extends Composer<_$AppDatabase, $RemindersTable> {
  $$RemindersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get timeOfDay => $composableBuilder(
    column: $table.timeOfDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get daysBefore => $composableBuilder(
    column: $table.daysBefore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isEnabled => $composableBuilder(
    column: $table.isEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RemindersTableOrderingComposer
    extends Composer<_$AppDatabase, $RemindersTable> {
  $$RemindersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get timeOfDay => $composableBuilder(
    column: $table.timeOfDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get daysBefore => $composableBuilder(
    column: $table.daysBefore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isEnabled => $composableBuilder(
    column: $table.isEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RemindersTableAnnotationComposer
    extends Composer<_$AppDatabase, $RemindersTable> {
  $$RemindersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get timeOfDay =>
      $composableBuilder(column: $table.timeOfDay, builder: (column) => column);

  GeneratedColumn<int> get daysBefore => $composableBuilder(
    column: $table.daysBefore,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isEnabled =>
      $composableBuilder(column: $table.isEnabled, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);
}

class $$RemindersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RemindersTable,
          Reminder,
          $$RemindersTableFilterComposer,
          $$RemindersTableOrderingComposer,
          $$RemindersTableAnnotationComposer,
          $$RemindersTableCreateCompanionBuilder,
          $$RemindersTableUpdateCompanionBuilder,
          (Reminder, BaseReferences<_$AppDatabase, $RemindersTable, Reminder>),
          Reminder,
          PrefetchHooks Function()
        > {
  $$RemindersTableTableManager(_$AppDatabase db, $RemindersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RemindersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RemindersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RemindersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> timeOfDay = const Value.absent(),
                Value<int> daysBefore = const Value.absent(),
                Value<bool> isEnabled = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RemindersCompanion(
                id: id,
                userId: userId,
                type: type,
                timeOfDay: timeOfDay,
                daysBefore: daysBefore,
                isEnabled: isEnabled,
                createdAt: createdAt,
                updatedAt: updatedAt,
                isSynced: isSynced,
                isDeleted: isDeleted,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String userId,
                required String type,
                required String timeOfDay,
                Value<int> daysBefore = const Value.absent(),
                Value<bool> isEnabled = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RemindersCompanion.insert(
                id: id,
                userId: userId,
                type: type,
                timeOfDay: timeOfDay,
                daysBefore: daysBefore,
                isEnabled: isEnabled,
                createdAt: createdAt,
                updatedAt: updatedAt,
                isSynced: isSynced,
                isDeleted: isDeleted,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RemindersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RemindersTable,
      Reminder,
      $$RemindersTableFilterComposer,
      $$RemindersTableOrderingComposer,
      $$RemindersTableAnnotationComposer,
      $$RemindersTableCreateCompanionBuilder,
      $$RemindersTableUpdateCompanionBuilder,
      (Reminder, BaseReferences<_$AppDatabase, $RemindersTable, Reminder>),
      Reminder,
      PrefetchHooks Function()
    >;
typedef $$AiInsightsTableCreateCompanionBuilder =
    AiInsightsCompanion Function({
      required String id,
      required String userId,
      required String category,
      Value<String?> cyclePhase,
      Value<String?> headline,
      required String insightText,
      required DateTime generatedDate,
      Value<DateTime> createdAt,
      Value<bool> isSynced,
      Value<bool> isDeleted,
      Value<int> rowid,
    });
typedef $$AiInsightsTableUpdateCompanionBuilder =
    AiInsightsCompanion Function({
      Value<String> id,
      Value<String> userId,
      Value<String> category,
      Value<String?> cyclePhase,
      Value<String?> headline,
      Value<String> insightText,
      Value<DateTime> generatedDate,
      Value<DateTime> createdAt,
      Value<bool> isSynced,
      Value<bool> isDeleted,
      Value<int> rowid,
    });

class $$AiInsightsTableFilterComposer
    extends Composer<_$AppDatabase, $AiInsightsTable> {
  $$AiInsightsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cyclePhase => $composableBuilder(
    column: $table.cyclePhase,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get headline => $composableBuilder(
    column: $table.headline,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get insightText => $composableBuilder(
    column: $table.insightText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get generatedDate => $composableBuilder(
    column: $table.generatedDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AiInsightsTableOrderingComposer
    extends Composer<_$AppDatabase, $AiInsightsTable> {
  $$AiInsightsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cyclePhase => $composableBuilder(
    column: $table.cyclePhase,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get headline => $composableBuilder(
    column: $table.headline,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get insightText => $composableBuilder(
    column: $table.insightText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get generatedDate => $composableBuilder(
    column: $table.generatedDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AiInsightsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AiInsightsTable> {
  $$AiInsightsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get cyclePhase => $composableBuilder(
    column: $table.cyclePhase,
    builder: (column) => column,
  );

  GeneratedColumn<String> get headline =>
      $composableBuilder(column: $table.headline, builder: (column) => column);

  GeneratedColumn<String> get insightText => $composableBuilder(
    column: $table.insightText,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get generatedDate => $composableBuilder(
    column: $table.generatedDate,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);
}

class $$AiInsightsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AiInsightsTable,
          AiInsight,
          $$AiInsightsTableFilterComposer,
          $$AiInsightsTableOrderingComposer,
          $$AiInsightsTableAnnotationComposer,
          $$AiInsightsTableCreateCompanionBuilder,
          $$AiInsightsTableUpdateCompanionBuilder,
          (
            AiInsight,
            BaseReferences<_$AppDatabase, $AiInsightsTable, AiInsight>,
          ),
          AiInsight,
          PrefetchHooks Function()
        > {
  $$AiInsightsTableTableManager(_$AppDatabase db, $AiInsightsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AiInsightsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AiInsightsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AiInsightsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String?> cyclePhase = const Value.absent(),
                Value<String?> headline = const Value.absent(),
                Value<String> insightText = const Value.absent(),
                Value<DateTime> generatedDate = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AiInsightsCompanion(
                id: id,
                userId: userId,
                category: category,
                cyclePhase: cyclePhase,
                headline: headline,
                insightText: insightText,
                generatedDate: generatedDate,
                createdAt: createdAt,
                isSynced: isSynced,
                isDeleted: isDeleted,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String userId,
                required String category,
                Value<String?> cyclePhase = const Value.absent(),
                Value<String?> headline = const Value.absent(),
                required String insightText,
                required DateTime generatedDate,
                Value<DateTime> createdAt = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AiInsightsCompanion.insert(
                id: id,
                userId: userId,
                category: category,
                cyclePhase: cyclePhase,
                headline: headline,
                insightText: insightText,
                generatedDate: generatedDate,
                createdAt: createdAt,
                isSynced: isSynced,
                isDeleted: isDeleted,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AiInsightsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AiInsightsTable,
      AiInsight,
      $$AiInsightsTableFilterComposer,
      $$AiInsightsTableOrderingComposer,
      $$AiInsightsTableAnnotationComposer,
      $$AiInsightsTableCreateCompanionBuilder,
      $$AiInsightsTableUpdateCompanionBuilder,
      (AiInsight, BaseReferences<_$AppDatabase, $AiInsightsTable, AiInsight>),
      AiInsight,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$UserProfilesTableTableManager get userProfiles =>
      $$UserProfilesTableTableManager(_db, _db.userProfiles);
  $$CyclesTableTableManager get cycles =>
      $$CyclesTableTableManager(_db, _db.cycles);
  $$DailyLogsTableTableManager get dailyLogs =>
      $$DailyLogsTableTableManager(_db, _db.dailyLogs);
  $$DailySymptomsTableTableManager get dailySymptoms =>
      $$DailySymptomsTableTableManager(_db, _db.dailySymptoms);
  $$RemindersTableTableManager get reminders =>
      $$RemindersTableTableManager(_db, _db.reminders);
  $$AiInsightsTableTableManager get aiInsights =>
      $$AiInsightsTableTableManager(_db, _db.aiInsights);
}
