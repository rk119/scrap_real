import 'package:flutter/material.dart';
import 'package:scrap_real/widgets/text_widgets/custom_subheader.dart';

class CustomSnackBar {
  static showSnackBar(BuildContext context, String? message) {
    if (message == null) return;

    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: const Color(0xffBC2D21),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static snackBarAlert(BuildContext context, String? message) {
    if (message == null) return;

    final snackBar = SnackBar(
      content: CustomSubheader(
        headerText: message,
        headerSize: 15,
        headerColor: Colors.white,
      ),
      backgroundColor: Colors.grey.shade900,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
