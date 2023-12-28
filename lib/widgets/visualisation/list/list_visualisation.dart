import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:line_icons/line_icons.dart';
import 'package:namer_app/db/database.dart';
import 'package:namer_app/utils/dates.dart';
import 'package:namer_app/utils/providers.dart';

class ListVisualisation extends ConsumerStatefulWidget {
  final Map<Category, List<Transaction>> data;
  final ScrollController scrollController;

  ListVisualisation({required this.data, required this.scrollController});

  @override
  ConsumerState<ListVisualisation> createState() => _ListVisualisationState();
}

class _ListVisualisationState extends ConsumerState<ListVisualisation> {
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
  void didUpdateWidget(ListVisualisation oldWidget) {
    super.didUpdateWidget(oldWidget);
    updateState();
  }

  ExpansionTile buildPanel(Category category, List<Transaction> transactions) {
    double total =
        transactions.map((t) => t.amount).reduce((a, b) => a + b) / 100;
    Color categoryColor = Color(category.color);

    return ExpansionTile(
      controlAffinity: ListTileControlAffinity.leading,
      title: Stack(
        children: [
          Row(
            children: [
              Icon(
                LineIcons.byName(category.iconName),
                color: categoryColor,
              ),
              SizedBox(width: 5),
              Text(
                category.name,
                style: TextStyle(color: categoryColor),
              ),
              SizedBox(width: 5),
              Container(
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                  child: Text(
                    transactions.length.toString(),
                    textScaleFactor: 0.8,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              '\$$total',
              style: TextStyle(
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
      children: [
        Column(
          children: transactions
              .map(
                (t) => ListTile(
                  title: Stack(
                    children: [
                      Text(
                        '\$${t.amount / 100} - ${t.remarks}',
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Tooltip(
                          message: "Debug: ${t.date}",
                          child: Text(
                            dateTimeToStringShort(t.date),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var categories = ref.watch(categoriesProvider);

    return categories.when(
      data: (categories) {
        return ListView(
          controller: widget.scrollController,
          children: () {
            List<ExpansionTile> panels = [];
            for (var entry in grouped.entries) {
              List<Transaction> transactions = entry.value;
              Category category =
                  categories.firstWhere((c) => c.id == entry.key.id);

              panels.add(buildPanel(category, transactions));
            }
            return panels;
          }(),
        );
      },
      loading: () => Text("Loading"),
      error: (_, __) => Text("Error"),
    );
  }
}
