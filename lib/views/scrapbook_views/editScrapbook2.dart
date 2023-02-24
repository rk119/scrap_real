import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:scrap_real/themes/theme_provider.dart';
import 'package:scrap_real/views/navigation.dart';
import 'package:scrap_real/views/scrapbook_views/editScrapbook3.dart';
import 'package:scrap_real/widgets/button_widgets/custom_backbutton.dart';
import 'package:scrap_real/widgets/button_widgets/custom_textbutton.dart';
import 'package:scrap_real/widgets/card_widgets/custom_usercard.dart';
import 'package:scrap_real/widgets/text_widgets/custom_header.dart';
import 'package:scrap_real/widgets/selection_widgets/custom_selectiontab1.dart';
import 'package:scrap_real/widgets/selection_widgets/custom_selectiontab2.dart';

class EditScrapbook2 extends StatefulWidget {
  final File? image;
  final String? title;
  final String? caption;
  final bool? tag;
  final bool? type;
  final bool? visibility;
  final List<dynamic>? images;
  final String scrapbookId;

  const EditScrapbook2(
      {Key? key,
      required this.image,
      required this.title,
      required this.caption,
      required this.tag,
      required this.type,
      required this.visibility,
      required this.images,
      required this.scrapbookId})
      : super(key: key);

  @override
  State<EditScrapbook2> createState() => _EditScrapbook2State();
}

class _EditScrapbook2State extends State<EditScrapbook2> {
  late bool? prevTag = widget.tag;
  late bool? prevType = widget.type;
  late bool? prevVisibility = widget.visibility;
  bool tag = true;
  bool type = true;
  bool visibility = true;

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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CustomBackButton(buttonFunction: () {
                  Navigator.pop(context);
                }),
                CustomHeader(headerText: "Create Scrapbook"),
                const SizedBox(height: 15),
                subheader("Tag"),
                const SizedBox(height: 5),
                CustomSelectionTab1(
                  selection: widget.tag!,
                  selection1: "Factual",
                  selecion2: "Personal",
                  path1: "assets/images/factual.png",
                  path2: "assets/images/personal.png",
                  func1: () {
                    if (tag == false) {
                      setState(() {
                        tag = true;
                      });
                    }
                  },
                  func2: () {
                    if (tag == true) {
                      setState(() {
                        tag = false;
                      });
                    }
                  },
                  insets1: const EdgeInsets.fromLTRB(16, 5, 27.46, 5),
                  insets2: const EdgeInsets.fromLTRB(14, 7, 21, 7),
                ),
                const SizedBox(height: 15),
                subheader("Type"),
                const SizedBox(height: 5),
                CustomSelectionTab1(
                  selection: widget.type!,
                  selection1: "Normal",
                  selecion2: "Challenge",
                  path1: "assets/images/normal.png",
                  path2: "assets/images/challenge.png",
                  func1: () {
                    if (type == false) {
                      setState(() {
                        type = true;
                      });
                    }
                  },
                  func2: () {
                    if (type == true) {
                      setState(() {
                        type = false;
                      });
                    }
                  },
                  insets1: const EdgeInsets.fromLTRB(20, 7, 22, 7),
                  insets2: const EdgeInsets.fromLTRB(13, 7, 13, 7),
                ),
                const SizedBox(height: 20),
                subheader("Visibility"),
                const SizedBox(height: 10),
                CustomSelectionTab2(
                  selection: widget.visibility!,
                  selection1: "Public",
                  selecion2: "Private",
                  func1: () {
                    if (visibility == false) {
                      setState(() {
                        visibility = true;
                      });
                    }
                  },
                  func2: () {
                    if (visibility == true) {
                      setState(() {
                        visibility = false;
                      });
                    }
                  },
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.35),
                CustomTextButton(
                  buttonBorderRadius: BorderRadius.circular(30),
                  buttonFunction: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditScrapbook3(
                          image: widget.image,
                          title: widget.title,
                          caption: widget.caption,
                          tag: tag,
                          type: type,
                          visibility: visibility,
                          images: widget.images,
                          scrapbookId: widget.scrapbookId,
                        ),
                      ),
                    );
                  },
                  buttonText: "Next",
                  buttonColor: const Color(0xff7be5e7),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget subheader(String text) {
    return Container(
      alignment: const Alignment(-1.0, 0),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          height: 1.5,
          color: Provider.of<ThemeProvider>(context).themeMode == ThemeMode.dark
              ? const Color(0xffd1e1ff)
              : const Color(0xff141b41),
        ),
      ),
    );
  }
}
