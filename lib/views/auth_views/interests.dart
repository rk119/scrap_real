import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scrap_real/utils/firestore_methods.dart';
import 'package:scrap_real/views/auth_views/set_profile.dart';
import 'package:scrap_real/widgets/button_widgets/custom_backbutton.dart';
import 'package:scrap_real/widgets/button_widgets/custom_textbutton.dart';
import 'package:scrap_real/widgets/card_widgets/custom_interestscard.dart';
import 'package:scrap_real/widgets/text_widgets/custom_header.dart';
import 'package:scrap_real/widgets/text_widgets/custom_subheader.dart';

// ignore: must_be_immutable
class ChooseInterestsPage extends StatefulWidget {
  final String name;
  final String bio;
  final String? photoUrl;
  PlatformFile? pickedFile;
  ChooseInterestsPage({
    Key? key,
    required this.name,
    required this.bio,
    required this.photoUrl,
    required this.pickedFile,
  }) : super(key: key);
  @override
  State<ChooseInterestsPage> createState() => _ChooseInterestsPageState();
}

class _ChooseInterestsPageState extends State<ChooseInterestsPage> {
  bool creativity = false;
  bool travel = false;
  bool history = false;
  bool motivation = false;
  List<bool> interests = [];
  final uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    setState(() {
      creativity = false;
      travel = false;
      history = false;
      motivation = false;
    });
  }

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
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  CustomSubheader(
                    headerText:
                        "Select at least 1 category you'd like to receive recommendations on",
                    headerSize: 20,
                    headerColor: const Color(0xffa09f9f),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                  CustomInterestsCard(
                    buttonColor: const Color(0xffffffff),
                    buttonBorderRadius: BorderRadius.circular(15),
                    buttonText: "Creativity",
                    svgPath: 'assets/creativity.svg',
                    buttonFunction: () {
                      setState(() {
                        creativity = !creativity;
                      });
                    },
                    selected: creativity,
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                  CustomInterestsCard(
                    buttonColor: const Color(0xffffffff),
                    buttonBorderRadius: BorderRadius.circular(15),
                    buttonText: "Travel",
                    svgPath: 'assets/travel.svg',
                    buttonFunction: () {
                      setState(() {
                        travel = !travel;
                      });
                    },
                    selected: travel,
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                  CustomInterestsCard(
                    buttonColor: const Color(0xffffffff),
                    buttonBorderRadius: BorderRadius.circular(15),
                    buttonText: "History",
                    svgPath: 'assets/history.svg',
                    buttonFunction: () {
                      setState(() {
                        history = !history;
                      });
                    },
                    selected: history,
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                  CustomInterestsCard(
                    buttonColor: const Color(0xffffffff),
                    buttonBorderRadius: BorderRadius.circular(15),
                    buttonText: "Motivation",
                    svgPath: 'assets/motivation.svg',
                    buttonFunction: () {
                      setState(() {
                        motivation = !motivation;
                      });
                    },
                    selected: motivation,
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.08),
                  CustomTextButton(
                    buttonBorderRadius: BorderRadius.circular(30),
                    buttonFunction: () {
                      interests = [creativity, travel, history, motivation];
                      setProfile();
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

  void setProfile() {
    FireStoreMethods().setProfile(
      uid,
      context,
      widget.name,
      widget.bio,
      widget.pickedFile,
      widget.photoUrl,
      interests,
      mounted,
    );
  }
}
