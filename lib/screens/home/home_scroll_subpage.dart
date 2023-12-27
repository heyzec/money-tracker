import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:namer_app/db/database.dart';
import 'package:namer_app/utils/providers.dart';
import 'package:namer_app/utils/query_provider.dart';
import 'package:namer_app/utils/styling.dart';
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
        double total = sum(transactions) / 100;
        return DraggableDrawer(
          backgroundChild: PieChartVisualisation(transactions),
          buildDrawerHandle: (toggleDrawer) => Container(
            color: appBackgroundColor,
            child: Stack(
              children: [
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.drag_handle,
                          color: Colors.green,
                        ),
                      ),
                      ElevatedButton(
                        style: appRoundedButtonStyle.copyWith(
                          backgroundColor: MaterialStatePropertyAll(
                            total >= 0 ? appIncomeColor : appExpenseColor,
                          ),
                        ),
                        onPressed: () {
                          toggleDrawer();
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          child: Text(
                            "Balance ${total.isNegative ? "-" : ""}\$${total.abs()}",
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.drag_handle,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: DefaultTextStyle(
                    style: TextStyle(fontSize: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text("Page Index: $pageIndex"),
                        Text("Period: ${queryPrecursor.state.period}"),
                        Text("Start: ${query.startDate}"),
                        Text("End: ${query.endDate}"),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          scrollableBuilder: (ScrollController scrollController) {
            return Breakdown(
              data: transactions,
              scrollController: scrollController,
            );
          },
        );
      },
      loading: () => Center(child: CircularProgressIndicator()),
      error: (error, __) => Text('Error: $error'),
    );
  }
}
