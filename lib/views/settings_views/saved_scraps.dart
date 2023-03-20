// import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scrap_real/widgets/button_widgets/custom_backbutton.dart';
import 'package:scrap_real/widgets/scrapbook_widgets/custom_scrapbooklarge.dart';
import 'package:scrap_real/widgets/text_widgets/custom_header.dart';
import 'package:scrap_real/widgets/text_widgets/custom_text.dart';

class SavedScrapbooksPage extends StatefulWidget {
  const SavedScrapbooksPage({Key? key}) : super(key: key);

  @override
  State<SavedScrapbooksPage> createState() => _SavedScrapbooksPageState();
}

class _SavedScrapbooksPageState extends State<SavedScrapbooksPage> {
  final user = FirebaseAuth.instance.currentUser!;
  var savedPosts = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    savedPosts = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get()
        .then((value) => value['savedPosts']);
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
                CustomHeader(headerText: "Saved"),
                isLoading
                    ? Column(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.3,
                          ),
                          const CircularProgressIndicator(
                              color: Color(0xFF918EF4)),
                        ],
                      )
                    : savedPosts.isNotEmpty
                        ? Container(
                            child: _buildSavedScrapbooks(),
                          )
                        : Column(
                            children: [
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.3,
                              ),
                              CustomText(
                                text: "You haven't saved any scrapbooks yet",
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

  Widget _buildSavedScrapbooks() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('scrapbooks')
          .where('scrapbookId', whereIn: savedPosts)
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
                    visibility: data['visibility'],
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
