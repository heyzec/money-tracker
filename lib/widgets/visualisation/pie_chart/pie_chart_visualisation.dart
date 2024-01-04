import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:money_tracker/db/database.dart';
import 'package:money_tracker/utils/types.dart';
import 'package:money_tracker/widgets/cards/category_percent.dart';
import 'package:money_tracker/widgets/visualisation/pie_chart/pie_chart.dart';

List<Coord> getBorderCoordinates(int nRows, int nCols) {
  List<Coord> coordinates = [];

  for (int i = 0; i < nRows; i++) {
    for (int j = 0; j < nCols; j++) {
      if (!(j == 0 || j == nCols - 1 || i == 0 || i == nRows - 1)) {
        continue;
      }
      coordinates.add(Coord(i, j));
    }
  }
  return coordinates;
}

class PieChartVisualisation extends ConsumerWidget {
  final QueryResult data;

  const PieChartVisualisation(this.data);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const int nRows = 5;
    const int nCols = 4;
    const double pieRatio = 0.7;

    QueryResult filtered = filterData(data);
    List<PieSliceInfo> slices = generateSlices(filtered);
    Map<Coord, Category> categoryMap =
        assignCategoryToCoord(slices, filtered, nRows, nCols);
    Map<Coord, (double, Color)> targets = categoryMap.map((key, value) {
      PieSliceInfo slice =
          slices.firstWhere((slice) => slice.categoryName == value.name);
      return MapEntry(
        key,
        (slice.startAngle + slice.sweepAngle / 2, slice.color),
      );
    });

    // Add a fake slice so that we render an empty-looking pie chart
    if (slices.isEmpty) {
      slices = [
        PieSliceInfo(startAngle: 0, sweepAngle: 360, color: Colors.grey),
      ];
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          double pieChartDiameter =
              min(constraints.maxHeight, constraints.maxWidth) * pieRatio;
          return Stack(
            children: [
              _CategoryPercentContainer(
                nRows: nRows,
                categoryData: categoryMap,
                nCols: nCols,
              ),
              Center(
                child: AspectRatio(
                  aspectRatio: 1,
                  child: FractionallySizedBox(
                    widthFactor: pieRatio,
                    heightFactor: pieRatio,
                    child: PieChart(slices),
                  ),
                ),
              ),
              SizedBox.expand(
                child: CustomPaint(
                  foregroundPainter: _CategoryIndicatorPainter(
                    targets: targets,
                    pieChartDiameter: pieChartDiameter,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  static QueryResult filterData(QueryResult data) {
    QueryResult output = Map.from(data);
    output.removeWhere((key, value) => key.isIncome);
    return output;
  }

  static List<PieSliceInfo> generateSlices(QueryResult data) {
    if (data.isEmpty) {
      return [];
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

    double grandTotal = sums.values.reduce((value, element) => value + element);

    List<PieSliceInfo> slices = [];
    double currentAngle = 0.0;

    sums.forEach((Category category, double weight) {
      double sweepAngle = weight / grandTotal * 360;
      slices.add(
        PieSliceInfo(
          startAngle: currentAngle,
          sweepAngle: sweepAngle,
          color: Color(category.color),
          categoryName: category.name,
        ),
      );
      currentAngle += sweepAngle;
    });
    return slices;
  }

  static Map<Coord, Category> assignCategoryToCoord(
    List<PieSliceInfo> slices,
    QueryResult data,
    int nRows,
    int nCols,
  ) {
    List<Coord> allCoordinates = getBorderCoordinates(nRows, nCols);

    return Map.fromEntries(
      slices.indexed.map((entry) {
        int i = entry.$1;
        PieSliceInfo slice = entry.$2;

        Category category =
            data.keys.firstWhere((cat) => cat.name == slice.categoryName);

        return MapEntry(allCoordinates[i % 10], category);
      }),
    );
  }
}

class _CategoryPercentContainer extends StatelessWidget {
  final Map<Coord, Category> categoryData;
  final int nRows;
  final int nCols;

  const _CategoryPercentContainer({
    required this.categoryData,
    this.nRows = 5,
    this.nCols = 4,
  });

  @override
  Widget build(BuildContext context) {
    CategoryPercent filler = CategoryPercent(
      category: Category(
        id: 0,
        iconName: 'question',
        name: "",
        color: Colors.grey.value,
        isIncome: false,
      ),
      percentage: 0,
    );

    List<Coord> allCoordinates = getBorderCoordinates(nRows, nCols);

    Alignment coordinatesToAlignment(coord) {
      var a1 = coord.first / (nRows - 1) * 2 - 1;
      var a2 = coord.second / (nCols - 1) * 2 - 1;
      return Alignment(a2, a1);
    }

    CategoryPercent wrap(cat) {
      return CategoryPercent(
        category: cat,
        percentage: 100,
      );
    }

    return Stack(
      children: allCoordinates
          .map(
            (coordinates) => Align(
              alignment: coordinatesToAlignment(coordinates),
              child: categoryData[coordinates] != null
                  ? wrap(categoryData[coordinates])
                  : filler,
            ),
          )
          .toList(),
    );
  }
}

class _CategoryIndicatorPainter extends CustomPainter {
  Map<Coord, (double, Color)> targets;
  final double pieChartDiameter;
  final int nRows;
  final int nCols;

  _CategoryIndicatorPainter({
    required this.targets,
    required this.pieChartDiameter,
    this.nRows = 5,
    this.nCols = 4,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Offset coordinateToOffset(Coord coord) {
      double y = coord.first / (nRows - 1) * size.height;
      double x = coord.second / (nCols - 1) * size.width;
      return Offset(x, y);
    }

    Offset translatePolar(Offset offset, double radius, double angle) {
      return offset.translate(radius * cos(angle), radius * sin(angle));
    }

    final Offset center = Offset(size.width / 2, size.height / 2);
    final radius = pieChartDiameter / 2;

    targets.forEach((coord, record) {
      double pieAngleInDegrees = record.$1;
      Color color = record.$2;
      double pieAngleInRadians = pieAngleInDegrees / 180 * pi;
      Offset pieCenterTranslated =
          translatePolar(center, radius, pieAngleInRadians);
      Offset categoryIconLocation = coordinateToOffset(coord);
      double lineAngleInRadians = atan2(
        (pieCenterTranslated - categoryIconLocation).dy,
        (pieCenterTranslated - categoryIconLocation).dx,
      );
      Offset categoryIconLocationTranslated =
          translatePolar(categoryIconLocation, 70, lineAngleInRadians);

      canvas.drawLine(
        pieCenterTranslated,
        categoryIconLocationTranslated,
        Paint()
          ..color = color
          ..strokeWidth = 1.5,
      );
    });
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
