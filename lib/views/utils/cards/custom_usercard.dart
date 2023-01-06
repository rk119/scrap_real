// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:scrap_real/views/utils/headers/custom_subheader.dart';

class CustomUserCard extends StatelessWidget {
  CustomUserCard({
    Key? key,
    required this.username,
  }) : super(key: key);

  String username;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 60,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: const Color.fromARGB(255, 245, 245, 245),
        ),
        borderRadius: BorderRadius.circular(15),
        color: const Color(0xfffefcfc),
        boxShadow: const [
          BoxShadow(
            color: Color(0x3f000000),
            blurRadius: 2,
            offset: Offset(0, 1),
          )
        ],
      ),
      child: Row(children: [
        const SizedBox(width: 8),
        Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: Colors.black,
          ),
        ),
        const SizedBox(
          width: 15,
        ),
        SizedBox(
          width: 200,
          child: CustomSubheader(
            headerText: username,
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
