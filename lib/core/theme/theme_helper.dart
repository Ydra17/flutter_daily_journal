import 'package:flutter/material.dart';

class ThemeHelper {
  static Color getTextColorForBackground(Color background) {
    return ThemeData.estimateBrightnessForColor(background) == Brightness.dark ? Colors.white : Colors.black;
  }
}
