import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:money_tracker/db/database.dart';
import 'package:money_tracker/utils/colors.dart';
import 'package:money_tracker/utils/providers.dart';
import 'package:money_tracker/widgets/cards/card_selector.dart';
import 'package:money_tracker/widgets/cards/category_card.dart';

class CategoryAddPage extends ConsumerStatefulWidget {
  final bool isIncome;
  final Function(Category) onSubmit;

  CategoryAddPage({required this.isIncome, required this.onSubmit});

  @override
  ConsumerState<CategoryAddPage> createState() => _CategoryAddPageState();
}

class _CategoryAddPageState extends ConsumerState<CategoryAddPage> {
  bool initalised = false;
  List<Category> allItems = [];
  final TextEditingController _controller = TextEditingController();
  CardInfo? selected;

  void _onSubmit(AppDatabase database) async {
    final enteredText = _controller.text;
    if (selected == null || enteredText == "") {
      print("Bad");
      return;
    }

    String name = enteredText;
    String iconName = selected!.iconName;
    Color color = selected!.color;

    int id = await database.insertCategory(
      name: name,
      iconName: iconName,
      color: color.value,
      isIncome: widget.isIncome,
    );
    widget.onSubmit(
      Category(
        id: id,
        name: name,
        iconName: iconName,
        color: color.value,
        isIncome: widget.isIncome,
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Add new category (${widget.isIncome ? 'income' : 'expense'})",
        ),
        actions: [
          IconButton(
            onPressed: () {
              _onSubmit(ref.read(databaseProvider));
            },
            icon: Icon(Icons.done),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: "Done",
        onPressed: () {
          _onSubmit(ref.read(databaseProvider));
        },
        child: Icon(Icons.check),
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextFormField(
              controller: _controller,
              decoration: InputDecoration(labelText: 'Category name'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
            CardSelector(
              categories: ALL
                  .map(
                    (category) => CardInfo(
                      iconName: category,
                      color: iconNametoColor(category),
                    ),
                  )
                  .toList(),
              onSelectCallback: (CardInfo card) {
                setState(() {
                  selected = card;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
