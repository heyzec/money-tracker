import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:line_icons/line_icons.dart';
import 'package:money_tracker/db/database.dart';
import 'package:money_tracker/features/transaction/transaction_edit_page.dart';
import 'package:money_tracker/utils/colors.dart';
import 'package:money_tracker/utils/dates.dart';
import 'package:money_tracker/utils/money.dart';
import 'package:money_tracker/utils/providers.dart';
import 'package:money_tracker/utils/theme.dart';
import 'package:money_tracker/utils/types.dart';

class ListVisualisation extends ConsumerWidget {
  final QueryResult data;
  final ScrollController scrollController;

  ListVisualisation({required this.data, required this.scrollController});

  ExpansionTile buildPanel(
    Category category,
    List<Transaction> transactions,
    BuildContext context,
  ) {
    int total = transactions.map((t) => t.amount).reduce((a, b) => a + b);
    Color categoryColor = Color(category.color).darken();

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
            child: DefaultTextStyle.merge(
              style: TextStyle(
                color: category.isIncome
                    ? Theme.of(context).extension<AppExtraColors>()!.incomeColor
                    : Theme.of(context)
                        .extension<AppExtraColors>()!
                        .expenseColor,
              ),
              child: displayMonetaryAmount(total),
            ),
          ),
        ],
      ),
      children: [
        Column(
          children: transactions.map(
            (transaction) {
              return ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TransactionEditPage(
                        transaction: transaction,
                        isIncome: category.isIncome,
                      ),
                    ),
                  );
                },
                title: Stack(
                  children: [
                    Row(
                      children: [
                        SizedBox(width: 30),
                        displayMonetaryAmount(transaction.amount),
                        Text(
                          transaction.remarks.isNotEmpty
                              ? " - ${transaction.remarks}"
                              : "",
                        ),
                      ],
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Tooltip(
                        message: "Debug: ${transaction.date}",
                        child: Text(dateTimeToStringShort(transaction.date)),
                      ),
                    ),
                  ],
                ),
              );
            },
          ).toList(),
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
        return Theme(
          // To remove divider lines https://stackoverflow.com/a/64237509
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ListView(
            controller: scrollController,
            children: () {
              List<ExpansionTile> panels = [];
              for (var entry in data.entries) {
                List<Transaction> transactions = entry.value;
                Category category =
                    categories.firstWhere((c) => c.id == entry.key.id);

                panels.add(buildPanel(category, transactions, context));
              }
              return panels;
            }(),
          ),
        );
      },
      loading: () => Text("Loading"),
      error: (_, __) => Text("Error"),
    );
  }
}
