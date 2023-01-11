// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:scrap_real/widgets/text_widgets/custom_subheader.dart';
import 'package:scrap_real/widgets/text_widgets/custom_text.dart';

class CustomUserInfoWidget extends StatelessWidget {
  CustomUserInfoWidget({
    Key? key,
    required this.name,
    required this.userName,
  }) : super(key: key);

  String name;
  String userName;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 125,
      child: Row(children: [
        Container(
          height: 125,
          width: 125,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              width: 5,
              color: const Color.fromARGB(255, 241, 241, 241),
            ),
            borderRadius: BorderRadius.circular(100),
          ),
          child: const SizedBox(),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomText(
                text: name,
                textSize: 20,
              ),
              CustomSubheader(
                headerText: userName,
                headerSize: 16,
                headerColor: const Color(0xff72768d),
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: () {},
                child: const Text("follow"),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
