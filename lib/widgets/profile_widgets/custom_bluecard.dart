// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:scrap_real/widgets/text_widgets/custom_subheader.dart';

class CustomBlueUserInfoCard extends StatelessWidget {
  CustomBlueUserInfoCard({
    Key? key,
    required this.text1,
    required this.text2,
  }) : super(key: key);

  String text1;
  String text2;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 73,
      height: 60,
      decoration: BoxDecoration(
        color: const Color(0xff8ee8ea),
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            color: Color.fromARGB(255, 118, 208, 209),
            offset: Offset(2, 2),
            blurRadius: 2,
          ),
        ],
      ),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        CustomSubheader(
          headerText: text1,
          headerSize: 18,
          headerColor: Colors.black,
        ),
        CustomSubheader(
          headerText: text2,
          headerSize: 13,
          headerColor: Colors.black,
        ),
      ]),
    );
  }
}
