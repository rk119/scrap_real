// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:scrap_real/themes/theme_provider.dart';

class CustomText extends StatelessWidget {
  CustomText({
    required this.text,
    required this.textSize,
    this.textAlignment = TextAlign.center,
    this.textWeight = FontWeight.w500,
    this.alert = false,
    Key? key,
  }) : super(key: key);

  String text;
  double textSize;
  TextAlign? textAlignment;
  FontWeight? textWeight;
  bool? alert;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlignment,
      style: GoogleFonts.poppins(
        fontSize: textSize,
        fontWeight: textWeight,
        height: 1.5,
        color: Provider.of<ThemeProvider>(context).themeMode == ThemeMode.dark
            ? Colors.white
            : alert != null && alert == true
                ? const Color(0xffBC2D21)
                : Colors.black,
      ),
    );
  }
}
