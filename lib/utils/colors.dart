import 'package:flutter/material.dart';

Color darken(color) {
  return Color.lerp(color, Colors.black, 0.4)!;
}

Color iconNametoColor(String iconName) {
  Color color = Color(iconName.hashCode);
  color = HSLColor.fromColor(color).withSaturation(1).toColor();
  return darken(color);
}
