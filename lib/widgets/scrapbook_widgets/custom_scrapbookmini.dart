// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scrap_real/themes/theme_provider.dart';
import 'package:scrap_real/views/scrapbook_views/scrapbook_expanded.dart';
import 'package:scrap_real/widgets/text_widgets/custom_text.dart';

class ScrapbookMiniSize extends StatelessWidget {
  ScrapbookMiniSize({
    Key? key,
    required this.scrapbookId,
    required this.scrapbookTitle,
  }) : super(key: key);

  final String scrapbookId;
  String scrapbookTitle;

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
            height: 140,
            width: 140,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Provider.of<ThemeProvider>(context).themeMode ==
                      ThemeMode.dark
                  ? Colors.grey.shade700
                  : Colors.grey.shade200,
            ),
          ),
          CustomText(text: scrapbookTitle, textSize: 15),
        ],
      ),
    );
  }
}
