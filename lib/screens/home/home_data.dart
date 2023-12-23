import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:namer_app/db/database.dart';
import 'package:namer_app/utils/providers.dart';
import 'package:namer_app/widgets/visualisation/pie_visual.dart';
import 'package:namer_app/widgets/visualisation/table.dart';

class ViewData extends ConsumerWidget {
  final DateTime startDate;
  final DateTime endDate;

  ViewData({required this.startDate, required this.endDate});

  Future<List<Transaction>> getFuture(AppDatabase database) {
    return database
        .getTransactionsWithinDateRange(
          startDate: startDate,
          endDate: endDate,
        )
        .get();
  }

  int sum(Map<Category, List<Transaction>> transactions) {
    return transactions.values
        .expand((list) => list)
        .map((e) => e.isIncome ? e.amount : -e.amount)
        .reduce((value, element) => value + element);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<Map<Category, List<Transaction>>> transactions =
        ref.watch(transactionsProvider);
    return transactions.when(
      data: (t) {
        var transactions = t;
        return Expanded(
          child: Column(
            children: [
              if (transactions.isNotEmpty)
                Text("Total: ${sum(transactions) / 100}"),
              Expanded(child: PieChartVisual(transactions)),
              Expanded(child: Breakdown(transactions)),
            ],
          ),
        );
      },
      loading: () => Center(child: CircularProgressIndicator()),
      error: (error, __) => Text('Error: $error'),
    );
  }
}
