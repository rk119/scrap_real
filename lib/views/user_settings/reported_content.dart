// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scrap_real/views/user_settings/user_settings.dart';
import 'package:scrap_real/widgets/buttons/custom_backbutton.dart';
import 'package:scrap_real/widgets/profile_widgets/custom_scrapbooklarge.dart';
import 'package:scrap_real/widgets/text_widgets/custom_header.dart';
import 'package:scrap_real/widgets/text_widgets/custom_subheader.dart';

class ReportedContentPage extends StatefulWidget {
  const ReportedContentPage({Key? key}) : super(key: key);

  @override
  State<ReportedContentPage> createState() => _ReportedContentPageState();
}

class _ReportedContentPageState extends State<ReportedContentPage> {
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
                CustomHeader(headerText: "Reported Content"),
                const SizedBox(height: 30),
                CustomScrapbookLarge(text: "Reported Scrapbook"),
                const SizedBox(height: 20),
                CustomScrapbookLarge(text: "Reported Scrapbook"),
                const SizedBox(height: 20),
                CustomScrapbookLarge(text: "Reported Scrapbook"),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
