// ignore_for_file: must_be_immutable

import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';

class CustomBioCard extends StatelessWidget {
  CustomBioCard({
    Key? key,
    required this.textController,
    this.textColor = Colors.black,
    this.cardText = "Bio",
    this.cardHintText = "Enter your bio",
  }) : super(key: key);

  TextEditingController textController;
  Color textColor;
  String cardText;
  String cardHintText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          cardText,
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
            color: const Color(0xfffdfbfb),
            borderRadius: BorderRadius.circular(6),
            boxShadow: const [
              BoxShadow(
                color: Color(0x3f000000),
                blurRadius: 2,
                offset: Offset(1, 2),
              )
            ],
          ),
          height: 208,
          child: Wrap(
            children: [
              Stack(
                children: [
                  SizedBox(
                    width: 310,
                    child: TextFormField(
                      controller: textController,
                      maxLength: 150,
                      maxLines: 8,
                      keyboardType: TextInputType.name,
                      style: const TextStyle(color: Colors.black87),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.all(10),
                        hintText: cardHintText,
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
