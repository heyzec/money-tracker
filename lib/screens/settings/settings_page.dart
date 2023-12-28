import 'package:flutter/material.dart';
import 'package:namer_app/screens/settings/category_view_page.dart';

class SettingsPage extends StatelessWidget {
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
          title: const Text('Settings'),
        ),
        body: ListView(
          children: [
            ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CategoryViewPage()),
                );
              },
              title: Card(
                child: Container(
                  height: 50,
                  // color: Colors.amber[600],
                  child: const Center(child: Text('Categories')),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
