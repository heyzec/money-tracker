import 'package:flutter/material.dart';
import 'package:namer_app/db/database.dart';
import 'package:namer_app/widgets/visualisation/helpers.dart';

class Breakdown extends StatefulWidget {
  final List<Transaction> data;

  Breakdown(this.data);

  @override
  State<Breakdown> createState() => _BreakdownState();
}

class _BreakdownState extends State<Breakdown> {
  late final Map<int, List<Transaction>> grouped;
  late List<bool> expansionStates;

  @override
  void initState() {
    grouped = groupTransactions(widget.data);

    expansionStates = [for (int i = 0; i < grouped.length; i++) false];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<ExpansionPanel> panels = [];
    int i = 0;
    for (var entry in grouped.entries) {
      int index = i;
      List<Transaction> transactions = entry.value;
      int categoryId = entry.key;
      double total =
          transactions.map((t) => t.amount).reduce((a, b) => a + b) / 100;

      panels.add(
        // Look into https://api.flutter.dev/flutter/material/ExpansionTile-class.html instead
        ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              title: Text('Category $categoryId - $total'),
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

    return ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          expansionStates[index] = isExpanded;
        });
      },
      children: panels,
    );
  }
}
