import 'package:flutter/material.dart';
import 'package:namer_app/screens/settings.dart';
import 'package:namer_app/widgets/numpad/layout.dart';
import 'package:namer_app/screens/numpadpage.dart';

class HomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
  final theme = Theme.of(context);

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.comment),
              tooltip: 'Comment Icon',
              onPressed: () {},
            ), //IconButton
            IconButton(
              icon: const Icon(Icons.settings),
              tooltip: 'Setting Icon',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsPage())
                );
              },
            ), //IconButton
          ], //<Widget
        ),
      drawer: Drawer(
          // Add a ListView to the drawer. This ensures the user can scroll
          // through the options in the drawer if there isn't enough vertical
          // space to fit everything.
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: [
              ListTile(
                title: const Text('Item 1'),
                onTap: () {
                  // Update the state of the app.
                  // ...
                },
              ),
              ListTile(
                title: const Text('Item 2'),
                onTap: () {
                  // Update the state of the app.
                  // ...
                },
              ),
            ],
          ),
        ),

    body: Column(
      children: [
        Placeholder(),
        Text("Balances"),
        Center(

            child:
          Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    Container(
      margin: EdgeInsets.all(16.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: CircleBorder(),
          padding: EdgeInsets.all(30), // Adjust the padding to make the button bigger
          backgroundColor: Colors.blue,
          foregroundColor: Colors.red,
        ),
        child: Icon(Icons.add, size: 40, color: Colors.white), // Adjust the icon size
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NumpadPage()),
          );
        },
      ),
    ),
    Container(
      margin: EdgeInsets.all(16.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: CircleBorder(),
          padding: EdgeInsets.all(30), // Adjust the padding to make the button bigger
          backgroundColor: Colors.blue,
          foregroundColor: Colors.red,
        ),
        child: Icon(Icons.remove, size: 40, color: Colors.white), // Adjust the icon size
        onPressed: () {
          // Handle onPressed for the second button
        },
      ),
    ),
  ],
)

        )
      ])
    )
    );
  }

}