// ==========  UNUSED  ==========


import 'dart:ui';
import 'package:drift/drift.dart';

extension ColorHexExt on Color {
  String toHexCode() {
    return '#${value.toRadixString(16).substring(2, 8)}';
  }

  static Color fromHexCode(String s) {
    s = s.replaceAll('#', '');
    return Color(int.parse(s, radix: 16));
  }
}

class ColorConverter extends TypeConverter<Color, String> {
  const ColorConverter();

  @override
  Color fromSql(String fromDb) {
    return ColorHexExt.fromHexCode(fromDb);
  }

  @override
  String toSql(Color value) {
    return value.toHexCode();
  }
}
