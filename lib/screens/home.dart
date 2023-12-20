import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:namer_app/db/database.dart';
import 'package:namer_app/screens/settings/settings.dart';
import 'package:namer_app/screens/numpadpage.dart';
import 'package:namer_app/widgets/cards/category_card.dart';
import 'package:namer_app/widgets/sidebar.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

enum Period {
  day,
  week,
  month,
  year,
  interval,
  all,
}

class _HomePageState extends State<HomePage> {
  Period period = Period.day;
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return MaterialApp(
      home: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: const Text('Home'),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.comment),
              tooltip: 'Comment Icon',
              onPressed: () {},
            ),
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
          child: Sidebar(period, (Period newPeriod, [dynamic dates]) {
            if (newPeriod == Period.interval) {
              DateTimeRange dateRange = dates as DateTimeRange;
              startDate = dateRange.start;
              endDate = dateRange.end;
            } else if (dates != null) {
              DateTime date = dates as DateTime;
              startDate = date;
              endDate = date;
            }

            setState(() {
              period = newPeriod;
            });
            _scaffoldKey.currentState!.openEndDrawer(); // Close drawer
          }),
        ),
        body: Column(
          children: [
            Text("Period: $period"),
            Text("start: $startDate"),
            Text("end: $endDate"),
            Placeholder(),
            Text("Balances"),
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
          ],
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
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: CircleBorder(),
        padding: EdgeInsets.all(30),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.red,
      ),
      child: Icon(
        (isIncome ? Icons.add : Icons.remove),
        size: 40,
        color: Colors.white,
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => NumpadPage()),
        );
      },
    );
  }
}
