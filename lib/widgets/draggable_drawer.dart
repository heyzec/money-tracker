import 'package:flutter/material.dart';
import 'package:namer_app/utils/helpers.dart';

class DraggableDrawer extends StatefulWidget {
  final Widget Function(ScrollController) scrollableBuilder;
  final Widget backgroundChild;
  final double handleHeight;
  final Widget Function(VoidCallback)? buildDrawerHandle;
  final bool openDrawerInitially;

  DraggableDrawer({
    required this.backgroundChild,
    required this.scrollableBuilder,
    this.handleHeight = 50,
    this.buildDrawerHandle,
    this.openDrawerInitially = false,
  });

  @override
  State<DraggableDrawer> createState() => _DraggableDrawerState();
}

class _DraggableDrawerState extends State<DraggableDrawer> {
  DraggableScrollableController controller = DraggableScrollableController();

  double gestureStartLocalPosition = 0.0;
  double gestureStartSize = 0.0;

  // For debugging purposes
  double gestureUpdateLocalPositionDebug = 0.0;
  double gestureEndVelocityDebug = 0.0;

  bool isManuallyDragged = false;

  @override
  void initState() {
    // controller.addListener(() {
    //   // Wrap setState in a future to delay it to the next tick.
    //   // This avoids the "setState() or markNeedsBuild() called during build" error
    //   Future.delayed(Duration.zero, () async {
    //     print(controller.size);
    //   });
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        double drawerHeight = constraints.maxHeight;
        double drawerHandleSize = widget.handleHeight / drawerHeight;

        if (controller.isAttached && !isManuallyDragged) {
          // print("Updating a drawer state, ${widget.hashCode}");
          if (widget.openDrawerInitially) {
            openDrawer();
          } else {
            closeDrawer();
          }
        }

        return Stack(
          children: [
            Opacity(
              opacity: controller.isAttached ? controller.size : 1,
              child: SizedBox(
                height: drawerHeight - widget.handleHeight,
                child: Container(
                  alignment: Alignment.center,
                  color: Colors.yellow[50],
                  child: widget.backgroundChild,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                height: drawerHeight,
                child: DraggableScrollableSheet(
                  snap: true,
                  initialChildSize: drawerHandleSize,
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

  void moveDrawerTo(
    double size,
    int milliseconds,
    /* [bool animate = true] */
  ) {
    controller.animateTo(
      size,
      duration: Duration(milliseconds: milliseconds),
      curve: Curves.easeOutCubic,
    );
  }

  void openDrawer([int milliseconds = 300]) {
    moveDrawerTo(1.0, milliseconds);
  }

  void closeDrawer([int milliseconds = 300]) {
    // 0.0 will be clamped to minChildSize parameter (minDrawerSize)
    moveDrawerTo(0.0, milliseconds);
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
        setState(() {
          gestureUpdateLocalPositionDebug = details.localPosition.dy;
        });
        var deltaInPixels =
            details.localPosition.dy - gestureStartLocalPosition;
        var deltaInFrac = controller.pixelsToSize(deltaInPixels);
        var newFrac = gestureStartSize - deltaInFrac;
        newFrac = newFrac.clamp(minDrawerSize, 1.0);
        controller.jumpTo(newFrac);
      },
      onVerticalDragEnd: (DragEndDetails details) {
        setState(() {
          gestureEndVelocityDebug = details.primaryVelocity ?? 1337;
        });

        const double thresholdVelocity = 1000;
        double gestureEndVelocity = details.primaryVelocity ?? 0.0;
        if (gestureEndVelocity > thresholdVelocity) {
          closeDrawer(100);
          setState(() {
            isManuallyDragged = false;
          });
          return;
        }
        if (gestureEndVelocity < -thresholdVelocity) {
          openDrawer(100);
          setState(() {
            isManuallyDragged = false;
          });
          return;
        }
        double newSize = snapToValue(
          controller.size,
          minDrawerSize,
          1.0,
        );

        // Speed of animation depends on how much the drawer needs to move
        double deltaSize = (newSize - controller.size).abs();
        int milliseconds = (deltaSize * 1000).toInt().clamp(100, 500);
        moveDrawerTo(newSize, milliseconds);
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
          : Container(color: Colors.orange),
    );
  }
}
