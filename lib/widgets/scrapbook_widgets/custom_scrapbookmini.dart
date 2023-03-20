// ignore_for_file: must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:scrap_real/themes/theme_provider.dart';
import 'package:scrap_real/views/scrapbook_views/scrapbook_expanded.dart';
import 'package:scrap_real/views/scrapbook_views/solve_riddle.dart';

class ScrapbookMiniSize extends StatefulWidget {
  final String scrapbookId;
  String scrapbookTitle;
  String coverImage;
  String scrapbookTag;
  String creatorId;
  String visibility;
  String type;
  bool map;

  ScrapbookMiniSize({
    Key? key,
    required this.scrapbookId,
    required this.scrapbookTitle,
    required this.coverImage,
    required this.scrapbookTag,
    required this.creatorId,
    required this.visibility,
    required this.type,
    required this.map,
  }) : super(key: key);
  @override
  State<ScrapbookMiniSize> createState() => _ScrapbookMiniSize();
}

class _ScrapbookMiniSize extends State<ScrapbookMiniSize> {
  String photo = "";
  String username = "";

  @override
  void initState() {
    super.initState();
    widget.map ? getData() : null;
  }

  @override
  void didUpdateWidget(covariant ScrapbookMiniSize oldWidget) {
    super.didUpdateWidget(oldWidget);
    photo = "";
    username = "";
    widget.map ? getData() : null;
  }

  getData() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.creatorId)
        .get()
        .then((value) {
      setState(() {
        photo = value.data()!['photoUrl'];
        username = value.data()!['username'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (widget.type == 'Secret') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SecretScrapbook(
                scrapbookId: widget.scrapbookId,
              ),
              settings: const RouteSettings(name: '/secretScrapbook'),
            ),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ScrapbookExpandedView(
                scrapbookId: widget.scrapbookId,
              ),
              settings: const RouteSettings(name: '/scrapbookExpanded'),
            ),
          );
        }
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: 100,
            width: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Provider.of<ThemeProvider>(context).themeMode ==
                      ThemeMode.dark
                  ? Colors.grey.shade700
                  : Colors.grey.shade900,
              image: DecorationImage(
                image: NetworkImage(
                  widget.coverImage,
                ),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.55), BlendMode.darken),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                widget.map
                    ? Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.all(5),
                            height: 20,
                            width: 20,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Colors.white,
                              border: Border.all(
                                color: Colors.white,
                                width: 1,
                              ),
                              image: DecorationImage(
                                image: photo == ''
                                    ? const AssetImage(
                                            'assets/images/profile.png')
                                        as ImageProvider
                                    : NetworkImage(photo),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Text(
                            username,
                            style: GoogleFonts.poppins(
                              fontSize: 9,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      )
                    : const SizedBox(),
                Container(
                  margin: const EdgeInsets.only(top: 7, right: 5),
                  padding: const EdgeInsets.only(
                      bottom: 2, left: 4, right: 4, top: 2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      color: Colors.black,
                      width: 1,
                    ),
                    color: const Color(0x4cffffff),
                  ),
                  child: Row(
                    children: [
                      Image.asset(
                        widget.scrapbookTag == 'Personal'
                            ? 'assets/images/personal.png'
                            : 'assets/images/factual.png',
                        height: 8,
                        width: 8,
                      ),
                      const SizedBox(
                        width: 3,
                      ),
                      Text(
                        widget.scrapbookTag == 'Personal'
                            ? 'Personal'
                            : 'Factual',
                        style: GoogleFonts.poppins(
                          fontSize: 7,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Text(
            widget.scrapbookTitle,
            style: GoogleFonts.poppins(
              fontSize: 15,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          widget.visibility == 'Private'
              ? const Positioned(
                  bottom: 13,
                  right: 11,
                  child: Icon(
                    Icons.lock,
                    color: Colors.white,
                    size: 20,
                  ),
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
