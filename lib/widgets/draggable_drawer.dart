import 'dart:async';

import 'package:flutter/material.dart';
import 'package:money_tracker/utils/functions.dart';

/// A drawer where user can drag the handle to choose between showing
/// (a) a single page; and (b) a scrollable section
class DraggableDrawer extends StatefulWidget {
  final Widget Function(ScrollController) scrollableBuilder;
  final Widget backgroundChild;

  /// Height of handle
  final double handleHeight;

  /// A builder that builds the handle. Takes in a callback function which, on triggered,
  /// toggles the state of the drawer.
  final Widget Function(VoidCallback)? buildDrawerHandle;

  /// Whether or not the drawer should be opened initally
  final bool openDrawer;

  /// A callback for when handle has been dragged, causing state of drawer to change.
  final void Function(bool)? onUpdate;

  /// For debugging, to remove in the future
  final int pageIndex;

  DraggableDrawer({
    required this.backgroundChild,
    required this.scrollableBuilder,
    this.handleHeight = 50,
    this.buildDrawerHandle,
    this.openDrawer = false,
    this.onUpdate,
    required this.pageIndex,
  }) {
    print(
      "Construct: DraggableDrawer(pageIndex: $pageIndex, openDrawer: $openDrawer)",
    );
  }

  @override
  State<DraggableDrawer> createState() => _DraggableDrawerState();
}

class _DraggableDrawerState extends State<DraggableDrawer> {
  DraggableScrollableController controller = DraggableScrollableController();

  double gestureStartLocalPosition = 0.0;
  double gestureStartSize = 0.0;

  /// For drawer to ignore `openHandle` when manually dragged
  bool isManuallyDragged = false;

  // To change shadow opacity without using setState to avoid rebuilding entire tree
  final StreamController<double> opacityController = StreamController<double>();

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      opacityController.add(controller.size);
    });
  }

  @override
  Widget build(BuildContext context) {
    print(
      "Build: DraggableDrawer(pageIndex: ${widget.pageIndex}, openDrawer: ${widget.openDrawer})",
    );

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        double drawerHeight = constraints.maxHeight;
        double drawerHandleSize = widget.handleHeight / drawerHeight;

        if (controller.isAttached && !isManuallyDragged) {
          if (widget.openDrawer) {
            print("Animate: Opening drawer ${widget.pageIndex}");
            openDrawer();
          } else {
            print("Animate: Closing drawer ${widget.pageIndex}");
            closeDrawer();
          }
        }

        return Stack(
          children: [
            Stack(
              children: [
                SizedBox(
                  height: drawerHeight - widget.handleHeight,
                  child: widget.backgroundChild,
                ),
                StreamBuilder<double>(
                  stream: opacityController.stream,
                  builder: (context, snapshot) {
                    double opacity;
                    if (snapshot.hasData) {
                      double size = snapshot.data!;
                      opacity =
                          (size - drawerHandleSize) / (1 - drawerHandleSize);
                      // If window is resized, can go out of bounds
                      opacity = opacity.clamp(0, 1);
                    } else {
                      opacity = widget.openDrawer ? 1.0 : 0.0;
                    }
                    return Opacity(
                      opacity: opacity,
                      child: Container(color: Colors.black.withOpacity(0.5)),
                    );
                  },
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                height: drawerHeight,
                child: DraggableScrollableSheet(
                  snap: true,
                  initialChildSize: widget.openDrawer ? 1.0 : drawerHandleSize,
                  minChildSize: drawerHandleSize,
                  maxChildSize: 1.0,
                  controller: controller,
                  builder: (
                    BuildContext context,
                    ScrollController scrollController,
                  ) {
                    return Column(
                      children: [
                        SizedBox(
                          height: drawerHeight * drawerHandleSize,
                          child: getGestureDetector(drawerHandleSize),
                        ),
                        Expanded(
                          child: widget.scrollableBuilder(scrollController),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  int moveDrawerTo(double size) {
    // Speed of animation depends on how much the drawer needs to move
    double deltaSize = (size - controller.size).abs();
    int milliseconds = (deltaSize * 1000).toInt().clamp(100, 500);
    controller.animateTo(
      size,
      duration: Duration(milliseconds: milliseconds),
      curve: Curves.easeOutCubic,
    );
    return milliseconds;
  }

  void openDrawer() {
    moveDrawerTo(1.0);
  }

  void closeDrawer() {
    // 0.0 will be clamped to minChildSize parameter (minDrawerSize)
    moveDrawerTo(0.0);
  }

  GestureDetector getGestureDetector(double minDrawerSize) {
    return GestureDetector(
      onVerticalDragStart: (DragStartDetails details) {
        setState(() {
          gestureStartLocalPosition = details.localPosition.dy;
          gestureStartSize = controller.size;
          isManuallyDragged = true;
        });
      },
      onVerticalDragUpdate: (DragUpdateDetails details) {
        double deltaInPixels =
            details.localPosition.dy - gestureStartLocalPosition;
        double deltaInFrac = controller.pixelsToSize(deltaInPixels);
        double newFrac = gestureStartSize - deltaInFrac;
        newFrac = newFrac.clamp(minDrawerSize, 1.0);
        controller.jumpTo(newFrac);
      },
      onVerticalDragEnd: (DragEndDetails details) {
        const double thresholdVelocity = 1000;
        double gestureEndVelocity = details.primaryVelocity ?? 0.0;
        double newSize;

        bool openDrawer;
        if (gestureEndVelocity > thresholdVelocity) {
          openDrawer = false;
        } else if (gestureEndVelocity < -thresholdVelocity) {
          openDrawer = true;
        } else {
          openDrawer = snapToValue(controller.size, minDrawerSize, 1.0) == 1.0;
        }

        widget.onUpdate!(openDrawer);
        newSize = openDrawer ? 1.0 : 0.0;

        int _ = moveDrawerTo(newSize);
        setState(() {
          isManuallyDragged = false;
        });
      },
      child: widget.buildDrawerHandle != null
          ? widget.buildDrawerHandle!(() {
              if (controller.size < 0.6) {
                openDrawer();
              } else {
                closeDrawer();
              }
            })
          : Container(),
    );
  }
}
