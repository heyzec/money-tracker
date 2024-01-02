import 'package:flutter/material.dart';
import 'package:namer_app/screens/settings/category_view_page.dart';
import 'package:namer_app/screens/settings/data/import_data_page.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
            leading: Icon(Icons.category),
            title: Text('Categories'),
            subtitle: Text("Add income and expense categories"),
          ),
          ListTile(
            onTap: () async {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ImportDataPage()),
              );
              return;
            },
            leading: Icon(Icons.download),
            title: Text('Data'),
            subtitle: Text("Import data from csv"),
          ),
        ],
      ),
    );
  }
}
