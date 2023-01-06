// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomSubheader extends StatelessWidget {
  CustomSubheader({
    required this.headerText,
    required this.headerSize,
    required this.headerColor,
    this.headerAlignment = TextAlign.center,
    this.headerWeight = FontWeight.w500,
    Key? key,
  }) : super(key: key);

  String headerText;
  double headerSize;
  Color headerColor;
  TextAlign? headerAlignment;
  FontWeight? headerWeight;

  @override
  Widget build(BuildContext context) {
    return Text(
      headerText,
      textAlign: headerAlignment,
      style: GoogleFonts.poppins(
        fontSize: headerSize,
        fontWeight: headerWeight,
        height: 1.5,
        color: headerColor,
      ),
    );
  }
}
