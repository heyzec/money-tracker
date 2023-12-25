import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:namer_app/db/database.dart';
import 'package:namer_app/utils/helpers.dart';
import 'package:namer_app/utils/types.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  AppDatabase database = AppDatabase();
  ref.onDispose(() {
    database.close();
  });
  return database;
});

final categoriesProvider = FutureProvider<List<Category>>((ref) async {
  AppDatabase database = ref.read(databaseProvider);
  return database.getCategories().get();
});

/// This provider takes in a Query and returns a QueryResult
final queryResultProvider =
    FutureProvider.autoDispose.family<QueryResult, Query>((ref, query) async {
  AppDatabase database = ref.read(databaseProvider);
  List<Category> categories = await ref.watch(categoriesProvider.future);

  var transactions = await database
      .getTransactionsWithinDateRange(
        startDate: query.startDate,
        endDate: query.endDate,
      )
      .get();

  return groupTransactions(transactions, categories);
});
