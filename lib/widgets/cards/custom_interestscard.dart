// ignore_for_file: must_be_immutable

import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomInterestsCard extends StatelessWidget {
  CustomInterestsCard({
    Key? key,
    required this.buttonColor,
    required this.buttonBorderRadius,
    required this.buttonText,
    required this.svgPath,
    required this.buttonFunction,
  }) : super(key: key);

  Color buttonColor;
  BorderRadius buttonBorderRadius;
  String buttonText;
  String svgPath;
  void Function()? buttonFunction;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      width: 345,
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
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(width: 65),
            SizedBox(
              width: 45,
              height: 45,
              child: SvgPicture.asset(
                svgPath,
              ),
            ),
            const SizedBox(width: 40),
            Text(
              buttonText,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                height: 1.5,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
