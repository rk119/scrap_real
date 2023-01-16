// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:scrap_real/themes/theme_provider.dart';
import 'package:scrap_real/widgets/text_widgets/custom_text.dart';
import 'package:scrap_real/widgets/text_widgets/custom_subheader.dart';

class CustomMenuItem extends StatelessWidget {
  CustomMenuItem({
    required this.svgPath,
    required this.text,
    required this.buttonFunction,
    Key? key,
  }) : super(key: key);

  String svgPath;
  String text;
  void Function()? buttonFunction;

  @override
  Widget build(BuildContext context) {
    var iconColor =
        Provider.of<ThemeProvider>(context).themeMode == ThemeMode.dark
            ? Colors.white
            : Colors.black;

    return SizedBox(
      height: 60,
      width: 366,
      child: TextButton(
        onPressed: buttonFunction,
        child: Row(children: [
          SvgPicture.asset(
            svgPath,
            height: 35,
            width: 35,
            color: iconColor,
          ),
          const SizedBox(width: 20),
          Expanded(
            child: CustomText(
              text: text,
              textSize: 20,
              textAlignment: TextAlign.left,
            ),
          ),
          SvgPicture.asset(
            "assets/forward.svg",
            height: 35,
            width: 35,
            color: iconColor,
          ),
        ]),
      ),
    );
  }
}

class CustomMenuItemColored extends StatelessWidget {
  CustomMenuItemColored({
    required this.svgPath,
    required this.text,
    required this.color,
    required this.buttonFunction,
    Key? key,
  }) : super(key: key);

  String svgPath;
  String text;
  Color color;
  void Function()? buttonFunction;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      width: 366,
      child: TextButton(
        onPressed: buttonFunction,
        child: Row(children: [
          SvgPicture.asset(
            svgPath,
            height: 35,
            width: 35,
            color: color,
          ),
          const SizedBox(width: 20),
          Expanded(
            child: CustomSubheader(
              headerText: text,
              headerSize: 20,
              headerColor: color,
              headerAlignment: TextAlign.left,
            ),
          ),
          SvgPicture.asset(
            "assets/forward.svg",
            height: 35,
            width: 35,
            color: color,
          ),
        ]),
      ),
    );
  }
}
