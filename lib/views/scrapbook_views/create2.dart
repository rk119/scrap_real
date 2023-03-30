import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:scrap_real/themes/theme_provider.dart';
import 'package:scrap_real/views/navigation.dart';
import 'package:scrap_real/views/scrapbook_views/create3.dart';
import 'package:scrap_real/widgets/button_widgets/custom_backbutton.dart';
import 'package:scrap_real/widgets/button_widgets/custom_textbutton.dart';
import 'package:scrap_real/widgets/card_widgets/custom_usercard.dart';
import 'package:scrap_real/widgets/text_widgets/custom_header.dart';
import 'package:scrap_real/widgets/selection_widgets/custom_selectiontab1.dart';
import 'package:scrap_real/widgets/selection_widgets/custom_selectiontab2.dart';

class CreateScrapbookPage2 extends StatefulWidget {
  final File? image;
  final String title;
  final String caption;
  const CreateScrapbookPage2({
    Key? key,
    required this.title,
    required this.caption,
    required this.image,
  }) : super(key: key);
  @override
  State<CreateScrapbookPage2> createState() => _CreateScrapbookPage2State();
}

class _CreateScrapbookPage2State extends State<CreateScrapbookPage2> {
  bool tag = true;
  bool type = true;
  bool visibility = true;
  String _searchQuery = "";
  bool search = true;
  final TextEditingController _collaborator = TextEditingController();

  final Map<String, bool> _collaborators = {};
  final TextEditingController riddle = TextEditingController();
  final TextEditingController answer = TextEditingController();

  @override
  void initState() {
    setState(() {
      tag = true;
      type = true;
      visibility = true;
    });
    super.initState();
  }

  @override
  void dispose() {
    _collaborator.dispose();
    super.dispose();
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NavBar(
                        currentIndex: 2,
                      ),
                    ),
                  );
                }),
                CustomHeader(headerText: "Create Scrapbook"),
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
                const SizedBox(height: 20),
                type == true
                    ? Column(
                        children: [
                          subheader("Collaborators"),
                          buildAddCollaborators(),
                          const SizedBox(height: 10),
                          _searchQuery.isNotEmpty
                              ? usersView()
                              : const SizedBox(),
                          const SizedBox(height: 10),
                          buildCollaborators(),
                        ],
                      )
                    : Column(
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
                      ),
                type == true
                    ? const SizedBox(height: 30)
                    : const SizedBox(height: 150),
                CustomTextButton(
                  key: const Key('nextScrapbookOption2'),
                  buttonBorderRadius: BorderRadius.circular(30),
                  buttonFunction: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CreateScrapbookPage3(
                          coverImage: widget.image,
                          title: widget.title,
                          caption: widget.caption,
                          tag: tag,
                          type: type,
                          visibility: visibility,
                          collaborators: _collaborators,
                          group: _collaborators.isNotEmpty,
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

  Widget usersView() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (context, snapshots) {
        if (!snapshots.hasData) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF918EF4)),
          );
        }
        return (snapshots.connectionState == ConnectionState.waiting)
            ? const Center(
                child: CircularProgressIndicator(color: Color(0xFF918EF4)),
              )
            : ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: snapshots.data!.docs.length,
                itemBuilder: (context, index) {
                  var data = snapshots.data!.docs[index].data()
                      as Map<String, dynamic>;
                  if (data['username']
                      .toString()
                      .toLowerCase()
                      .startsWith(_searchQuery.toLowerCase())) {
                    return !_collaborators.containsKey(data['username'])
                        ? CustomUserCard(
                            photoUrl: data['photoUrl'],
                            alt: "assets/images/profile.png",
                            username: data['username'],
                            onTapFunc: () => setState(() {
                              _collaborators.addAll({data['username']: false});
                            }),
                            bottomPadding: 5,
                          )
                        : Container();
                  }
                  return Container();
                },
              );
      },
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

  Widget buildAddCollaborators() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 45,
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.60,
                decoration: BoxDecoration(
                  color: Provider.of<ThemeProvider>(context).themeMode ==
                          ThemeMode.dark
                      ? Colors.black
                      : const Color(0xfffdfbfb),
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x3f000000),
                      offset: Offset(0, 1),
                      blurRadius: 2,
                    ),
                  ],
                ),
                child: TextField(
                  controller: _collaborator,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(10),
                    hintText: 'username',
                    hintStyle: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      height: 1.5,
                      color: const Color.fromARGB(255, 193, 193, 193),
                    ),
                  ),
                  onChanged: (value) => setState(() {
                    _searchQuery = value;
                    // _scrollController.animateTo();
                    // _scrollController.animateTo(offset,
                    // duration: duration, curve: curve);
                  }),
                ),
              ),
            ),
            // const SizedBox(width: 10),
            // Container(
            //   width: MediaQuery.of(context).size.width * 0.125,
            //   height: 45,
            //   decoration: BoxDecoration(
            //     color: const Color(0xffB0F0F1),
            //     borderRadius: BorderRadius.circular(6),
            //   ),
            //   child: TextButton(
            //     onPressed: () {
            //       setState(() {
            //         _collaborators.add(_collaborator.text);
            //         _collaborator.clear();
            //       });
            //     },
            //     child: const Icon(Icons.add, color: Colors.black, size: 30),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Widget buildCollaborators() {
    return Scrollbar(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 150,
        decoration: BoxDecoration(
          color: Provider.of<ThemeProvider>(context).themeMode == ThemeMode.dark
              ? Colors.black
              : const Color(0xfffdfbfb),
          borderRadius: BorderRadius.circular(6),
          boxShadow: const [
            BoxShadow(
              color: Color(0x3f000000),
              offset: Offset(0, 1),
              blurRadius: 2,
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Wrap(
            children: _collaborators.keys
                .map(
                  (collaborator) => Container(
                    margin: const EdgeInsets.all(5),
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                    decoration: BoxDecoration(
                      color: const Color(0xff141B41),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          collaborator,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            height: 1.5,
                            color: const Color(0xffffffff),
                          ),
                        ),
                        const SizedBox(width: 15),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _collaborators.remove(collaborator);
                            });
                          },
                          child: Icon(
                            Icons.cancel,
                            color:
                                Provider.of<ThemeProvider>(context).themeMode ==
                                        ThemeMode.dark
                                    ? Colors.black
                                    : const Color(0xfffdfbfb),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}
