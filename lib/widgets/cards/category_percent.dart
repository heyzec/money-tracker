import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:money_tracker/db/database.dart';

class CategoryPercent extends StatelessWidget {
  final Category category;
  final double percentage;
  final VoidCallback? onPressed;

  const CategoryPercent({
    required this.category,
    required this.percentage,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    Color color = Color(category.color);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: onPressed,
          icon: Icon(
            LineIcons.byName(category.iconName),
            color: color,
          ),
        ),
        Text(
          "${percentage.toInt().toString()}%",
          style: TextStyle(color: color),
        ),
      ],
    );
  }
}
