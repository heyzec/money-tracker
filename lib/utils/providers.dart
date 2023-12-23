import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:namer_app/db/database.dart';
import 'package:namer_app/utils/helpers.dart';
import 'package:namer_app/utils/query_provider.dart';

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

final transactionsProvider =
    FutureProvider<Map<Category, List<Transaction>>>((ref) async {
  AppDatabase database = ref.read(databaseProvider);
  List<Category> categories = await ref.watch(categoriesProvider.future);

  Query query = ref.watch(queryProvider);
  var transactions = await database
      .getTransactionsWithinDateRange(
        startDate: query.getDateRange().start,
        endDate: query.getDateRange().end,
      )
      .get();

  return groupTransactions(transactions, categories);
});
