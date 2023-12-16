import 'package:flutter/material.dart';

class Numpad extends StatefulWidget {

  @override
  State<Numpad> createState() => _NumpadState();
}

class _NumpadState extends State<Numpad> {
  String buffer = "";
  int? register;
  String? operation;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    int parseToCents(String s) {
      if (s.isEmpty) {
        return 0;
      }

      List<String> arr = s.split(".");
      int dollars = int.parse(arr[0]);
      int cents;

      if (arr.length == 1) {
        cents = 0;
      } else if (arr[1].length == 1) {
        cents = int.parse(arr[1]) * 10;
      } else {
        cents = int.parse(arr[1]);
      }
      return dollars * 100 + cents;
    }

    String formatFromCents(int n) {
      int dollars = n ~/ 100;
      int cents = n % 100;
        return cents > 0 ? "$dollars.$cents" : "$dollars";
    }

    Button createButton(String ch) {
      int? number = int.tryParse(ch);
      VoidCallback callback;
      if (ch == "." || number != null) {
        callback = () {
          setState((){
            if (buffer.length >= 6) {
              return;
            }
            if (buffer == '0' && ch != '.') {
              buffer = ch;
              return;
            }
            buffer += ch;
          });
        };
      } else if (ch == '+' || ch == '-' || ch == 'x' || ch == '/') {
        callback = () {
          setState((){
            register = parseToCents(buffer);
            buffer = "";
            operation = ch;
          });
        };
      } else if (ch == '=') {
        callback = () {
          setState((){
            if (operation == null) {
              return;
            }

            int num1 = register!;
            int num2 = parseToCents(buffer);
            int result;

            if (operation == '+') {
              result = num1 + num2;
            } else if (operation == '-') {
              result = num1 - num2;
            } else if (operation == 'x') {
              result = num1 * num2 ~/ 100;
            } else if (operation == '/') {
              if (num2 != 0) {
                result = num1 * 100 ~/ num2;
              } else {
                result = 0;
              }
            } else {
              result = 999;
            }

            buffer = formatFromCents(result);
          });
        };
      } else if (ch == 'BS') {
        callback = () {
          setState((){
            if (buffer.length == 1) {
              buffer = "0";
              return;
            }
            buffer = buffer.substring(0, buffer.length - 1);
          });
        };

      } else {
        callback = () {};
        print("Nothing");
      }

      return Button(text: ch, callback: callback);
    }

    return Column(
      children: [
        Text("Balances"),
        Text(buffer.toString(), textScaleFactor: 5,),
        Text("Operation:" + operation.toString()),
        Text("Accumulator" + buffer.toString()),
        Text("Register" + register.toString()),
        createButton('BS'),


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
  VoidCallback? callback;
  Button({required this.text, this.callback});

  @override
  Widget build(BuildContext context) {
    return Padding(
    padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: OutlinedButton(
          onPressed: (){if (callback != null) {
            callback!();
            print("Yay");
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