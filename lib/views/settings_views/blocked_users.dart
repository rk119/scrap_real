import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:scrap_real/themes/theme_provider.dart';
import 'package:scrap_real/widgets/card_widgets/custom_usercard.dart';
import 'package:scrap_real/widgets/text_widgets/custom_header.dart';
import 'package:scrap_real/widgets/text_widgets/custom_text.dart';

import '../../widgets/button_widgets/custom_backbutton.dart';

class BlockedUsersPage extends StatefulWidget {
  const BlockedUsersPage({super.key});

  @override
  State<BlockedUsersPage> createState() => _BlockedUsersPageState();
}

class _BlockedUsersPageState extends State<BlockedUsersPage> {
  final user = FirebaseAuth.instance.currentUser!;
  var blockedUsers = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    blockedUsers = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get()
        .then((value) => value['blockedUsers']);
    setState(() {});
    print(blockedUsers);
    isLoading = false;
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
              horizontal: 15,
              vertical: 50,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CustomBackButton(buttonFunction: () {
                  Navigator.of(context).pop();
                }),
                CustomHeader(headerText: "Blocked Users"),
                isLoading
                    ? Column(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.3,
                          ),
                          const CircularProgressIndicator(
                              color: Color(0xFF918EF4)),
                        ],
                      )
                    : blockedUsers.isNotEmpty
                        ? Container(
                            child: blockedUsersView(),
                          )
                        : Column(
                            children: [
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.3,
                              ),
                              CustomText(
                                text: "No blocked users",
                                textSize: 20,
                                textAlignment: TextAlign.center,
                                textWeight: FontWeight.w300,
                              ),
                            ],
                          ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget blockedUsersView() {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where(FieldPath.documentId, whereIn: blockedUsers)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot blockedUser = snapshot.data!.docs[index];
                  return Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.75,
                            height: 55,
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1,
                                color: Provider.of<ThemeProvider>(context)
                                            .themeMode ==
                                        ThemeMode.dark
                                    ? Colors.grey.shade800
                                    : Colors.white,
                              ),
                              borderRadius: BorderRadius.circular(15),
                              color: Provider.of<ThemeProvider>(context)
                                          .themeMode ==
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
                              blockedUser["photoUrl"] == ""
                                  ? Image.asset(
                                      "assets/images/profile.png",
                                      width: 50,
                                      height: 50,
                                    )
                                  : CircleAvatar(
                                      backgroundColor: Colors.grey,
                                      backgroundImage: NetworkImage(
                                        blockedUser["photoUrl"]!,
                                      ),
                                      radius: 25,
                                    ),
                              const SizedBox(
                                width: 15,
                              ),
                              SizedBox(
                                // width: 200,
                                child: CustomText(
                                  text: "@${blockedUser["username"]}",
                                  textSize: 15,
                                  textAlignment: TextAlign.left,
                                  textWeight: FontWeight.w300,
                                ),
                              ),
                            ]),
                          ),
                          // const SizedBox(width: 5),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                blockedUsers.remove(blockedUser.id);
                              });
                              FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(user.uid)
                                  .update({
                                'blockedUsers': blockedUsers,
                              });
                            },
                            child: Container(
                              child: Icon(Icons.remove,
                                  color: Colors.white, size: 40),
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(5),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color(0x3f000000),
                                    blurRadius: 2,
                                    offset: Offset(0, 1),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                  );
                });
          } else {
            return const Center(
                child: CircularProgressIndicator(color: Color(0xFF918EF4)));
          }
        });
  }
}
