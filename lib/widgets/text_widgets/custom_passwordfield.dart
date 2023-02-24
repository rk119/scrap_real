// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:scrap_real/themes/theme_provider.dart';

class CustomPasswordFormField extends StatelessWidget {
  CustomPasswordFormField({
    Key? key,
    required this.textController,
    required this.headingText,
    required this.validatorFunction,
    required this.onTapFunction,
    required this.hintingText,
    required this.obscureTextBool,
    this.textColor = Colors.black,
  }) : super(key: key);

  TextEditingController textController;
  String headingText;
  String? Function(String?)? validatorFunction;
  void Function()? onTapFunction;
  String hintingText;
  bool obscureTextBool;
  Color textColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          headingText,
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
                    width: MediaQuery.of(context).size.width * 0.82,
                    child: TextFormField(
                      controller: textController,
                      obscureText: obscureTextBool,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: validatorFunction,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.all(10),
                        suffixIcon: GestureDetector(
                          onTap: onTapFunction,
                          child: Icon(
                            obscureTextBool
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: const Color(0xffc4c4c4),
                          ),
                        ),
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
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
