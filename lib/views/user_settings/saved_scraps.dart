// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scrap_real/views/user_settings/user_settings.dart';
import 'package:scrap_real/views/utils/buttons/custom_backbutton.dart';
import 'package:scrap_real/views/utils/headers/custom_header.dart';
import 'package:scrap_real/views/utils/headers/custom_subheader.dart';

class SavedScrapbooksPage extends StatefulWidget {
  const SavedScrapbooksPage({Key? key}) : super(key: key);

  @override
  State<SavedScrapbooksPage> createState() => SavedScrapbooksPageState();
}

class SavedScrapbooksPageState extends State<SavedScrapbooksPage> {
  // final user = FirebaseAuth.instance.currentUser!;

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
                        builder: (context) => const UserSettingsPage()),
                  );
                }),
                CustomHeader(headerText: "Saved"),
                const SizedBox(height: 30),
                scrapbookLargeSize(),
                const SizedBox(height: 20),
                scrapbookLargeSize(),
                const SizedBox(height: 20),
                scrapbookLargeSize(),
                const SizedBox(height: 20),
                scrapbookLargeSize(),
                const SizedBox(height: 20),
                scrapbookLargeSize(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget scrapbookLargeSize() {
    return Container(
      width: 350,
      height: 205,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 43, 43, 43),
        border: Border.all(
          width: 5,
          color: const Color.fromARGB(255, 241, 241, 241),
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(children: [
        Container(
          height: 40,
        ),
        SizedBox(
          height: 100,
          child: Center(
            child: CustomSubheader(
              headerText: "Saved Scrapbook", // max 22 char
              headerColor: Colors.white,
              headerSize: 23,
            ),
          ),
        ),
        Container(
          height: 40,
        ),
      ]),
    );
  }
}
