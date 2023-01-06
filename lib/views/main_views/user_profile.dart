import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scrap_real/views/login_signup/choose_interests.dart';
import 'package:scrap_real/views/login_signup/welcome.dart';
import 'package:scrap_real/views/user_settings/user_settings.dart';
import 'package:scrap_real/views/utils/buttons/custom_textbutton.dart';
import 'package:scrap_real/views/utils/headers/custom_subheader.dart';
import 'package:scrap_real/views/utils/selection_widgets/custom_selectiontab3.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({Key? key}) : super(key: key);

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final user = FirebaseAuth.instance.currentUser!;
  bool posts = true;

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
                settingsMenu(),
                profileCard(),
                const SizedBox(height: 15),
                userInformationCard(),
                const SizedBox(height: 26),
                CustomSelectionTab3(
                  selection: posts,
                  selection1: "Posts",
                  selecion2: "Collaborated",
                  func1: () {
                    if (posts == false) {
                      setState(() {
                        posts = true;
                      });
                    }
                  },
                  func2: () {
                    if (posts == true) {
                      setState(() {
                        posts = false;
                      });
                    }
                  },
                ),
                const SizedBox(height: 20),
                const Divider(height: 5, thickness: 1, color: Colors.black),
                const SizedBox(height: 13),
                scrapbookContainer(),
                const SizedBox(height: 20),
                // items below are for testing
                CustomTextButton(
                  buttonBorderRadius: BorderRadius.circular(30),
                  buttonFunction: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ChooseInterestsPage()),
                    );
                  },
                  buttonText: "Testing: Choose Interests",
                ),
                const SizedBox(height: 20),
                signOutOption(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget settingsMenu() {
    return Container(
      alignment: const Alignment(1.07, 0),
      child: TextButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const UserSettingsPage()),
          );
        },
        child: const Icon(Icons.menu, size: 45, color: Colors.black),
      ),
    );
  }

  Widget profileCard() {
    return SizedBox(
      width: 300,
      height: 125,
      child: Row(children: [
        Container(
          height: 125,
          width: 125,
          decoration: BoxDecoration(
            border: Border.all(
              width: 5,
              color: const Color.fromARGB(255, 241, 241, 241),
            ),
            borderRadius: BorderRadius.circular(100),
          ),
          child: const SizedBox(),
        ),
        const SizedBox(width: 10),
        SizedBox(
          height: 75,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomSubheader(
                headerText: "Hana Khan",
                headerSize: 20,
                headerColor: Colors.black,
              ),
              CustomSubheader(
                headerText: "@hana",
                headerSize: 16,
                headerColor: const Color(0xff72768d),
              ),
            ],
          ),
        ),
      ]),
    );
  }

  Widget blueCard(String text1, String text2) {
    return Container(
      width: 73,
      height: 60,
      decoration: BoxDecoration(
        color: const Color(0xff8ee8ea),
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
              color: Color(0x19000000), offset: Offset(2, 4), blurRadius: 2),
        ],
      ),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        CustomSubheader(
            headerText: text1, headerSize: 18, headerColor: Colors.black),
        CustomSubheader(
            headerText: text2, headerSize: 13, headerColor: Colors.black),
      ]),
    );
  }

  Widget userInformationCard() {
    return Container(
      width: 360,
      height: 175,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(35),
        boxShadow: const [
          BoxShadow(
            color: Color(0x19000000),
            offset: Offset(2, 4),
            blurRadius: 2,
          ),
        ],
      ),
      child: Column(children: [
        // const SizedBox(height: 22),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            blueCard("2448", "Posts"),
            const SizedBox(width: 25),
            blueCard("4.2M", "Followers"),
            const SizedBox(width: 25),
            blueCard("745", "Following"),
          ],
        ),
        const SizedBox(height: 15),
        const SizedBox(
          width: 300,
          child: Text(
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam",
            textAlign: TextAlign.left,
          ),
        ),
      ]),
    );
  }

  Widget scrapbookContainer() {
    return Container(
      width: 360,
      height: 375,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        boxShadow: const [
          BoxShadow(
            color: Color(0x19000000),
            offset: Offset(2, 4),
            blurRadius: 2,
          ),
        ],
      ),
    );
  }

  Widget signOutOption() {
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text('signed in as: ${user.email!}'),
        MaterialButton(
          color: Colors.deepPurple[200],
          child: const Text('Testing: Logout'),
          onPressed: () async {
            await FirebaseAuth.instance.signOut();
            if (!mounted) return;
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const WelcomePage()),
            );
          },
        ),
      ]),
    );
  }
}
