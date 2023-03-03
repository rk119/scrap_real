import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:scrap_real/themes/theme_provider.dart';
import 'package:scrap_real/utils/custom_snackbar.dart';
import 'package:scrap_real/utils/firestore_methods.dart';
import 'package:scrap_real/widgets/button_widgets/custom_backbutton.dart';
import 'package:scrap_real/widgets/card_widgets/custom_commentcard.dart';
import 'package:scrap_real/widgets/text_widgets/custom_header.dart';
import 'package:scrap_real/widgets/text_widgets/custom_text.dart';

class ScrapbookContributorsPage extends StatefulWidget {
  final String scrapbookId;
  const ScrapbookContributorsPage({Key? key, required this.scrapbookId})
      : super(key: key);

  @override
  State<ScrapbookContributorsPage> createState() =>
      _ScrapbookCollaboratorsState();
}

class _ScrapbookCollaboratorsState extends State<ScrapbookContributorsPage> {
  bool creator = false;
  bool currentUserGroupM = false;
  var collaborators = {};
  var userData = {};
  String currentUserName = "";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    collaborators = await FirebaseFirestore.instance
        .collection('scrapbooks')
        .doc(widget.scrapbookId)
        .get()
        .then((value) => value['collaborators']);

    creator = await FirebaseFirestore.instance
        .collection('scrapbooks')
        .doc(widget.scrapbookId)
        .get()
        .then((value) =>
            value['creatorUid'] == FirebaseAuth.instance.currentUser!.uid);

    currentUserName = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) => value['username']);

    for (var collaborator in collaborators.keys) {
      if (collaborator == currentUserName && collaborators[collaborator]) {
        currentUserGroupM = true;
      }
      var collaboratorId = await FirebaseFirestore.instance
          .collection('users')
          .where('username', isEqualTo: collaborator)
          .get()
          .then((value) => value.docs[0].id);

      userData[collaborator] = await FirebaseFirestore.instance
          .collection('users')
          .doc(collaboratorId)
          .get()
          .then((value) => value.data());
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
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
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 50,
                ),
                child: Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Column(
                      children: [
                        CustomBackButton(
                          buttonFunction: () {
                            FirebaseFirestore.instance
                                .collection("scrapbooks")
                                .doc(widget.scrapbookId)
                                .get()
                                .then((value) {
                              FirebaseFirestore.instance
                                  .collection("scrapbooks")
                                  .doc(widget.scrapbookId)
                                  .update({"collaborators": collaborators});
                            });
                            Navigator.pop(context);
                          },
                        ),
                        CustomHeader(
                          headerText: 'Collaborators',
                        ),
                        const SizedBox(height: 20),
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                subheader('Group Managers'),
                                creator
                                    ? IconButton(
                                        onPressed: () {
                                          String username = '';
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                title: const Text(
                                                    'Add Group Manager'),
                                                content: TextField(
                                                  decoration:
                                                      const InputDecoration(
                                                    hintText: 'Enter username',
                                                  ),
                                                  onChanged: (value) {
                                                    username = value;
                                                  },
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context,
                                                              rootNavigator:
                                                                  true)
                                                          .pop();
                                                    },
                                                    child: const Text(
                                                      'Cancel',
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xff141b41),
                                                      ),
                                                    ),
                                                  ),
                                                  TextButton(
                                                    onPressed: () async {
                                                      try {
                                                        var collaboratorId =
                                                            await FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'users')
                                                                .where(
                                                                    'username',
                                                                    isEqualTo:
                                                                        username)
                                                                .get()
                                                                .then((value) =>
                                                                    value
                                                                        .docs[0]
                                                                        .id);
                                                        print(collaboratorId);

                                                        userData[username] =
                                                            await FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'users')
                                                                .doc(
                                                                    collaboratorId)
                                                                .get()
                                                                .then((value) =>
                                                                    value
                                                                        .data());
                                                      } catch (e) {
                                                        print(e);
                                                      }

                                                      if (userData[username] ==
                                                          null) {
                                                        // ignore: use_build_context_synchronously
                                                        CustomSnackBar
                                                            .showSnackBar(
                                                          context,
                                                          'User does not exist',
                                                        );
                                                      } else {
                                                        collaborators[
                                                            username] = true;
                                                        setState(() {});
                                                      }
                                                      // ignore: use_build_context_synchronously
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text(
                                                      'Add',
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xff141b41),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                        icon: const Icon(Icons.add),
                                        color:
                                            Provider.of<ThemeProvider>(context)
                                                        .themeMode ==
                                                    ThemeMode.dark
                                                ? const Color(0xffd1e1ff)
                                                : const Color(0xff141b41),
                                      )
                                    : const SizedBox(),
                              ],
                            ),
                            const SizedBox(height: 10),
                            collaboratorCard(true),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                subheader('Collaborators'),
                                creator || currentUserGroupM
                                    ? IconButton(
                                        onPressed: () {
                                          String username = '';
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                title: const Text(
                                                    'Add Collaborator'),
                                                content: TextField(
                                                  decoration:
                                                      const InputDecoration(
                                                    hintText: 'Enter username',
                                                  ),
                                                  onChanged: (value) {
                                                    username = value;
                                                  },
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context,
                                                              rootNavigator:
                                                                  true)
                                                          .pop();
                                                    },
                                                    child: const Text(
                                                      'Cancel',
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xff141b41),
                                                      ),
                                                    ),
                                                  ),
                                                  TextButton(
                                                    onPressed: () async {
                                                      try {
                                                        var collaboratorId =
                                                            await FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'users')
                                                                .where(
                                                                    'username',
                                                                    isEqualTo:
                                                                        username)
                                                                .get()
                                                                .then((value) =>
                                                                    value
                                                                        .docs[0]
                                                                        .id);
                                                        print(collaboratorId);

                                                        userData[username] =
                                                            await FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'users')
                                                                .doc(
                                                                    collaboratorId)
                                                                .get()
                                                                .then((value) =>
                                                                    value
                                                                        .data());
                                                      } catch (e) {
                                                        print(e);
                                                      }

                                                      if (userData[username] ==
                                                          null) {
                                                        // ignore: use_build_context_synchronously
                                                        CustomSnackBar
                                                            .showSnackBar(
                                                          context,
                                                          'User does not exist',
                                                        );
                                                      } else {
                                                        collaborators[
                                                            username] = false;
                                                        setState(() {});
                                                      }
                                                      // ignore: use_build_context_synchronously
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text(
                                                      'Add',
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xff141b41),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                        icon: const Icon(Icons.add),
                                        color:
                                            Provider.of<ThemeProvider>(context)
                                                        .themeMode ==
                                                    ThemeMode.dark
                                                ? const Color(0xffd1e1ff)
                                                : const Color(0xff141b41),
                                      )
                                    : const SizedBox(),
                              ],
                            ),
                            const SizedBox(height: 10),
                            collaboratorCard(false),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
  }

  Widget subheader(String text) {
    return Container(
      alignment: const Alignment(-1.0, 0),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          height: 1.5,
          color: Provider.of<ThemeProvider>(context).themeMode == ThemeMode.dark
              ? const Color(0xffd1e1ff)
              : const Color(0xff141b41),
        ),
      ),
    );
  }

  Widget collaboratorCard(bool groupManager) {
    bool acceptable = groupManager ? false : currentUserGroupM;
    return Scrollbar(
        child: Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.3,
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: Provider.of<ThemeProvider>(context).themeMode == ThemeMode.dark
            ? Colors.black
            : const Color(0xfffdfbfb),
        borderRadius: BorderRadius.circular(6),
        boxShadow: const [
          BoxShadow(
            color: Color(0x3f000000),
            offset: Offset(0, 1),
            blurRadius: 2,
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            for (var collaborator in collaborators.keys)
              if (collaborators[collaborator] == groupManager)
                ((creator || (currentUserName == collaborator) || acceptable))
                    ? Dismissible(
                        key: UniqueKey(),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          margin: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            color: const Color(0xffe74c3c),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        ),
                        onDismissed: (direction) {
                          setState(() {
                            collaborators.remove(collaborator);
                          });
                        },
                        child: collaboratorC(collaborator),
                      )
                    : collaboratorC(collaborator),
          ],
        ),
      ),
    ));
  }

  Widget collaboratorC(String collaborator) {
    return Container(
      margin: const EdgeInsets.all(3),
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      width: double.infinity,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: Provider.of<ThemeProvider>(context).themeMode == ThemeMode.dark
              ? Colors.grey.shade800
              : Colors.white,
        ),
        borderRadius: BorderRadius.circular(8),
        color: Provider.of<ThemeProvider>(context).themeMode == ThemeMode.dark
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(children: [
            const SizedBox(width: 8),
            userData[collaborator]['photoUrl'] == ""
                ? Image.asset(
                    "assets/images/profile.png",
                    width: 50,
                    height: 50,
                  )
                : CircleAvatar(
                    backgroundColor: Colors.grey,
                    backgroundImage: NetworkImage(
                      userData[collaborator]['photoUrl'],
                    ),
                    radius: 25,
                  ),
            const SizedBox(
              width: 15,
            ),
            SizedBox(
              child: CustomText(
                text: "@${userData[collaborator]['username']}",
                textSize: 15,
                textAlignment: TextAlign.left,
                textWeight: FontWeight.w500,
              ),
            ),
          ]),
          creator
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      collaborators[collaborator] =
                          !collaborators[collaborator];
                    });
                  },
                  icon: collaborators[collaborator]
                      ? const Icon(Icons.arrow_circle_down_outlined)
                      : const Icon(Icons.arrow_circle_up_outlined),
                  color: collaborators[collaborator]
                      ? const Color.fromARGB(255, 108, 200, 202)
                      : const Color(0xff918ef4),
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
