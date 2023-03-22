import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:scrap_real/themes/theme_provider.dart';
import 'package:scrap_real/views/navigation.dart';
import 'package:scrap_real/views/scrapbook_views/editScrapbook4.dart';
import 'package:scrap_real/widgets/button_widgets/custom_backbutton.dart';
import 'package:scrap_real/widgets/button_widgets/custom_textbutton.dart';
import 'package:scrap_real/widgets/card_widgets/custom_interestscard.dart';
import 'package:scrap_real/widgets/text_widgets/custom_header.dart';
import 'package:scrap_real/widgets/text_widgets/custom_subheader.dart';

class EditScrapbook3 extends StatefulWidget {
  final File? image;
  final String? title;
  final String? caption;
  final bool? tag;
  final bool? type;
  final bool? visibility;
  final Map<dynamic, dynamic> scrapbookData;
  final String scrapbookId;
  final String riddle;
  final String answer;

  const EditScrapbook3(
      {Key? key,
      required this.image,
      required this.title,
      required this.caption,
      required this.tag,
      required this.type,
      required this.visibility,
      required this.scrapbookData,
      required this.scrapbookId,
      required this.riddle,
      required this.answer})
      : super(key: key);

  @override
  State<EditScrapbook3> createState() => _EditScrapbook3State();
}

class _EditScrapbook3State extends State<EditScrapbook3> {
  bool creativity = false;
  bool travel = false;
  bool history = false;
  bool motivation = false;
  int interestIndex = -1;

  @override
  void initState() {
    super.initState();
    interestIndex = widget.scrapbookData['interestIndex'] ?? -1;
    if (interestIndex == 0) {
      creativity = true;
    } else if (interestIndex == 1) {
      travel = true;
    } else if (interestIndex == 2) {
      history = true;
    } else if (interestIndex == 3) {
      motivation = true;
    }
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
                    Navigator.popUntil(
                        context, ModalRoute.withName('/scrapbookExpanded'));
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
                    buttonBorderRadius: BorderRadius.circular(30),
                    buttonFunction: () {
                      if (interestIndex != -1) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditScrapbook4(
                              image: widget.image,
                              title: widget.title,
                              caption: widget.caption,
                              tag: widget.tag,
                              type: widget.type,
                              visibility: widget.visibility,
                              interestIndex: interestIndex,
                              riddle: widget.riddle,
                              answer: widget.answer,
                              scrapbookData: widget.scrapbookData,
                              scrapbookId: widget.scrapbookId,
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
