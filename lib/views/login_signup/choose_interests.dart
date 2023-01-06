import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scrap_real/views/login_signup/set_profile.dart';
import 'package:scrap_real/views/navigation.dart';
import 'package:scrap_real/views/utils/buttons/custom_backbutton.dart';
import 'package:scrap_real/views/utils/buttons/custom_textbutton.dart';
import 'package:scrap_real/views/utils/cards/custom_interestscard.dart';
import 'package:scrap_real/views/utils/headers/custom_header.dart';
import 'package:scrap_real/views/utils/headers/custom_subheader.dart';

class ChooseInterestsPage extends StatefulWidget {
  const ChooseInterestsPage({Key? key}) : super(key: key);
  @override
  State<ChooseInterestsPage> createState() => _ChooseInterestsPageState();
}

class _ChooseInterestsPageState extends State<ChooseInterestsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(
              horizontal: 30,
              vertical: 50,
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CustomBackButton(buttonFunction: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SetProfilePage()),
                    );
                  }),
                  CustomHeader(headerText: "Interests"),
                  const SizedBox(height: 12),
                  CustomSubheader(
                    headerText:
                        "Select at least 1 category you'd like to receive recommendations on",
                    headerSize: 20,
                    headerColor: const Color(0xffa09f9f),
                  ),
                  const SizedBox(height: 32),
                  CustomInterestsCard(
                    buttonColor: const Color(0xffffffff),
                    buttonBorderRadius: BorderRadius.circular(15),
                    buttonText: "Creativity",
                    svgPath: 'assets/creativity.svg',
                    buttonFunction: () {},
                  ),
                  const SizedBox(height: 25),
                  CustomInterestsCard(
                    buttonColor: const Color(0xffffffff),
                    buttonBorderRadius: BorderRadius.circular(15),
                    buttonText: "Travel",
                    svgPath: 'assets/travel.svg',
                    buttonFunction: () {},
                  ),
                  const SizedBox(height: 25),
                  CustomInterestsCard(
                    buttonColor: const Color(0xffffffff),
                    buttonBorderRadius: BorderRadius.circular(15),
                    buttonText: "History",
                    svgPath: 'assets/creativity.svg',
                    buttonFunction: () {},
                  ),
                  const SizedBox(height: 25),
                  CustomInterestsCard(
                    buttonColor: const Color(0xffffffff),
                    buttonBorderRadius: BorderRadius.circular(15),
                    buttonText: "Motivation",
                    svgPath: 'assets/travel.svg',
                    buttonFunction: () {},
                  ),
                  const SizedBox(height: 44),
                  CustomTextButton(
                    buttonBorderRadius: BorderRadius.circular(30),
                    buttonFunction: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const NavBar()),
                      );
                    },
                    buttonText: "Done",
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
