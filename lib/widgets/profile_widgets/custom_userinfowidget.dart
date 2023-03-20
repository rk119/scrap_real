// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:scrap_real/widgets/text_widgets/custom_subheader.dart';
import 'package:scrap_real/widgets/text_widgets/custom_text.dart';

class CustomUserInfoWidget extends StatelessWidget {
  CustomUserInfoWidget({
    Key? key,
    required this.name,
    required this.username,
    this.photoUrl,
    required this.alt,
  }) : super(key: key);

  String name;
  String username;
  String? photoUrl;
  String alt;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 125,
      child: Row(children: [
        photoUrl == ""
            ? Image.asset(
                alt,
                width: 150,
                height: 150,
              )
            : CircleAvatar(
                backgroundColor: Colors.grey,
                backgroundImage: NetworkImage(
                  photoUrl!,
                ),
                radius: 75,
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
                headerText: username,
                headerSize: 16,
                headerColor: const Color(0xff72768d),
              ),
              const SizedBox(height: 15),
            ],
          ),
        ),
      ]),
    );
  }
}
