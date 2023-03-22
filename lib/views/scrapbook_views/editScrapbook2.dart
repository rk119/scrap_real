import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:scrap_real/themes/theme_provider.dart';
import 'package:scrap_real/views/scrapbook_views/editScrapbook3.dart';
import 'package:scrap_real/widgets/button_widgets/custom_backbutton.dart';
import 'package:scrap_real/widgets/button_widgets/custom_textbutton.dart';
import 'package:scrap_real/widgets/text_widgets/custom_header.dart';
import 'package:scrap_real/widgets/selection_widgets/custom_selectiontab1.dart';
import 'package:scrap_real/widgets/selection_widgets/custom_selectiontab2.dart';

class EditScrapbook2 extends StatefulWidget {
  final File? image;
  final String? title;
  final String? caption;
  final Map<dynamic, dynamic> scrapbookData;
  final String scrapbookId;

  const EditScrapbook2(
      {Key? key,
      required this.image,
      required this.title,
      required this.caption,
      required this.scrapbookData,
      required this.scrapbookId})
      : super(key: key);

  @override
  State<EditScrapbook2> createState() => _EditScrapbook2State();
}

class _EditScrapbook2State extends State<EditScrapbook2> {
  late bool tag = widget.scrapbookData['tag'] == "Factual" ? true : false;
  late bool type = widget.scrapbookData['type'] == "Normal" ? true : false;
  late bool visibility =
      widget.scrapbookData['visibility'] == "Public" ? true : false;

  final TextEditingController riddle = TextEditingController();
  final TextEditingController answer = TextEditingController();

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() {
    riddle.text = widget.scrapbookData['riddle'] ?? "";
    answer.text = widget.scrapbookData['answer'] ?? "";
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CustomBackButton(buttonFunction: () {
                  Navigator.popUntil(
                      context, ModalRoute.withName('/scrapbookExpanded'));
                }),
                CustomHeader(headerText: "Edit Scrapbook"),
                const SizedBox(height: 15),
                subheader("Tag"),
                const SizedBox(height: 5),
                CustomSelectionTab1(
                  selection: tag,
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
                  selection: type,
                  selection1: "Normal",
                  selecion2: "Secret",
                  path1: "assets/images/normal.png",
                  path2: "assets/images/mystery-box.png",
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
                  insets2: const EdgeInsets.fromLTRB(23, 7, 23, 7),
                ),
                const SizedBox(height: 20),
                type == true ? subheader("Visibility") : const SizedBox(),
                const SizedBox(height: 10),
                type == true
                    ? CustomSelectionTab2(
                        selection: visibility,
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
                      )
                    : const SizedBox(),
                type == false
                    ? Column(
                        children: [
                          subheader("Enter your secret code"),
                          const SizedBox(height: 10),
                          Container(
                            alignment: Alignment.topLeft,
                            decoration: BoxDecoration(
                              color: Provider.of<ThemeProvider>(context)
                                          .themeMode ==
                                      ThemeMode.dark
                                  ? Colors.black
                                  : const Color(0xfffdfbfb),
                              borderRadius: BorderRadius.circular(6),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x3f000000),
                                  blurRadius: 2,
                                  offset: Offset(1, 2),
                                )
                              ],
                            ),
                            height: 50,
                            child: Wrap(
                              children: [
                                Stack(
                                  children: [
                                    SizedBox(
                                      width: 310,
                                      child: TextFormField(
                                        controller: riddle,
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        keyboardType: TextInputType.name,
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return "Please enter a riddle";
                                          }
                                          return null;
                                        },
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          contentPadding:
                                              const EdgeInsets.all(10),
                                          hintText: "Riddle",
                                          hintStyle: GoogleFonts.poppins(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            height: 1.5,
                                            color: const Color.fromARGB(
                                                255, 193, 193, 193),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 40),
                          Container(
                            alignment: Alignment.topLeft,
                            decoration: BoxDecoration(
                              color: Provider.of<ThemeProvider>(context)
                                          .themeMode ==
                                      ThemeMode.dark
                                  ? Colors.black
                                  : const Color(0xfffdfbfb),
                              borderRadius: BorderRadius.circular(6),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x3f000000),
                                  blurRadius: 2,
                                  offset: Offset(1, 2),
                                )
                              ],
                            ),
                            height: 50,
                            child: Wrap(
                              children: [
                                Stack(
                                  children: [
                                    SizedBox(
                                      width: 310,
                                      child: TextFormField(
                                        controller: answer,
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        keyboardType: TextInputType.name,
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return "Please enter the answer";
                                          }
                                          return null;
                                        },
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          contentPadding:
                                              const EdgeInsets.all(10),
                                          hintText: "Secret answer",
                                          hintStyle: GoogleFonts.poppins(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            height: 1.5,
                                            color: const Color.fromARGB(
                                                255, 193, 193, 193),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    : const SizedBox(),
                type == true
                    ? SizedBox(
                        height: MediaQuery.of(context).size.height * 0.35)
                    : SizedBox(
                        height: MediaQuery.of(context).size.height * 0.20),
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
                          scrapbookData: widget.scrapbookData,
                          scrapbookId: widget.scrapbookId,
                          riddle: riddle.text.trim(),
                          answer: answer.text.trim().toLowerCase(),
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
