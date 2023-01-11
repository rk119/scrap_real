// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomSelectionTab1 extends StatelessWidget {
  CustomSelectionTab1({
    Key? key,
    required this.selection,
    required this.selection1,
    required this.selecion2,
    required this.path1,
    required this.path2,
    required this.func1,
    required this.func2,
    required this.insets1,
    required this.insets2,
  }) : super(key: key);

  bool selection;
  String selection1;
  String selecion2;
  String path1;
  String path2;
  void Function()? func1;
  void Function()? func2;
  EdgeInsets insets1;
  EdgeInsets insets2;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextButton(
              onPressed: func1,
              child: Container(
                padding: insets1,
                height: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xffb0f0f1),
                  borderRadius: BorderRadius.circular(50),
                  border: selection
                      ? Border.all(
                          color: const Color.fromARGB(255, 39, 146, 148),
                          width: 2)
                      : null,
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x3f000000),
                      offset: Offset(0, 1),
                      blurRadius: 2,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Image.asset(path1),
                    const SizedBox(width: 5.54),
                    Text(
                      selection1,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        height: 1.5,
                        color: const Color(0xff141b41),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 25),
            TextButton(
              onPressed: func2,
              child: Container(
                padding: insets2,
                height: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xffb0f0f1),
                  borderRadius: BorderRadius.circular(50),
                  border: selection
                      ? null
                      : Border.all(
                          color: const Color.fromARGB(255, 39, 146, 148),
                          width: 2),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x3f000000),
                      offset: Offset(0, 1),
                      blurRadius: 2,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Image.asset(path2),
                    const SizedBox(width: 5.54),
                    Text(
                      selecion2,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        height: 1.5,
                        color: const Color(0xff141b41),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
