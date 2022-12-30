import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomHeader extends StatelessWidget {
  CustomHeader({
    required this.headerText,
    Key? key,
  }) : super(key: key);

  String headerText;

  @override
  Widget build(BuildContext context) {
    return Text(
      headerText,
      textAlign: TextAlign.center,
      style: GoogleFonts.poppins(
        fontSize: 30,
        fontWeight: FontWeight.w600,
        height: 1.5,
        color: const Color(0xff918ef4),
      ),
    );
  }
}
