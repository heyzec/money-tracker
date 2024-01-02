// import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' show ProviderScope;
import 'package:namer_app/utils/theme.dart';
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

@pragma('vm:entry-point')
taskerActionConfigMain(List<String> args) {
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}
