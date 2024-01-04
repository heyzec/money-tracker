import 'package:intl/intl.dart';
import 'package:money_tracker/db/database.dart';

Future<String> addTransaction(List<String> args) async {
  AppDatabase database = AppDatabase();

  String dateString = args[0];
  String amountString = args[1];
  String remarksString = args[2];
  String categoryString = args[3];

  DateTime date = DateFormat('d/M/y').parse(dateString);
  int amount = int.parse(amountString);

  await database.insertTransaction(
    date: date,
    amount: amount,
    remarks: remarksString,
    categoryName: categoryString,
  );
  return "";
}
