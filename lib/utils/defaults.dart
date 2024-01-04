import 'package:flutter/material.dart';
import 'package:money_tracker/utils/colors.dart';

Map<String, Color> iconNameToColors = {
  // Income
  "moneyCheck": Colors.green,
  "handHoldingUsDollar": Colors.lightGreen,
  "piggyBank": Colors.pink,

  // Expense
  "gamepad": Colors.green,
  // "taxi": Colors.yellow,
  "cocktail": Colors.orange,
  "utensils": Colors.lightGreen,
  "shoppingBag": Colors.blue,
  "gift": Colors.purple,
  "cookieBite": Colors.lightGreenAccent,
  "subway": Colors.pink,
  "fileInvoiceWithUsDollar": Colors.yellow,
  "shapes": Colors.grey,
};

Map<String, Color> iconNameToMutedColors =
    iconNameToColors.map((key, value) => MapEntry(key, value.muted()));

Map<String, (String, bool)> iconNameToDetails = {
  // Income
  "moneyCheck": ("Salary", true),
  "handHoldingUsDollar": ("Deposits", true),
  "piggyBank": ("Savings", true),

  // Expense
  "gamepad": ("Entertainment", false),
  "cocktail": ("Drinks", false),
  "utensils": ("Eating out", false),
  "shoppingBag": ("Shopping", false),
  "gift": ("Gifts", false),
  "cookieBite": ("Snacks", false),
  "subway": ("Transport", false),
  "fileInvoiceWithUsDollar": ("Bills", false),
  "shapes": ("Others", false),
};

typedef CategoryRecord = ({
  String iconName,
  Color color,
  String name,
  bool isIncome,
});

List<CategoryRecord> getDefaultCategories() {
  assert(iconNameToColors.length == iconNameToDetails.length);
  List<CategoryRecord> output = [];
  for (String iconName in iconNameToDetails.keys) {
    output.add(
      (
        iconName: iconName,
        color: iconNameToMutedColors[iconName]!,
        name: iconNameToDetails[iconName]!.$1,
        isIncome: iconNameToDetails[iconName]!.$2,
      ),
    );
  }
  return output;
}
