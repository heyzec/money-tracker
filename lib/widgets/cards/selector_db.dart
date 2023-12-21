import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:namer_app/db/database.dart';
import 'package:namer_app/widgets/cards/card_selector.dart';

class SelectorWithDbItems extends ConsumerStatefulWidget {
  final Function(String) onSelectCallback;

  SelectorWithDbItems(this.onSelectCallback);

  @override
  ConsumerState<SelectorWithDbItems> createState() =>
      _SelectorWithDbItemsState();
}

class _SelectorWithDbItemsState extends ConsumerState<SelectorWithDbItems> {
  List<Category>? categories;

  Future<List<Category>>? fetch(AppDatabase database) async {
    if (categories != null) {
      return categories!;
    }
    var items = await database.getCategories().get();
    setState(() {
      categories = items;
    });
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetch(ref.read(databaseProvider)),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No items available.'));
        }
        var categories = snapshot.data!;
        return CardSelector(
          categories: categories
              .map(
                (category) => CardInfo(
                  iconName: category.iconName,
                  text: category.name,
                ),
              )
              .toList(),
          onSelectCallback: (CardInfo card) {
            widget.onSelectCallback(card.text!);
          },
        );
      },
    );
  }
}
