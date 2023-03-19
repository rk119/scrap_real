// ignore_for_file: must_be_immutable

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:scrap_real/themes/theme_provider.dart';
import 'package:scrap_real/utils/firestore_methods.dart';
import 'package:scrap_real/widgets/button_widgets/custom_textbutton.dart';
import 'package:scrap_real/widgets/text_widgets/custom_text.dart';

class CustomNotifCard extends StatelessWidget {
  CustomNotifCard({
    Key? key,
    this.photoUrl,
    required this.postImageUrl,
    required this.alt,
    required this.type,
    required this.notifText,
    required this.scrapbookId,
    required this.uid,
    required this.username,
    required this.title,
    required this.mounted,
  }) : super(key: key);

  String? photoUrl;
  String postImageUrl;
  String alt;
  String type;
  String notifText;
  String scrapbookId;
  String uid;
  String username;
  String title;
  bool mounted;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    if (type == 'collaborate') {
      return Column(
        children: [
          Container(
            width: double.infinity,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(
                width: 1,
                color: Provider.of<ThemeProvider>(context).themeMode ==
                        ThemeMode.dark
                    ? Colors.grey.shade800
                    : Colors.white,
              ),
              borderRadius: BorderRadius.circular(15),
              color: Provider.of<ThemeProvider>(context).themeMode ==
                      ThemeMode.dark
                  ? Colors.black
                  : Colors.white,
              // boxShadow: const [
              //   BoxShadow(
              //     color: Color(0x3f000000),
              //     blurRadius: 2,
              //     offset: Offset(0, 1),
              //   )
              // ],
            ),
            child: Row(children: [
              const SizedBox(width: 20),
              Stack(
                children: [
                  photoUrl == ""
                      ? Image.asset(
                          alt,
                          width: 50,
                          height: 50,
                        )
                      : CircleAvatar(
                          backgroundColor: Colors.grey,
                          backgroundImage: NetworkImage(
                            photoUrl!,
                          ),
                          radius: 25,
                        ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 186, 219, 245),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.person_add_alt_1,
                        size: 15,
                        color: Color(0xFF918EF4),
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(width: 15),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.65,
                child: RichText(
                  text: TextSpan(
                    text: '',
                    style: GoogleFonts.poppins(
                      fontSize: 17,
                      fontWeight: FontWeight.w400,
                      height: 1.5,
                      color: Colors.black,
                    ),
                    children: [
                      TextSpan(
                        text: '@$username ',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: notifText,
                      ),
                      TextSpan(
                        text: ' $title',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ]),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                onTap: () async {
                  FireStoreMethods()
                      .addCollaborator(uid, scrapbookId, context, mounted);
                  FireStoreMethods().createNotification(uid, scrapbookId,
                      postImageUrl, 'acceptAccess', context, mounted);
                  FireStoreMethods().removeNotification(_auth.currentUser!.uid,
                      scrapbookId, uid, type, context, mounted);
                },
                child: const Icon(
                  Icons.check,
                  color: Colors.green,
                  size: 30,
                ),
              ),
              InkWell(
                onTap: () async {
                  FireStoreMethods().createNotification(uid, scrapbookId,
                      postImageUrl, 'deniedAccess', context, mounted);
                  FireStoreMethods().removeNotification(_auth.currentUser!.uid,
                      scrapbookId, uid, type, context, mounted);
                },
                child: const Icon(
                  Icons.close,
                  color: Colors.red,
                  size: 30,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      );
    } else if (type == 'follow' ||
        type == 'deniedAccess' ||
        type == 'acceptAccess' ||
        postImageUrl == '') {
      return Column(
        children: [
          Container(
            width: double.infinity,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(
                width: 1,
                color: Provider.of<ThemeProvider>(context).themeMode ==
                        ThemeMode.dark
                    ? Colors.grey.shade800
                    : Colors.white,
              ),
              borderRadius: BorderRadius.circular(15),
              color: Provider.of<ThemeProvider>(context).themeMode ==
                      ThemeMode.dark
                  ? Colors.black
                  : Colors.white,
              // boxShadow: const [
              //   BoxShadow(
              //     color: Color(0x3f000000),
              //     blurRadius: 2,
              //     offset: Offset(0, 1),
              //   )
              // ],
            ),
            child: Row(children: [
              const SizedBox(width: 20),
              Stack(
                children: [
                  photoUrl == ""
                      ? Image.asset(
                          alt,
                          width: 50,
                          height: 50,
                        )
                      : CircleAvatar(
                          backgroundColor: Colors.grey,
                          backgroundImage: NetworkImage(
                            photoUrl!,
                          ),
                          radius: 25,
                        ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: type == 'follow'
                        ? const Icon(
                            Icons.verified,
                            size: 24,
                            color: Colors.blue,
                          )
                        : type == 'deniedAccess'
                            ? Container(
                                padding: const EdgeInsets.all(3),
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.close,
                                  size: 15,
                                  color: Colors.white,
                                ),
                              )
                            : type == 'acceptAccess'
                                ? Container(
                                    padding: const EdgeInsets.all(3),
                                    decoration: const BoxDecoration(
                                      color: Colors.green,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.check,
                                      size: 15,
                                      color: Colors.white,
                                    ),
                                  )
                                : type == 'like'
                                    ? Container(
                                        padding: const EdgeInsets.all(3),
                                        decoration: const BoxDecoration(
                                          color: Color.fromARGB(
                                              255, 186, 219, 245),
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.favorite,
                                          size: 15,
                                          color: Colors.red,
                                        ),
                                      )
                                    : Container(
                                        padding: const EdgeInsets.all(3),
                                        decoration: const BoxDecoration(
                                          color: Color.fromARGB(
                                              255, 186, 219, 245),
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.comment,
                                          size: 15,
                                          color: Color(0xFF918EF4),
                                        ),
                                      ),
                  ),
                ],
              ),
              const SizedBox(width: 15),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.65,
                child:
                    // CustomText(
                    //   text: notifText,
                    //   textSize: 15,
                    //   textAlignment: TextAlign.left,
                    //   textWeight: FontWeight.w400,
                    // ),
                    type == "acceptAccess"
                        ? RichText(
                            text: TextSpan(
                              text: '',
                              style: GoogleFonts.poppins(
                                fontSize: 17,
                                fontWeight: FontWeight.w400,
                                height: 1.5,
                                color: Colors.black,
                              ),
                              children: [
                                TextSpan(
                                  text: "$notifText ",
                                ),
                                TextSpan(
                                  text: title,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          )
                        : type == "deniedAccess"
                            ? RichText(
                                text: TextSpan(
                                  text: '',
                                  style: GoogleFonts.poppins(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w400,
                                    height: 1.5,
                                    color: Colors.black,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: "$notifText ",
                                    ),
                                    TextSpan(
                                      text: title,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const TextSpan(
                                      text: " is rejected",
                                    ),
                                  ],
                                ),
                              )
                            : RichText(
                                text: TextSpan(
                                  text: '',
                                  style: GoogleFonts.poppins(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w400,
                                    height: 1.5,
                                    color: Colors.black,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: '@$username ',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    TextSpan(
                                      text: notifText,
                                    ),
                                  ],
                                ),
                              ),
              ),
            ]),
          ),
          const SizedBox(height: 20),
        ],
      );
    } else {
      return Column(
        children: [
          Container(
            width: double.infinity,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(
                width: 1,
                color: Provider.of<ThemeProvider>(context).themeMode ==
                        ThemeMode.dark
                    ? Colors.grey.shade800
                    : Colors.white,
              ),
              borderRadius: BorderRadius.circular(15),
              color: Provider.of<ThemeProvider>(context).themeMode ==
                      ThemeMode.dark
                  ? Colors.black
                  : Colors.white,
              // boxShadow: const [
              //   BoxShadow(
              //     color: Color(0x3f000000),
              //     blurRadius: 2,
              //     offset: Offset(0, 1),
              //   )
              // ],
            ),
            child: Row(children: [
              const SizedBox(width: 20),
              Stack(children: [
                photoUrl == ""
                    ? Image.asset(
                        alt,
                        width: 50,
                        height: 50,
                      )
                    : CircleAvatar(
                        backgroundColor: Colors.grey,
                        backgroundImage: NetworkImage(
                          photoUrl!,
                        ),
                        radius: 25,
                      ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 186, 219, 245),
                      shape: BoxShape.circle,
                    ),
                    child: type == 'like'
                        ? const Icon(
                            Icons.favorite,
                            size: 15,
                            color: Colors.red,
                          )
                        : const Icon(
                            Icons.comment,
                            size: 15,
                            color: Color(0xFF918EF4),
                          ),
                  ),
                ),
              ]),
              const SizedBox(width: 15),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                child: RichText(
                  text: TextSpan(
                    text: '',
                    style: GoogleFonts.poppins(
                      fontSize: 17,
                      fontWeight: FontWeight.w400,
                      height: 1.5,
                      color: Colors.black,
                    ),
                    children: [
                      TextSpan(
                        text: '@$username ',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: notifText,
                      ),
                    ],
                  ),
                ),
                // CustomText(
                //   text: notifText,
                //   textSize: 15,
                //   textAlignment: TextAlign.left,
                //   textWeight: FontWeight.w400,
                // ),
              ),
              const SizedBox(width: 30),
              ClipRRect(
                borderRadius: BorderRadius.circular(3.0),
                child: ColorFiltered(
                  colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.20), BlendMode.darken),
                  child: Image.network(
                    postImageUrl,
                    height: 40,
                    width: 60,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ]),
          ),
          const SizedBox(height: 20),
        ],
      );
    }
  }
}
