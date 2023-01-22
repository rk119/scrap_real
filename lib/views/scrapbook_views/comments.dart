import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scrap_real/widgets/button_widgets/custom_backbutton.dart';
import 'package:scrap_real/widgets/text_widgets/custom_header.dart';

class ScrapbookCommentsPage extends StatefulWidget {
  const ScrapbookCommentsPage({Key? key}) : super(key: key);
  @override
  State<ScrapbookCommentsPage> createState() => _ScrapbookCommentsPageState();
}

class _ScrapbookCommentsPageState extends State<ScrapbookCommentsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 40,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CustomBackButton(buttonFunction: () {
                  Navigator.of(context).pop();
                }),
                CustomHeader(headerText: "Scrapbook Comments"),
                const SizedBox(height: 200),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
