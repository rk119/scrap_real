// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scrap_real/themes/theme_provider.dart';
import 'package:scrap_real/widgets/profile_widgets/custom_bluecard.dart';

class CustomUserProfileInfo extends StatelessWidget {
  CustomUserProfileInfo({
    Key? key,
    required this.numOfPosts,
    required this.followers,
    required this.following,
    required this.bioText,
    required this.cardColor,
  }) : super(key: key);

  String numOfPosts;
  String followers;
  String following;
  String bioText;
  Color cardColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 360,
      height: 175,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(35),
        boxShadow: [
          BoxShadow(
            color:
                Provider.of<ThemeProvider>(context).themeMode == ThemeMode.dark
                    ? const Color.fromARGB(255, 52, 50, 50)
                    : const Color.fromARGB(255, 247, 242, 242),
            offset: const Offset(4, 4),
            blurRadius: 2,
          ),
        ],
      ),
      child: Column(children: [
        // const SizedBox(height: 22),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: CustomBlueUserInfoCard(
                text1: numOfPosts,
                text2: "Posts",
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: CustomBlueUserInfoCard(
                text1: followers,
                text2: "Followers",
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: CustomBlueUserInfoCard(
                text1: following,
                text2: "Following",
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        SizedBox(
          width: 300,
          child: Text(
            bioText,
            textAlign: TextAlign.left,
          ),
        ),
      ]),
    );
  }
}
