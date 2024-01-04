// import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' show ProviderScope;
import 'package:money_tracker/tasker/add_transaction.dart';
import 'package:money_tracker/tasker/add_transaction.g.dart';
import 'package:money_tracker/utils/theme.dart';

// import 'package:noob/noob.dart';

import 'screens/home/home_page.dart';

void main() async {
  debugPaintSizeEnabled = false;
  //  // initialize `TrackingBuildOwnerWidgetsFlutterBinding` to enable tracking
  // TrackingBuildOwnerWidgetsFlutterBinding.ensureInitialized();

  // // initialize `BuildTracker`
  // final tracker = BuildTracker(printBuildFrameIncludeRebuildDirtyWidget: false);

  // // print top 10 stacks leading to rebuilds every 10 seconds
  // Timer.periodic(const Duration(seconds: 10), (_) => tracker.printTopScheduleBuildForStacks());

  SystemChrome.setSystemUIOverlayStyle(overlayStyle);
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );

  WidgetsFlutterBinding.ensureInitialized();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const appName = 'Money Tracker';

    return MaterialApp(
      title: appName,
      theme: appThemeData,
      home: HomePage(),
    );
  }
}

/// Catches errors which would otherwise be swallowed silently by Flutter
Future<String> doSafely(Future<String> Function() todo) async {
  try {
    return await todo();
  } catch (e) {
    return e.toString();
  }
}

@pragma('vm:entry-point')
void taskerAddTransactionRunMain(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();

  String errMsg = await doSafely(() => addTransaction(args));

  AddTransactionOutputMessage obj;
  if (errMsg.isEmpty) {
    obj = AddTransactionOutputMessage(isError: false);
  } else {
    obj = AddTransactionOutputMessage(isError: true, err: 1, errMsg: errMsg);
  }

  await AddTransactionRunApi().runDone(obj);
}
