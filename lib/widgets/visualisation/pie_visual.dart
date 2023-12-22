import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:namer_app/db/database.dart';
import 'package:namer_app/widgets/visualisation/pie_chart.dart';

class PieChartVisual extends ConsumerWidget {
  final Map<Category, List<Transaction>> data;

  const PieChartVisual(this.data);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (data.isEmpty) {
      return Text("No Data");
    }

    var slices = data.entries.map((entry) {
      Category category = entry.key;
      List<Transaction> transactions = entry.value;
      return PieSliceInfo(
        value: transactions
            .map((t) => t.amount)
            .reduce((value, element) => value + element)
            .toDouble(),
        color: Color(category.color),
      );
    }).toList();
    return PieChart(slices);
  }
}
