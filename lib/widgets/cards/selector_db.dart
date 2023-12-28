import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:namer_app/utils/providers.dart';
import 'package:namer_app/widgets/cards/card_selector.dart';

class SelectorWithDbItems extends ConsumerWidget {
  // TODO: Merge this class with NumpadPage
  final Function(String) onSelectCallback;
  final bool isIncome;

  SelectorWithDbItems(this.onSelectCallback, this.isIncome);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var categories = ref.watch(categoriesProvider);

    return categories.when(
      data: (categories) {
        var filtered =
            categories.where((category) => category.isIncome == isIncome);
        return CardSelector(
          categories: filtered
              .map(
                (category) => CardInfo(
                  iconName: category.iconName,
                  text: category.name,
                  color: Color(category.color),
                ),
              )
              .toList(),
          onSelectCallback: (CardInfo card) {
            onSelectCallback(card.text!);
          },
        );
      },
      loading: () => Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text('Error: $error')),
    );
  }
}
