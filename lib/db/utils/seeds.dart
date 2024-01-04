import 'package:drift/drift.dart';
import 'package:money_tracker/db/database.dart';
import 'package:money_tracker/utils/defaults.dart';

void seedCategories(AppDatabase db) async {
  getDefaultCategories().forEach((item) {
    db.into(db.categories).insert(
          CategoriesCompanion(
            name: Value(item.name),
            iconName: Value(item.iconName),
            color: Value(item.color.value),
            isIncome: Value(item.isIncome),
          ),
        );
  });
}
