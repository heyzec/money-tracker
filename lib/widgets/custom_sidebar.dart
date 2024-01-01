import 'package:flutter/material.dart';

/// A wrapper of Drawer and DrawerController
/// Useful for building sidebar that are below AppBar
/// Make sure drawer is not rebuilt when animating open/close state
class CustomSidebar extends StatefulWidget {
  final Widget child;
  final Widget drawerContents;
  final double? width;

  CustomSidebar({
    required key,
    required this.child,
    required this.drawerContents,
    this.width,
  }) : super(key: key);

  @override
  State<CustomSidebar> createState() => CustomSidebarState();
}

class CustomSidebarState extends State<CustomSidebar> {
  GlobalKey<DrawerControllerState> key = GlobalKey();
  // To store state without using setState to not trigger rebuilds
  List<bool> hackyDrawerState = [false];

  void open() => key.currentState!.open();

  void close() => key.currentState!.close();

  void toggle() {
    if (hackyDrawerState[0]) {
      close();
    } else {
      open();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        // Container(
        //   color: Colors.amber,
        // ),
        DrawerController(
          key: key,
          alignment: DrawerAlignment.start,
          drawerCallback: (b) {
            hackyDrawerState[0] = b;
          },
          child: Drawer(
            width: widget.width,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            child: widget.drawerContents,
            // Container(
            //   color: Colors.blue,
            // ),
          ),
        ),
      ],
    );
  }
}
