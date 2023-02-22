// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:scrap_real/themes/theme_provider.dart';
import 'package:scrap_real/utils/firestore_methods.dart';
import 'package:scrap_real/views/scrapbook_views/ar_view.dart';
import 'package:scrap_real/views/scrapbook_views/comments.dart';
import 'package:scrap_real/views/scrapbook_views/scrapbook_images.dart';
import 'package:scrap_real/widgets/button_widgets/custom_backbutton.dart';
import 'package:scrap_real/widgets/button_widgets/custom_textbutton.dart';
import 'package:scrap_real/widgets/text_widgets/custom_header.dart';
import 'package:scrap_real/widgets/text_widgets/custom_subheader.dart';
import 'package:scrap_real/widgets/text_widgets/custom_text.dart';

class ScrapbookExpandedView extends StatefulWidget {
  final String scrapbookId;
  const ScrapbookExpandedView({
    Key? key,
    required this.scrapbookId,
  }) : super(key: key);
  @override
  State<ScrapbookExpandedView> createState() => _ScrapbookExpandedViewState();
}

class _ScrapbookExpandedViewState extends State<ScrapbookExpandedView> {
  final user = FirebaseAuth.instance.currentUser!;
  var scrapbookData = {};
  bool posts = true;
  int postsLen = 0;
  int followers = 0;
  int following = 0;
  bool isFollowing = false;
  bool isCurrentUser = false;
  bool isLoading = true;
  bool isLiked = false;
  late bool isSaved;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    try {
      var scrapbookSnap = await FirebaseFirestore.instance
          .collection('scrapbooks')
          .doc(widget.scrapbookId)
          .get();

      // get post length
      // var scrapbookSnap = await FirebaseFirestore.instance
      //     .collection('scrapbooks')
      //     .where('creatorUid', isEqualTo: widget.uid)
      //     .get();

      // var sbCollabSnap = await FirebaseFirestore.instance
      //     .collection('scrapbooks')
      //     .where('collaborators', arrayContains: widget.uid)
      //     .get();
      scrapbookData = scrapbookSnap.data()!;
      // followers = userSnap.data()!['followers'].length;
      // following = userSnap.data()!['following'].length;
      // isFollowing = userSnap.data()!['followers'].contains(user.uid);
      isLiked = scrapbookData['likes'].contains(user.uid);
      if (await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get()
          .then((value) =>
              value.data()!['savedScrapbooks'].contains(widget.scrapbookId))) {
        setState(() {
          isSaved = false;
        });
      } else {
        setState(() {
          isSaved = true;
        });
      }
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      // ignore: avoid_print
      print(e);
      setState(() {
        isLoading = true;
      });
    }
  }

  Future requestAlert() {
    return showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: CustomSubheader(
          headerText: "Request Collaboration Access",
          headerSize: 20,
          headerColor: const Color(0xff918ef4),
        ),
        content: CustomText(
          text:
              "You are about to request collaboration access to this Scrapbook. Collaborators will be able to contribute to this scrapbook.\n\nWould you like to confirm?",
          textSize: 13,
          textAlignment: TextAlign.center,
          textWeight: FontWeight.w400,
        ),
        actions: <Widget>[
          Row(
            children: [
              CustomTextButton(
                buttonBorderRadius: BorderRadius.circular(35),
                buttonFunction: () {
                  Navigator.of(context).pop();
                  requestSentAlert();
                },
                buttonText: "Yes, I want access",
                buttonWidth: MediaQuery.of(context).size.width * 0.35,
                buttonHeight: 60,
                fontSize: 12,
              ),
              SizedBox(width: 22),
              CustomTextButton(
                buttonBorderRadius: BorderRadius.circular(35),
                buttonFunction: () {
                  Navigator.of(context).pop();
                },
                buttonText: "Cancel",
                buttonColor: Colors.grey.shade200,
                buttonWidth: MediaQuery.of(context).size.width * 0.35,
                buttonHeight: 60,
                fontSize: 12,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future requestSentAlert() {
    return showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              content: SizedBox(
                width: double.maxFinite,
                height: 140,
                child: Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    CustomSubheader(
                      headerText: "Request Sent!",
                      headerSize: 20,
                      headerColor: const Color(0xff918ef4),
                    ),
                  ],
                ),
              ),
            ));
  }

  void containSavedPost() async {
    if (await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get()
        .then((value) =>
            value.data()!['savedScrapbooks'].contains(widget.scrapbookId))) {
      setState(() {
        isSaved = true;
      });
    } else {
      setState(() {
        isSaved = false;
      });
    }
  }

  void reportScrapbook() {
    // ignore: avoid_print
    print('report');
  }

  @override
  Widget build(BuildContext context) {
    var greyColor =
        Provider.of<ThemeProvider>(context).themeMode == ThemeMode.dark
            ? Colors.grey.shade800
            : Colors.grey.shade200;

    return isLoading
        ? Container(
            color:
                Provider.of<ThemeProvider>(context).themeMode == ThemeMode.dark
                    ? Colors.grey.shade900
                    : Colors.white,
            child: const Center(
              child: CircularProgressIndicator(color: Color(0xFF918EF4)),
            ),
          )
        : Scaffold(
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
                        Navigator.of(context).pop();
                      }),
                      CustomHeader(headerText: scrapbookData['title']),
                      const SizedBox(height: 15),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            height: 200,
                            width: 350,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: greyColor,
                              image: DecorationImage(
                                image: NetworkImage(scrapbookData['coverUrl']),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              InkWell(
                                onTap: () async {
                                  FireStoreMethods().likeScrapbook(
                                    widget.scrapbookId,
                                    user.uid,
                                  );
                                  setState(() {
                                    isLiked = !isLiked;
                                  });
                                },
                                child: isLiked
                                    ? Icon(
                                        Icons.favorite,
                                        color: Colors.red,
                                        size: 30,
                                      )
                                    : Icon(
                                        Icons.favorite_border,
                                        size: 30,
                                      ),
                              ),
                              const SizedBox(width: 15),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ScrapbookCommentsPage(
                                        scrapbookId: widget.scrapbookId,
                                      ),
                                    ),
                                  );
                                },
                                child: Icon(
                                  Icons.comment,
                                  color: Color(0xFF918EF4),
                                  size: 30,
                                ),
                              ),
                              const SizedBox(width: 15),
                              InkWell(
                                onTap: () {
                                  requestAlert();
                                },
                                child: Icon(
                                  Icons.person_add_alt_1,
                                  color: Color(0xFF918EF4),
                                  size: 30,
                                ),
                              ),
                            ],
                          ),
                          PopupMenuButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              onSelected: (value) {
                                value == 'save'
                                    ? FireStoreMethods().saveScrapbook(
                                        widget.scrapbookId, context)
                                    : reportScrapbook();
                              },
                              itemBuilder: (BuildContext context) {
                                containSavedPost();
                                return [
                                  PopupMenuItem(
                                      value: 'save',
                                      child: CustomText(
                                        text: isSaved ? 'Save' : 'Unsave',
                                        textSize: 15,
                                      )),
                                  PopupMenuItem(
                                      value: 'report',
                                      child: CustomText(
                                        text: 'Report',
                                        textSize: 15,
                                      ))
                                ];
                              }),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: greyColor,
                            ),
                          ),
                          CustomText(
                            text: scrapbookData['caption'] ?? "",
                            textSize: 15,
                          ),
                        ],
                      ),
                      SizedBox(height: 15),
                      CustomTextButton(
                        buttonBorderRadius: BorderRadius.circular(35),
                        buttonFunction: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ScrapbookImagesPage(
                                scrapbookId: widget.scrapbookId,
                              ),
                            ),
                          );
                        },
                        buttonText: "View images",
                        buttonColor: Colors.grey.shade200,
                      ),
                      SizedBox(height: 15),
                      CustomTextButton(
                        buttonBorderRadius: BorderRadius.circular(35),
                        buttonFunction: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const AugmentedRealityView(),
                            ),
                          );
                        },
                        buttonText: "View in AR",
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
