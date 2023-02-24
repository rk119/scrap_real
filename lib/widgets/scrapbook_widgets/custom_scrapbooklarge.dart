import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:scrap_real/themes/theme_provider.dart';
import 'package:scrap_real/views/scrapbook_views/scrapbook_expanded.dart';

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
  String photo = '';
  String username = '';

  @override
  void initState() {
    super.initState();
    getData();
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
                    Colors.black.withOpacity(0.75), BlendMode.darken),
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
                        border: Border.all(
                          color: Colors.white,
                          width: 1,
                        ),
                        image: DecorationImage(
                          image: photo == ''
                              ? const AssetImage('assets/images/profile.png')
                                  as ImageProvider
                              : NetworkImage(photo),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Text(
                      username,
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
                    border: Border.all(
                      color: Colors.black,
                      width: 2,
                    ),
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
