import 'package:namer_app/db/database.dart';
import 'package:namer_app/utils/helpers.dart';

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
    return combineHashes(startDate.hashCode, endDate.hashCode);
  }

  @override
  String toString() {
    return "Query($startDate $endDate)";
  }
}

typedef QueryResult = Map<Category, List<Transaction>>;

class Pair<T, U> {
  final T first;
  final U second;

  Pair(this.first, this.second);

  @override
  String toString() {
    return "($first, $second)";
  }

  @override
  bool operator ==(Object other) {
    return other is Pair<T, U> &&
        other.first == first &&
        other.second == second;
  }

  @override
  int get hashCode => combineHashes(first.hashCode, second.hashCode);
}

class Coord extends Pair<int, int> {
  Coord(super.first, super.second);
}
