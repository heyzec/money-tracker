import 'dart:math';
import 'package:flutter/material.dart';

class PieSliceInfo {
  double startAngle;
  double sweepAngle;
  Color color;

  PieSliceInfo({
    required this.startAngle,
    required this.sweepAngle,
    required this.color,
  });

  @override
  String toString() {
    return "PieSliceInfo()";
  }
}

class PieChart extends StatelessWidget {
  // final double _holeRadius = 50.0;

  final List<PieSliceInfo> slices;

  PieChart(this.slices);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: slices
          .map(
            (e) => PieSliceButton(
              onPressed: () {},
              startAngle: e.startAngle,
              sweepAngle: e.sweepAngle,
              color: e.color,
            ),
          )
          .toList(),
    );
  }
}

class PieSliceBorder extends OutlinedBorder {
  final double startAngle;
  final double sweepAngle;

  PieSliceBorder({
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
    path.lineTo(centerX + rect.width / 2 * cos(_degreesToRadians(startAngle)),
        centerY + rect.height / 2 * sin(_degreesToRadians(startAngle)));
    path.arcTo(rect, _degreesToRadians(startAngle),
        _degreesToRadians(sweepAngle), false); // Arc representing the pie slice
    path.close();

    return path;
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {}

  @override
  PieSliceBorder copyWith({BorderSide? side}) {
    return PieSliceBorder(
      startAngle: startAngle,
      sweepAngle: sweepAngle,
    );
  }

  @override
  ShapeBorder scale(double t) => this;

  double _degreesToRadians(double degrees) {
    return degrees * pi / 180;
  }
}

class PieSliceButton extends StatelessWidget {
  final VoidCallback onPressed;
  final double startAngle;
  final double sweepAngle;
  final Color color;

  PieSliceButton({
    required this.onPressed,
    required this.startAngle,
    required this.sweepAngle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    var pieSliceShape =
        PieSliceBorder(startAngle: startAngle, sweepAngle: sweepAngle);
    return Material(
      color: color,
      shape: pieSliceShape,
      child: InkWell(
        onTap: onPressed,
        customBorder: pieSliceShape,
      ),
    );
  }
}
