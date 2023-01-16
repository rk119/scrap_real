// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:scrap_real/themes/theme_provider.dart';
import 'package:scrap_real/utils/custom_snackbar.dart';
import 'package:scrap_real/views/scrapbook_views/ar_view.dart';
import 'package:scrap_real/views/scrapbook_views/comments.dart';
import 'package:scrap_real/views/scrapbook_views/scrapbook_images.dart';
import 'package:scrap_real/views/settings_views/saved_scraps.dart';
import 'package:scrap_real/widgets/button_widgets/custom_backbutton.dart';
import 'package:scrap_real/widgets/button_widgets/custom_textbutton.dart';
import 'package:scrap_real/widgets/text_widgets/custom_header.dart';
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
  var scrapbookData = {};
  bool posts = true;
  int postsLen = 0;
  int followers = 0;
  int following = 0;
  bool isFollowing = false;
  bool isCurrentUser = false;
  bool isLoading = true;

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
              child: CircularProgressIndicator(),
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
                            height: 250,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: greyColor,
                            ),
                          ),
                          CustomText(
                            text: "Scrapbook cover image",
                            textSize: 15,
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          InkWell(
                            onTap: () {},
                            child: Icon(
                              Icons.heart_broken,
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
                                      const ScrapbookCommentsPage(),
                                ),
                              );
                            },
                            child: Icon(
                              Icons.comment,
                              size: 30,
                            ),
                          ),
                          const SizedBox(width: 15),
                          InkWell(
                            onTap: () {},
                            child: Icon(
                              Icons.share,
                              size: 30,
                            ),
                          ),
                          SizedBox(width: 15),
                          Expanded(
                            child: Align(
                              alignment: Alignment.topRight,
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const SavedScrapbooksPage(),
                                    ),
                                  );
                                  CustomSnackBar.snackBarAlert(
                                      context, "Saved!");
                                },
                                child: Icon(
                                  Icons.bookmark,
                                  size: 30,
                                ),
                              ),
                            ),
                          ),
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
