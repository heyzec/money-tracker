import 'package:flutter/material.dart';

Color appBackgroundColor = Colors.green[100]!;

const Color appIncomeColor = Colors.green;
const Color appExpenseColor = Colors.red;

ButtonStyle appRoundedButtonStyle = ButtonStyle(
  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
    RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(7.0),
    ),
  ),
);
