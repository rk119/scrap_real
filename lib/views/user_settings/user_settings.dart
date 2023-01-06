import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scrap_real/views/navigation.dart';
import 'package:scrap_real/views/user_settings/account_info.dart';
import 'package:scrap_real/views/user_settings/edit_profile.dart';
import 'package:scrap_real/views/user_settings/information.dart';
import 'package:scrap_real/views/user_settings/privacy_policy.dart';
import 'package:scrap_real/views/user_settings/reported_content.dart';
import 'package:scrap_real/views/user_settings/saved_scraps.dart';
import 'package:scrap_real/views/user_settings/support.dart';
import 'package:scrap_real/views/utils/buttons/custom_backbutton.dart';
import 'package:scrap_real/views/utils/buttons/custom_menuitem.dart';
import 'package:scrap_real/views/utils/headers/custom_header.dart';
import 'package:scrap_real/views/login_signup/welcome.dart';

class UserSettingsPage extends StatefulWidget {
  const UserSettingsPage({Key? key}) : super(key: key);

  @override
  State<UserSettingsPage> createState() => _UserSettingsPageState();
}

class _UserSettingsPageState extends State<UserSettingsPage> {
  final user = FirebaseAuth.instance.currentUser!;

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
                    MaterialPageRoute(builder: (context) => const NavBar()),
                  );
                }),
                CustomHeader(headerText: "Settings"),
                const SizedBox(height: 30),
                CustomMenuItem(
                  svgPath: "assets/edit_profile.svg",
                  text: "Edit Profile",
                  color: Colors.black,
                  buttonFunction: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const EditProfilePage()),
                    );
                  },
                ),
                const SizedBox(height: 10),
                CustomMenuItem(
                  svgPath: "assets/saved_scraps.svg",
                  text: "Saved",
                  color: Colors.black,
                  buttonFunction: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SavedScrapbooksPage()),
                    );
                  },
                ),
                const SizedBox(height: 10),
                CustomMenuItem(
                  svgPath: "assets/privacy_policy.svg",
                  text: "Privacy Policy",
                  color: Colors.black,
                  buttonFunction: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PrivacyPolicyPage()),
                    );
                  },
                ),
                const SizedBox(height: 10),
                CustomMenuItem(
                  svgPath: "assets/account_info.svg",
                  text: "Account Information",
                  color: Colors.black,
                  buttonFunction: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AccountInformationPage()),
                    );
                  },
                ),
                const SizedBox(height: 10),
                CustomMenuItem(
                  svgPath: "assets/reported_content.svg",
                  text: "Reported Content",
                  color: Colors.black,
                  buttonFunction: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ReportedContentPage()),
                    );
                  },
                ),
                const SizedBox(height: 10),
                CustomMenuItem(
                  svgPath: "assets/support.svg",
                  text: "Support",
                  color: Colors.black,
                  buttonFunction: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SupportPage()),
                    );
                  },
                ),
                const SizedBox(height: 10),
                CustomMenuItem(
                  svgPath: "assets/information.svg",
                  text: "Information",
                  color: Colors.black,
                  buttonFunction: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const InformationPage()),
                    );
                  },
                ),
                const SizedBox(height: 10),
                CustomMenuItem(
                  svgPath: "assets/logout.svg",
                  text: "Log out",
                  color: const Color(0xffbc2d21),
                  buttonFunction: () async {
                    await FirebaseAuth.instance.signOut();
                    if (!mounted) return;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const WelcomePage()),
                    );
                  },
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
