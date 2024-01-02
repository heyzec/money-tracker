import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:namer_app/db/database.dart';
import 'package:namer_app/screens/settings/category_add_page.dart';
import 'package:namer_app/utils/providers.dart';
import 'package:namer_app/widgets/cards/category_card.dart';

class CategoryViewPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var categories = ref.watch(categoriesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
      ),
      floatingActionButton: PopupMenuButton(
        tooltip: "Add category",
        itemBuilder: (context) => [
          PopupMenuItem(
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CategoryAddPage(
                      isIncome: true,
                      onSubmit: (Category item) {
                        ref.invalidate(categoriesProvider);
                      },
                    ),
                  ),
                );
              },
              child: Text("Add income category"),
            ),
          ),
          PopupMenuItem(
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CategoryAddPage(
                      isIncome: false,
                      onSubmit: (Category item) {
                        ref.invalidate(categoriesProvider);
                      },
                    ),
                  ),
                );
              },
              child: Text("Add expense category"),
            ),
          ),
        ],
        child: FloatingActionButton(
          onPressed: null,
          child: Icon(Icons.add),
        ),
      ),
      body: categories.when(
        data: (categories) {
          List<Category> incomeCategories =
              categories.where((category) => category.isIncome).toList();
          List<Category> expenseCategories =
              categories.where((category) => !category.isIncome).toList();

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                DividerWithSubheader('Expense'),
                Expanded(
                  child: CardsContainer(
                    categories: expenseCategories,
                    onSubmit: (Category item) {},
                  ),
                ),
                DividerWithSubheader('Income'),
                Expanded(
                  child: CardsContainer(
                    categories: incomeCategories,
                    onSubmit: (Category item) {},
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
      ),
    );
  }

  Future<List<Category>> fetchCategories(AppDatabase database) async {
    return database.getCategories().get();
  }
}

class DividerWithSubheader extends StatelessWidget {
  final String text;
  const DividerWithSubheader(this.text);

  @override
  Widget build(BuildContext context) {
    // Adapted from https://api.flutter.dev/flutter/material/Divider-class.html
    return Column(
      children: [
        Divider(),
        Container(
          padding: const EdgeInsets.only(left: 20),
          child: Align(
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.start,
            ),
          ),
        ),
      ],
    );
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
