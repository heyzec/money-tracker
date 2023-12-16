import 'package:flutter/material.dart';
import 'package:namer_app/widgets/numpad/logic.dart';

class NumpadLayout extends StatelessWidget {
  final NumpadLogic logic;
  final void Function(String) onUpdate;

  NumpadLayout({required this.logic, required this.onUpdate});



  @override
  Widget build(BuildContext context) {

    Button createButton(String ch) {
      return Button(text: ch, callback: () {
        logic.handle(ch);
        onUpdate(logic.getBuffer());
      });
    }

    return Column(
      children: [
        Expanded(
          child: Column(children: [
            Row(children: [
              Expanded(child: createButton('1')),
              Expanded(child: createButton('2')),
              Expanded(child: createButton('3')),
              Expanded(child: createButton('+')),
            ]),
            Row(children: [
              Expanded(child: createButton('4')),
              Expanded(child: createButton('5')),
              Expanded(child: createButton('6')),
              Expanded(child: createButton('-')),
            ]),
            Row(children: [
              Expanded(child: createButton('7')),
              Expanded(child: createButton('8')),
              Expanded(child: createButton('9')),
              Expanded(child: createButton('x')),
            ]),
            Row(children: [
              Expanded(child: createButton('0')),
              Expanded(child: createButton('.')),
              Expanded(child: createButton('=')),
              Expanded(child: createButton('/')),
            ]),
          ]),
        ),
    ]);
  }
}

class Button extends StatelessWidget {
  final String text;
  final VoidCallback? callback;
  Button({required this.text, this.callback});

  @override
  Widget build(BuildContext context) {
    return Padding(
    padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: OutlinedButton(
          onPressed: (){if (callback != null) {
            callback!();
          }},
          style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            padding: EdgeInsets.all(30),
            // backgroundColor: Colors.blue, // <-- Button color
            // foregroundColor: Colors.white, // <-- Splash color
          ),
          child: Text(text),
      ),
    );
  }
}