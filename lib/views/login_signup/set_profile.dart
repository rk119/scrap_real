import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scrap_real/views/login_signup/choose_interests.dart';
import 'package:scrap_real/views/utils/buttons/custom_textbutton.dart';
import 'package:scrap_real/views/utils/cards/custom_biocard.dart';
import 'package:scrap_real/views/utils/cards/custom_namecard.dart';
import 'package:scrap_real/views/utils/headers/custom_header.dart';
import 'package:scrap_real/views/utils/headers/custom_subheader.dart';
import 'package:scrap_real/views/utils/profile_widgets/custom_profile.dart';

class SetProfilePage extends StatefulWidget {
  const SetProfilePage({Key? key}) : super(key: key);
  @override
  State<SetProfilePage> createState() => _SetProfilePageState();
}

class _SetProfilePageState extends State<SetProfilePage> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _bio = TextEditingController();
  File? image; // image used as the user's profile

  @override
  void dispose() {
    super.dispose();
    _name.dispose();
    _bio.dispose();
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
                CustomHeader(headerText: "Profile Setup"),
                const SizedBox(height: 28),
                CustomProfilePicture(
                  image: image,
                  context: context,
                  profileFunction1: () {
                    takePhoto(ImageSource.camera);
                  },
                  profileFunction2: () {
                    takePhoto(ImageSource.gallery);
                  },
                ),
                const SizedBox(height: 7),
                CustomSubheader(
                  headerText: "Edit",
                  headerSize: 20,
                  headerColor: const Color(0xffa09f9f),
                ),
                CustomNameCard(
                  textName: "Name",
                  hintingText: "Enter Name",
                  textController: _name,
                  validatorFunction: (value) {
                    return null;
                  },
                  textColor: Colors.black,
                ),
                const SizedBox(height: 28),
                CustomBioCard(textController: _bio),
                const SizedBox(height: 44),
                CustomTextButton(
                  buttonBorderRadius: BorderRadius.circular(30),
                  buttonFunction: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ChooseInterestsPage()),
                    );
                  },
                  buttonText: "Set Profile",
                ),
              ],
            ),
          ),
        ),
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
