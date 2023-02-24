// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scrap_real/themes/theme_provider.dart';

class CustomBackButton extends StatelessWidget {
  CustomBackButton({
    required this.buttonFunction,
    Key? key,
  }) : super(key: key);

  void Function()? buttonFunction;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        IconButton(
          padding: const EdgeInsets.only(left: 0.0),
          iconSize: 25,
          onPressed: buttonFunction,
          icon: const Icon(Icons.arrow_back_ios),
          color: Provider.of<ThemeProvider>(context).themeMode == ThemeMode.dark
              ? Colors.white
              : Colors.black,
        ),
      ],
    );
  }
}
