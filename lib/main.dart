// import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' show ProviderScope;
import 'package:intl/intl.dart';
import 'package:money_tracker/db/database.dart';
import 'package:money_tracker/tasker/add_transaction.dart';
import 'package:money_tracker/tasker/tasker_action_pigeon.dart';
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

@pragma('vm:entry-point')
void taskerAddTransactionConfigMain(List<String> args) {
  const title = 'Tasker Action Config';

  // final input = AddTransactionInputMessage(config: args[0]);
  final input = AddTransactionInputMessage(config: "hai");

  runApp(
    MaterialApp(
      title: title,
      theme: appThemeData,
      home: NewWidget(input: input),
    ),
  );
}

class NewWidget extends StatefulWidget {
  const NewWidget({
    super.key,
    required this.input,
  });

  final AddTransactionInputMessage input;

  @override
  State<NewWidget> createState() => _NewWidgetState();
}

class _NewWidgetState extends State<NewWidget> {
  late AddTransactionInputMessage input;
  late TextEditingController controller;
  List<String> logs = [];

  @override
  void initState() {
    super.initState();
    input = widget.input;
    controller = TextEditingController(text: input.config);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        logs.add("on pop");
        try {
          if (input.config?.isNotEmpty ?? false) {
            logs.add(input.config!);
            await AddTransactionConfigApi().configDone(input);
          } else {
            logs.add("bailing");
            logs.add((input.config?.isNotEmpty == null).toString());
          }
          logs.add("retuning true");
          return true;
        } catch (e) {
          logs.add(e.toString());
        }
        return false;
      },
      child: Scaffold(
        body: Center(
          child: Column(
            children: [
              TextField(
                controller: controller,
                decoration: const InputDecoration(
                  labelText: 'Action Config',
                ),
                onChanged: (value) {
                  logs.add("Hello world");
                  setState(() {
                    input.config = value;
                  });
                },
              ),
              Column(
                children: logs.map((e) => Text(e)).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }
}

// @pragma('vm:entry-point')
// void taskerAddTransactionRunMain(List<String> args) async {
//   // String message = await doSafely(() async {
//   //   return "wow";
//   //   // return await addTransaction(args);
//   // });

//   await AddTransactionRunApi()
//       .runDone(AddTransactionOutputMessage(config: "indeed"));
// }

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
