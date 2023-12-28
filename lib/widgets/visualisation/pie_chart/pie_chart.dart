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

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    final Path path = Path();
    final double centerX = rect.center.dx;
    final double centerY = rect.center.dy;

    path.moveTo(centerX, centerY); // Move to the center of the circle
    path.lineTo(
      centerX + rect.width / 2 * cos(_degreesToRadians(startAngle)),
      centerY + rect.height / 2 * sin(_degreesToRadians(startAngle)),
    );
    path.arcTo(
      rect,
      _degreesToRadians(startAngle),
      _degreesToRadians(sweepAngle),
      false,
    ); // Arc representing the pie slice
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
    var pieSliceShape =
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
