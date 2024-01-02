import 'dart:math';
import 'package:flutter/material.dart';

class PieSliceInfo {
  double startAngle;
  double sweepAngle;
  Color color;
  String? categoryName;

  PieSliceInfo({
    required this.startAngle,
    required this.sweepAngle,
    required this.color,
    this.categoryName,
  });

  @override
  String toString() {
    return "PieSliceInfo($startAngle, $sweepAngle, $color)";
  }
}

class PieChart extends StatefulWidget {
  // final double _holeRadius = 50.0;

  final List<PieSliceInfo> slices;

  PieChart(this.slices);

  @override
  State<PieChart> createState() => _PieChartState();
}

class _PieChartState extends State<PieChart> {
  String? text;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Stack(
          children: widget.slices
              .map(
                (slice) => _PieSliceButton(
                  onPressed: () {},
                  onHover: (b) {
                    if (!b) {
                      return;
                    }
                    setState(() {
                      text = slice.categoryName;
                    });
                  },
                  startAngle: slice.startAngle,
                  sweepAngle: slice.sweepAngle,
                  color: slice.color,
                ),
              )
              .toList(),
        ),
        // For debugging purpose
        Center(child: Text(text.toString())),
      ],
    );
  }
}

double _degreesToRadians(double degrees) {
  return degrees * pi / 180;
}

class _PieSliceBorder extends OutlinedBorder {
  final double startAngle;
  final double sweepAngle;

  _PieSliceBorder({
    required this.startAngle,
    required this.sweepAngle,
  });

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.all(0);

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return Path(); // No inner path for a pie slice
  }

  static const double holeRatio = 0.6;

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    final Path path = Path();
    final double centerX = rect.center.dx;
    final double centerY = rect.center.dy;
    final double radius = min(rect.width, rect.height) / 2;

    double sweepAngle = this.sweepAngle;

    // Handle edge case, Path.arcTo will not draw anything if sweepAngle is 360
    if (sweepAngle == 360) {
      // Hacky way to handle edge case. Original way no longer works now that we need a hole.
      sweepAngle = 360 - 0.00001;
      // path.addOval(rect);
      // return path;
    }

    Rect boundingSquareLarge = Rect.fromCenter(
      center: Offset(centerX, centerY),
      width: radius * 2,
      height: radius * 2,
    );

    Rect boundingSquareSmall = Rect.fromCenter(
      center: Offset(centerX, centerY),
      width: radius * 2 * holeRatio,
      height: radius * 2 * holeRatio,
    );
    path.arcTo(
      boundingSquareLarge,
      _degreesToRadians(startAngle),
      _degreesToRadians(sweepAngle),
      false,
    );

    path.arcTo(
      boundingSquareSmall,
      _degreesToRadians(startAngle + sweepAngle),
      _degreesToRadians(-sweepAngle),
      false,
    );

    path.close();

    return path;
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {}

  @override
  _PieSliceBorder copyWith({BorderSide? side}) {
    return _PieSliceBorder(
      startAngle: startAngle,
      sweepAngle: sweepAngle,
    );
  }

  @override
  ShapeBorder scale(double t) => this;
}

class _PieSliceButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Function(bool) onHover;
  final double startAngle;
  final double sweepAngle;
  final Color color;

  _PieSliceButton({
    required this.onPressed,
    required this.onHover,
    required this.startAngle,
    required this.sweepAngle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    OutlinedBorder pieSliceShape =
        _PieSliceBorder(startAngle: startAngle, sweepAngle: sweepAngle);
    return Material(
      color: color,
      shape: pieSliceShape,
      child: InkWell(
        onTap: onPressed,
        onHover: onHover,
        customBorder: pieSliceShape,
      ),
    );
  }
}
