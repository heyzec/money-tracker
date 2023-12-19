import 'package:flutter/material.dart';
import 'package:namer_app/db/database.dart';
import 'package:namer_app/widgets/categorycard.dart';
import 'package:provider/provider.dart';
import 'package:drift/drift.dart' show Value;

class AddCategoryPage extends StatefulWidget {
  final Function(Category) onSubmit;

  AddCategoryPage(this.onSubmit);

  @override
  State<AddCategoryPage> createState() => _AddCategoryPageState();
}

class _AddCategoryPageState extends State<AddCategoryPage> {
  bool initalised = false;
  List<Category> allItems = [];
  final TextEditingController _controller = TextEditingController();

  void _onSubmit(context) async {
    var database = Provider.of<AppDatabase>(context, listen: false);
    final enteredText = _controller.text;

    int id = await database.insertCategory(
      CategoriesCompanion(
        name: Value(enteredText),
        iconName: Value("home"),
      ),
    );
    widget.onSubmit(
      Category(
        id: id,
        name: enteredText,
        iconName: "plus",
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
              AllCategoryCards(),
            ],
          ),
        ),
      ),
    );
  }
}

class CardsContainer2 extends StatelessWidget {
  final List<Category> categories;

  CardsContainer2({required this.categories});

  @override
  Widget build(BuildContext context) {
    List<Widget> cards = List.from(
      categories.map(
        (category) => CategoryCard(
          text: category.name,
          iconName: category.iconName,
        ),
      ),
    );
    cards.add(
      ElevatedButton(
        onPressed: () {},
        child: CategoryCard(iconName: "plus", text: "Add category"),
      ),
    );

    return Wrap(children: cards);
  }
}
