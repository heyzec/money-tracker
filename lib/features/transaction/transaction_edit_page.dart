import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:money_tracker/db/database.dart';
import 'package:money_tracker/features/transaction/transaction_base_page.dart';
import 'package:money_tracker/utils/providers.dart';
import 'package:money_tracker/widgets/cards/card_selector.dart';
import 'package:money_tracker/widgets/numpad/logic.dart';

class TransactionEditPage extends ConsumerWidget {
  final Transaction transaction;
  // Ideally, this will be removed if we can access category via transaction.category like models
  final bool isIncome;

  TransactionEditPage({
    required this.transaction,
    required this.isIncome,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AppDatabase database = ref.read(databaseProvider);

    NumpadLogic logic = NumpadLogic(transaction.amount);
    DateTime initialDate = transaction.date;

    void onSubmit({
      required CardInfo cardInfo,
      required String text,
      required DateTime date,
    }) {
      database.updateTransaction(
        id: transaction.id,
        date: date,
        amount: logic.getValue(),
        remarks: text,
        categoryName: cardInfo.text!,
      );
      ref.invalidate(queryResultProvider);
      Navigator.pop(context);
    }

    void onDelete() {
      database.deleteTransaction(id: transaction.id);
      ref.invalidate(queryResultProvider);
      Navigator.pop(context);
    }

    return TransactionBasePage(
      logic: logic,
      transaction: transaction,
      initialDate: initialDate,
      onSubmit: onSubmit,
      onDelete: onDelete,
      isIncome: isIncome,
    );
  }
}
