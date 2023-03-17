// ignore_for_file: prefer_const_constructors
import 'globals.dart' as globals;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:scrap_real/themes/theme_provider.dart';
import 'package:scrap_real/utils/custom_snackbar.dart';
import 'package:scrap_real/utils/firestore_methods.dart';
import 'package:scrap_real/views/scrapbook_views/collaborators.dart';
import 'package:scrap_real/views/scrapbook_views/comments.dart';
import 'package:scrap_real/views/scrapbook_views/editScrapbook1.dart';
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
  var userData = {};
  bool posts = true;
  int postsLen = 0;
  int followers = 0;
  int following = 0;
  bool isFollowing = false;
  bool isCurrentUser = false;
  bool isLoading = true;
  bool isLiked = false;
  bool isSaved = false;
  bool privileged = false;
  int numLikes = 0;

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  void dispose() {
    super.dispose();
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

      scrapbookData = scrapbookSnap.data()!;
      var userName = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get()
          .then((value) => value.data()!['username']);
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(scrapbookData['creatorUid'])
          .get();

      userData = userSnap.data()!;
      // followers = userSnap.data()!['followers'].length;
      // following = userSnap.data()!['following'].length;
      // isFollowing = userSnap.data()!['followers'].contains(user.uid);
      isLiked = scrapbookData['likes'].contains(user.uid);
      numLikes = scrapbookData['likes'].length;

      globals.numComments = await FirebaseFirestore.instance
          .collection('comment')
          .doc(widget.scrapbookId)
          .collection('comments')
          .get()
          .then((value) => value.docs.length);
      privileged = scrapbookData['creatorUid'] == user.uid ||
          scrapbookData['collaborators'].keys.contains(userName);
      if (await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get()
          .then((value) =>
              value.data()!['savedPosts'].contains(widget.scrapbookId))) {
        setState(() {
          isSaved = true;
        });
      } else {
        setState(() {
          isSaved = false;
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
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
            value.data()!['savedPosts'].contains(widget.scrapbookId))) {
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
    showDialog(
        context: context,
        builder: (BuildContext context) {
          TextEditingController reportController = TextEditingController();
          return AlertDialog(
            title: const Text("Report Scrapbook"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                    "Please provide a reason for reporting this scrapbook."),
                const SizedBox(height: 10),
                TextField(
                  controller: reportController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Reason',
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () {
                  FireStoreMethods().reportScrapbook(
                      widget.scrapbookId, reportController.text, context);

                  CustomSnackBar.showSnackBar(context, 'Scrapbook reported');

                  Navigator.pop(context);
                },
                child: const Text("Report"),
              )
            ],
          );
        });
  }

  void deleteScrapbook() {
    /* show an alert box confirming delete */
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: CustomSubheader(
          headerText: "Delete Scrapbook",
          headerSize: 20,
          headerColor: const Color(0xffBC2D21),
        ),
        content: CustomText(
          text:
              "You are about to delete this Scrapbook. This action cannot be undone.\n\nWould you like to confirm?",
          textSize: 13,
          textAlignment: TextAlign.center,
          textWeight: FontWeight.w400,
        ),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CustomTextButton(
                buttonTextColor: Colors.white,
                buttonBorderRadius: BorderRadius.circular(35),
                buttonFunction: () {
                  Navigator.of(context).pop();
                  FireStoreMethods()
                      .deleteScrapbook(widget.scrapbookId, context);
                },
                buttonText: "Yes, delete",
                buttonWidth: MediaQuery.of(context).size.width * 0.35,
                buttonHeight: 60,
                fontSize: 12,
                buttonColor: const Color(0xffBC2D21),
              ),
              CustomTextButton(
                buttonBorderRadius: BorderRadius.circular(35),
                buttonFunction: () {
                  Navigator.of(context, rootNavigator: true).pop();
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomBackButton(buttonFunction: () {
                            Navigator.of(context).pop();
                          }),
                          SizedBox(
                            child: privileged
                                ? IconButton(
                                    iconSize: 25,
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => EditScrapbook1(
                                            scrapbookId: widget.scrapbookId,
                                          ),
                                        ),
                                      );
                                    },
                                    icon: Icon(Icons.edit),
                                  )
                                : null,
                          ),
                        ],
                      ),
                      CustomHeader(headerText: scrapbookData['title']),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02),
                      Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.all(10),
                            height: 45,
                            width: 45,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Colors.white,
                              border: Border.all(
                                color: userData['photoUrl'] != ''
                                    ? Colors.black
                                    : Colors.white,
                                width: 1,
                              ),
                              image: DecorationImage(
                                image: userData['photoUrl'] == ''
                                    ? const AssetImage(
                                            'assets/images/profile.png')
                                        as ImageProvider
                                    : NetworkImage(userData['photoUrl']),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Text(
                            userData['username'],
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
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
                        children: [
                          Text(
                            numLikes.toString(),
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            numLikes != 1 ? " likes" : " like",
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            " • ",
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            globals.numComments.toString(),
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            globals.numComments != 1 ? " comments" : " comment",
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
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
                                      context,
                                      mounted);
                                  setState(() {
                                    isLiked = !isLiked;
                                    numLikes =
                                        isLiked ? numLikes + 1 : numLikes - 1;
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
                                  privileged
                                      ? Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ScrapbookContributorsPage(
                                              scrapbookId: widget.scrapbookId,
                                            ),
                                          ),
                                        )
                                      : requestAlert();
                                },
                                child: Icon(
                                  privileged
                                      ? Icons.person
                                      : Icons.person_add_alt_1,
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
                                    : value == 'report'
                                        ? reportScrapbook()
                                        : deleteScrapbook();
                              },
                              itemBuilder: (BuildContext context) {
                                containSavedPost();
                                return [
                                  PopupMenuItem(
                                      value: 'save',
                                      child: CustomText(
                                        text: isSaved ? 'Unsave' : 'Save',
                                        textSize: 15,
                                      )),
                                  PopupMenuItem(
                                      value: scrapbookData['creatorUid'] ==
                                              user.uid
                                          ? 'delete'
                                          : 'report',
                                      child: CustomText(
                                        text: scrapbookData['creatorUid'] ==
                                                user.uid
                                            ? 'Delete'
                                            : 'Report',
                                        textSize: 15,
                                        alert: true,
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
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
