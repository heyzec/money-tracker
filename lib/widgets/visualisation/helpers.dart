import 'package:namer_app/db/database.dart';

Map<int, List<Transaction>> groupTransactions(List<Transaction> transactions) {
  Set<int> allCategories = transactions.map((e) => e.category).toSet();
  return {
    for (int category in allCategories)
      category: transactions.where((t) => t.category == category).toList(),
  };
}
