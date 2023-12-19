import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

Color darken(color) {
  return Color.lerp(color, Colors.black, 0.4)!;
}

var ALL = [
  'taxi',
  'train',
  'camera',
  'glasses',
  'gamepad',
  'home',
  'cocktail',
];

Color iconNametoColor(String iconName) {
  // var colors = {
  //   'taxi': Colors.yellow,
  //   'train': Colors.yellow,
  //   'camera': Colors.yellow,
  //   'glasses': Colors.yellow,
  //   'gamepad': Colors.yellow,
  //   'home': Colors.yellow,
  //   'cocktail': Colors.yellow,
  // };
  Color color = Color(iconName.hashCode);
  color = HSLColor.fromColor(color).withSaturation(1).toColor();
  return darken(color);
}

class CategoryCard extends StatelessWidget {
  final String iconName;
  final String? text;

  CategoryCard({required this.iconName, required this.text});

  @override
  Widget build(BuildContext context) {
    Color color = iconNametoColor(iconName);
    return Card(
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
                style: TextStyle(color: darken(color)),
              ),
          ],
        ),
      ),
    );
  }
}

class AllCategoryCards extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: List.from(
        ALL.map(
          (iconName) => CategoryCard(
            iconName: iconName,
            text: null,
          ),
        ),
      ),
    );
  }
}
