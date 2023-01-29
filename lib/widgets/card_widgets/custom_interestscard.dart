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
    required this.selected,
  }) : super(key: key);

  Color buttonColor;
  BorderRadius buttonBorderRadius;
  String buttonText;
  String svgPath;
  void Function()? buttonFunction;
  bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      width: 345,
      decoration: BoxDecoration(
        border: selected ? Border.all(color: Colors.black, width: 2) : null,
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
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(width: MediaQuery.of(context).size.width * 0.15),
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
