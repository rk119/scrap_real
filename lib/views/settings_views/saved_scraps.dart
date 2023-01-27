// import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scrap_real/widgets/button_widgets/custom_backbutton.dart';
import 'package:scrap_real/widgets/scrapbook_widgets/custom_scrapbooklarge.dart';
import 'package:scrap_real/widgets/text_widgets/custom_header.dart';

class SavedScrapbooksPage extends StatefulWidget {
  const SavedScrapbooksPage({Key? key}) : super(key: key);

  @override
  State<SavedScrapbooksPage> createState() => _SavedScrapbooksPageState();
}

class _SavedScrapbooksPageState extends State<SavedScrapbooksPage> {
  final user = FirebaseAuth.instance.currentUser!;
  var savedScrapbooks = [];

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    savedScrapbooks = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get()
        .then((value) => value['savedScrapbooks']);
    setState(() {});
    print(savedScrapbooks);
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
                const SizedBox(height: 30),
                _buildSavedScrapbooks(),
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
          .where('scrapbookId', whereIn: savedScrapbooks)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return (snapshot.connectionState == ConnectionState.waiting)
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
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
                      ),
                      const SizedBox(height: 30),
                    ],
                  );
                },
              );
      },
    );
  }
}
