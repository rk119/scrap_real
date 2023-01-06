// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scrap_real/views/utils/cards/custom_notifcard.dart';
import 'package:scrap_real/views/utils/headers/custom_header.dart';
import 'package:scrap_real/views/utils/headers/custom_subheader.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  List<String> notifMsg = [
    "started following you",
    "liked your post",
    "commented on your post"
  ];

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
                SizedBox(height: 15),
                notifDateBar("Today"),
                SizedBox(height: 15),
                CustomNotifCard(notifText: "username ${notifMsg[0]}"),
                SizedBox(height: 15),
                CustomNotifCard(notifText: "username ${notifMsg[2]}"),
                SizedBox(height: 15),
                CustomNotifCard(notifText: "username ${notifMsg[1]}"),
                SizedBox(height: 15),
                notifDateBar("Yesterday"),
                SizedBox(height: 15),
                CustomNotifCard(notifText: "username ${notifMsg[0]}"),
                SizedBox(height: 15),
                CustomNotifCard(notifText: "username ${notifMsg[2]}"),
                SizedBox(height: 15),
                CustomNotifCard(notifText: "username ${notifMsg[1]}"),
                SizedBox(height: 15),
                SizedBox(height: 15),
                CustomNotifCard(notifText: "username ${notifMsg[0]}"),
                SizedBox(height: 15),
                CustomNotifCard(notifText: "username ${notifMsg[2]}"),
                SizedBox(height: 15),
                CustomNotifCard(notifText: "username ${notifMsg[1]}"),
                SizedBox(height: 15),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget notifDateBar(String text) {
    return Container(
      padding: EdgeInsets.all(10),
      width: double.infinity,
      height: 43,
      decoration: BoxDecoration(
        color: Color(0xffF4F3F3),
        boxShadow: const [
          BoxShadow(
            color: Color.fromARGB(55, 0, 0, 0),
            offset: Offset(2, 4),
            blurRadius: 2,
          ),
        ],
      ),
      child: CustomSubheader(
        headerText: text,
        headerSize: 18,
        headerAlignment: TextAlign.left,
        headerColor: Color(0xff545454),
      ),
    );
  }
}
