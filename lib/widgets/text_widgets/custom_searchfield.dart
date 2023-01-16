// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomSearchField extends StatelessWidget {
  CustomSearchField({
    Key? key,
    // required this.validatorFunction,
    required this.hintingText,
    required this.onChangedFunc,
  }) : super(key: key);

  // String? Function(String?)? validatorFunction;
  String hintingText;
  void Function(String)? onChangedFunc;

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
        // validator: validatorFunction,
        onChanged: onChangedFunc,
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
