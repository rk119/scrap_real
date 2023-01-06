// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomSearchField extends StatelessWidget {
  CustomSearchField({
    Key? key,
    required this.textController,
    required this.validatorFunction,
    required this.hintingText,
  }) : super(key: key);

  TextEditingController textController;
  String? Function(String?)? validatorFunction;
  String hintingText;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color.fromARGB(255, 201, 201, 201),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextFormField(
        controller: textController,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search),
          border: InputBorder.none,
          hintText: hintingText,
          hintStyle: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            height: 1.5,
            color: const Color.fromARGB(255, 193, 193, 193),
          ),
        ),
      ),
    );
  }
}
