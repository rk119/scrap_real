import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:scrap_real/themes/theme_provider.dart';
import 'package:scrap_real/widgets/button_widgets/custom_backbutton.dart';
import 'package:scrap_real/widgets/text_widgets/custom_header.dart';

class ScrapbookImagesPage extends StatefulWidget {
  final String scrapbookId;
  const ScrapbookImagesPage({Key? key, required this.scrapbookId})
      : super(key: key);

  @override
  State<ScrapbookImagesPage> createState() => _ScrapbookImagesPageState();
}

class _ScrapbookImagesPageState extends State<ScrapbookImagesPage> {
  List<dynamic> images = [];
  var scrapbookData = {};
  bool isLoading = true;
  int pageNumber = 0;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    try {
      var scrapbookSnap = await FirebaseFirestore.instance
          .collection('scrapbooks')
          .doc(widget.scrapbookId)
          .get();

      scrapbookData = scrapbookSnap.data()!;
      images = scrapbookData['posts'];
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      // ignore: avoid_print
      print(e);
      setState(() {
        isLoading = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Container(
            color:
                Provider.of<ThemeProvider>(context).themeMode == ThemeMode.dark
                    ? Colors.grey.shade900
                    : Colors.white,
            child: const Center(
              child: CircularProgressIndicator(color: Color(0xFF918EF4)),
            ),
          )
        : Scaffold(
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
                        Navigator.of(context).pop();
                      }),
                      CustomHeader(headerText: "Scrapbook Images"),
                      const SizedBox(height: 80),
                      addImages(),
                      const SizedBox(height: 40),
                      addLeftAndRightButtonsforPages(),
                    ],
                  ),
                ),
              ),
            ),
          );
  }

  Widget addImages() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.height * 0.27,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/scrapbook.png"),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              imageContainer(pageNumber * 4),
              const SizedBox(
                width: 35,
              ),
              imageContainer((pageNumber * 4) + 1),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              imageContainer((pageNumber * 4) + 2),
              const SizedBox(
                width: 35,
              ),
              imageContainer((pageNumber * 4) + 3),
            ],
          ),
        ],
      ),
    );
  }

  Widget imageContainer(var index) {
    return GestureDetector(
      onTap: () {
        images[index] != "" ? popUpImage(index) : null;
      },
      child: Container(
        width: 120,
        height: 80,
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2),
          color: images[index] != "" ? Colors.white : Colors.transparent,
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            image: images[index] == ""
                ? null
                : DecorationImage(
                    image: NetworkImage(images[index]!),
                    fit: BoxFit.cover,
                  ),
          ),
        ),
      ),
    );
  }

  popUpImage(var index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
          child: AlertDialog(
            content: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Expanded(
                child: Image.network(images[index]!),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget addLeftAndRightButtonsforPages() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () {
            if (pageNumber <= 0) {
              pageNumber = 0;
            } else {
              pageNumber--;
            }
            setState(() {});
          },
          child: const Icon(Icons.arrow_circle_left_sharp,
              size: 60, color: Color.fromARGB(255, 139, 225, 226)),
        ),
        Text(
          "${pageNumber + 1}/3",
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            height: 1.5,
            color:
                Provider.of<ThemeProvider>(context).themeMode == ThemeMode.dark
                    ? const Color(0xffd1e1ff)
                    : const Color(0xff141b41),
          ),
        ),
        GestureDetector(
          onTap: () {
            if (pageNumber >= 2) {
              pageNumber = 2;
            } else {
              pageNumber++;
            }
            setState(() {});
          },
          child: const Icon(Icons.arrow_circle_right_sharp,
              size: 60, color: Color.fromARGB(255, 139, 225, 226)),
        ),
      ],
    );
  }
}
