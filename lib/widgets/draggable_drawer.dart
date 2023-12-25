import 'package:flutter/material.dart';
import 'package:namer_app/utils/helpers.dart';

class DraggableDrawer extends StatefulWidget {
  @override
  State<DraggableDrawer> createState() => _DraggableDrawerState();
}

class _DraggableDrawerState extends State<DraggableDrawer> {
  DraggableScrollableController controller = DraggableScrollableController();

  double drawerSize = 1.0;

  // For debugging purposes
  double? gestureStartLocalPosition;
  double? gestureStartSize;
  double gestureUpdateLocalPosition = 0.0;
  double? gestureEndVelocity;

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
    double viewportHeight = MediaQuery.of(context).size.height;
    double appbarHeight = Scaffold.of(context).appBarMaxHeight!;
    double drawerHeight = viewportHeight - appbarHeight;
    // TODO: Remove this quickfix line
    drawerHeight -= 2.0;

    const double minDrawerSize = 0.1;

    return Scaffold(
      body: Stack(
        children: [
          Opacity(
            opacity: controller.isAttached ? 1 - drawerSize : 1,
            // duration: Duration(milliseconds: 200),
            child: Container(
              alignment: Alignment.center,
              color: Colors.yellow[50],
              child: Column(
                children: [
                  Text(
                    "Gesture start local position: ${gestureStartLocalPosition?.toStringAsFixed(2)}",
                  ),
                  Text(
                    "Gesture update local position: ${gestureUpdateLocalPosition.toStringAsFixed(2)}",
                  ),
                  Text(
                    "Controller size in pixels: ${drawerSize.toStringAsFixed(2)}",
                  ),
                  Text(
                    "Gesture end velocity: ${gestureEndVelocity?.toStringAsFixed(2)}",
                  ),
                ],
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Center(
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
                      return Container(
                        color: Colors.lightBlue[100],
                        child: Column(
                          children: [
                            SizedBox(
                              height: drawerHeight * minDrawerSize,
                              child: getGestureDetector(minDrawerSize),
                            ),
                            Expanded(
                              child: ListView.builder(
                                controller: scrollController,
                                itemCount: 25,
                                itemBuilder: (BuildContext context, int index) {
                                  return ListTile(title: Text('Item $index'));
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
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
          gestureUpdateLocalPosition = details.localPosition.dy;
        });
        var deltaInPixels =
            details.localPosition.dy - gestureStartLocalPosition!;
        var deltaInFrac = controller.pixelsToSize(deltaInPixels);
        var newFrac = gestureStartSize! - deltaInFrac;
        newFrac = newFrac.clamp(0.1, 1.0);
        controller.jumpTo(newFrac);
      },
      onVerticalDragEnd: (DragEndDetails details) {
        const thresholdVelocity = 1000;
        setState(() {
          gestureEndVelocity = details.primaryVelocity;
        });
        double newSize;
        int duration;
        if (gestureEndVelocity! > thresholdVelocity) {
          newSize = 0.0;
          duration = 100;
        } else if (gestureEndVelocity! < -thresholdVelocity) {
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
      child: Container(color: Colors.orange),
    );
  }
}
