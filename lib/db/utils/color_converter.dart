// ==========  UNUSED  ==========

import 'dart:ui';
import 'package:drift/drift.dart';
import 'package:money_tracker/utils/colors.dart';

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
