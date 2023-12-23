import 'package:namer_app/db/database.dart';

Map<Category, List<Transaction>> groupTransactions(
  List<Transaction> transactions,
  List<Category> categories,
) {
  Set<int> seenCategories = transactions.map((e) => e.category).toSet();
  return {
    for (int category in seenCategories)
      (categories.firstWhere((c) => c.id == category)):
          transactions.where((t) => t.category == category).toList(),
  };
}
