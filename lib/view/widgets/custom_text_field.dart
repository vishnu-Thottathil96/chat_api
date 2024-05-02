import 'package:flutter/material.dart';
import 'package:lamie/constants/colors.dart';
import 'package:lamie/util/screen_size.dart';

class CustomTextFormField extends StatelessWidget {
  final BuildContext context;
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final num? fieldHeightRatio;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final TextInputAction textInputAction;
  final void Function(String)? onFieldSubmitted;
  final Color? fieldColor;
  final Color? textColor;

  const CustomTextFormField({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.context,
    this.obscureText = false,
    this.fieldHeightRatio,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.textInputAction = TextInputAction.done,
    this.onFieldSubmitted,
    this.fieldColor,
    this.textColor,
  }) : super(key: key);

  @override
  Widget build(context) {
    final double fieldHeight = fieldHeightRatio != null
        ? ScreenSize.getHeight(context) * fieldHeightRatio!
        : ScreenSize.getHeight(context) / 10;
    return SizedBox(
      height: fieldHeight,
      child: TextFormField(
        style: TextStyle(color: ProjectColors.whiteColor),
        controller: controller,
        decoration: InputDecoration(
          hintStyle: TextStyle(color: textColor ?? ProjectColors.whiteColor),
          fillColor: fieldColor,
          filled: fieldColor != null ? true : false,
          hintText: hintText,
          enabledBorder: OutlineInputBorder(
            // Set border color when field is enabled
            borderRadius: BorderRadius.circular(8.0),
            borderSide:
                BorderSide(color: fieldColor ?? ProjectColors.whiteColor),
          ),
          focusedBorder: OutlineInputBorder(
            // Set border color when field is focused
            borderRadius: BorderRadius.circular(8.0),
            borderSide:
                BorderSide(color: fieldColor ?? ProjectColors.whiteColor),
          ),
          errorStyle: TextStyle(color: ProjectColors.redColor),
        ),
        obscureText: obscureText,
        keyboardType: keyboardType,
        validator: validator,
        textInputAction: textInputAction,
        onFieldSubmitted: onFieldSubmitted,
      ),
    );
  }
}
