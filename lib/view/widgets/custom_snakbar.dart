import 'package:flutter/material.dart';
import 'package:lamie/constants/colors.dart';
import 'package:lamie/constants/enumes.dart';

class CustomSnakbar {
  static SnackBar createSnackBar(String message, SnackBarType type) {
    Color backgroundColor;
    switch (type) {
      case SnackBarType.error:
        backgroundColor = ProjectColors.redColor;
        break;
      case SnackBarType.success:
        backgroundColor = ProjectColors.green;
        break;
      case SnackBarType.normal:
      default:
        backgroundColor = ProjectColors.greyColor;
        break;
    }

    return SnackBar(
      content: Text(message),
      backgroundColor: backgroundColor,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
