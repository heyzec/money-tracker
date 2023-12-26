import 'package:flutter/material.dart';
import 'package:namer_app/utils/helpers.dart';

class DraggableDrawer extends StatefulWidget {
  final Function(ScrollController) scrollableBuilder;
  final Widget backgroundChild;
  final double handleHeight;
  final Widget? handleChild;

  DraggableDrawer({
    required this.backgroundChild,
    required this.scrollableBuilder,
    this.handleHeight = 50,
    this.handleChild,
  });

  @override
  State<DraggableDrawer> createState() => _DraggableDrawerState();
}

class _DraggableDrawerState extends State<DraggableDrawer> {
  DraggableScrollableController controller = DraggableScrollableController();

  double drawerSize = 1.0;

  double gestureStartLocalPosition = 0.0;
  double gestureStartSize = 0.0;

  // For debugging purposes
  double gestureUpdateLocalPositionDebug = 0.0;
  double gestureEndVelocityDebug = 0.0;

  @override
  void initState() {
    controller.addListener(() {
      setState(() {
        drawerSize = controller.size;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        double drawerHeight = constraints.maxHeight;

        double minDrawerSize = widget.handleHeight / drawerHeight;
        return Stack(
          children: [
            Opacity(
              opacity: controller.isAttached ? 1 - drawerSize : 1,
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
                  initialChildSize: minDrawerSize,
                  minChildSize: minDrawerSize,
                  maxChildSize: 1.0,
                  controller: controller,
                  builder: (
                    BuildContext context,
                    ScrollController scrollController,
                  ) {
                    return Column(
                      children: [
                        SizedBox(
                          height: drawerHeight * minDrawerSize,
                          child: getGestureDetector(minDrawerSize),
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

  GestureDetector getGestureDetector(double minDrawerSize) {
    return GestureDetector(
      onVerticalDragStart: (DragStartDetails details) {
        setState(() {
          gestureStartLocalPosition = details.localPosition.dy;
          gestureStartSize = controller.size;
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
        double newSize;
        int duration;
        if (gestureEndVelocity > thresholdVelocity) {
          newSize = 0.0;
          duration = 100;
        } else if (gestureEndVelocity < -thresholdVelocity) {
          newSize = 1.0;
          duration = 100;
        } else {
          newSize = snapToValue(
            controller.size,
            minDrawerSize,
            1.0,
          );
          duration = 200;
        }

        double deltaSize = (newSize - controller.size).abs();
        duration = (deltaSize * 1000).toInt().clamp(100, 500);
        controller.animateTo(
          newSize,
          duration: Duration(milliseconds: duration),
          curve: Curves.easeOutCubic,
        );
      },
      child: widget.handleChild ?? Container(color: Colors.orange),
    );
  }
}
