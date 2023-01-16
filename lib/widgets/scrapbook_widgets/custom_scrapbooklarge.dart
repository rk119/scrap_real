// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scrap_real/themes/theme_provider.dart';
import 'package:scrap_real/views/scrapbook_views/scrapbook_expanded.dart';
import 'package:scrap_real/widgets/text_widgets/custom_text.dart';

class CustomScrapbookLarge extends StatelessWidget {
  CustomScrapbookLarge({
    Key? key,
    required this.scrapbookId,
    required this.title,
  }) : super(key: key);

  final String scrapbookId;
  String title;

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
      child: Container(
        width: 350,
        height: 205,
        decoration: BoxDecoration(
          color: Provider.of<ThemeProvider>(context).themeMode == ThemeMode.dark
              ? Colors.grey.shade700
              : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(children: [
          const SizedBox(height: 40),
          SizedBox(
            height: 100,
            child: Center(
              child: CustomText(
                text: title, // max 22 char
                textSize: 23,
              ),
            ),
          ),
          Container(height: 40),
        ]),
      ),
    );
  }
}
