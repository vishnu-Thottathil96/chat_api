import 'package:flutter/material.dart';
import 'package:lamie/constants/enumes.dart';

class CustomAlertBox {
  static void showAlert({
    required BuildContext context,
    required String title,
    required String message,
    AlertType type = AlertType.information,
    String closeButtonText = "Close", // Default close button text
    String? optionalButtonText, // Optional button text, null by default
    VoidCallback? onOptionalButtonPressed,
  }) {
    // Determine the title color based on the alert type
    Color titleColor = type == AlertType.error ? Colors.red : Colors.black;

    // Create the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title, style: TextStyle(color: titleColor)),
      content: Text(message),
      actions: <Widget>[
        TextButton(
          child: Text(closeButtonText),
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
        ),
        if (optionalButtonText != null && onOptionalButtonPressed != null)
          TextButton(
            onPressed: onOptionalButtonPressed,
            child: Text(optionalButtonText),
          ),
      ],
    );

    // Show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
