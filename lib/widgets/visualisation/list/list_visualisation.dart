import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:line_icons/line_icons.dart';
import 'package:namer_app/db/database.dart';
import 'package:namer_app/utils/dates.dart';
import 'package:namer_app/utils/providers.dart';
import 'package:namer_app/utils/types.dart';

class ListVisualisation extends ConsumerWidget {
  final QueryResult data;
  final ScrollController scrollController;

  ListVisualisation({required this.data, required this.scrollController});

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
  Widget build(BuildContext context, WidgetRef ref) {
    var categories = ref.watch(categoriesProvider);

    if (data.isEmpty) {
      return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) =>
            SingleChildScrollView(
          controller: scrollController,
          child: SizedBox(
            width: viewportConstraints.maxWidth,
            height: viewportConstraints.maxHeight,
            child: Center(
              child: Text("There are no records for this period yet"),
            ),
          ),
        ),
      );
    }

    return categories.when(
      data: (categories) {
        return ListView(
          controller: scrollController,
          children: () {
            List<ExpansionTile> panels = [];
            for (var entry in data.entries) {
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
