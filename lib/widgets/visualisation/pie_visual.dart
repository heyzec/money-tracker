import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:namer_app/db/database.dart';
import 'package:namer_app/widgets/cards/category_card.dart';
import 'package:namer_app/widgets/visualisation/pie_chart.dart';

class PieChartVisual extends ConsumerWidget {
  final Map<Category, List<Transaction>> data;

  const PieChartVisual(this.data);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (data.isEmpty) {
      return Text("No Data");
    }

    Map<Category, double> sums = Map.fromIterable(
      data.entries,
      key: (entry) => entry.key,
      value: (entry) {
        List<Transaction> transactions = entry.value;

        return transactions
            .map((t) => t.amount)
            .reduce((value, element) => value + element)
            .toDouble();
      },
    );

    dynamic grandTotal =
        sums.values.reduce((value, element) => value + element);

    List<PieSliceInfo> slices = [];
    double currentAngle = 0.0;

    sums.forEach((Category category, double weight) {
      double sweepAngle = weight / grandTotal * 360;
      slices.add(
        PieSliceInfo(
          startAngle: currentAngle,
          sweepAngle: sweepAngle,
          color: Color(category.color),
        ),
      );
      currentAngle += sweepAngle;
    });

    return Container(
      alignment: Alignment.center,
      color: Colors.blue,
      child: CustomPaint(
        foregroundPainter: CategoryIndicatorPainter(
          Map.of(
            {
              Offset(800, 100): 0,
              Offset(10, 400): 180,
            },
          ),
        ),
        child: Center(
          child: AspectRatio(
            aspectRatio: 1,
            child: PieChart(slices),
          ),
        ),
      ),
    );
  }
}

class CategoryIndicatorPainter extends CustomPainter {
  Map<Offset, double> targets;

  CategoryIndicatorPainter(this.targets);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;

    final Offset center = Offset(size.width / 2, size.height / 2);
    final radius = size.height / 2;

    targets.forEach((Offset location, double angle) {
      double inRadians = angle / 180 * pi;
      canvas.drawLine(
        center.translate(radius * cos(inRadians), radius * sin(inRadians)),
        location,
        paint,
      );
    });
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

/* class IconContainer extends StatelessWidget {
  const IconContainer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CategoryCard(iconName: "cocktail", color: Colors.red),
            CategoryCard(iconName: "cocktail", color: Colors.red),
            CategoryCard(iconName: "cocktail", color: Colors.red),
            CategoryCard(iconName: "cocktail", color: Colors.red),
            CategoryCard(iconName: "cocktail", color: Colors.red),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CategoryCard(iconName: "cocktail", color: Colors.red),
            CategoryCard(iconName: "cocktail", color: Colors.red),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CategoryCard(iconName: "cocktail", color: Colors.red),
            CategoryCard(iconName: "cocktail", color: Colors.red),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CategoryCard(iconName: "cocktail", color: Colors.red),
            CategoryCard(iconName: "cocktail", color: Colors.red),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CategoryCard(iconName: "cocktail", color: Colors.red),
            CategoryCard(iconName: "cocktail", color: Colors.red),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CategoryCard(iconName: "cocktail", color: Colors.red),
            CategoryCard(iconName: "cocktail", color: Colors.red),
            CategoryCard(iconName: "cocktail", color: Colors.red),
            CategoryCard(iconName: "cocktail", color: Colors.red),
            CategoryCard(iconName: "cocktail", color: Colors.red),
          ],
        ),
      ],
    );
  }
} */