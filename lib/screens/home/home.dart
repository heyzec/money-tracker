import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:namer_app/screens/home/home_data.dart';
import 'package:namer_app/screens/numpadpage.dart';
import 'package:namer_app/screens/settings/settings.dart';
import 'package:namer_app/utils/providers.dart';
import 'package:namer_app/widgets/sidebar.dart';

class HomePage extends ConsumerStatefulWidget {
  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

enum Period {
  day,
  week,
  month,
  year,
  interval,
  all,
}

class _HomePageState extends ConsumerState<HomePage> {
  Period period = Period.day;
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
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
            Query newQuery = ref.read(queryProvider);
            newQuery.startDate = DateTime(2020);
            newQuery.endDate = DateTime(2025);
            ref.read(queryProvider.notifier).state = newQuery;
            setState(() {
              period = newPeriod;
            });
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
                  Text("Period: $period"),
                  Text("start: $startDate"),
                  Text("end: $endDate"),
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
