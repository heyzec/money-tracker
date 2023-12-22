import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:namer_app/db/database.dart';
import 'package:namer_app/utils/providers.dart';

class Breakdown extends ConsumerStatefulWidget {
  final Map<Category, List<Transaction>> data;

  Breakdown(this.data);

  @override
  ConsumerState<Breakdown> createState() => _BreakdownState();
}

class _BreakdownState extends ConsumerState<Breakdown> {
  late Map<Category, List<Transaction>> grouped;
  late List<bool> expansionStates;

  void updateState() {
    grouped = widget.data;
    expansionStates = [for (int i = 0; i < grouped.length; i++) false];
  }

  @override
  void initState() {
    super.initState();
    updateState();
  }

  @override
  void didUpdateWidget(Breakdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    updateState();
  }

  List<ExpansionPanel> buildPanels(List<Category> categories) {
    List<ExpansionPanel> panels = [];
    int i = 0;
    for (var entry in grouped.entries) {
      int index = i;
      List<Transaction> transactions = entry.value;
      int categoryId = entry.key.id;
      double total =
          transactions.map((t) => t.amount).reduce((a, b) => a + b) / 100;

      String categoryName =
          categories.firstWhere((c) => c.id == categoryId).name;

      panels.add(
        // Look into https://api.flutter.dev/flutter/material/ExpansionTile-class.html instead
        ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              title: Text('Category $categoryName - $total'),
            );
          },
          isExpanded: expansionStates[index],
          // controlAffinity: ListTileControlAffinity.leading,

          body: Column(
            children: transactions
                .map(
                  (t) => ListTile(
                    title:
                        Text('\$${t.amount / 100} - ${t.remarks} - ${t.date}'),
                  ),
                )
                .toList(),
          ),
        ),
      );
      i++;
    }
    return panels;
  }

  @override
  Widget build(BuildContext context) {
    var categories = ref.watch(categoriesProvider);

    return categories.when(
      data: (categories) {
        return ExpansionPanelList(
          expansionCallback: (int index, bool isExpanded) {
            setState(() {
              expansionStates[index] = isExpanded;
            });
          },
          children: buildPanels(categories),
        );
      },
      loading: () => Text("Loading"),
      error: (_, __) => Text("Error"),
    );
  }
}
