// ignore_for_file: must_be_immutable
// ignore_for_file: const

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextButton extends StatelessWidget {
  CustomTextButton({
    required this.buttonBorderRadius,
    required this.buttonFunction,
    required this.buttonText,
    this.buttonColor = const Color(0xff7be5e7),
    this.buttonTextColor = Colors.black,
    this.buttonWidth = double.infinity,
    this.buttonHeight = 50,
    this.fontSize = 18,
    Key? key,
  }) : super(key: key);

  BorderRadiusGeometry buttonBorderRadius;
  void Function()? buttonFunction;
  String buttonText;
  Color buttonColor;
  Color buttonTextColor;
  double buttonWidth;
  double buttonHeight;
  double fontSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: buttonWidth,
      height: buttonHeight == 50
          ? MediaQuery.of(context).size.height * 0.065
          : buttonHeight,
      decoration: BoxDecoration(
        color: buttonColor,
        borderRadius: buttonBorderRadius,
        boxShadow: const [
          BoxShadow(
            color: Color(0x19000000),
            offset: Offset(2, 4),
            blurRadius: 2,
          ),
        ],
      ),
      child: TextButton(
        onPressed: buttonFunction,
        child: Center(
          child: Text(
            buttonText,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
              height: 1.5,
              color: buttonTextColor,
            ),
          ),
        ),
      ),
    );
  }
}
