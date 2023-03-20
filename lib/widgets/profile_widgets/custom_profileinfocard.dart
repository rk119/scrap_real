// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scrap_real/themes/theme_provider.dart';
import 'package:scrap_real/widgets/profile_widgets/custom_bluecard.dart';
import 'package:gradient_floating_button/gradient_floating_button.dart';

class CustomUserProfileInfo extends StatelessWidget {
  CustomUserProfileInfo({
    Key? key,
    required this.numOfPosts,
    required this.followers,
    required this.following,
    required this.bioText,
    required this.cardColor,
    required this.isFollowing,
    required this.isCurrentUser,
    required this.onPressedFunc,
  }) : super(key: key);

  String numOfPosts;
  String followers;
  String following;
  String bioText;
  bool isFollowing;
  bool isCurrentUser;
  Function() onPressedFunc;
  Color cardColor;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.2,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(35),
                boxShadow: [
                  BoxShadow(
                    color: Provider.of<ThemeProvider>(context).themeMode ==
                            ThemeMode.dark
                        ? const Color.fromARGB(255, 52, 50, 50)
                        : Colors.grey.withOpacity(0.7),
                    offset: const Offset(4, 4),
                    blurRadius: 2,
                  ),
                  BoxShadow(
                    color: Provider.of<ThemeProvider>(context).themeMode ==
                            ThemeMode.dark
                        ? const Color.fromARGB(255, 52, 50, 50)
                        : Colors.grey.withOpacity(0.6),
                    offset: const Offset(-0.1, -0.1),
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
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Text(
                    bioText,
                    textAlign: TextAlign.left,
                  ),
                ),
              ]),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.03,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0),
              ),
            ),
          ],
        ),
        isCurrentUser
            ? const SizedBox()
            : Positioned(
                bottom: 8,
                right: 8,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0),
                    borderRadius: BorderRadius.circular(50),
                    boxShadow: [
                      BoxShadow(
                        color: Provider.of<ThemeProvider>(context).themeMode ==
                                ThemeMode.dark
                            ? const Color.fromARGB(255, 52, 50, 50)
                            : Colors.grey.withOpacity(0.2),
                        offset: const Offset(2, 2),
                        blurRadius: 2,
                      ),
                    ],
                  ),
                  child: GradientFloatingButton().withLinearGradient(
                      buttonHeight: 55,
                      buttonWidth: 55,
                      onTap: onPressedFunc,
                      iconWidget: isFollowing
                          ? const Icon(
                              Icons.check,
                              size: 27,
                              color: Colors.black,
                            )
                          : const Icon(
                              Icons.person_add_alt_1,
                              size: 27,
                              color: Colors.black,
                            ),
                      alignmentEnd: Alignment.topCenter,
                      alignmentBegin: Alignment.bottomCenter,
                      colors: [Color(0xffBDBBFA), Color(0xffA1FDFF)]),
                ),
              ),
      ],
    );
  }
}

// isCurrentUser
//             ? const SizedBox()
//             : Positioned(
//                 bottom: 8,
//                 right: 8,
//                 child: GradientFloatingButton().withLinearGradient(
//                     onTap: onPressedFunc,
//                     iconWidget: isFollowing
//                         ? const Icon(
//                             Icons.check,
//                             size: 25,
//                             color: Colors.black,
//                           )
//                         : const Icon(
//                             Icons.person_add_alt_1,
//                             size: 25,
//                             color: Colors.black,
//                           ),
//                     alignmentEnd: Alignment.topCenter,
//                     alignmentBegin: Alignment.bottomCenter,
//                     colors: [Color(0xffBDBBFA), Color(0xffA1FDFF)]),
//               ),