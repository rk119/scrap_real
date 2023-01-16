// ignore_for_file: must_be_immutable

import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:scrap_real/themes/theme_provider.dart';

class CustomNameCard extends StatelessWidget {
  CustomNameCard({
    Key? key,
    required this.textName,
    required this.hintingText,
    required this.textController,
    required this.validatorFunction,
    this.textColor = const Color(0xffa0a0a0),
  }) : super(key: key);

  String textName;
  String hintingText;
  TextEditingController textController;
  String? Function(String?)? validatorFunction;
  Color textColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          textName,
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            height: 1.5,
            color: textColor,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          alignment: Alignment.topLeft,
          decoration: BoxDecoration(
            color:
                Provider.of<ThemeProvider>(context).themeMode == ThemeMode.dark
                    ? Colors.black
                    : const Color(0xfffdfbfb),
            borderRadius: BorderRadius.circular(6),
            boxShadow: const [
              BoxShadow(
                color: Color(0x3f000000),
                blurRadius: 2,
                offset: Offset(1, 2),
              )
            ],
          ),
          height: 50,
          child: Wrap(
            children: [
              Stack(
                children: [
                  SizedBox(
                    width: 310,
                    child: TextFormField(
                      controller: textController,
                      keyboardType: TextInputType.name,
                      validator: validatorFunction,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.all(10),
                        hintText: hintingText,
                        hintStyle: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          height: 1.5,
                          color: const Color.fromARGB(255, 193, 193, 193),
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: SvgPicture.asset(
                        'assets/edit.svg',
                        height: 35,
                        width: 35,
                        color: const Color(0xffa0a0a0),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
