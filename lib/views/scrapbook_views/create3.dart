import 'dart:io';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:scrap_real/themes/theme_provider.dart';
import 'package:scrap_real/utils/firestore_methods.dart';
import 'package:scrap_real/views/navigation.dart';
import 'package:scrap_real/views/scrapbook_views/create4.dart';
import 'package:scrap_real/widgets/button_widgets/custom_backbutton.dart';
import 'package:scrap_real/widgets/button_widgets/custom_textbutton.dart';
import 'package:scrap_real/widgets/card_widgets/custom_interestscard.dart';
import 'package:scrap_real/widgets/card_widgets/custom_usercard.dart';
import 'package:scrap_real/widgets/text_widgets/custom_header.dart';
import 'package:scrap_real/widgets/selection_widgets/custom_selectiontab1.dart';
import 'package:scrap_real/widgets/selection_widgets/custom_selectiontab2.dart';
import 'package:scrap_real/widgets/text_widgets/custom_subheader.dart';

class CreateScrapbookPage3 extends StatefulWidget {
  final File? coverImage;
  final String title;
  final String caption;
  final bool tag;
  final bool type;
  final bool visibility;
  final Map<String, bool> collaborators;
  final bool group;
  final String riddle;
  final String answer;

  const CreateScrapbookPage3({
    Key? key,
    required this.coverImage,
    required this.title,
    required this.caption,
    required this.tag,
    required this.type,
    required this.visibility,
    required this.collaborators,
    required this.group,
    required this.riddle,
    required this.answer,
  }) : super(key: key);

  @override
  State<CreateScrapbookPage3> createState() => _CreateScrapbookPage3State();
}

class _CreateScrapbookPage3State extends State<CreateScrapbookPage3> {
  bool creativity = false;
  bool travel = false;
  bool history = false;
  bool motivation = false;
  int interestIndex = -1;

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
                        builder: (context) => NavBar(
                          currentIndex: 2,
                        ),
                      ),
                    );
                  }),
                  CustomHeader(headerText: "Category"),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  CustomSubheader(
                    headerText:
                        "Select a category that your Scrapbook is based on",
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
                        if (!creativity) {
                          creativity = !creativity;
                          interestIndex = 0;
                          if (travel) {
                            travel = !travel;
                          }
                          if (history) {
                            history = !history;
                          }
                          if (motivation) {
                            motivation = !motivation;
                          }
                        }
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
                        if (!travel) {
                          travel = !travel;
                          interestIndex = 1;
                          if (creativity) {
                            creativity = !creativity;
                          }
                          if (history) {
                            history = !history;
                          }
                          if (motivation) {
                            motivation = !motivation;
                          }
                        }
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
                        if (!history) {
                          history = !history;
                          interestIndex = 2;
                          if (creativity) {
                            creativity = !creativity;
                          }
                          if (travel) {
                            travel = !travel;
                          }
                          if (motivation) {
                            motivation = !motivation;
                          }
                        }
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
                        if (!motivation) {
                          motivation = !motivation;
                          interestIndex = 3;
                          if (creativity) {
                            creativity = !creativity;
                          }
                          if (history) {
                            history = !history;
                          }
                          if (travel) {
                            travel = !travel;
                          }
                        }
                      });
                    },
                    selected: motivation,
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.08),
                  CustomTextButton(
                    key: const Key('nextScrapbookOption3'),
                    buttonBorderRadius: BorderRadius.circular(30),
                    buttonFunction: () {
                      if (interestIndex != -1) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CreateScrapbookPage4(
                              coverImage: widget.coverImage,
                              title: widget.title,
                              caption: widget.caption,
                              tag: widget.tag,
                              type: widget.type,
                              visibility: widget.visibility,
                              collaborators: widget.collaborators,
                              group: widget.group,
                              riddle: widget.riddle,
                              answer: widget.answer,
                              interestIndex: interestIndex,
                            ),
                          ),
                        );
                      }
                    },
                    buttonText: "Next",
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
