import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter/scheduler.dart';
import 'package:scrap_real/themes/theme_provider.dart';
import 'package:scrap_real/views/login_signup/choose_interests.dart';
import 'package:scrap_real/views/login_signup/welcome.dart';
import 'package:scrap_real/views/user_settings/user_settings.dart';
import 'package:scrap_real/widgets/buttons/custom_textbutton.dart';
import 'package:scrap_real/widgets/profile_widgets/custom_profileinfocard.dart';
import 'package:scrap_real/widgets/profile_widgets/custom_userinfowidget.dart';
import 'package:scrap_real/widgets/selection_widgets/custom_selectiontab3.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({Key? key}) : super(key: key);

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final user = FirebaseAuth.instance.currentUser!;
  var userData = {};
  bool posts = true;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      // get post lENGTH
      // var postSnap = await FirebaseFirestore.instance
      //     .collection('posts')
      //     .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      //     .get();

      // postLen = postSnap.docs.length;
      userData = userSnap.data()!;
      // followers = userSnap.data()!['followers'].length;
      // following = userSnap.data()!['following'].length;
      // isFollowing = userSnap
      //     .data()!['followers']
      //     .contains(FirebaseAuth.instance.currentUser!.uid);
      setState(() {});
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
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
                settingsMenu(),
                CustomUserInfoWidget(
                  name: userData['name'] ?? 'loading',
                  userName: "@${userData['userName'] ?? 'loading'}",
                ),
                const SizedBox(height: 15),
                CustomUserProfileInfo(
                  numOfPosts: "2448",
                  followers: "4.2M",
                  following: "745",
                  bioText: userData['bio'] ?? 'loading',
                  cardColor: Provider.of<ThemeProvider>(context).themeMode ==
                          ThemeMode.dark
                      ? const Color.fromARGB(255, 51, 49, 49)
                      : Colors.white,
                ),
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
                Divider(
                  height: 5,
                  thickness: 1,
                  color: MediaQuery.of(context).platformBrightness ==
                          Brightness.light
                      ? Colors.black
                      : Colors.white,
                ),
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
        child: Icon(
          Icons.menu,
          size: 45,
          color: Provider.of<ThemeProvider>(context).themeMode == ThemeMode.dark
              ? Colors.white
              : Colors.black,
        ),
      ),
    );
  }

  Widget scrapbookContainer() {
    return Container(
      width: 360,
      height: 375,
      decoration: BoxDecoration(
        color: Provider.of<ThemeProvider>(context).themeMode == ThemeMode.dark
            ? Colors.black
            : Colors.white,
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
        ElevatedButton(
          onPressed: () {
            SchedulerBinding.instance.addPostFrameCallback((_) {
              WidgetsBinding.instance.reassembleApplication();
            });
          },
          child: const Text("Hot reload"),
        ),
      ]),
    );
  }
}
