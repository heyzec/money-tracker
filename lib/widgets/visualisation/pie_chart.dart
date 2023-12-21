import 'dart:math';
import 'package:flutter/material.dart';

class PieSliceInfo {
  double value;
  Color color;

  PieSliceInfo({required this.value, required this.color});

  @override
  String toString() {
    return "PieSliceInfo(x: $value, y: $color)";
  }
}

class PieChart extends StatelessWidget {
  final double _holeRadius = 50.0;

  final List<PieSliceInfo> slices;

  PieChart(this.slices);

  @override
  Widget build(BuildContext context) {
    List<double> data = slices.map((slice) => slice.value).toList();
    List<Color> colors = slices.map((slice) => slice.color).toList();
    return SizedBox(
      width: 200,
      height: 200,
      child: CustomPaint(
        painter: PieChartPainter(
          data: data,
          colors: colors,
          holeRadius: _holeRadius,
        ),
      ),
    );
  }
}

class PieChartPainter extends CustomPainter {
  final List<double> data;
  final List<Color> colors;
  final double holeRadius;
  late double total;

  PieChartPainter({
    required this.data,
    required this.colors,
    required this.holeRadius,
  }) {
    total = data.reduce((value, element) => value + element);
  }

  @override
  void paint(Canvas canvas, Size size) {
    double startAngle = 0;

    for (int i = 0; i < data.length; i++) {
      double sweepAngle = (data[i] / total) * 360;
      _drawArc(canvas, size, startAngle, sweepAngle, colors[i]);
      startAngle += sweepAngle;
    }

    // Draw a smaller circle in the center to create a hole
    final center = size.center(Offset.zero);
    final Paint holePaint = Paint()
      ..color = Colors.white; // Adjust hole color as needed
    canvas.drawCircle(center, holeRadius, holePaint);
  }

  void _drawArc(
    Canvas canvas,
    Size size,
    double startAngle,
    double sweepAngle,
    Color color,
  ) {
    final Rect rect = Rect.fromCircle(
      center: size.center(Offset.zero),
      radius: size.width / 2,
    );
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    canvas.drawArc(
      rect,
      _degreesToRadians(startAngle),
      _degreesToRadians(sweepAngle),
      true,
      paint,
    );
  }

  double _degreesToRadians(double degrees) {
    return degrees * pi / 180;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
