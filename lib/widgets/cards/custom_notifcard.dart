// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scrap_real/themes/theme_provider.dart';
import 'package:scrap_real/widgets/text_widgets/custom_text.dart';

class CustomNotifCard extends StatelessWidget {
  CustomNotifCard({
    Key? key,
    required this.notifText,
  }) : super(key: key);

  String notifText;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 80,
      alignment: Alignment.center,
      child: Row(children: [
        const SizedBox(width: 15),
        Container(
          height: 65,
          width: 65,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color:
                Provider.of<ThemeProvider>(context).themeMode == ThemeMode.dark
                    ? Colors.white
                    : Colors.black,
          ),
        ),
        const SizedBox(width: 15),
        SizedBox(
          width: 200,
          child: CustomText(
            text: notifText,
            textSize: 15,
            textAlignment: TextAlign.left,
            textWeight: FontWeight.w300,
          ),
        ),
      ]),
    );
  }
}
