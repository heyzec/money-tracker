import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:namer_app/db/database.dart';

void seedCategories(AppDatabase db) async {
  void insertCategory({
    required String name,
    required String iconName,
    required int color,
    required bool isIncome,
  }) async {
    await db.into(db.categories).insert(
          CategoriesCompanion(
            name: Value(name),
            iconName: Value(iconName),
            color: Value(color),
            isIncome: Value(isIncome),
          ),
        );
  }

  insertCategory(
    name: "taxi",
    iconName: "taxi",
    color: Colors.yellow.value,
    isIncome: false,
  );
  insertCategory(
    name: "Camera",
    iconName: "train",
    color: Colors.yellow.value,
    isIncome: false,
  );
  insertCategory(
    name: "Glasses",
    iconName: "glasses",
    color: Colors.blue.value,
    isIncome: false,
  );
  insertCategory(
    name: "Gamepad",
    iconName: "gamepad",
    color: Colors.green.value,
    isIncome: false,
  );
  insertCategory(
    name: "Home",
    iconName: "home",
    color: Colors.blue.value,
    isIncome: false,
  );
  insertCategory(
    name: "Cocktail",
    iconName: "cocktail",
    color: Colors.yellow.value,
    isIncome: false,
  );


  insertCategory(
    name: "Income",
    iconName: "moneyCheck",
    color: Colors.green.value,
    isIncome: true,
  );
  insertCategory(
    name: "Deposits",
    iconName: "handHoldingUsDollar",
    color: Colors.lightGreen.value,
    isIncome: true,
  );
  insertCategory(
    name: "Savings",
    iconName: "piggyBank",
    color: Colors.pink.value,
    isIncome: true,
  );
}
