import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';

import 'package:drift/drift.dart';

part 'database.g.dart';

@DataClassName("Category")
class Categories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().unique()();
  TextColumn get iconName => text()();
}

class Transactions extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get date => dateTime()();
  IntColumn get amount => integer()();
  BoolColumn get isIncome => boolean()();
  TextColumn get remarks => text()();
  IntColumn get category => integer().references(Categories, #id)();
}

@DriftDatabase(tables: [Categories, Transactions])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  Future<List<Category>> getCategories() async {
    return await select(categories).get();
  }

  Future<int> insertCategory({
    required String name,
    required String iconName,
  }) async {
    return await into(categories).insert(
      CategoriesCompanion(
        name: Value(name),
        iconName: Value(iconName),
      ),
    );
  }

  Future<int> getTransactionCount() async {
    return (await select(transactions).get()).length;
  }

  Future<int> insertTransaction({
    required DateTime date,
    required int amount,
    required bool isIncome,
    required String remarks,
    required String categoryName,
  }) async {
    Category category = await (select(categories)
          ..where((c) => c.name.equals(categoryName)))
        .getSingle();

    var entry = TransactionsCompanion(
      date: Value(date),
      amount: Value(amount),
      isIncome: Value(false), // TODO: Placeholder
      remarks: Value("Hi"),   // TODO: Placeholder
      category: Value(category.id),
    );
    return await into(transactions).insert(entry);
  }
}

LazyDatabase _openConnection() {
  // the LazyDatabase util lets us find the right location for the file async.
  return LazyDatabase(() async {
    // put the database file, called db.sqlite here, into the documents folder
    // for your app.
    Directory dbFolder;
    try {
      dbFolder = await getApplicationDocumentsDirectory();
    } catch (MissingPlatformDirectoryException) {
      dbFolder = Directory('/home/heyzec/Documents');
    }

    final file = File(p.join(dbFolder.path, 'db.sqlite'));

    // Also work around limitations on old Android versions
    if (Platform.isAndroid) {
      await applyWorkaroundToOpenSqlite3OnOldAndroidVersions();
    }

    // Make sqlite3 pick a more suitable location for temporary files - the
    // one from the system may be inaccessible due to sandboxing.
    final cachebase = (await getTemporaryDirectory()).path;
    // We can't access /tmp on Android, which sqlite3 would try by default.
    // Explicitly tell it about the correct temporary directory.
    sqlite3.tempDirectory = cachebase;

    return NativeDatabase.createInBackground(file);
  });
}
