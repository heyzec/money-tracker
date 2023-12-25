import 'package:namer_app/db/database.dart';

class Query {
  DateTime startDate;
  DateTime endDate;

  Query(this.startDate, this.endDate);

  @override
  bool operator ==(Object other) {
    return other is Query &&
        runtimeType == other.runtimeType &&
        startDate == other.startDate &&
        endDate == other.endDate;
  }

  @override
  int get hashCode {
    // Use Jenkins hash function to combine the hash codes of the two values
    int hash = 17;
    hash = 37 * hash + startDate.hashCode;
    hash = 37 * hash + endDate.hashCode;
    return hash;
  }

  @override
  String toString() {
    return "Query($startDate $endDate)";
  }
}

typedef QueryResult = Map<Category, List<Transaction>>;
