import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:namer_app/db/database.dart';

void seedCategories(AppDatabase db) async {
  insertCategory({
    required String name,
    required String iconName,
    required int color,
  }) async {
    await db.into(db.categories).insert(
          CategoriesCompanion(
            name: Value(name),
            iconName: Value(iconName),
            color: Value(color),
          ),
        );
  }

  insertCategory(
    name: "taxi",
    iconName: "taxi",
    color: Colors.yellow.value,
  );
  insertCategory(
    name: "Camera",
    iconName: "train",
    color: Colors.yellow.value,
  );
  insertCategory(
    name: "Glasses",
    iconName: "glasses",
    color: Colors.blue.value,
  );
  insertCategory(
    name: "Gamepad",
    iconName: "gamepad",
    color: Colors.green.value,
  );
  insertCategory(
    name: "Home",
    iconName: "home",
    color: Colors.blue.value,
  );
  insertCategory(
    name: "Cocktail",
    iconName: "cocktail",
    color: Colors.yellow.value,
  );
}
