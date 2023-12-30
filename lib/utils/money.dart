import 'package:flutter/material.dart';

// String formatMonetaryAmount(int inCents) {
//   return "\$$dollars.${cents.toString().padLeft(2, '0')}";
// }

Widget displayMonetaryAmount(
  int inCents, {
  // bool colorBySign = false,
  bool addLeadingMinusBySign = false,
}) {
  int dollars = inCents.abs() ~/ 100;
  int cents = inCents % 100;
  String dollarsFormatted = dollars.toString();
  String centsFormatted = cents.toString().padLeft(2, '0');

  return Row(
    mainAxisSize: MainAxisSize.min,
    // To align multiple Text of different sizes
    // https://stackoverflow.com/a/53759612
    crossAxisAlignment: CrossAxisAlignment.baseline,
    textBaseline: TextBaseline.alphabetic,
    children: [
      Text(
        "${addLeadingMinusBySign && inCents.isNegative ? "-" : ""}\$$dollarsFormatted",
        style: TextStyle(fontSize: 16),
      ),
      Text(
        ".",
        style: TextStyle(fontSize: 14),
      ),
      Text(
        centsFormatted,
        style: TextStyle(fontSize: 12),
      ),
    ],
  );
}
