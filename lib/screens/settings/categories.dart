import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:namer_app/db/database.dart';
import 'package:namer_app/screens/settings/addcategory.dart';
import 'package:namer_app/widgets/categorycard.dart';
import 'package:namer_app/widgets/numpad/layout.dart';
import 'package:provider/provider.dart';

class CategoriesPage extends StatefulWidget {
  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  bool initalised = false;
  List<Category> allItems = [];

  Future<List<Category>>? fetch(context) async {
    if (initalised) {
      initalised = true;
      return allItems;
    }
    var items = await fetchTodoItems(context);
    setState(() {
      allItems = items;
    });
    initalised = true;
    return items;
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
          title: const Text('Categories'),
        ),
        body: FutureBuilder<List<Category>>(
          future: fetch(context),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            // if (!snapshot.hasData || snapshot.data!.isEmpty) {
            //   return Center(child: Text('No items available.'));
            // }
            print("here");
            print(allItems);

            return Column(
              children: [
                Expanded(
                  child: CardsContainer(
                    categories: allItems,
                    onSubmit: (Category item) {
                      setState(() {
                        allItems.add(item);
                      });
                    },
                  ),
                ),
                AllCategoryCards(),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<List<Category>> fetchTodoItems(context) async {
    var database = Provider.of<AppDatabase>(context);
    return database.getCategories();
  }
}

class CardsContainer extends StatelessWidget {
  final List<Category> categories;
  final Function(Category) onSubmit;

  CardsContainer({required this.categories, required this.onSubmit});

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
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddCategoryPage(onSubmit)),
          );
        },
        child: CategoryCard(iconName: "plus", text: "Add category"),
      ),
    );

    return Wrap(children: cards);
  }
}
