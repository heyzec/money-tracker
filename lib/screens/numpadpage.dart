import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:namer_app/db/database.dart';
import 'package:namer_app/widgets/numpad/logic.dart';
import 'package:namer_app/widgets/numpad/layout.dart';
import 'package:provider/provider.dart';
import 'package:drift/drift.dart' show Value;

class NumpadPage extends StatefulWidget {
  @override
  State<NumpadPage> createState() => _NumpadPageState();
}

class _NumpadPageState extends State<NumpadPage> {
  // Reference to the child widget
  NumpadLogic logic = NumpadLogic();
  bool showCategories = false;
  String display = "0";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading:
            IconButton(
              icon: const Icon(Icons.arrow_back),
              tooltip: 'Back',
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          title: const Text('Key in'),
        ),
        body:
        Column(
  children: [
    Padding(
      padding: EdgeInsets.symmetric(horizontal: 200),
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(display, textScaleFactor: 5),
              IconButton(
                icon: const Icon(Icons.backspace),
                tooltip: 'Increase volume by 10',
                onPressed: () {
                  logic.handle('BS');
                  setState(() {
                    display = logic.getBuffer();
                  });
                },
              ),
            ]
          ),
        )
      ),
    ),
    Expanded(
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        transitionBuilder: (Widget child, Animation<double> animation) {
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;

          var slideTransition = Tween(begin: begin, end: end)
              .animate(CurvedAnimation(parent: animation, curve: curve));

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


        child: showCategories ? NumpadLayout(
          logic: logic,
          onUpdate: (String newDisplay) {
            setState(() {
              display = newDisplay;
            });
          },
        ) : Placeholder(),
      ),
    ),
    ElevatedButton(
      child: Text("Toggle"),
      onPressed: () {
        setState(() {
          showCategories = !showCategories;
        });
      },
    ),
    ElevatedButton(
      child: Text("Done"),
      onPressed: () async {
        var amount = logic.getValue();
        var database = Provider.of<AppDatabase>(context, listen: false);

        await database.insertTransaction(TransactionsCompanion(
          date: Value(DateTime.now()),
          amount: Value(amount),
          isIncome: Value(false),
          remarks: Value("Hi"),
          category: Value(0),
        ));

        Navigator.pop(context);
      },
    )
  ],
)

        ),
      );
  }
}
