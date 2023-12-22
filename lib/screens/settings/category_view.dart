import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:namer_app/db/database.dart';
import 'package:namer_app/screens/settings/category_add.dart';
import 'package:namer_app/utils/providers.dart';
import 'package:namer_app/widgets/cards/category_card.dart';

class CategoryViewPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var categories = ref.watch(categoriesProvider);

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
                  ref.invalidate(categoriesProvider);
                }),
              ),
            );
          },
          child: Icon(Icons.add),
        ),
        body: categories.when(
          data: (data) => Column(
            children: [
              Expanded(
                child: CardsContainer(
                  categories: data,
                  onSubmit: (Category item) {},
                ),
              ),
            ],
          ),
          loading: () => Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(child: Text('Error: $error')),
        ),
      ),
    );
  }

  Future<List<Category>> fetchCategories(AppDatabase database) async {
    return database.getCategories().get();
  }
}

class CardsContainer extends StatelessWidget {
  final List<Category> categories;
  final Function(Category) onSubmit; // Unused

  CardsContainer({required this.categories, required this.onSubmit});

  @override
  Widget build(BuildContext context) {
    List<Widget> cards = List.from(
      categories.map(
        (category) => CategoryCard(
          text: category.name,
          iconName: category.iconName,
          color: Color(category.color),
        ),
      ),
    );

    return Wrap(children: cards);
  }
}
