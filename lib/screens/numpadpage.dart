import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:namer_app/widgets/numpad.dart';

class NumpadPage extends StatelessWidget {
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
        body: Numpad(),
      )
    );
  }
}
