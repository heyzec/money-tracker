import 'package:flutter/material.dart';
import 'package:namer_app/utils/constants.dart';
import 'package:namer_app/widgets/numpad/logic.dart';

extension ListSpaceBetweenExtension on List<Widget> {
  List<Widget> withSpaceBetween({double? width, double? height}) => [
        for (int i = 0; i < length; i++) ...[
          if (i > 0) SizedBox(width: width, height: height),
          this[i],
        ],
      ];
}

String actionToDisplay(String action) {
  switch (action) {
    case "x":
      return charTimes;
    case "/":
      return charDivision;
    default:
      return action;
  }
}

class NumpadLayout extends StatelessWidget {
  final NumpadLogic logic;

  NumpadLayout({required this.logic});

  _NumpadButton _createButton(String action) {
    return _NumpadButton(
      action: action,
      onPressed: () {
        logic.handle(action);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(child: _createButton('1')),
                    Expanded(child: _createButton('2')),
                    Expanded(child: _createButton('3')),
                    Expanded(child: _createButton('+')),
                  ].withSpaceBetween(width: 5.0),
                ),
              ),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(child: _createButton('4')),
                    Expanded(child: _createButton('5')),
                    Expanded(child: _createButton('6')),
                    Expanded(child: _createButton('-')),
                  ].withSpaceBetween(width: 5.0),
                ),
              ),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(child: _createButton('7')),
                    Expanded(child: _createButton('8')),
                    Expanded(child: _createButton('9')),
                    Expanded(child: _createButton('x')),
                  ].withSpaceBetween(width: 5.0),
                ),
              ),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(child: _createButton('0')),
                    Expanded(child: _createButton('.')),
                    Expanded(child: _createButton('=')),
                    Expanded(child: _createButton('/')),
                  ].withSpaceBetween(width: 5.0),
                ),
              ),
            ].withSpaceBetween(height: 5.0),
          ),
        ),
      ],
    );
  }
}

class _NumpadButton extends StatelessWidget {
  final String action;
  final VoidCallback? onPressed;

  _NumpadButton({required this.action, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () {
        if (onPressed != null) {
          onPressed!();
        }
      },
      child: Text(
        actionToDisplay(action),
        textScaleFactor: 2,
      ),
    );
  }
}
