import 'package:flutter/material.dart';

Color darken(color) {
  return Color.lerp(color, Colors.black, 0.4)!;
}

Color iconNametoColor(String iconName) {
  Color color = Color(iconName.hashCode);
  color = HSLColor.fromColor(color).withSaturation(1).toColor();
  return darken(color);
}

Color combineColors(Color color1, Color color2) {
  // Calculate the average of RGB components
  int averageRed = ((color1.red + color2.red) / 2).round();
  int averageGreen = ((color1.green + color2.green) / 2).round();
  int averageBlue = ((color1.blue + color2.blue) / 2).round();

  // Create a new Color with the calculated average components
  return Color.fromARGB(255, averageRed, averageGreen, averageBlue);
}
