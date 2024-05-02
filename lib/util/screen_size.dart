import 'package:flutter/material.dart';

class ScreenSize {
  static double getWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double getHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static double getTextSize(BuildContext context, {double scale = 0.02}) {
    final screenWidth = getWidth(context);
    return screenWidth * scale;
  }
}
