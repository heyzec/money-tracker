// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class Categories extends Table with TableInfo<Categories, Category> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Categories(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints: 'NOT NULL PRIMARY KEY AUTOINCREMENT');
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL UNIQUE');
  static const VerificationMeta _iconNameMeta =
      const VerificationMeta('iconName');
  late final GeneratedColumn<String> iconName = GeneratedColumn<String>(
      'iconName', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  late final GeneratedColumn<int> color = GeneratedColumn<int>(
      'color', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  @override
  List<GeneratedColumn> get $columns => [id, name, iconName, color];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categories';
  @override
  VerificationContext validateIntegrity(Insertable<Category> instance,
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
    if (data.containsKey('iconName')) {
      context.handle(_iconNameMeta,
          iconName.isAcceptableOrUnknown(data['iconName']!, _iconNameMeta));
    } else if (isInserting) {
      context.missing(_iconNameMeta);
    }
    if (data.containsKey('color')) {
      context.handle(
          _colorMeta, color.isAcceptableOrUnknown(data['color']!, _colorMeta));
    } else if (isInserting) {
      context.missing(_colorMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Category map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Category(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      iconName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}iconName'])!,
      color: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}color'])!,
    );
  }

  @override
  Categories createAlias(String alias) {
    return Categories(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class Category extends DataClass implements Insertable<Category> {
  final int id;
  final String name;
  final String iconName;

  /// color    TEXT NOT NULL MAPPED BY `const ColorConverter()`
  /// ColorConverter does not seem to work
  final int color;
  const Category(
      {required this.id,
      required this.name,
      required this.iconName,
      required this.color});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['iconName'] = Variable<String>(iconName);
    map['color'] = Variable<int>(color);
    return map;
  }

  CategoriesCompanion toCompanion(bool nullToAbsent) {
    return CategoriesCompanion(
      id: Value(id),
      name: Value(name),
      iconName: Value(iconName),
      color: Value(color),
    );
  }

  factory Category.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Category(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      iconName: serializer.fromJson<String>(json['iconName']),
      color: serializer.fromJson<int>(json['color']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'iconName': serializer.toJson<String>(iconName),
      'color': serializer.toJson<int>(color),
    };
  }

  Category copyWith({int? id, String? name, String? iconName, int? color}) =>
      Category(
        id: id ?? this.id,
        name: name ?? this.name,
        iconName: iconName ?? this.iconName,
        color: color ?? this.color,
      );
  @override
  String toString() {
    return (StringBuffer('Category(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('iconName: $iconName, ')
          ..write('color: $color')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, iconName, color);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Category &&
          other.id == this.id &&
          other.name == this.name &&
          other.iconName == this.iconName &&
          other.color == this.color);
}

class CategoriesCompanion extends UpdateCompanion<Category> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> iconName;
  final Value<int> color;
  const CategoriesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.iconName = const Value.absent(),
    this.color = const Value.absent(),
  });
  CategoriesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String iconName,
    required int color,
  })  : name = Value(name),
        iconName = Value(iconName),
        color = Value(color);
  static Insertable<Category> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? iconName,
    Expression<int>? color,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (iconName != null) 'iconName': iconName,
      if (color != null) 'color': color,
    });
  }

  CategoriesCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String>? iconName,
      Value<int>? color}) {
    return CategoriesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      iconName: iconName ?? this.iconName,
      color: color ?? this.color,
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
    if (iconName.present) {
      map['iconName'] = Variable<String>(iconName.value);
    }
    if (color.present) {
      map['color'] = Variable<int>(color.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('iconName: $iconName, ')
          ..write('color: $color')
          ..write(')'))
        .toString();
  }
}

class Transactions extends Table with TableInfo<Transactions, Transaction> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Transactions(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints: 'NOT NULL PRIMARY KEY AUTOINCREMENT');
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  late final GeneratedColumn<int> amount = GeneratedColumn<int>(
      'amount', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _isIncomeMeta =
      const VerificationMeta('isIncome');
  late final GeneratedColumn<bool> isIncome = GeneratedColumn<bool>(
      'isIncome', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _remarksMeta =
      const VerificationMeta('remarks');
  late final GeneratedColumn<String> remarks = GeneratedColumn<String>(
      'remarks', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  late final GeneratedColumn<int> category = GeneratedColumn<int>(
      'category', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL REFERENCES categories(id)');
  @override
  List<GeneratedColumn> get $columns =>
      [id, date, amount, isIncome, remarks, category];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transactions';
  @override
  VerificationContext validateIntegrity(Insertable<Transaction> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('isIncome')) {
      context.handle(_isIncomeMeta,
          isIncome.isAcceptableOrUnknown(data['isIncome']!, _isIncomeMeta));
    } else if (isInserting) {
      context.missing(_isIncomeMeta);
    }
    if (data.containsKey('remarks')) {
      context.handle(_remarksMeta,
          remarks.isAcceptableOrUnknown(data['remarks']!, _remarksMeta));
    } else if (isInserting) {
      context.missing(_remarksMeta);
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Transaction map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Transaction(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}amount'])!,
      isIncome: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}isIncome'])!,
      remarks: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}remarks'])!,
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}category'])!,
    );
  }

  @override
  Transactions createAlias(String alias) {
    return Transactions(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class Transaction extends DataClass implements Insertable<Transaction> {
  final int id;
  final DateTime date;
  final int amount;
  final bool isIncome;
  final String remarks;
  final int category;
  const Transaction(
      {required this.id,
      required this.date,
      required this.amount,
      required this.isIncome,
      required this.remarks,
      required this.category});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date'] = Variable<DateTime>(date);
    map['amount'] = Variable<int>(amount);
    map['isIncome'] = Variable<bool>(isIncome);
    map['remarks'] = Variable<String>(remarks);
    map['category'] = Variable<int>(category);
    return map;
  }

  TransactionsCompanion toCompanion(bool nullToAbsent) {
    return TransactionsCompanion(
      id: Value(id),
      date: Value(date),
      amount: Value(amount),
      isIncome: Value(isIncome),
      remarks: Value(remarks),
      category: Value(category),
    );
  }

  factory Transaction.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Transaction(
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<DateTime>(json['date']),
      amount: serializer.fromJson<int>(json['amount']),
      isIncome: serializer.fromJson<bool>(json['isIncome']),
      remarks: serializer.fromJson<String>(json['remarks']),
      category: serializer.fromJson<int>(json['category']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'date': serializer.toJson<DateTime>(date),
      'amount': serializer.toJson<int>(amount),
      'isIncome': serializer.toJson<bool>(isIncome),
      'remarks': serializer.toJson<String>(remarks),
      'category': serializer.toJson<int>(category),
    };
  }

  Transaction copyWith(
          {int? id,
          DateTime? date,
          int? amount,
          bool? isIncome,
          String? remarks,
          int? category}) =>
      Transaction(
        id: id ?? this.id,
        date: date ?? this.date,
        amount: amount ?? this.amount,
        isIncome: isIncome ?? this.isIncome,
        remarks: remarks ?? this.remarks,
        category: category ?? this.category,
      );
  @override
  String toString() {
    return (StringBuffer('Transaction(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('amount: $amount, ')
          ..write('isIncome: $isIncome, ')
          ..write('remarks: $remarks, ')
          ..write('category: $category')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, date, amount, isIncome, remarks, category);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Transaction &&
          other.id == this.id &&
          other.date == this.date &&
          other.amount == this.amount &&
          other.isIncome == this.isIncome &&
          other.remarks == this.remarks &&
          other.category == this.category);
}

class TransactionsCompanion extends UpdateCompanion<Transaction> {
  final Value<int> id;
  final Value<DateTime> date;
  final Value<int> amount;
  final Value<bool> isIncome;
  final Value<String> remarks;
  final Value<int> category;
  const TransactionsCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.amount = const Value.absent(),
    this.isIncome = const Value.absent(),
    this.remarks = const Value.absent(),
    this.category = const Value.absent(),
  });
  TransactionsCompanion.insert({
    this.id = const Value.absent(),
    required DateTime date,
    required int amount,
    required bool isIncome,
    required String remarks,
    required int category,
  })  : date = Value(date),
        amount = Value(amount),
        isIncome = Value(isIncome),
        remarks = Value(remarks),
        category = Value(category);
  static Insertable<Transaction> custom({
    Expression<int>? id,
    Expression<DateTime>? date,
    Expression<int>? amount,
    Expression<bool>? isIncome,
    Expression<String>? remarks,
    Expression<int>? category,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (amount != null) 'amount': amount,
      if (isIncome != null) 'isIncome': isIncome,
      if (remarks != null) 'remarks': remarks,
      if (category != null) 'category': category,
    });
  }

  TransactionsCompanion copyWith(
      {Value<int>? id,
      Value<DateTime>? date,
      Value<int>? amount,
      Value<bool>? isIncome,
      Value<String>? remarks,
      Value<int>? category}) {
    return TransactionsCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      amount: amount ?? this.amount,
      isIncome: isIncome ?? this.isIncome,
      remarks: remarks ?? this.remarks,
      category: category ?? this.category,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (amount.present) {
      map['amount'] = Variable<int>(amount.value);
    }
    if (isIncome.present) {
      map['isIncome'] = Variable<bool>(isIncome.value);
    }
    if (remarks.present) {
      map['remarks'] = Variable<String>(remarks.value);
    }
    if (category.present) {
      map['category'] = Variable<int>(category.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransactionsCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('amount: $amount, ')
          ..write('isIncome: $isIncome, ')
          ..write('remarks: $remarks, ')
          ..write('category: $category')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  late final Categories categories = Categories(this);
  late final Transactions transactions = Transactions(this);
  Selectable<int> getTransactionCount() {
    return customSelect('SELECT COUNT(*) AS _c0 FROM transactions',
        variables: [],
        readsFrom: {
          transactions,
        }).map((QueryRow row) => row.read<int>('_c0'));
  }

  Future<int> insertTransaction(
      {required DateTime date,
      required int amount,
      required bool isIncome,
      required String remarks,
      required String categoryName}) {
    return customInsert(
      'INSERT INTO transactions (date, amount, isIncome, remarks, category) VALUES (?1, ?2, ?3, ?4, (SELECT id FROM categories WHERE name == ?5))',
      variables: [
        Variable<DateTime>(date),
        Variable<int>(amount),
        Variable<bool>(isIncome),
        Variable<String>(remarks),
        Variable<String>(categoryName)
      ],
      updates: {transactions},
    );
  }

  Selectable<Transaction> getTransactionsWithinDateRange(
      {required DateTime startDate, required DateTime endDate}) {
    return customSelect(
        'SELECT * FROM transactions WHERE date >= ?1 AND date <= ?2',
        variables: [
          Variable<DateTime>(startDate),
          Variable<DateTime>(endDate)
        ],
        readsFrom: {
          transactions,
        }).asyncMap(transactions.mapFromRow);
  }

  Selectable<Category> getCategories() {
    return customSelect('SELECT * FROM categories', variables: [], readsFrom: {
      categories,
    }).asyncMap(categories.mapFromRow);
  }

  Future<int> insertCategory(
      {required String name, required String iconName, required int color}) {
    return customInsert(
      'INSERT INTO categories (name, iconName, color) VALUES (?1, ?2, ?3)',
      variables: [
        Variable<String>(name),
        Variable<String>(iconName),
        Variable<int>(color)
      ],
      updates: {categories},
    );
  }

  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [categories, transactions];
}
