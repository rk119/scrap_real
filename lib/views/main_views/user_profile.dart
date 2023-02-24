import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:scrap_real/themes/theme_provider.dart';
import 'package:scrap_real/utils/firestore_methods.dart';
import 'package:scrap_real/views/navigation.dart';
import 'package:scrap_real/views/settings_views/user_settings.dart';
import 'package:scrap_real/widgets/button_widgets/custom_backbutton.dart';
import 'package:scrap_real/widgets/profile_widgets/custom_profileinfocard.dart';
import 'package:scrap_real/widgets/profile_widgets/custom_userinfowidget.dart';
import 'package:scrap_real/widgets/scrapbook_widgets/custom_scrapbookmini.dart';
import 'package:scrap_real/widgets/selection_widgets/custom_selectiontab3.dart';
import 'package:scrap_real/widgets/text_widgets/custom_text.dart';

class UserProfilePage extends StatefulWidget {
  final String uid;
  final bool implyLeading;
  const UserProfilePage({
    Key? key,
    required this.uid,
    required this.implyLeading,
  }) : super(key: key);

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final user = FirebaseAuth.instance.currentUser!;
  var userData = {};
  bool posts = true;
  int postsLen = 0;
  int followers = 0;
  int following = 0;
  bool isFollowing = false;
  bool isCurrentUser = false;
  bool isLoading = true;
  var scrapbooksToShow = [];

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();

      // get post length
      var scrapbookSnap = await FirebaseFirestore.instance
          .collection('scrapbooks')
          .where('creatorUid', isEqualTo: widget.uid)
          .get();
      // if you want to count the collaborated scrapbooks
      // add this amount as well
      // var sbCollabSnap = await FirebaseFirestore.instance
      //     .collection('scrapbooks')
      //     .where('collaborators', arrayContains: widget.uid)
      //     .get();

      // get the user data

      for (var i = 0; i < scrapbookSnap.docs.length; i++) {
        var data = scrapbookSnap.docs[i].data();
        if (data['visibility'] == 'Private' &&
            data['creatorUid'] != user.uid &&
            !data['collaborators'].contains(user.uid)) {
          continue;
        } else {
          scrapbooksToShow.add(scrapbookSnap.docs[i]);
        }
      }

      postsLen = scrapbooksToShow.length;
      userData = userSnap.data()!;
      followers = userData['followers'].length;
      following = userData['following'].length;
      isFollowing = userData['followers'].contains(user.uid);
      isCurrentUser = widget.uid == user.uid;
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      // ignore: avoid_print
      print(e);
      setState(() {
        isLoading = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var iconColor =
        Provider.of<ThemeProvider>(context).themeMode == ThemeMode.dark
            ? Colors.white
            : Colors.black;
    return isLoading
        ? Container(
            color:
                Provider.of<ThemeProvider>(context).themeMode == ThemeMode.dark
                    ? Colors.grey.shade900
                    : Colors.white,
            child: const Center(
              child: CircularProgressIndicator(color: Color(0xFF918EF4)),
            ),
          )
        : Scaffold(
            body: AnnotatedRegion<SystemUiOverlayStyle>(
              value: SystemUiOverlayStyle.light,
              child: GestureDetector(
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 10,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.05,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          !widget.implyLeading
                              ? const SizedBox.shrink()
                              : CustomBackButton(
                                  buttonFunction: () {
                                    Navigator.pop(context);
                                  },
                                ),
                          isCurrentUser
                              ? settingsMenu(iconColor)
                              : optionsMenu(iconColor),
                        ],
                      ),
                      CustomUserInfoWidget(
                        name: userData['name'],
                        username: "@${userData['username']}",
                        photoUrl: userData['photoUrl'],
                        alt: "assets/images/profile.png",
                        isFollowing: isFollowing,
                        isCurrentUser: isCurrentUser,
                        onPressedFunc: () async {
                          FireStoreMethods().followUser(
                            user.uid,
                            userData['uid'],
                          );
                          setState(() {
                            isFollowing = !isFollowing;
                            if (isFollowing) {
                              followers = followers + 1;
                            } else {
                              followers = followers - 1;
                            }
                          });
                        },
                      ),
                      const SizedBox(height: 15),
                      CustomUserProfileInfo(
                        numOfPosts: postsLen.toString(),
                        followers: followers.toString(),
                        following: following.toString(),
                        bioText: userData['bio'] ?? 'ye',
                        cardColor:
                            Provider.of<ThemeProvider>(context).themeMode ==
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
                      const SizedBox(height: 15),
                      Divider(
                        height: 5,
                        thickness: 1,
                        color: iconColor,
                      ),
                      const SizedBox(height: 15),
                      postsView(),
                    ],
                  ),
                ),
              ),
            ),
          );
  }

  Widget settingsMenu(Color iconColor) {
    return IconButton(
      icon: const Icon(Icons.settings),
      color: iconColor,
      iconSize: 35,
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const UserSettingsPage()),
        );
      },
    );
  }

  Widget optionsMenu(Color iconColor) {
    return TextButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("Block User"),
                            content: const Text(
                                "Are you sure you want to block this user?"),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text("Cancel"),
                              ),
                              TextButton(
                                onPressed: () {
                                  FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(user.uid)
                                      .update({
                                    'blockedUsers':
                                        FieldValue.arrayUnion([userData['uid']])
                                  });
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => NavBar()),
                                  );
                                },
                                child: const Text("Block"),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: const Text("Block User"),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("Report User"),
                            content: const Text(
                                "Are you sure you want to report this user?"),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text("Cancel"),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => NavBar()),
                                  );
                                  // FireStoreMethods().reportUser(
                                  //   user.uid,
                                  //   userData['uid'],
                                  // );
                                  FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(user.uid)
                                      .update({
                                    'reportUsers':
                                        FieldValue.arrayUnion([userData['uid']])
                                  });
                                },
                                child: const Text("Report"),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: const Text("Report User"),
                  ),
                ],
              ),
            );
          },
        );
      },
      child: Icon(
        Icons.more_horiz,
        size: 35,
        color: iconColor,
      ),
    );
  }

  Widget postsView() {
    return posts
        ? scrapbookContainer(FirebaseFirestore.instance
            .collection('scrapbooks')
            .where('creatorUid', isEqualTo: widget.uid)
            .snapshots())
        : scrapbookContainer(FirebaseFirestore.instance
            .collection('scrapbooks')
            .where('collaborators', arrayContains: widget.uid)
            .snapshots());
  }

  Widget scrapbookContainer(Stream<QuerySnapshot<Object?>> postsStream) {
    return StreamBuilder<QuerySnapshot>(
      stream: postsStream,
      builder: (context, snapshots) {
        if (!snapshots.hasData) {
          return const Center(
            child: CircularProgressIndicator(
              color: Color(0xFF918EF4),
            ),
          );
        }
        if (snapshots.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF918EF4)),
          );
        } else if (snapshots.data!.docs.isEmpty) {
          return Center(
            child: CustomText(text: "No Scrapbooks", textSize: 15),
          );
        } else {
          return GridView.builder(
            itemCount: scrapbooksToShow.length,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.5,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
            ),
            itemBuilder: (BuildContext context, int index) {
              var data = scrapbooksToShow[index].data() as Map<String, dynamic>;

              if (data['visibility'] == 'Private' &&
                  data['creatorUid'] != user.uid &&
                  !data['collaborators'].contains(user.uid)) {
                return const SizedBox.shrink();
              } else {
                return ScrapbookMiniSize(
                  scrapbookId: data['scrapbookId'],
                  scrapbookTitle: data['title'],
                  coverImage: data['coverUrl'],
                  scrapbookTag: data['tag'],
                  creatorId: data['creatorUid'],
                  map: false,
                );
              }
            },
          );
        }
      },
    );
  }
}
