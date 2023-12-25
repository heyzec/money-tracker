import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:namer_app/utils/dates.dart';
import 'package:namer_app/utils/types.dart';

// TODO: Find a better name for this
class QueryPrecursorState {
  final DateTime startDate;
  final DateTime endDate;
  final Period period;
  late final DateTime originalStartDate; // Unused

  QueryPrecursorState({
    required this.startDate,
    required this.endDate,
    this.period = Period.day,
  }) {
    originalStartDate = startDate;
  }

  QueryPrecursorState setPeriod(Period newPeriod) {
    return QueryPrecursorState(
      startDate: startDate,
      endDate: endDate,
      period: newPeriod,
    );
  }

  QueryPrecursorState setDates(DateTime newStartDate, DateTime newEndDate) {
    return QueryPrecursorState(
      startDate: newStartDate,
      endDate: newEndDate,
      period: period,
    );
  }

  DateTimeRange getDateRange() {
    DateTime newStartDate = startDate;
    DateTime newEndDate;
    switch (period) {
      case (Period.day):
        newEndDate = incrementDay(newStartDate);
      case (Period.week):
        newEndDate = incrementWeek(newStartDate);
      case (Period.month):
        newEndDate = incrementMonth(newStartDate);
      case (Period.year):
        newEndDate = incrementYear(newStartDate);
      case (Period.all):
        newStartDate = appMinDate;
        newEndDate = appMaxDate;
      case (Period.interval):
        newEndDate = endDate;
    }
    return DateTimeRange(
      start: newStartDate,
      end: newEndDate,
    );
  }

  @override
  String toString() {
    return "$period, $startDate - $endDate";
  }
}

class QueryPrecursor extends Notifier<QueryPrecursorState> {
  @override
  QueryPrecursorState build() {
    return QueryPrecursorState(
      startDate: coerceToDay(DateTime.now()),
      endDate: incrementDay(coerceToDay(DateTime.now())),
    );
  }

  void changePeriod(Period newPeriod, [dynamic dates]) {
    DateTime newStartDate = state.startDate;
    DateTime endDate = state.endDate;

    if (newPeriod == Period.interval) {
      DateTimeRange dateRange = dates as DateTimeRange;
      newStartDate = dateRange.start;
      endDate = dateRange.end;
    } else if (dates != null) {
      DateTime date = dates as DateTime;
      newStartDate = date;
      endDate = date;
    } else if (state.period.isSmallerThan(newPeriod)) {
      newStartDate = coerceByPeriod(newStartDate, newPeriod);
    } else {}
    var newState = state.setPeriod(newPeriod).setDates(newStartDate, endDate);
    state = newState;
  }

  Query getQueryByIndex(int pageIndex) {
    DateTime queryStartDate = incrementByPeriod(
      state.startDate,
      state.period,
      pageIndex,
    );
    DateTime queryEndDate = incrementByPeriod(
      state.endDate,
      state.period,
      pageIndex,
    );
    return Query(queryStartDate, queryEndDate);
  }
}

final queryPrecursorProvider =
    NotifierProvider<QueryPrecursor, QueryPrecursorState>(() {
  return QueryPrecursor();
});
