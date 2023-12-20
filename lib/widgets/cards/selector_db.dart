import 'package:flutter/material.dart';
import 'package:namer_app/db/database.dart';
import 'package:namer_app/widgets/cards/card_selector.dart';
import 'package:provider/provider.dart';

class SelectorWithDbItems extends StatefulWidget {
  final Function(String) onSelectCallback;

  SelectorWithDbItems(this.onSelectCallback);

  @override
  State<SelectorWithDbItems> createState() => _SelectorWithDbItemsState();
}

class _SelectorWithDbItemsState extends State<SelectorWithDbItems> {
  List<Category>? categories;

  Future<List<Category>>? fetch(context) async {
    if (categories != null) {
      return categories!;
    }
    var database = Provider.of<AppDatabase>(context);
    var items = await database.getCategories();
    setState(() {
      categories = items;
    });
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetch(context),
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
