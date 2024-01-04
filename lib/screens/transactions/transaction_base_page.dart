import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:money_tracker/db/database.dart';
import 'package:money_tracker/utils/dates.dart';
import 'package:money_tracker/utils/providers.dart';
import 'package:money_tracker/widgets/cards/card_selector.dart';
import 'package:money_tracker/widgets/numpad/layout.dart';
import 'package:money_tracker/widgets/numpad/logic.dart';

class TransactionBasePage extends ConsumerStatefulWidget {
  final NumpadLogic logic;
  final Transaction? transaction;
  final DateTime initialDate;
  final void Function({
    required CardInfo cardInfo,
    required String text,
    required DateTime date,
  }) onSubmit;
  final VoidCallback? onDelete;
  final bool isIncome;

  TransactionBasePage({
    required this.logic,
    this.transaction,
    required this.initialDate,
    required this.onSubmit,
    this.onDelete,
    required this.isIncome,
  });

  @override
  ConsumerState<TransactionBasePage> createState() =>
      _TransactionBasePageState();
}

class _TransactionBasePageState extends ConsumerState<TransactionBasePage> {
  bool showCategories = false;
  TextEditingController _controller = TextEditingController();
  late DateTime date;

  @override
  void initState() {
    super.initState();
    date = widget.initialDate;
  }

  void onDatePressed(BuildContext context) async {
    DateTime? newDate = await showDatePicker(
      context: context,
      initialDate: date,
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

  @override
  Widget build(BuildContext context) {
    var categories = ref.watch(categoriesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${widget.transaction == null ? "New" : "Edit"} ${widget.isIncome ? 'income' : 'expense'}",
        ),
        actions: widget.transaction == null
            ? null
            : [
                IconButton(
                  icon: const Icon(Icons.delete),
                  tooltip: 'Delete',
                  onPressed: widget.onDelete,
                ),
              ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextButton.icon(
              onPressed: () => onDatePressed(context),
              icon: Icon(Icons.calendar_month),
              label: Text(dateTimeToStringLong(date)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                children: [
                  Card(
                    color: Theme.of(context).colorScheme.primary,
                    child: IntrinsicHeight(
                      child: Stack(
                        children: [
                          Align(
                            child: StreamBuilder<String>(
                              stream: widget.logic.stream,
                              initialData: widget.logic.getBuffer(),
                              builder: (context, snapshot) {
                                return Text(
                                  snapshot.data!,
                                  textScaleFactor: 5,
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                  ),
                                );
                              },
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: IconButton(
                                icon: Icon(
                                  Icons.backspace,
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                ),
                                tooltip: 'Backspace',
                                onPressed: () => widget.logic.handle('B'),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: TextFormField(
                      controller: _controller,
                      decoration: InputDecoration(labelText: 'Remarks'),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              flex: 4,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  const begin = Offset(0.0, 1.0);
                  const end = Offset.zero;
                  const curve = Curves.easeInOut;

                  Animation<Offset> slideTransition =
                      Tween(begin: begin, end: end).animate(
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
                            onSelectCallback: (CardInfo card) =>
                                widget.onSubmit(
                              cardInfo: card,
                              text: _controller.text,
                              date: date,
                            ),
                          );
                        },
                        loading: () =>
                            Center(child: CircularProgressIndicator()),
                        error: (error, _) =>
                            Center(child: Text('Error: $error')),
                      )
                    : NumpadLayout(
                        logic: widget.logic,
                      ),
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              flex: 1,
              child: SizedBox(
                child: OutlinedButton(
                  child: Text("Select Category"),
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
