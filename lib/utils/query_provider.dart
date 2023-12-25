import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:namer_app/utils/dates.dart';
import 'package:namer_app/utils/types.dart';

// TODO: Find a better name for this
class QueryPrecursorState {
  final DateTime startDate;
  final Period period;

  QueryPrecursorState({
    required this.startDate,
    this.period = Period.day,
  });

  QueryPrecursorState setPeriod(Period newPeriod) {
    return QueryPrecursorState(
      startDate: startDate,
      period: newPeriod,
    );
  }

  QueryPrecursorState setDates(DateTime newStartDate) {
    return QueryPrecursorState(
      startDate: newStartDate,
      period: period,
    );
  }

  @override
  String toString() {
    return "$period, $startDate";
  }
}

class QueryPrecursor extends Notifier<QueryPrecursorState> {
  @override
  QueryPrecursorState build() {
    return QueryPrecursorState(
      startDate: coerceToDay(DateTime.now()),
    );
  }

  void changePeriod(Period newPeriod, [DateTime? newStartDate]) {
    QueryPrecursorState newState = state;

    if (newStartDate != null) {
      newState = newState.setDates(newStartDate);
    }
    newState = newState.setPeriod(newPeriod);
    state = newState;
  }

  Query getQueryByIndex(int pageIndex) {
    DateTime coercedDate = state.period.coerceDate(state.startDate);
    DateTime queryStartDate =
        state.period.incrementDate(coercedDate, pageIndex);
    DateTime queryEndDate =
        state.period.incrementDate(coercedDate, pageIndex + 1);

    return Query(queryStartDate, queryEndDate);
  }
}

final queryPrecursorProvider =
    NotifierProvider<QueryPrecursor, QueryPrecursorState>(() {
  return QueryPrecursor();
});
