// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:async';
// import 'package:async/async.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:scrap_real/themes/theme_provider.dart';
import 'package:scrap_real/views/main_views/search.dart';
import 'package:scrap_real/widgets/scrapbook_widgets/custom_scrapbooklarge.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _value = "Home";
  final user = FirebaseAuth.instance.currentUser!;
  List<int> interests = [];

  @override
  void initState() {
    super.initState();
    dropDown(_value);
    userInterest();
  }

  userInterest() async {
    try {
      List<int> indexList = [];
      var userName = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get()
          .then((value) => value.data()!['interests']);
      for (int i = 0; i < userName.length; i++) {
        if (userName[i] == true) {
          indexList.add(i);
        }
      }
      setState(() {
        interests = indexList;
      });
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  List<DropdownMenuItem> dropDown(String value) {
    final List<DropdownMenuItem> items = [
      DropdownMenuItem(
        value: "Home",
        child: Row(
          children: [
            Icon(
              Icons.home_outlined,
              color: value == "Home" ? Color(0xFF918EF4) : Colors.black,
            ),
            SizedBox(width: 10),
            Text("Home"),
          ],
        ),
      ),
      DropdownMenuItem(
        value: "Groups",
        child: Row(
          children: [
            Icon(
              Icons.group_outlined,
              color: value == "Groups" ? Color(0xFF918EF4) : Colors.black,
            ),
            SizedBox(width: 10),
            Text("Groups"),
          ],
        ),
      ),
      DropdownMenuItem(
        value: "Recommended",
        child: Row(
          children: [
            Icon(
              Icons.star_border_outlined,
              color: value == "Recommended" ? Color(0xFF918EF4) : Colors.black,
            ),
            SizedBox(width: 10),
            Text("Recommended"),
          ],
        ),
      ),
    ];
    return items;
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: DropdownButton<dynamic>(
                        dropdownColor:
                            Provider.of<ThemeProvider>(context).themeMode ==
                                    ThemeMode.dark
                                ? Colors.grey[850]
                                : Color(0xFFFAFAFA),
                        borderRadius: BorderRadius.circular(10),
                        onChanged: (value) => setState(() {
                          _value = value;
                        }),
                        iconSize: 25,
                        value: _value,
                        isExpanded: true,
                        items: dropDown(_value),
                        style: const TextStyle(
                          color: Color.fromRGBO(0, 0, 0, 1),
                          fontSize: 16,
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SearchPage()),
                        );
                      },
                      child: Icon(
                        Icons.search,
                        color: Provider.of<ThemeProvider>(context).themeMode ==
                                ThemeMode.dark
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ],
                ),
                scrapbooksView(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget scrapbooksView() {
    return StreamBuilder<List<QuerySnapshot>>(
      stream: _value == "Home"
          ? CombineLatestStream.list<QuerySnapshot>([
              FirebaseFirestore.instance
                  .collection('scrapbooks')
                  .where('type', isEqualTo: "Normal")
                  .where('visibility', isEqualTo: 'Public')
                  .where('group', isEqualTo: false)
                  .snapshots()
            ])
          : _value == "Groups"
              // add a new bool field while making a scrapbook
              ? CombineLatestStream.list<QuerySnapshot>([
                  FirebaseFirestore.instance
                      .collection('scrapbooks')
                      .where('type', isEqualTo: "Normal")
                      .where('visibility', isEqualTo: 'Public')
                      .where('group', isEqualTo: true)
                      .snapshots(),
                  FirebaseFirestore.instance
                      .collection('scrapbooks')
                      .where('type', isEqualTo: "Normal")
                      .where('visibility', isEqualTo: 'Private')
                      .where('group', isEqualTo: true)
                      .where('creatorUid', isEqualTo: user.uid)
                      .snapshots(),
                ])
              : CombineLatestStream.list<QuerySnapshot>([
                  FirebaseFirestore.instance
                      .collection('scrapbooks')
                      .where('type', isEqualTo: "Normal")
                      .where('interestIndex', whereIn: interests)
                      .snapshots()
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

                  // if (data['visibility'] == 'Private') {
                  //   final creatorUid = data['creatorUid'];
                  //   final userUid = FirebaseAuth.instance.currentUser!.uid;
                  // if you want to allow private scrapbooks to be
                  // viewed by followers, you will have to work with
                  // futures, which can't really be done inside
                  // this ListView.builder. That means you would
                  // have to find an alternative method
                  // the code for checking if the creator is followed by the current user is there below:
                  // final firestore = FirebaseFirestore.instance;
                  // bool isFollowing = false;
                  // try {
                  //   DocumentSnapshot snap =
                  //       firestore.collection('users').doc(userUid).get();
                  //   List following = (snap.data()! as dynamic)['following'];

                  //   if (following.contains(creatorUid)) {
                  //     isFollowing = true;
                  //   }
                  // } catch (e) {
                  //   // ignore: avoid_print
                  //   print(e);
                  // }
                  // if (creatorUid == userUid) {
                  //   return Column(
                  //     children: [
                  //       CustomScrapbookLarge(
                  //         scrapbookId: data['scrapbookId'],
                  //         title: data['title'],
                  //         coverImage: data['coverUrl'],
                  //       ),
                  //       SizedBox(height: 10),
                  //     ],
                  //   );
                  // }
                  // return SizedBox();
                  // } else {
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
                  // }
                },
              );
      },
    );
  }
}
