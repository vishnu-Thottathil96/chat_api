import 'package:flutter/material.dart';
import 'package:lamie/constants/enumes.dart';
import 'package:lamie/util/screen_size.dart';

class CustomText {
  static Widget createCustomText({
    required BuildContext context,
    required String text,
    TextType textType = TextType.normal,
    double scale = 0.04,
    Color color = Colors.black,
    FontWeight fontWeight = FontWeight.normal,
  }) {
    double textSize = ScreenSize.getTextSize(context, scale: scale);
    TextStyle textStyle = TextStyle(
      fontSize: textSize,
      color: color,
      fontWeight: fontWeight,
    );

    // Adjust the style based on the text type
    switch (textType) {
      case TextType.heading:
        textStyle = textStyle.copyWith(
            fontSize: ScreenSize.getTextSize(context, scale: 0.1),
            fontWeight: FontWeight.bold);
        break;
      case TextType.subheading:
        textStyle = textStyle.copyWith(
            fontSize: ScreenSize.getTextSize(context, scale: 0.05),
            fontWeight: FontWeight.w600);
        break;
      case TextType.normal:
      default:
        // For normal text, we use the passed values or defaults
        break;
    }

    return Text(
      text,
      style: textStyle,
    );
  }
}
