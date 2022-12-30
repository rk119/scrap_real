import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomSubheader extends StatelessWidget {
  CustomSubheader({
    required this.headerText,
    required this.headerSize,
    required this.headerColor,
    Key? key,
  }) : super(key: key);

  String headerText;
  double headerSize;
  Color headerColor;

  @override
  Widget build(BuildContext context) {
    return Text(
      headerText,
      textAlign: TextAlign.center,
      style: GoogleFonts.poppins(
        fontSize: headerSize,
        fontWeight: FontWeight.w500,
        height: 1.5,
        color: headerColor,
      ),
    );
  }
}
