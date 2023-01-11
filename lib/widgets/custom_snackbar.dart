import 'package:flutter/material.dart';

class CustomSnackBar {
  static showSnackBar(BuildContext context, String? message) {
    if (message == null) return;

    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: const Color(0xffBC2D21),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
