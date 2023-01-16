import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:scrap_real/themes/theme_provider.dart';
import 'package:scrap_real/utils/custom_snackbar.dart';
import 'package:scrap_real/views/navigation.dart';
import 'package:scrap_real/views/scrapbook_views/create2.dart';
import 'package:scrap_real/widgets/button_widgets/custom_backbutton.dart';
import 'package:scrap_real/widgets/button_widgets/custom_textbutton.dart';
import 'package:scrap_real/widgets/card_widgets/custom_biocard.dart';
import 'package:scrap_real/widgets/card_widgets/custom_namecard.dart';
import 'package:scrap_real/widgets/text_widgets/custom_header.dart';

class CreateScrapbookPage1 extends StatefulWidget {
  const CreateScrapbookPage1({Key? key}) : super(key: key);
  @override
  State<CreateScrapbookPage1> createState() => _CreateScrapbookPage1State();
}

class _CreateScrapbookPage1State extends State<CreateScrapbookPage1> {
  File? image;
  final TextEditingController _title = TextEditingController();
  final TextEditingController _caption = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _title.dispose();
    _caption.dispose();
  }

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
                    MaterialPageRoute(builder: (context) => const NavBar()),
                  );
                }),
                CustomHeader(headerText: "Create Scrapbook"),
                const SizedBox(height: 5),
                buildCoverPage(),
                const SizedBox(height: 7),
                const SizedBox(height: 10),
                CustomNameCard(
                  textName: "Title",
                  hintingText: "Enter Name",
                  textController: _title,
                  validatorFunction: (title) =>
                      (title != null && title.length < 6)
                          ? 'Enter a min. of 6 characters'
                          : null,
                  textColor: Provider.of<ThemeProvider>(context).themeMode ==
                          ThemeMode.dark
                      ? Colors.white
                      : Colors.black,
                ),
                const SizedBox(height: 28),
                CustomBioCard(
                  textController: _caption,
                  cardText: "Caption",
                  cardHintText: "Enter your caption",
                  textColor: Provider.of<ThemeProvider>(context).themeMode ==
                          ThemeMode.dark
                      ? Colors.white
                      : Colors.black,
                ),
                const SizedBox(height: 44),
                CustomTextButton(
                  buttonBorderRadius: BorderRadius.circular(30),
                  buttonFunction: () {
                    if (_title.text.isEmpty) {
                      CustomSnackBar.snackBarAlert(
                        context,
                        "Please enter a title",
                      );
                      return;
                    }
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CreateScrapbookPage2()),
                    );
                  },
                  buttonText: "Next",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildCoverPage() {
    return Center(
      child: TextButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: ((builder) => buildBottomSheet()),
          );
        },
        child: Stack(
          children: [
            image != null
                ? Container(
                    height: 205,
                    width: 350,
                    decoration: BoxDecoration(
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x3f000000),
                          blurRadius: 2,
                          offset: Offset(0, 1),
                        )
                      ],
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const SizedBox(),
                  )
                : const SizedBox(),
            ClipRRect(
              borderRadius: BorderRadius.circular(15.0), // add border radius
              child: image != null
                  ? Image.file(
                      image!,
                      width: 350,
                      height: 205,
                      fit: BoxFit.cover,
                    )
                  : Image.asset(
                      "assets/images/addCover.jpg",
                      width: 350,
                      height: 205,
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildBottomSheet() {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: <Widget>[
          const Text(
            "Choose Profile Photo",
            style: TextStyle(fontSize: 20.0),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextButton(
                child: const Icon(Icons.camera_alt_rounded),
                onPressed: () {
                  takePhoto(ImageSource.camera);
                },
              ),
              const Text("Camera"),
              const SizedBox(width: 30),
              TextButton(
                child: const Icon(Icons.image),
                onPressed: () {
                  takePhoto(ImageSource.gallery);
                },
              ),
              const Text("Gallery"),
            ],
          )
        ],
      ),
    );
  }

  Future takePhoto(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;
      final imageTmp = File(image.path);
      setState(() => this.image = imageTmp);
    } on PlatformException catch (e) {
      // ignore: avoid_print
      print('Failed to pick image: $e');
    }
  }
}
