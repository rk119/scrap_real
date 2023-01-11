// import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scrap_real/views/user_settings/user_settings.dart';
import 'package:scrap_real/widgets/buttons/custom_backbutton.dart';
import 'package:scrap_real/widgets/buttons/custom_textbutton.dart';
import 'package:scrap_real/widgets/cards/custom_biocard.dart';
import 'package:scrap_real/widgets/cards/custom_namecard.dart';
import 'package:scrap_real/widgets/text_widgets/custom_header.dart';
import 'package:scrap_real/widgets/text_widgets/custom_subheader.dart';
import 'package:scrap_real/widgets/profile_widgets/custom_profile.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final user = FirebaseAuth.instance.currentUser!;
  final TextEditingController _username = TextEditingController();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _bio = TextEditingController();
  File? image; // image used as the user's profile

  final docId = FirebaseAuth.instance.currentUser!.uid;

  @override
  void dispose() {
    super.dispose();
    _username.dispose();
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
            child: StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: ((BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  // UserClass user = snapshot.data as UserClass;
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CustomBackButton(buttonFunction: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const UserSettingsPage()),
                        );
                      }),
                      CustomHeader(headerText: "Edit Profile"),
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
                      const SizedBox(height: 20),
                      CustomNameCard(
                        textName: "Username",
                        hintingText: "Enter Username",
                        textController: _username,
                        validatorFunction: (value) {
                          return null;
                        },
                      ),
                      const SizedBox(height: 30),
                      CustomNameCard(
                        textName: "Name",
                        hintingText: "Enter Name",
                        textController: _name,
                        validatorFunction: (value) {
                          return null;
                        },
                      ),
                      const SizedBox(height: 30),
                      CustomBioCard(
                        textController: _bio,
                        textColor: const Color(0xffa09f9f),
                      ),
                      const SizedBox(height: 30),
                      // Text(userData['name']),
                      const SizedBox(height: 30),
                      CustomTextButton(
                        buttonBorderRadius: BorderRadius.circular(35),
                        buttonFunction: () {
                          final docUser = FirebaseFirestore.instance
                              .collection('users')
                              .doc(user.uid);
                          if (_username.text.isNotEmpty) {
                            docUser.update({'userName': _username.text});
                          }
                          if (_name.text.isNotEmpty) {
                            docUser.update({'name': _name.text});
                          }
                          if (_bio.text.isNotEmpty) {
                            docUser.update({'bio': _bio.text});
                          }
                        },
                        buttonText: "Save",
                      ),
                      const SizedBox(height: 10),
                    ],
                  );
                }
                return const Center(child: Text("no data"));
              }),
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
