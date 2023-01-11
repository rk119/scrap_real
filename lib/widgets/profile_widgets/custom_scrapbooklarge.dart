// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:scrap_real/widgets/text_widgets/custom_subheader.dart';

class CustomScrapbookLarge extends StatelessWidget {
  CustomScrapbookLarge({
    Key? key,
    required this.text,
  }) : super(key: key);

  String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350,
      height: 205,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 43, 43, 43),
        border: Border.all(
          width: 5,
          color: const Color.fromARGB(255, 69, 69, 69),
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(children: [
        const SizedBox(height: 40),
        SizedBox(
          height: 100,
          child: Center(
            child: CustomSubheader(
              headerText: text, // max 22 char
              headerColor: Colors.white,
              headerSize: 23,
            ),
          ),
        ),
        Container(
          height: 40,
        ),
      ]),
    );
  }
}
