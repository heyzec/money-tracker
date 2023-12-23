import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:namer_app/screens/home/home_data.dart';
import 'package:namer_app/screens/numpadpage.dart';
import 'package:namer_app/screens/settings/settings.dart';
import 'package:namer_app/utils/dates.dart';
import 'package:namer_app/utils/query_provider.dart';
import 'package:namer_app/widgets/sidebar.dart';

class HomePage extends ConsumerStatefulWidget {
  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    Query query = ref.watch(queryProvider);

    return MaterialApp(
      home: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: const Text('Home'),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.settings),
              tooltip: 'Setting Icon',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsPage()),
                );
              },
            ),
          ],
        ),
        drawer: Padding(
          padding: const EdgeInsets.fromLTRB(0, 80, 0, 0),
          child: Sidebar(query.period, (
            Period newPeriod, [
            dynamic dates,
          ]) {
            ref.read(queryProvider.notifier).changePeriod(newPeriod, dates);
            _scaffoldKey.currentState!.openEndDrawer(); // Close drawer
          }),
        ),
        body: Padding(
          padding: EdgeInsets.all(25.0),
          child: Column(
            children: [
              ViewData(
                startDate: DateTime(2000),
                endDate: DateTime(2025),
              ),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.all(16.0),
                      child: HomeEntryButton(false),
                    ),
                    Container(
                      margin: EdgeInsets.all(16.0),
                      child: HomeEntryButton(true),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  Text("Debug Info"),
                  Text("Period: ${query.period}"),
                  Text("start: ${query.getDateRange().start}"),
                  Text("end: ${query.getDateRange().end}"),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          ref.read(queryProvider.notifier).decrement();
                        },
                        icon: Icon(Icons.arrow_left),
                      ),
                      IconButton(
                        onPressed: () {
                          ref.read(queryProvider.notifier).increment();
                        },
                        icon: Icon(Icons.arrow_right),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeEntryButton extends StatelessWidget {
  final bool isIncome;

  HomeEntryButton(this.isIncome);

  @override
  Widget build(BuildContext context) {
    Color color = isIncome ? Colors.green : Colors.red;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: CircleBorder(),
        padding: EdgeInsets.all(30),
        backgroundColor: Colors.white,
        foregroundColor: color,
        side: BorderSide(color: color),
      ),
      child: Icon(
        (isIncome ? Icons.add : Icons.remove),
        size: 40,
        color: color,
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NumpadPage(
              isIncome: isIncome,
            ),
          ),
        );
      },
    );
  }
}
