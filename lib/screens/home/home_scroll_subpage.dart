import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:namer_app/utils/providers.dart';
import 'package:namer_app/utils/styling.dart';
import 'package:namer_app/utils/types.dart';
import 'package:namer_app/widgets/draggable_drawer.dart';
import 'package:namer_app/widgets/visualisation/list/list_visualisation.dart';
import 'package:namer_app/widgets/visualisation/pie_chart/pie_chart_visualisation.dart';

class HomeScrollSubpage extends ConsumerWidget {
  final int pageIndex;
  final Query query;

  HomeScrollSubpage({required this.pageIndex, required this.query});

  static int calculateBalance(QueryResult queryResult) {
    int output = 0;
    queryResult.forEach((category, transactions) {
      if (transactions.isEmpty) {
        return;
      }
      int sum = transactions
          .map((e) => e.amount)
          .reduce((value, element) => value + element);
      if (category.isIncome) {
        output += sum;
      } else {
        output -= sum;
      }
    });
    return output;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print("Build: HomeScrollSubpage(pageIndex: $pageIndex)");

    AsyncValue<QueryResult> queryResult = ref.watch(queryResultProvider(query));
    bool openDrawerInitially = ref.watch(
      appStateProvider.select(
        (appState) => appState.isDrawerOpen,
      ),
    );

    return queryResult.when(
      data: (queryResult) {
        double total = calculateBalance(queryResult) / 100;
        return Column(
          children: [
            _DebugArea(pageIndex: pageIndex, query: query),
            Expanded(
              child: DraggableDrawer(
                pageIndex: pageIndex,
                openDrawer: openDrawerInitially,
                backgroundChild: PieChartVisualisation(queryResult),
                onUpdate: (b) {
                  ref.read(appStateProvider.notifier).changeDrawerOpen(b);
                },
                buildDrawerHandle: (toggleDrawer) => Container(
                  color: appBackgroundColor,
                  child: Center(
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
                            // TODO: Avoid this, will cause rebuild
                            ref
                                .read(appStateProvider.notifier)
                                .changeDrawerOpen(
                                  !ref.watch(
                                    appStateProvider.select(
                                      (appState) => appState.isDrawerOpen,
                                    ),
                                  ),
                                );
                            // toggleDrawer();
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
                ),
                scrollableBuilder: (ScrollController scrollController) {
                  return Container(
                    color: Colors.white,
                    child: ListVisualisation(
                      data: queryResult,
                      scrollController: scrollController,
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
      loading: () => Center(child: CircularProgressIndicator()),
      error: (error, __) => Text('Error: $error'),
    );
  }
}

class _DebugArea extends ConsumerWidget {
  const _DebugArea({
    required this.pageIndex,
    required this.query,
  });

  final int pageIndex;
  final Query query;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AppState state = ref.watch(appStateProvider);
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: DefaultTextStyle(
        style: TextStyle(fontSize: 15, color: Colors.black),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text("Page Index: $pageIndex"),
                SizedBox(width: 20),
                Text("Start: ${query.startDate}"),
                SizedBox(width: 20),
                Text("End: ${query.endDate}"),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text("Period: ${state.period}"),
                SizedBox(width: 20),
                Text("StartDate: ${state.startDate}"),
                SizedBox(width: 20),
                Text("IsDrawerOpen: ${state.isDrawerOpen}"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
