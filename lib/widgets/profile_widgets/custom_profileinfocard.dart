// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
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
        boxShadow: const [
          BoxShadow(
            color: Color(0x19000000),
            offset: Offset(2, 4),
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
            const SizedBox(width: 25),
            Expanded(
              child: CustomBlueUserInfoCard(
                text1: followers,
                text2: "Followers",
              ),
            ),
            const SizedBox(width: 25),
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
