// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scrap_real/views/main_views/user_profile.dart';
import 'package:scrap_real/views/navigation.dart';
import 'package:scrap_real/widgets/button_widgets/custom_backbutton.dart';
import 'package:scrap_real/widgets/card_widgets/custom_usercard.dart';
import 'package:scrap_real/widgets/scrapbook_widgets/custom_scrapbooklarge.dart';
import 'package:scrap_real/widgets/selection_widgets/custom_selectiontab3.dart';
import 'package:scrap_real/widgets/text_widgets/custom_searchfield.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  bool users = true;
  bool search = true;
  String _searchQuery = "";
  var blockedUsers = [];
  final user = FirebaseAuth.instance.currentUser!;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    blockedUsers = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) => value['blockedUsers']);
    setState(() {});
    // ignore: avoid_print
    print(blockedUsers);
  }

  @override
  void dispose() {
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
                          builder: (context) => NavBar(currentIndex: 0)));
                }),
                SizedBox(height: 20),
                CustomSearchField(
                  // validatorFunction: (query) =>
                  //     (query != null && query.length < 6)
                  //         ? 'Enter a min. of 6 characters'
                  //         : null,
                  hintingText:
                      users ? "Search for a user" : "Search for a scrapbook",
                  onChangedFunc: (val) {
                    setState(() {
                      _searchQuery = val;
                    });
                  },
                ),
                SizedBox(height: 20),
                CustomSelectionTab3(
                  selection: users,
                  selection1: "Users",
                  selecion2: "Scrapbooks",
                  func1: () {
                    if (users == false) {
                      setState(() {
                        users = true;
                      });
                    }
                  },
                  func2: () {
                    if (users == true) {
                      setState(() {
                        users = false;
                      });
                    }
                  },
                ),
                const SizedBox(height: 1),
                _searchQuery == ""
                    ? Container()
                    : users
                        ? usersView()
                        : scrapbooksView(),
                // usersView2(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget usersView() {
    return StreamBuilder<QuerySnapshot>(
      stream: blockedUsers.isNotEmpty
          ? FirebaseFirestore.instance
              .collection('users')
              .where(FieldPath.documentId, whereNotIn: blockedUsers)
              .where('uid', isNotEqualTo: user.uid)
              .snapshots()
          : FirebaseFirestore.instance
              .collection('users')
              .where('uid', isNotEqualTo: user.uid)
              .snapshots(),
      builder: (context, snapshots) {
        if (!snapshots.hasData) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF918EF4)),
          );
        }
        return (snapshots.connectionState == ConnectionState.waiting)
            ? Center(
                child: CircularProgressIndicator(color: Color(0xFF918EF4)),
              )
            : ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: snapshots.data!.docs.length,
                itemBuilder: (context, index) {
                  var data = snapshots.data!.docs[index].data()
                      as Map<String, dynamic>;

                  if (_searchQuery.isEmpty) {
                    return CustomUserCard(
                      photoUrl: data['photoUrl'],
                      alt: "assets/images/profile.png",
                      username: data['username'],
                      onTapFunc: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => UserProfilePage(
                            uid: (snapshots.data! as dynamic).docs[index]
                                ['uid'],
                            implyLeading: search,
                          ),
                        ),
                      ),
                      bottomPadding: 20,
                    );
                  }
                  if (data['username']
                      .toString()
                      .toLowerCase()
                      .startsWith(_searchQuery.toLowerCase())) {
                    return CustomUserCard(
                      photoUrl: data['photoUrl'],
                      alt: "assets/images/profile.png",
                      username: data['username'],
                      onTapFunc: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => UserProfilePage(
                            uid: (snapshots.data! as dynamic).docs[index]
                                ['uid'],
                            implyLeading: search,
                          ),
                        ),
                      ),
                      bottomPadding: 20,
                    );
                  }
                  return Container();
                },
              );
      },
    );
  }

  Widget scrapbooksView() {
    return StreamBuilder<List<QuerySnapshot>>(
      stream: CombineLatestStream.list<QuerySnapshot>([
        FirebaseFirestore.instance
            .collection('scrapbooks')
            .where('type', isEqualTo: 'Normal')
            .where('visibility', isEqualTo: 'Public')
            .where('creatorUid', isNotEqualTo: user.uid)
            .snapshots(),
        FirebaseFirestore.instance
            .collection('scrapbooks')
            .where('visibility', isEqualTo: 'Private')
            .where('creatorUid', isEqualTo: user.uid)
            .snapshots(),
      ]),
      builder: (context, snapshots) {
        if (!snapshots.hasData) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF918EF4)),
          );
        }

        List<DocumentSnapshot> documents = [];
        snapshots.data?.forEach((querySnapshot) {
          documents.addAll(querySnapshot.docs);
        });

        return (snapshots.connectionState == ConnectionState.waiting)
            ? Center(
                child: CircularProgressIndicator(color: Color(0xFF918EF4)),
              )
            : ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: documents.length,
                itemBuilder: (context, index) {
                  var data = documents[index].data() as Map<String, dynamic>;

                  if (_searchQuery.isEmpty) {
                    return Column(
                      children: [
                        CustomScrapbookLarge(
                          scrapbookId: data['scrapbookId'],
                          title: data['title'],
                          coverImage: data['coverUrl'],
                          scrapbookTag: data['tag'],
                          creatorId: data['creatorUid'],
                          scrapbookType: data['type'],
                          visibility: data['visibility'],
                        ),
                        SizedBox(height: 10),
                      ],
                    );
                  }
                  if (data['title']
                      .toString()
                      .toLowerCase()
                      .startsWith(_searchQuery.toLowerCase())) {
                    return Column(
                      children: [
                        CustomScrapbookLarge(
                          scrapbookId: data['scrapbookId'],
                          title: data['title'],
                          coverImage: data['coverUrl'],
                          scrapbookTag: data['tag'],
                          creatorId: data['creatorUid'],
                          scrapbookType: data['type'],
                          visibility: data['visibility'],
                        ),
                        SizedBox(height: 10),
                      ],
                    );
                  }
                  return Container();
                },
              );
      },
    );
  }
}
