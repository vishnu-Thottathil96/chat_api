import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String logoPath;
  final String buttonText;
  final VoidCallback onPressed;
  final double? width; // Made nullable to check for overrides
  final double? height; // Made nullable to check for overrides
  final BuildContext context;
  final Color? textColor;
  final Color? backgroundColor;

  const CustomButton({
    Key? key,
    required this.context,
    required this.logoPath,
    required this.buttonText,
    required this.onPressed,
    this.width, // No default value here, will check and set dynamically
    this.height, // No default value here, will check and set dynamically
    this.textColor,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(context) {
    // Set default size based on MediaQuery if not provided
    final double defaultWidth =
        MediaQuery.of(context).size.width; // 100% of screen width
    final double defaultHeight =
        MediaQuery.of(context).size.height * 0.068; // 6% of screen height

    return SizedBox(
      width: width ?? defaultWidth,
      height: height ?? defaultHeight,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Image.asset(
          logoPath,
          height: 24, // Adjust icon size as needed
        ),
        label: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Text(buttonText),
        ),
        style: ElevatedButton.styleFrom(
          foregroundColor: textColor ?? Colors.black,
          backgroundColor: backgroundColor ?? Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
        ),
      ),
    );
  }
}
