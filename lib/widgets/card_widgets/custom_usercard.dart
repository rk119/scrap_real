// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scrap_real/themes/theme_provider.dart';
import 'package:scrap_real/widgets/text_widgets/custom_text.dart';

class CustomUserCard extends StatelessWidget {
  CustomUserCard({
    Key? key,
    this.photoUrl,
    required this.alt,
    required this.username,
    required this.onTapFunc,
    required this.bottomPadding,
  }) : super(key: key);

  String? photoUrl;
  String alt;
  String username;
  void Function()? onTapFunc;
  double bottomPadding = 20;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTapFunc,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 60,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(
                width: 1,
                color: Provider.of<ThemeProvider>(context).themeMode ==
                        ThemeMode.dark
                    ? Colors.grey.shade800
                    : Colors.white,
              ),
              borderRadius: BorderRadius.circular(15),
              color: Provider.of<ThemeProvider>(context).themeMode ==
                      ThemeMode.dark
                  ? Colors.black
                  : Colors.white,
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
              photoUrl == ""
                  ? Image.asset(
                      alt,
                      width: 50,
                      height: 50,
                    )
                  : CircleAvatar(
                      backgroundColor: Colors.grey,
                      backgroundImage: NetworkImage(
                        photoUrl!,
                      ),
                      radius: 25,
                    ),
              const SizedBox(
                width: 15,
              ),
              SizedBox(
                width: 200,
                child: CustomText(
                  text: "@$username",
                  textSize: 15,
                  textAlignment: TextAlign.left,
                  textWeight: FontWeight.w300,
                ),
              ),
            ]),
          ),
          SizedBox(height: bottomPadding),
        ],
      ),
    );
  }
}
