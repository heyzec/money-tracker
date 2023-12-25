import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:namer_app/db/database.dart';
import 'package:namer_app/utils/providers.dart';
import 'package:namer_app/utils/query_provider.dart';
import 'package:namer_app/utils/types.dart';
import 'package:namer_app/widgets/draggable_drawer.dart';
import 'package:namer_app/widgets/visualisation/pie_visual.dart';
import 'package:namer_app/widgets/visualisation/table.dart';

class HomeScrollSubpage extends ConsumerWidget {
  final int pageIndex;

  HomeScrollSubpage(this.pageIndex);

  int sum(Map<Category, List<Transaction>> transactions) {
    if (transactions.isEmpty) {
      return 0;
    }
    return transactions.values
        .expand((list) => list)
        .map((e) => e.isIncome ? e.amount : -e.amount)
        .reduce((value, element) => value + element);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    QueryPrecursor queryPrecursor = ref.watch(queryPrecursorProvider.notifier);

    Query query = queryPrecursor.getQueryByIndex(pageIndex);

    AsyncValue<QueryResult> transactions =
        ref.watch(queryResultProvider(query));

    return transactions.when(
      data: (t) {
        var transactions = t;
        return DraggableDrawer();
        return Column(
          children: [
            Text("Total: ${sum(transactions) / 100}"),
            Expanded(child: PieChartVisual(transactions)),
            Expanded(child: Breakdown(transactions)),
            Column(
              children: [
                Text("Debug Info"),
                Text("Page Index: $pageIndex"),
                Text("Period: ${queryPrecursor.state.period}"),
                Text("Start: ${query.startDate}"),
                Text("End: ${query.endDate}"),
              ],
            ),
          ],
        );
      },
      loading: () => Center(child: CircularProgressIndicator()),
      error: (error, __) => Text('Error: $error'),
    );
  }
}
