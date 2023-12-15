import 'package:flutter/material.dart';
import 'package:namer_app/numpad.dart';
import 'package:namer_app/numpadpage.dart';

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
              onPressed: () {},
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
          Row(children: [

          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: CircleBorder(),
              padding: EdgeInsets.all(20),
              backgroundColor: Colors.blue, // <-- Button color
              foregroundColor: Colors.red, // <-- Splash color
            ),
            child: Icon(Icons.add, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NumpadPage())
              );
            },
          ),
          ElevatedButton(
            onPressed: () {},
            child: Icon(Icons.remove, color: Colors.white),
            style: ElevatedButton.styleFrom(
              shape: CircleBorder(),
              padding: EdgeInsets.all(20),
              backgroundColor: Colors.blue, // <-- Button color
              foregroundColor: Colors.red, // <-- Splash color
            )
          ),
        ])
        )
      ])
    )
    );
  }

}