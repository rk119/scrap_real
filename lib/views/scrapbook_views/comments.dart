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

  final TextEditingController _comment = TextEditingController();

  //String photoUrl = FireStoreMethods().getCurrentUserPfp() as String;
  String photoUrl = "";
  String alt = "assets/images/profile.png";

  @override
  void initState() {
    super.initState();
    getCurrentUserPfp();
  }

  void getCurrentUserPfp() async {
    try {
      DocumentSnapshot snap =
          await _firestore.collection('users').doc(user).get();
      setState(() {
        photoUrl = (snap.data()! as dynamic)['photoUrl'];
      });
    } catch (err) {
      // ignore: avoid_print
      print(err.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CustomBackButton(buttonFunction: () {
                    Navigator.of(context).pop();
                  }),
                  CustomHeader(headerText: "Comments"),
                  const SizedBox(height: 20),
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
                          : const Color(0xffFAFAFA),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x3f000000),
                          blurRadius: 2,
                          offset: Offset(0, 1),
                        )
                      ],
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 10),
                        CircleAvatar(
                          radius: 20,
                          backgroundImage: photoUrl == ""
                              ? AssetImage(alt)
                              : NetworkImage(photoUrl) as ImageProvider,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: _comment,
                            style: GoogleFonts.poppins(
                              color: Provider.of<ThemeProvider>(context)
                                          .themeMode ==
                                      ThemeMode.dark
                                  ? Colors.white
                                  : Colors.black,
                            ),
                            decoration: InputDecoration(
                              hintText: "Add a comment...",
                              hintStyle: GoogleFonts.poppins(
                                color: Provider.of<ThemeProvider>(context)
                                            .themeMode ==
                                        ThemeMode.dark
                                    ? Colors.grey.shade800
                                    : Colors.grey,
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            addComment();
                          },
                          icon: const Icon(
                            Icons.send,
                            color: Color(0xFF918EF4),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Scrollbar(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 530,
                      child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Wrap(children: [buildComments()])),
                    ),
                  ),
                ],
              ),
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
        return ListView.builder(
          reverse: true,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          itemCount: snapshots.data!.docs.length,
          itemBuilder: (context, index) {
            var data =
                snapshots.data!.docs[index].data() as Map<String, dynamic>;

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
