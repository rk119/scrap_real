// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:scrap_real/themes/theme_provider.dart';
import 'package:scrap_real/widgets/text_widgets/custom_text.dart';

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
            color:
                Provider.of<ThemeProvider>(context).themeMode == ThemeMode.dark
                    ? Colors.white
                    : Colors.black,
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
            color:
                Provider.of<ThemeProvider>(context).themeMode == ThemeMode.dark
                    ? Colors.white
                    : Colors.black,
          ),
        ]),
      ),
    );
  }
}
