// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:scrap_real/themes/theme_provider.dart';
import 'package:scrap_real/widgets/card_widgets/custom_notifcard.dart';
import 'package:scrap_real/widgets/text_widgets/custom_header.dart';
import 'package:scrap_real/widgets/text_widgets/custom_text.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser!.uid;

  List<String> notifMsg = [
    "started following you",
    "liked your post",
    "commented on your post",
    "requested for collaboration access to",
    "Your request for collaboration access to",
    "You are now a collaborator for"
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
              // horizontal: 30,
              vertical: 50,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CustomHeader(headerText: "Notifications"),
                SizedBox(height: 30),
                buildNotification(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildNotification() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('feed')
          .doc(user)
          .collection('feedItems')
          .orderBy("feedNum", descending: false)
          .snapshots(),
      builder: (context, snapshots) {
        if (!snapshots.hasData) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF918EF4)),
          );
        }
        if (snapshots.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF918EF4)),
          );
        } else if (snapshots.data!.docs.isEmpty) {
          return Center(
            child: CustomText(text: "No Notifications", textSize: 15),
          );
        } else {
          return ListView.builder(
            reverse: true,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemCount: snapshots.data!.docs.length,
            itemBuilder: (context, index) {
              var data =
                  snapshots.data!.docs[index].data() as Map<String, dynamic>;
              String notifText = "";
              if (data['type'] == 'follow') {
                // notifText = '@${data['username']} ${notifMsg[0]}';
                notifText = notifMsg[0];
              } else if (data['type'] == 'like') {
                // notifText = '@${data['username']} ${notifMsg[1]}';
                notifText = notifMsg[1];
              } else if (data['type'] == 'comment') {
                // notifText = '@${data['username']} ${notifMsg[2]}';
                notifText = notifMsg[2];
              } else if (data['type'] == 'collaborate') {
                // notifText =
                //     '@${data['username']} ${notifMsg[3]} "${data['title']}"';
                notifText = notifMsg[3];
              } else if (data['type'] == 'deniedAccess') {
                // notifText = '${notifMsg[4]} "${data['title']}" is rejected';
                notifText = notifMsg[4];
              } else if (data['type'] == 'acceptAccess') {
                // notifText = '${notifMsg[5]} "${data['title']}"';
                notifText = notifMsg[5];
              }
              return CustomNotifCard(
                photoUrl: data['photoUrl'],
                postImageUrl: data['coverUrl'],
                alt: "assets/images/profile.png",
                type: data['type'],
                notifText: notifText,
                scrapbookId: data['scrapbookId'],
                uid: data['uid'],
                username: data['username'],
                title: data['title'],
                mounted: mounted,
              );
            },
          );
        }
      },
    );
  }

  Widget notifDateBar(String text) {
    return Container(
      padding: EdgeInsets.all(10),
      width: double.infinity,
      height: 43,
      decoration: BoxDecoration(
        color: Provider.of<ThemeProvider>(context).themeMode == ThemeMode.dark
            ? Color.fromARGB(255, 47, 46, 46)
            : Color(0xffF4F3F3),
        boxShadow: const [
          BoxShadow(
            color: Color.fromARGB(55, 0, 0, 0),
            offset: Offset(2, 4),
            blurRadius: 2,
          ),
        ],
      ),
      child: CustomText(
        text: text,
        textSize: 18,
        textAlignment: TextAlign.left,
      ),
    );
  }
}
