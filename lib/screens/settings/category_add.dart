import 'package:flutter/material.dart';
import 'package:namer_app/db/database.dart';
import 'package:namer_app/widgets/cards/card_selector.dart';
import 'package:namer_app/widgets/cards/category_card.dart';
import 'package:provider/provider.dart';

class CategoryAddPage extends StatefulWidget {
  final Function(Category) onSubmit;

  CategoryAddPage(this.onSubmit);

  @override
  State<CategoryAddPage> createState() => _CategoryAddPageState();
}

class _CategoryAddPageState extends State<CategoryAddPage> {
  bool initalised = false;
  List<Category> allItems = [];
  final TextEditingController _controller = TextEditingController();
  CardInfo? selected;

  void _onSubmit(context) async {
    final enteredText = _controller.text;
    if (selected == null || enteredText == "") {
      print("Bad");
      return;
    }

    var database = Provider.of<AppDatabase>(context, listen: false);

    String name = enteredText;
    String iconName = selected!.iconName;

    int id = await database.insertCategory(
      name: name,
      iconName: iconName,
    );
    widget.onSubmit(
      Category(
        id: id,
        name: name,
        iconName: iconName,
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            tooltip: 'Back',
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Text('Add new category'),
          actions: [
            IconButton(
              onPressed: () {
                _onSubmit(context);
              },
              icon: Icon(Icons.done),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _onSubmit(context);
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
                    .map((category) => CardInfo(iconName: category))
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
      ),
    );
  }
}
