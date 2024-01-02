import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:namer_app/screens/home/home_scroll_subpages.dart';
import 'package:namer_app/screens/sandbox.dart';
import 'package:namer_app/screens/settings/settings_page.dart';
import 'package:namer_app/screens/transactions/transaction_add_page.dart';
import 'package:namer_app/utils/dates.dart';
import 'package:namer_app/utils/providers.dart';
import 'package:namer_app/utils/theme.dart';
import 'package:namer_app/widgets/custom_sidebar.dart';
import 'package:namer_app/widgets/sidebar.dart';

class HomePage extends ConsumerStatefulWidget {
  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<CustomSidebarState> drawerKey = GlobalKey();
  bool _showSandbox = false;

  @override
  Widget build(BuildContext context) {
    print("Build: HomePage()");

    Period period =
        ref.watch(appStateProvider.select((appState) => appState.period));

    double drawerWidth =
        (MediaQuery.of(context).size.width - 120).clamp(0, 300);

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Home'),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          tooltip: 'Open navigation',
          onPressed: () {
            drawerKey.currentState!.toggle();
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.face),
            tooltip: 'Sandbox',
            onPressed: () {
              setState(() {
                _showSandbox = !_showSandbox;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Settings',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsPage()),
              );
            },
          ),
        ],
      ),
      body: _showSandbox
          ? Sandbox()
          : CustomSidebar(
              key: drawerKey,
              width: drawerWidth,
              drawerContents: Sidebar(period, (
                Period newPeriod, [
                DateTime? date,
              ]) {
                ref
                    .read(appStateProvider.notifier)
                    .changePeriod(newPeriod, date);
                drawerKey.currentState!.close();
              }),
              child: Column(
                children: [
                  Expanded(child: HomeScrollSubpages()),
                  ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: 200),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Spacer(
                            flex: 2,
                          ),
                          Expanded(
                            flex: 7,
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: HomeEntryButton(false),
                            ),
                          ),
                          Spacer(
                            flex: 2,
                          ),
                          Expanded(
                            flex: 7,
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: HomeEntryButton(true),
                            ),
                          ),
                          Spacer(
                            flex: 2,
                          ),
                        ],
                      ),
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
    Color color = isIncome
        ? Theme.of(context).extension<AppExtraColors>()!.incomeColor
        : Theme.of(context).extension<AppExtraColors>()!.expenseColor;
    return LayoutBuilder(
      builder: (_, constraints) => SizedBox(
        width: min(constraints.maxWidth, constraints.maxHeight),
        height: min(constraints.maxWidth, constraints.maxHeight),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: CircleBorder(),
            backgroundColor: Colors.white,
            foregroundColor: color,
            side: BorderSide(color: color, width: 6),
          ),
          child: Center(
            child: Icon(
              (isIncome ? Icons.add : Icons.remove),
              size: 45,
              color: color,
            ),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TransactionAddPage(
                  isIncome: isIncome,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
