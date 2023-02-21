// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:scrap_real/themes/theme_provider.dart';
import 'package:scrap_real/views/scrapbook_views/scrapbook_expanded.dart';
import 'package:scrap_real/widgets/text_widgets/custom_text.dart';

class CustomScrapbookLarge extends StatelessWidget {
  CustomScrapbookLarge({
    Key? key,
    required this.scrapbookId,
    required this.title,
    required this.coverImage,
  }) : super(key: key);

  final String scrapbookId;
  String title;
  String coverImage;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ScrapbookExpandedView(
              scrapbookId: scrapbookId,
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
                  coverImage,
                ),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.4), BlendMode.darken),
              ),
            ),
          ),
          Text(
            title,
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
