// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextFormField extends StatelessWidget {
  CustomTextFormField({
    Key? key,
    required this.textController,
    required this.headingText,
    required this.validatorFunction,
    required this.hintingText,
  }) : super(key: key);

  TextEditingController textController;
  String headingText;
  String? Function(String?)? validatorFunction;
  String hintingText;

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
            color: const Color(0xff141b41),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
              color: const Color(0xfffdfbfb),
              borderRadius: BorderRadius.circular(6),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x3f000000),
                  blurRadius: 2,
                  offset: Offset(1, 2),
                )
              ]),
          height: 60,
          child: TextFormField(
            controller: textController,
            keyboardType: TextInputType.emailAddress,
            style: const TextStyle(color: Colors.black87),
            autovalidateMode: AutovalidateMode.onUserInteraction,
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
      ],
    );
  }
}
