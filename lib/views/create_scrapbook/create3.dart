import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scrap_real/views/create_scrapbook/create2.dart';
import 'package:scrap_real/widgets/buttons/custom_backbutton.dart';
import 'package:scrap_real/widgets/text_widgets/custom_header.dart';

class CreateScrapbookPage3 extends StatefulWidget {
  const CreateScrapbookPage3({Key? key}) : super(key: key);
  @override
  State<CreateScrapbookPage3> createState() => _CreateScrapbookPage3State();
}

class _CreateScrapbookPage3State extends State<CreateScrapbookPage3> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(
              horizontal: 30,
              vertical: 50,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CustomBackButton(buttonFunction: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CreateScrapbookPage2()),
                  );
                }),
                CustomHeader(headerText: "Create Scrapbook"),
                const SizedBox(height: 15),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
