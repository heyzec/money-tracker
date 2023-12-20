import 'package:flutter/material.dart';
import 'package:namer_app/db/database.dart';
import 'package:namer_app/screens/settings/category_add.dart';
import 'package:namer_app/widgets/cards/category_card.dart';
import 'package:provider/provider.dart';

class CategoryViewPage extends StatefulWidget {
  @override
  State<CategoryViewPage> createState() => _CategoryViewPageState();
}

class _CategoryViewPageState extends State<CategoryViewPage> {
  List<Category>? allItems;

  Future<List<Category>>? fetch(context) async {
    if (allItems != null) {
      return allItems!;
    }
    var items = await fetchCategories(context);
    setState(() {
      allItems = items;
    });
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
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CategoryAddPage((Category item) {
                  setState(() {
                    allItems?.add(item);
                  });
                }),
              ),
            );
          },
          child: Icon(Icons.add),
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
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No items available.'));
            }
            var items = snapshot.data!;

            return Column(
              children: [
                Expanded(
                  child: CardsContainer(
                    categories: items,
                    onSubmit: (Category item) {
                      setState(() {
                        items.add(item);
                      });
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<List<Category>> fetchCategories(context) async {
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

    return Wrap(children: cards);
  }
}
