import 'package:flutter/material.dart';

extension ColorHexExt on Color {
  String toHexCode() {
    return '#${value.toRadixString(16).substring(2, 8)}';
  }

  static Color fromHexCode(String s) {
    s = s.replaceAll('#', '');
    return Color(int.parse(s, radix: 16));
  }

  static const minMutedSaturation = 0.1;
  static const maxMutedSaturation = 0.5;
  static const minMutedValue = 0.5;
  static const maxMutedValue = 0.9;

  Color muted() {
    HSVColor hsvColor = HSVColor.fromColor(this);

    double newSaturation =
        hsvColor.saturation * (maxMutedSaturation - minMutedSaturation) +
            minMutedSaturation;
    double newValue =
        hsvColor.value * (maxMutedValue - minMutedValue) + minMutedValue;

    HSVColor newHsvColor =
        hsvColor.withSaturation(newSaturation).withValue(newValue);
    return newHsvColor.toColor();
  }

  Color darken() {
    return Color.lerp(this, Colors.black, 0.1)!;
  }
}

Color iconNametoColor(String iconName) {
  Color color = Color(iconName.hashCode);
  color = HSLColor.fromColor(color).withSaturation(1).toColor();
  return color.darken();
}

Color combineColors(Color color1, Color color2) {
  // Calculate the average of RGB components
  int averageRed = ((color1.red + color2.red) / 2).round();
  int averageGreen = ((color1.green + color2.green) / 2).round();
  int averageBlue = ((color1.blue + color2.blue) / 2).round();

  // Create a new Color with the calculated average components
  return Color.fromARGB(255, averageRed, averageGreen, averageBlue);
}
