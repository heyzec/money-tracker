// import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' show ProviderScope;
import 'package:namer_app/tasker/tasker_action_pigeon.dart';
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
void taskerActionConfigMain(List<String> args) {
  const title = 'Tasker Action Config';

  final input = TaskerActionInput(config: args[0]);

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

  final TaskerActionInput input;

  @override
  State<NewWidget> createState() => _NewWidgetState();
}

class _NewWidgetState extends State<NewWidget> {
  late TaskerActionInput input;
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
            await TaskerActionConfigApi().configDone(input);
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
