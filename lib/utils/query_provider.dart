import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:namer_app/utils/dates.dart';

class Query {
  final DateTime startDate;
  final DateTime endDate;
  final Period period;
  late final DateTime originalStartDate; // Unused

  Query({
    required this.startDate,
    required this.endDate,
    this.period = Period.day,
  }) {
    originalStartDate = startDate;
  }

  Query setPeriod(Period newPeriod) {
    return Query(
      startDate: startDate,
      endDate: endDate,
      period: newPeriod,
    );
  }

  Query setDates(DateTime newStartDate, DateTime newEndDate) {
    return Query(
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
        newStartDate = MIN_DATE;
        newEndDate = MAX_DATE;
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

class QueryNotifier extends Notifier<Query> {
  @override
  Query build() {
    return Query(
      startDate: coerceToDay(DateTime.now()),
      endDate: coerceToDay(DateTime.now()),
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

  void increment() {
    state = state.setDates(
      incrementByPeriod(state.startDate, state.period),
      state.endDate,
    );
  }

  void decrement() {
    state = state.setDates(
      decrementByPeriod(state.startDate, state.period),
      state.endDate,
    );
  }
}

final queryProvider = NotifierProvider<QueryNotifier, Query>(() {
  return QueryNotifier();
});
