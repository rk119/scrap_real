// import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scrap_real/widgets/button_widgets/custom_backbutton.dart';
import 'package:scrap_real/widgets/card_widgets/custom_usercard.dart';
import 'package:scrap_real/widgets/scrapbook_widgets/custom_scrapbooklarge.dart';
import 'package:scrap_real/widgets/selection_widgets/custom_selectiontab3.dart';
import 'package:scrap_real/widgets/text_widgets/custom_header.dart';
import 'package:scrap_real/widgets/text_widgets/custom_text.dart';

class ReportedScrapbooksPage extends StatefulWidget {
  const ReportedScrapbooksPage({Key? key}) : super(key: key);

  @override
  State<ReportedScrapbooksPage> createState() => _ReportedScrapbooksPageState();
}

class _ReportedScrapbooksPageState extends State<ReportedScrapbooksPage> {
  final user = FirebaseAuth.instance.currentUser!;
  bool users = true;
  var reportedScrapbooks = [];
  var reportedUsers = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    reportedScrapbooks = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get()
        .then((value) => value['reportedPosts']);
    setState(() {});

    reportedUsers = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get()
        .then((value) => value['reportedUsers']);

    setState(() {});
    isLoading = false;
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
                  Navigator.of(context).pop();
                }),
                CustomHeader(headerText: "Reported"),
                const SizedBox(height: 20),
                CustomSelectionTab3(
                  selection: users,
                  selection1: "Users",
                  selecion2: "Scrapbooks",
                  func1: () {
                    if (users == false) {
                      isLoading = true;
                      setState(() {
                        users = true;
                      });
                      isLoading = false;
                    }
                  },
                  func2: () {
                    if (users == true) {
                      isLoading = true;
                      setState(() {
                        users = false;
                      });
                      isLoading = false;
                    }
                  },
                ),
                const SizedBox(height: 15),
                isLoading
                    ? Column(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.3,
                          ),
                          const CircularProgressIndicator(
                            color: Color(0xFF918EF4),
                          ),
                        ],
                      )
                    : users && reportedUsers.isNotEmpty
                        ? Container(
                            child: _buildReportedUsers(),
                          )
                        : reportedScrapbooks.isNotEmpty
                            ? Container(
                                child: _buildReportedScrapbooks(),
                              )
                            : Column(
                                children: [
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.3,
                                  ),
                                  CustomText(
                                    text: users
                                        ? "You haven't reported any users"
                                        : "You haven't reported any scrapbooks",
                                    textSize: 20,
                                    textAlignment: TextAlign.center,
                                    textWeight: FontWeight.w300,
                                  ),
                                ],
                              ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildReportedUsers() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .where('uid', whereIn: reportedUsers)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var data =
                  snapshot.data!.docs[index].data() as Map<String, dynamic>;
              return Column(
                children: [
                  CustomUserCard(
                    username: data['username'],
                    photoUrl: data['photoUrl'],
                    alt: 'assets/images/profile.png',
                    bottomPadding: 20,
                    onTapFunc: () {},
                  ),
                  const SizedBox(height: 30),
                ],
              );
            },
          );
        } else {
          return const Center(
              child: CircularProgressIndicator(color: Color(0xFF918EF4)));
        }
      },
    );
  }

  Widget _buildReportedScrapbooks() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('scrapbooks')
          .where('scrapbookId', whereIn: reportedScrapbooks)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var data =
                  snapshot.data!.docs[index].data() as Map<String, dynamic>;
              return Column(
                children: [
                  CustomScrapbookLarge(
                    scrapbookId: data['scrapbookId'],
                    title: data['title'],
                    coverImage: data['coverUrl'],
                    scrapbookTag: data['tag'],
                    creatorId: data['creatorUid'],
                    scrapbookType: data['type'],
                  ),
                  const SizedBox(height: 30),
                ],
              );
            },
          );
        } else {
          return const Center(
              child: CircularProgressIndicator(color: Color(0xFF918EF4)));
        }
      },
    );
  }
}
