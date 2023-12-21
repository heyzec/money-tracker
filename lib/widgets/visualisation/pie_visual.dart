import 'package:flutter/material.dart';
import 'package:namer_app/db/database.dart';
import 'package:namer_app/widgets/visualisation/helpers.dart';
import 'package:namer_app/widgets/visualisation/pie_chart.dart';

class PieChartVisual extends StatelessWidget {
  final List<Transaction> data;

  const PieChartVisual(this.data);

  @override
  Widget build(BuildContext context) {
    var grouped = groupTransactions(data);
    var slices = grouped.entries
        .map(
          (entry) => PieSliceInfo(
            value: entry.value
                .map((t) => t.amount)
                .reduce((value, element) => value + element)
                .toDouble(),
            color: Colors.primaries[entry.key],
          ),
        )
        .toList();
    return PieChart(slices);
  }
}
