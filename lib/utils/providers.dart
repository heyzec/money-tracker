import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:namer_app/db/database.dart';
import 'package:namer_app/utils/dates.dart';
import 'package:namer_app/utils/helpers.dart';
import 'package:namer_app/utils/types.dart';

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

/// This provider takes in a Query and returns a QueryResult
final queryResultProvider =
    FutureProvider.autoDispose.family<QueryResult, Query>((ref, query) async {
  AppDatabase database = ref.read(databaseProvider);
  List<Category> categories = await ref.watch(categoriesProvider.future);

  var transactions = await database
      .getTransactionsWithinDateRange(
        startDate: query.startDate,
        endDate: query.endDate,
      )
      .get();

  return groupTransactions(transactions, categories);
});

class AppStateNotifier extends Notifier<AppState> {
  @override
  AppState build() {
    return AppState(
      startDate: coerceToDay(DateTime.now()),
      period: Period.day,
      isDrawerOpen: false,
    );
  }

  void changePeriod(Period newPeriod, [DateTime? newStartDate]) {
    AppState newState = state;

    if (newStartDate != null) {
      newState = newState.copyWith(startDate: newStartDate);
    }
    newState = newState.copyWith(period: newPeriod);
    state = newState;
  }

  void changeDrawerOpen(bool b) {
    state = state.copyWith(isDrawerOpen: b);
  }

  void increment() {
    state =
        state.copyWith(startDate: state.period.incrementDate(state.startDate));
  }

  void decrement() {
    state = state.copyWith(
      startDate: state.period.incrementDate(state.startDate, -1),
    );
  }
}

final appStateProvider = NotifierProvider<AppStateNotifier, AppState>(() {
  return AppStateNotifier();
});

final dateExtentProvider = FutureProvider<DateTimeRange>((ref) async {
  AppDatabase database = ref.read(databaseProvider);
  return database.getDateExtent().getSingle().then(
        (value) => DateTimeRange(start: value.minDate!, end: value.maxDate!),
      );
});
