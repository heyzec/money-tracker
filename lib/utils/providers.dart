import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:namer_app/db/database.dart';
import 'package:namer_app/widgets/visualisation/helpers.dart';

class Query {
  DateTime startDate;
  DateTime endDate;

  Query({required this.startDate, required this.endDate});
}

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

final queryProvider = StateProvider<Query>((ref) {
  return Query(
    // startDate: DateTime.now(),
    // endDate: DateTime.now(),
    startDate: DateTime(2020),
    endDate: DateTime(2025),
  );
});

final transactionsProvider =
    FutureProvider<Map<Category, List<Transaction>>>((ref) async {
  AppDatabase database = ref.read(databaseProvider);
  List<Category> categories = await ref.watch(categoriesProvider.future);

  Query query = ref.watch(queryProvider);
  var transactions = await database
      .getTransactionsWithinDateRange(
        startDate: query.startDate,
        endDate: query.endDate,
      )
      .get();

  return groupTransactions(transactions, categories);
});
