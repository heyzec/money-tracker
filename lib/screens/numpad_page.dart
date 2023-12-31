import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:namer_app/db/database.dart';
import 'package:namer_app/utils/dates.dart';
import 'package:namer_app/utils/providers.dart';
import 'package:namer_app/widgets/cards/card_selector.dart';
import 'package:namer_app/widgets/numpad/layout.dart';
import 'package:namer_app/widgets/numpad/logic.dart';

class NumpadPage extends ConsumerStatefulWidget {
  final bool isIncome;

  NumpadPage({required this.isIncome});

  @override
  ConsumerState<NumpadPage> createState() => _NumpadPageState();
}

class _NumpadPageState extends ConsumerState<NumpadPage> {
  NumpadLogic logic = NumpadLogic();
  bool showCategories = false;
  String display = "0";
  DateTime date = DateTime.now();
  String? selected;
  final TextEditingController _controller = TextEditingController();

  void insertTransaction(AppDatabase database) async {
    var amount = logic.getValue();

    await database.insertTransaction(
      date: date,
      amount: amount,
      remarks: _controller.text,
      // TODO: Handle in the event of duplicate category name
      categoryName: selected!,
    );

    Navigator.pop(context);
  }

  void onDatePressed() async {
    DateTime? newDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: appMinDate,
      lastDate: appMaxDate,
    );
    if (newDate == null) {
      return;
    }
    setState(() {
      date = newDate;
    });
  }

  void onCategorySelected(CardInfo cardInfo) {
    setState(() {
      selected = cardInfo.text;
    });
    insertTransaction(ref.read(databaseProvider));
    ref.invalidate(queryResultProvider);
  }

  void onBackspacePressed() {
    logic.handle('B');
    setState(() {
      display = logic.getBuffer();
    });
  }

  @override
  Widget build(BuildContext context) {
    var categories = ref.watch(categoriesProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Back',
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(widget.isIncome ? "New income" : "New expense"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextButton.icon(
              onPressed: onDatePressed,
              icon: Icon(Icons.calendar_month),
              label: Text(dateTimeToStringLong(date)),
            ),
            Card(
              color: Theme.of(context).colorScheme.primary,
              child: IntrinsicHeight(
                child: Stack(
                  children: [
                    Align(
                      child: Text(
                        display,
                        textScaleFactor: 5,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        icon: Icon(
                          Icons.backspace,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                        tooltip: 'Backspace',
                        onPressed: onBackspacePressed,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            TextFormField(
              controller: _controller,
              decoration: InputDecoration(labelText: 'Note'),
            ),
            Expanded(
              flex: 4,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  const begin = Offset(0.0, 1.0);
                  const end = Offset.zero;
                  const curve = Curves.easeInOut;

                  var slideTransition = Tween(begin: begin, end: end).animate(
                    CurvedAnimation(parent: animation, curve: curve),
                  );

                  return Stack(
                    children: [
                      // // Outgoing widget with fade-out effect
                      // FadeTransition(
                      //   opacity: Tween<double>(begin: 1.0, end: 0.0).animate(animation),
                      //   child: child,
                      // ),
                      // Incoming widget sliding in from the bottom
                      SlideTransition(
                        position: slideTransition,
                        child: FadeTransition(
                          opacity: animation,
                          child: child,
                        ),
                      ),
                    ],
                  );
                },
                child: showCategories
                    ? categories.when(
                        data: (categories) {
                          List<CardInfo> cards = categories
                              .where(
                                (category) =>
                                    category.isIncome == widget.isIncome,
                              )
                              .map(
                                (category) => CardInfo(
                                  iconName: category.iconName,
                                  text: category.name,
                                  color: Color(category.color),
                                ),
                              )
                              .toList();
                          return CardSelector(
                            categories: cards,
                            onSelectCallback: onCategorySelected,
                          );
                        },
                        loading: () =>
                            Center(child: CircularProgressIndicator()),
                        error: (error, _) =>
                            Center(child: Text('Error: $error')),
                      )
                    : NumpadLayout(
                        logic: logic,
                        onUpdate: (String newDisplay) {
                          setState(() {
                            display = newDisplay;
                          });
                        },
                      ),
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              flex: 1,
              child: SizedBox(
                child: OutlinedButton(
                  child: Text(
                    "Select Category",
                    //   style: TextStyle(
                    //     color: Theme.of(context).colorScheme.tertiary,
                    //   ),
                  ),
                  onPressed: () {
                    setState(() {
                      showCategories = !showCategories;
                    });
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
