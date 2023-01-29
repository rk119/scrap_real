import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:scrap_real/themes/theme_provider.dart';
import 'package:scrap_real/views/auth_views/interests.dart';
import 'package:scrap_real/widgets/button_widgets/custom_textbutton.dart';
import 'package:scrap_real/widgets/card_widgets/custom_biocard.dart';
import 'package:scrap_real/widgets/card_widgets/custom_namecard.dart';
import 'package:scrap_real/widgets/profile_widgets/custom_profile.dart';
import 'package:scrap_real/widgets/text_widgets/custom_header.dart';
import 'package:scrap_real/widgets/text_widgets/custom_subheader.dart';

class SetProfilePage extends StatefulWidget {
  const SetProfilePage({Key? key}) : super(key: key);
  @override
  State<SetProfilePage> createState() => _SetProfilePageState();
}

class _SetProfilePageState extends State<SetProfilePage> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _bio = TextEditingController();
  String? photoUrl;
  PlatformFile? pickedFile;
  bool isLoading = true;

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
    _name.dispose();
    _bio.dispose();
  }

  getData() async {
    try {
      var userSnap =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      userData = userSnap.data()!;
      photoUrl = userSnap['photoUrl'];
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    var formColor =
        Provider.of<ThemeProvider>(context).themeMode == ThemeMode.dark
            ? Colors.white
            : const Color(0xffa09f9f);

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
                      CustomHeader(headerText: "Profile Setup"),
                      const SizedBox(height: 28),
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
                      CustomNameCard(
                        textName: "Name",
                        hintingText: "Enter Name",
                        textController: _name,
                        validatorFunction: (value) {
                          return null;
                        },
                        textColor: formColor,
                      ),
                      const SizedBox(height: 28),
                      CustomBioCard(
                        textController: _bio,
                        textColor: formColor,
                      ),
                      const SizedBox(height: 44),
                      CustomTextButton(
                        buttonBorderRadius: BorderRadius.circular(30),
                        buttonFunction: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChooseInterestsPage(
                                name: _name.text.trim(),
                                bio: _bio.text.trim(),
                                photoUrl: photoUrl,
                                pickedFile: pickedFile,
                              ),
                            ),
                          );
                        },
                        buttonText: "Set Profile",
                      ),
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
}
