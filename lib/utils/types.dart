import 'package:namer_app/db/database.dart';
import 'package:namer_app/utils/dates.dart';
import 'package:namer_app/utils/helpers.dart';
import 'package:namer_app/utils/providers.dart';

/// Immutable class that captures state of the object.
/// To be accessed and modified via [appStateProvider].
class AppState {
  final DateTime startDate;
  final Period period;
  final bool isDrawerOpen;

  AppState({
    required this.startDate,
    required this.period,
    required this.isDrawerOpen,
  });

  AppState copyWith({
    DateTime? startDate,
    Period? period,
    bool? isDrawerOpen,
  }) {
    return AppState(
      startDate: startDate ?? this.startDate,
      period: period ?? this.period,
      isDrawerOpen: isDrawerOpen ?? this.isDrawerOpen,
    );
  }

  @override
  int get hashCode {
    return combineHashes(combineHashes(startDate.hashCode, period.hashCode),
        isDrawerOpen.hashCode);
  }

  @override
  String toString() {
    return "$period, $startDate";
  }

  @override
  bool operator ==(Object other) {
    return other is AppState &&
        startDate == other.startDate &&
        period == other.period &&
        isDrawerOpen == other.isDrawerOpen;
  }
}

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

  static Query generateQuery({
    required int pageIndex,
    required DateTime startDate,
    required Period period,
  }) {
    DateTime coercedDate = period.coerceDate(startDate);
    DateTime queryStartDate = period.incrementDate(coercedDate, pageIndex);
    DateTime queryEndDate = period.incrementDate(coercedDate, pageIndex + 1);

    return Query(queryStartDate, queryEndDate);
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
