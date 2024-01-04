import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:money_tracker/db/database.dart';
import 'package:money_tracker/screens/transactions/transaction_base_page.dart';
import 'package:money_tracker/utils/providers.dart';
import 'package:money_tracker/widgets/cards/card_selector.dart';
import 'package:money_tracker/widgets/numpad/logic.dart';

class TransactionAddPage extends ConsumerWidget {
  final bool isIncome;

  TransactionAddPage({required this.isIncome});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    NumpadLogic logic = NumpadLogic();
    DateTime initialDate = DateTime.now();

    void onSubmit({
      required CardInfo cardInfo,
      required String text,
      required DateTime date,
    }) {
      AppDatabase database = ref.read(databaseProvider);
      database.insertTransaction(
        date: date,
        amount: logic.getValue(),
        remarks: text,
        categoryName: cardInfo.text!,
      );
      ref.invalidate(queryResultProvider);
      Navigator.pop(context);
    }

    return TransactionBasePage(
      isIncome: isIncome,
      onSubmit: onSubmit,
      logic: logic,
      initialDate: initialDate,
    );
  }
}
