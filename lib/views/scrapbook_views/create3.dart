import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:scrap_real/themes/theme_provider.dart';
import 'package:scrap_real/utils/firestore_methods.dart';
import 'package:scrap_real/views/navigation.dart';
import 'package:scrap_real/widgets/button_widgets/custom_backbutton.dart';
import 'package:scrap_real/widgets/button_widgets/custom_textbutton.dart';
import 'package:scrap_real/widgets/text_widgets/custom_header.dart';

class CreateScrapbookPage3 extends StatefulWidget {
  final File? coverImage;
  final String title;
  final String caption;
  final bool tag;
  final bool type;
  final bool visibility;
  final List<String> collaborators;
  final bool group;

  const CreateScrapbookPage3({
    Key? key,
    required this.coverImage,
    required this.title,
    required this.caption,
    required this.tag,
    required this.type,
    required this.visibility,
    required this.collaborators,
    required this.group,
  }) : super(key: key);

  @override
  State<CreateScrapbookPage3> createState() => _CreateScrapbookPage3State();
}

class _CreateScrapbookPage3State extends State<CreateScrapbookPage3> {
  List<File?> images = List.filled(12, null);
  int pageNumber = 0;
  bool _isLocationEnabled = false;
  final List<String> likes = [];

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
                      builder: (context) => NavBar(
                        currentIndex: 2,
                      ),
                    ),
                  );
                }),
                CustomHeader(headerText: "Create Scrapbook"),
                const SizedBox(height: 40),
                Text(
                  "Add Images",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    height: 1.5,
                    color: Provider.of<ThemeProvider>(context).themeMode ==
                            ThemeMode.dark
                        ? const Color(0xffd1e1ff)
                        : const Color(0xff141b41),
                  ),
                ),
                const SizedBox(height: 40),
                addImages(),
                const SizedBox(height: 40),
                addLeftAndRightButtonsforPages(),
                const SizedBox(height: 40),
                locationToggle(),
                const SizedBox(height: 60),
                CustomTextButton(
                  buttonBorderRadius: BorderRadius.circular(30),
                  buttonFunction: createScrapbook,
                  buttonText: "Create",
                  buttonColor: const Color(0xff7be5e7),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget subheader(String text) {
    return Container(
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          height: 1.5,
          color: Provider.of<ThemeProvider>(context).themeMode == ThemeMode.dark
              ? const Color(0xffd1e1ff)
              : const Color(0xff141b41),
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
        showModalBottomSheet(
          context: context,
          builder: ((builder) => buildBottomSheet(index)),
        );
      },
      onLongPress: () {
        images[index] != null ? popUpImage(index) : null;
      },
      child: Container(
        width: 120,
        height: 80,
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2),
          color: Colors.white,
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            image: images[index] == null
                ? const DecorationImage(
                    image: AssetImage("assets/images/addImage.png"),
                    fit: BoxFit.cover,
                  )
                : DecorationImage(
                    image: FileImage(images[index]!),
                    fit: BoxFit.cover,
                  ),
          ),
        ),
      ),
    );
  }

  Widget buildBottomSheet(var index) {
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
                  takePhoto(ImageSource.camera, index);
                },
              ),
              const Text("Camera"),
              const SizedBox(width: 30),
              TextButton(
                child: const Icon(Icons.image),
                onPressed: () {
                  takePhoto(ImageSource.gallery, index);
                },
              ),
              const Text("Gallery"),
            ],
          )
        ],
      ),
    );
  }

  Future takePhoto(ImageSource source, var index) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;
      final imageTmp = File(image.path);
      setState(() => images[index] = imageTmp);
    } on PlatformException catch (e) {
      // ignore: avoid_print
      print('Failed to pick image: $e');
    }
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
                child: Image.file(images[index]!),
              ),
            ),
            actions: [
              Center(
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      images[index] = null;
                    });
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Delete",
                    style: TextStyle(color: Colors.red, fontSize: 15),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget addLeftAndRightButtonsforPages() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              if (pageNumber <= 0) {
                pageNumber = 0;
              } else {
                pageNumber--;
                print(pageNumber);
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
              color: Provider.of<ThemeProvider>(context).themeMode ==
                      ThemeMode.dark
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
                print(pageNumber);
              }
              setState(() {});
            },
            child: const Icon(Icons.arrow_circle_right_sharp,
                size: 60, color: Color.fromARGB(255, 139, 225, 226)),
          ),
        ],
      ),
    );
  }

  Future createScrapbook() async {
    double lat = 0.0;
    double long = 0.0;
    if (_isLocationEnabled) {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      lat = position.latitude;
      long = position.longitude;
    }

    // ignore: use_build_context_synchronously
    FireStoreMethods().createScrapbook(
      widget.coverImage,
      widget.title,
      widget.caption,
      widget.tag,
      widget.type,
      widget.visibility,
      likes,
      widget.collaborators,
      images,
      widget.group,
      lat,
      long,
      context,
      mounted,
      // _collaborators.length > 0 ? true : false,
    );
  }

  Widget locationToggle() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Location ${_isLocationEnabled ? "Enabled" : "Disabled"}",
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              height: 1.5,
              color: Provider.of<ThemeProvider>(context).themeMode ==
                      ThemeMode.dark
                  ? const Color(0xffd1e1ff)
                  : const Color(0xff141b41),
            ),
          ),
          Switch(
            value: _isLocationEnabled,
            onChanged: (value) {
              setState(() {
                _isLocationEnabled = value;
                print(_isLocationEnabled);
              });
            },
            activeTrackColor: Color.fromARGB(255, 225, 225, 255),
            activeColor: const Color(0xff918ef4),
          ),
        ],
      ),
    );
  }
}
