import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:namer_app/db/database.dart';
import 'package:namer_app/utils/providers.dart';
import 'package:namer_app/widgets/cards/selector_db.dart';
import 'package:namer_app/widgets/numpad/layout.dart';
import 'package:namer_app/widgets/numpad/logic.dart';
import 'package:namer_app/widgets/sidebar.dart' show MIN_DATE, MAX_DATE;

class NumpadPage extends ConsumerStatefulWidget {
  @override
  ConsumerState<NumpadPage> createState() => _NumpadPageState();
}

String dateTimeToString(DateTime dt) {
  var dayOfWeekLookup = {
    1: "Mon",
    2: "Tue",
    3: "Wed",
    4: "Thu",
    5: "Fri",
    6: "Sat",
    7: "Sun",
  };
  var monthLookup = {
    1: "Jan",
    2: "Feb",
    3: "Mar",
    4: "Apr",
    5: "May",
    6: "June",
    7: "Jul",
    8: "Aug",
    9: "Sep",
    10: "Oct",
    11: "Nov",
    12: "Dec",
  };
  return "${dayOfWeekLookup[dt.weekday]}, ${dt.day.toString().padLeft(2, '0')} ${monthLookup[dt.month]} ${dt.year.toString()}";
}

class _NumpadPageState extends ConsumerState<NumpadPage> {
  NumpadLogic logic = NumpadLogic();
  bool showCategories = false;
  String display = "0";
  DateTime date = DateTime.now();
  String? selected;

  void insertTransaction(AppDatabase database) async {
    var amount = logic.getValue();

    await database.insertTransaction(
      date: date,
      amount: amount,
      isIncome: false,
      remarks: "Hi",
      categoryName: selected!,
    );

    Navigator.pop(context);
  }

  void onDatePressed() async {
    DateTime? newDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: MIN_DATE,
      lastDate: MAX_DATE,
    );
    if (newDate == null) {
      return;
    }
    setState(() {
      date = newDate;
    });
  }

  void onCategorySelected(String categoryName) {
    setState(() {
      selected = categoryName;
    });
    insertTransaction(ref.read(databaseProvider));
    ref.invalidate(transactionsProvider);
  }

  void onBackspacePressed() {
    logic.handle('B');
    setState(() {
      display = logic.getBuffer();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            tooltip: 'Back',
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Text('Key in'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextButton.icon(
                onPressed: onDatePressed,
                icon: Icon(Icons.calendar_month),
                label: Text(dateTimeToString(date)),
              ),
              Card(
                color: Colors.lightGreen[200],
                child: IntrinsicHeight(
                  child: Stack(
                    children: [
                      Align(
                        child: Text(display, textScaleFactor: 5),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                          icon: const Icon(Icons.backspace),
                          tooltip: 'Backspace',
                          onPressed: onBackspacePressed,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
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
                      ? SelectorWithDbItems(onCategorySelected)
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
      ),
    );
  }
}
