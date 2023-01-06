// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:scrap_real/views/utils/headers/custom_subheader.dart';

class CustomNotifCard extends StatelessWidget {
  CustomNotifCard({
    Key? key,
    required this.notifText,
  }) : super(key: key);

  String notifText;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 80,
      alignment: Alignment.center,
      child: Row(children: [
        const SizedBox(width: 15),
        Container(
          height: 65,
          width: 65,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: Colors.black,
          ),
        ),
        const SizedBox(width: 15),
        SizedBox(
          width: 200,
          child: CustomSubheader(
            headerText: notifText,
            headerSize: 15,
            headerColor: Colors.black,
            headerAlignment: TextAlign.left,
            headerWeight: FontWeight.w300,
          ),
        ),
      ]),
    );
  }
}
