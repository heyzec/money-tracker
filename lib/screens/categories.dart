import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:namer_app/db/database.dart';
import 'package:provider/provider.dart';

class CategoriesPage extends StatefulWidget {
  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  List<Category> allItems = [];

  Future<void> _initializeStateVariables(context) async {
    var items = await fetchTodoItems(context);

    print("Allitems $allItems");
    print("items $items");
    if (allItems != []) {
      return;
    }
    // Update state variables when the asynchronous task is complete
    setState(() {
      allItems = items;
    });
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
          future: fetchTodoItems(context),
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

            _initializeStateVariables(context);

            return Column(
              children: [
                Enter(),
                Expanded(
                  child: Cards(items: allItems.map((emp) => emp.name).toList()),
                ),
                Text("LOL"),
                ElevatedButton(onPressed: () {
                  print("Pressed");
                }, child: Text("Refresh"))
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

class Enter extends StatelessWidget {

  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(context) {
            var database = Provider.of<AppDatabase>(context);

            return Row(
  children: [
    Expanded(
      child: TextFormField(
        controller: _controller,
        decoration: InputDecoration(labelText: 'Category name'),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter some text';
          }
          return null;
        },
      ),
    ),
    SizedBox(width: 16.0),
    ElevatedButton(
      onPressed: () {
        final enteredText = _controller.text;
        database.insertCategory(CategoriesCompanion(name: Value(enteredText)));
      },
      child: Text('Submit'),
    ),
  ],
);


  }

}

class Cards extends StatelessWidget {
  final List<String> items;

  // Constructor taking in a parameter
  Cards({required this.items});

  @override
  Widget build(BuildContext context) {
    print(items);

    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        var item = items[index];
        print(index);
        print(item);

        return ListTile(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Placeholder()),
            );
          },
          title: Container(
            height: 50,
            color: Colors.amber[600],
            child: Center(child: Text(item)),
          ),
        );
      },
    );
  }
}
