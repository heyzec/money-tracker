import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:money_tracker/utils/colors.dart';

// TODO: remove and use defaults
var ALL = [
  'taxi',
  'train',
  'camera',
  'glasses',
  'gamepad',
  'home',
  'cocktail',
];

class CategoryCard extends StatelessWidget {
  final String iconName;
  final String? text;
  final Color color;

  final VoidCallback? onPressed;
  final bool marked;

  CategoryCard({
    required this.iconName,
    this.text,
    required this.color,
    this.onPressed,
    this.marked = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onPressed,
      child: Card(
        color: marked ? Colors.green : null,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Column(
            children: [
              Icon(
                color: color,
                LineIcons.byName(iconName),
              ),
              if (text != null)
                Text(
                  text!,
                  style: TextStyle(color: color.darken()),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
