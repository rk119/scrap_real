import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:scrap_real/themes/theme_provider.dart';
import 'package:scrap_real/utils/custom_snackbar.dart';
import 'package:scrap_real/views/scrapbook_views/editScrapbook2.dart';
import 'package:scrap_real/widgets/button_widgets/custom_textbutton.dart';
import 'package:scrap_real/widgets/card_widgets/custom_biocard.dart';
import 'package:scrap_real/widgets/card_widgets/custom_namecard.dart';
import 'package:scrap_real/widgets/text_widgets/custom_header.dart';
import '../../widgets/button_widgets/custom_backbutton.dart';

class EditScrapbook1 extends StatefulWidget {
  final String scrapbookId;
  const EditScrapbook1({Key? key, required this.scrapbookId}) : super(key: key);

  @override
  State<EditScrapbook1> createState() => _EditScrapbook1State();
}

class _EditScrapbook1State extends State<EditScrapbook1> {
  File? image;
  final TextEditingController _title = TextEditingController();
  final TextEditingController _caption = TextEditingController();
  String coverUrl = "";
  var scrapbookData = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  void dispose() {
    super.dispose();
    _title.dispose();
    _caption.dispose();
  }

  void getData() async {
    final DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection("scrapbooks")
        .doc(widget.scrapbookId)
        .get();
    setState(() {
      _title.text = documentSnapshot["title"];
      _caption.text = documentSnapshot["caption"];
      coverUrl = documentSnapshot["coverUrl"];
      scrapbookData = documentSnapshot.data() as Map<dynamic, dynamic>;
      isLoading = false;
    });
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
                        Navigator.pop(context);
                      }),
                      CustomHeader(headerText: "Edit Scrapbook"),
                      const SizedBox(height: 5),
                      buildCoverPage(),
                      const SizedBox(height: 7),
                      const SizedBox(height: 10),
                      CustomNameCard(
                        textName: "Title",
                        hintingText: "Enter Name",
                        textController: _title,
                        validatorFunction: (value) {
                          if (value!.isEmpty) {
                            return "Please enter a title";
                          }
                          return null;
                        },
                        textColor:
                            Provider.of<ThemeProvider>(context).themeMode ==
                                    ThemeMode.dark
                                ? Colors.white
                                : const Color(0xff141B41),
                      ),
                      const SizedBox(height: 28),
                      CustomBioCard(
                        textController: _caption,
                        cardText: "Caption",
                        cardHintText: "Enter your caption",
                        textColor:
                            Provider.of<ThemeProvider>(context).themeMode ==
                                    ThemeMode.dark
                                ? Colors.white
                                : const Color(0xff141B41),
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
                              builder: (context) => EditScrapbook2(
                                title: _title.text.trim(),
                                caption: _caption.text.trim(),
                                image: image,
                                scrapbookData: scrapbookData,
                                scrapbookId: widget.scrapbookId,
                              ),
                            ),
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
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (context) => buildBottomSheet(),
        );
      },
      child: Container(
        height: 200,
        width: 350,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(15),
          image: image != null
              ? DecorationImage(
                  image: FileImage(image!),
                  fit: BoxFit.cover,
                )
              : coverUrl.isNotEmpty
                  ? DecorationImage(
                      image: NetworkImage(coverUrl),
                      fit: BoxFit.cover,
                    )
                  : null,
        ),
        child: image == null && coverUrl.isEmpty
            ? const Icon(
                Icons.add_a_photo,
                color: Colors.grey,
                size: 50,
              )
            : null,
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
            "Choose a Photo",
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
