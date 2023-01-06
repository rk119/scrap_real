// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomSelectionTab2 extends StatelessWidget {
  CustomSelectionTab2({
    Key? key,
    required this.selection,
    required this.selection1,
    required this.selecion2,
    required this.func1,
    required this.func2,
  }) : super(key: key);

  bool selection;
  String selection1;
  String selecion2;
  void Function()? func1;
  void Function()? func2;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: Center(
        child: Container(
          padding: const EdgeInsets.fromLTRB(3, 3, 3, 3),
          width: MediaQuery.of(context).size.width * 0.50,
          decoration: BoxDecoration(
            color: const Color(0xffb0f0f1),
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(
                color: Color(0x3f000000),
                offset: Offset(0, 1),
                blurRadius: 2,
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: TextButton(
                  onPressed: func1,
                  style: TextButton.styleFrom(
                    backgroundColor: selection ? const Color(0xff141b41) : null,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    selection1,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      height: 1.5,
                      color: selection ? Colors.white : const Color(0xff141b41),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: TextButton(
                  onPressed: func2,
                  style: TextButton.styleFrom(
                    backgroundColor: selection ? null : const Color(0xff141b41),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    selecion2,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      height: 1.5,
                      color: selection ? const Color(0xff141b41) : Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
