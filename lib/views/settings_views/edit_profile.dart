// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scrap_real/utils/firestore_methods.dart';
import 'package:scrap_real/utils/storage_methods.dart';
import 'package:scrap_real/views/settings_views/user_settings.dart';
import 'package:scrap_real/widgets/button_widgets/custom_backbutton.dart';
import 'package:scrap_real/widgets/button_widgets/custom_textbutton.dart';
import 'package:scrap_real/widgets/card_widgets/custom_biocard.dart';
import 'package:scrap_real/widgets/card_widgets/custom_namecard.dart';
import 'package:scrap_real/widgets/text_widgets/custom_header.dart';
import 'package:scrap_real/widgets/text_widgets/custom_subheader.dart';
import 'package:scrap_real/widgets/profile_widgets/custom_profile.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController _username = TextEditingController();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _bio = TextEditingController();
  Uint8List? file;
  String imgPath = "";
  String? photoUrl;
  bool isLoading = true;
  PlatformFile? pickedFile;

  var userData = {};
  final uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  void dispose() {
    super.dispose();
    _username.dispose();
    _name.dispose();
    _bio.dispose();
  }

  getData() async {
    try {
      var userSnap =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      _username.text = userSnap['username'];
      _name.text = userSnap['name'];
      _bio.text = userSnap['bio'];

      photoUrl = userSnap['photoUrl'];
      userData = userSnap.data()!;
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print(e);
    }
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
                if (snapshot.hasData && !isLoading) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CustomBackButton(buttonFunction: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const UserSettingsPage(),
                          ),
                        );
                      }),
                      CustomHeader(headerText: "Edit Profile"),
                      CustomProfilePicture(
                        pickedFile: pickedFile,
                        context: context,
                        onTapFunc: selectFile,
                        photoUrl: photoUrl,
                        alt: "assets/images/profile.png",
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
                        validatorFunction: (value) =>
                            (value != null && value.length > 10)
                                ? 'Username can be max of 10 characters'
                                : null,
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
                      CustomTextButton(
                        buttonBorderRadius: BorderRadius.circular(35),
                        buttonFunction: updateProfile,
                        buttonText: "Save",
                      ),
                      const SizedBox(height: 10),
                    ],
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(color: Color(0xFF918EF4)),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }

  Future takePhoto(ImageSource source) async {
    try {
      // image
      Uint8List im = await StorageMethods().selectImage(source);
      setState(() => file = im);

      // image path
      final path = await StorageMethods().selectTempImage(source);
      setState(() => imgPath = path);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowMultiple: false,
      allowedExtensions: ['jpg', 'jpeg', 'png'],
    );
    if (result == null) {
      return;
    }

    setState(() {
      pickedFile = result.files.first;
    });
  }

  Future<bool> checkValueExistsInDatabase(String value, String field) async {
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('users')
        .where(field, isEqualTo: value)
        .get();
    final List<DocumentSnapshot> documents = result.docs;
    return documents.isEmpty;
  }

  void updateProfile() {
    if (_username.text.trim() == userData['username'] &&
        _name.text.trim() == userData['name'] &&
        _bio.text.trim() == userData['bio'] &&
        pickedFile == null) {
      return;
    }
    FireStoreMethods().updateProfile(
      uid,
      _username.text.trim(),
      _name.text.trim(),
      _bio.text.trim(),
      pickedFile,
      photoUrl,
      userData['username'],
      mounted,
      context,
    );
  }
}
