// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

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
