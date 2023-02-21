import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:scrap_real/themes/theme_provider.dart';
import 'package:scrap_real/views/scrapbook_views/scrapbook_expanded.dart';
import 'package:scrap_real/widgets/text_widgets/custom_text.dart';

class CustomScrapbookLarge extends StatefulWidget {
  final String scrapbookId;
  final String title;
  final String coverImage;
  final String scrapbookTag;
  final String creatorId;

  const CustomScrapbookLarge({
    Key? key,
    required this.scrapbookId,
    required this.title,
    required this.coverImage,
    required this.scrapbookTag,
    required this.creatorId,
  }) : super(key: key);

  @override
  State<CustomScrapbookLarge> createState() => _CustomScrapbookLarge();
}

class _CustomScrapbookLarge extends State<CustomScrapbookLarge> {
  var photos = {};
  var usernames = {};

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    var userSnap = await FirebaseFirestore.instance.collection('users').get();
    var userData = userSnap.docs;
    for (var user in userData) {
      usernames[user['uid']] = user['username'];
      photos[user['uid']] = user['photoUrl'];
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ScrapbookExpandedView(
              scrapbookId: widget.scrapbookId,
            ),
          ),
        );
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: 200,
            width: 350,
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
                    Colors.black.withOpacity(0.6), BlendMode.darken),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(10),
                      height: 45,
                      width: 45,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.white,
                        image: DecorationImage(
                          image: photos[widget.creatorId] == "" ||
                                  photos[widget.creatorId] == null
                              ? const AssetImage('assets/images/profile.png')
                                  as ImageProvider
                              : NetworkImage(photos[widget.creatorId]),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Text(
                      usernames[widget.creatorId] ?? 'Unknown',
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.only(
                      bottom: 6, left: 10, right: 10, top: 6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: const Color(0x4cffffff),
                  ),
                  child: Row(
                    children: [
                      Image.asset(
                        widget.scrapbookTag == 'Personal'
                            ? 'assets/images/personal.png'
                            : 'assets/images/factual.png',
                        height: 25,
                        width: 25,
                      ),
                      const SizedBox(
                        width: 6,
                      ),
                      Text(
                        widget.scrapbookTag == 'Personal'
                            ? 'Personal'
                            : 'Factual',
                        style: GoogleFonts.poppins(
                          fontSize: 15,
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
            widget.title,
            style: GoogleFonts.poppins(
              fontSize: 23,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
