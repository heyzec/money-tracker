import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:money_tracker/utils/money.dart';
import 'package:money_tracker/utils/providers.dart';
import 'package:money_tracker/utils/theme.dart';
import 'package:money_tracker/utils/types.dart';
import 'package:money_tracker/widgets/draggable_drawer.dart';
import 'package:money_tracker/widgets/visualisation/list/list_visualisation.dart';
import 'package:money_tracker/widgets/visualisation/pie_chart/pie_chart_visualisation.dart';

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
        int total = calculateBalance(queryResult);
        return Column(
          children: [
            // _DebugArea(pageIndex: pageIndex, query: query),
            Expanded(
              child: DraggableDrawer(
                pageIndex: pageIndex,
                openDrawer: openDrawerInitially,
                backgroundChild: PieChartVisualisation(queryResult),
                onUpdate: (b) {
                  ref.read(appStateProvider.notifier).changeDrawerOpen(b);
                },
                buildDrawerHandle: (toggleDrawer) {
                  Widget signifyDraggable = FittedBox(
                    fit: BoxFit.fitHeight,
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: Icon(
                        Icons.drag_handle,
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                    ),
                  );
                  Widget balanceButton = Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(
                          total.isNegative
                              ? Theme.of(context)
                                  .extension<AppExtraColors>()!
                                  .expenseColor
                              : Theme.of(context)
                                  .extension<AppExtraColors>()!
                                  .incomeColor,
                        ),
                      ),
                      onPressed: () {
                        // TODO: Avoid this, will cause rebuild
                        ref.read(appStateProvider.notifier).changeDrawerOpen(
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
                        child: DefaultTextStyle.merge(
                          style: TextStyle(color: Colors.white),
                          child: Row(
                            children: [
                              Text("Balance"),
                              SizedBox(width: 5),
                              displayMonetaryAmount(
                                total,
                                addLeadingMinusBySign: true,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );

                  return Container(
                    color: Theme.of(context).colorScheme.background,
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          signifyDraggable,
                          balanceButton,
                          signifyDraggable,
                        ],
                      ),
                    ),
                  );
                },
                scrollableBuilder: (ScrollController scrollController) {
                  return Container(
                    color: Theme.of(context).colorScheme.background,
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
