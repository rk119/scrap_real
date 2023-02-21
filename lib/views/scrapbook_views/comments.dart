import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:scrap_real/themes/theme_provider.dart';
import 'package:scrap_real/utils/firestore_methods.dart';
import 'package:scrap_real/widgets/button_widgets/custom_backbutton.dart';
import 'package:scrap_real/widgets/card_widgets/custom_commentcard.dart';
import 'package:scrap_real/widgets/text_widgets/custom_header.dart';

class ScrapbookCommentsPage extends StatefulWidget {
  final String scrapbookId;
  const ScrapbookCommentsPage({
    Key? key,
    required this.scrapbookId,
  }) : super(key: key);
  @override
  State<ScrapbookCommentsPage> createState() => _ScrapbookCommentsPageState();
}

class _ScrapbookCommentsPageState extends State<ScrapbookCommentsPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser!.uid;

  TextEditingController _comment = TextEditingController();

  //String photoUrl = FireStoreMethods().getCurrentUserPfp() as String;
  String photoUrl = "";
  String alt = "assets/images/profile.png";

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
                CustomHeader(headerText: "Scrapbook Comments"),
                const SizedBox(height: 20),
                buildComments(),
                Container(
                  width: double.infinity,
                  height: 60,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                      color: Provider.of<ThemeProvider>(context).themeMode ==
                              ThemeMode.dark
                          ? Colors.grey.shade800
                          : Colors.white,
                    ),
                    borderRadius: BorderRadius.circular(15),
                    color: Provider.of<ThemeProvider>(context).themeMode ==
                            ThemeMode.dark
                        ? Colors.black
                        : Colors.white,
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x3f000000),
                        blurRadius: 2,
                        offset: Offset(0, 1),
                      )
                    ],
                  ),
                  child: Row(children: [
                    const SizedBox(width: 8),
                    photoUrl == ""
                        ? Image.asset(
                            alt,
                            width: 50,
                            height: 50,
                          )
                        : CircleAvatar(
                            backgroundColor: Colors.grey,
                            backgroundImage: NetworkImage(
                              photoUrl,
                            ),
                            radius: 25,
                          ),
                    const SizedBox(
                      width: 15,
                    ),
                    SizedBox(
                      width: 200,
                      child: TextFormField(
                        controller: _comment,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Add a comment...",
                          hintStyle: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            height: 1.5,
                            color: const Color.fromARGB(255, 193, 193, 193),
                          ),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: addComment,
                      // onPressed: addComment,
                      child: Text('Post'),
                    ),
                  ]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildComments() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('comment')
          .doc(widget.scrapbookId)
          .collection('comments')
          .orderBy("commentNum", descending: false)
          .snapshots(),
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

                  return CustomCommentCard(
                    photoUrl: data['photoUrl'],
                    alt: "assets/images/profile.png",
                    username: data['username'],
                    comment: data['comment'],
                    bottomPadding: 5,
                  );
                },
              );
      },
    );
  }

  addComment() {
    FireStoreMethods()
        .createComment(_comment.text, widget.scrapbookId, context, mounted);
    _comment.clear();
  }
}
