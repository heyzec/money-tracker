import 'package:money_tracker/db/database.dart';

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

double snapToValue(double value, double snapPoint1, double snapPoint2) {
  double distanceToSnapPoint1 = (value - snapPoint1).abs();
  double distanceToSnapPoint2 = (value - snapPoint2).abs();

  if (distanceToSnapPoint1 < distanceToSnapPoint2) {
    return snapPoint1;
  } else {
    return snapPoint2;
  }
}

int combineHashes(int hash1, int hash2) {
  // Use Jenkins hash function to combine the hash codes of the two values
  int hash = 17;
  hash = 37 * hash + hash1;
  hash = 37 * hash + hash2;
  return hash;
}
