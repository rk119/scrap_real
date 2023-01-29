import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:scrap_real/themes/theme_provider.dart';
import 'package:scrap_real/views/auth_views/welcome.dart';
import 'package:scrap_real/views/settings_views/account_info.dart';
import 'package:scrap_real/widgets/button_widgets/custom_backbutton.dart';
import 'package:scrap_real/widgets/button_widgets/custom_textbutton.dart';
import 'package:scrap_real/widgets/text_widgets/custom_subheader.dart';
import 'package:scrap_real/widgets/text_widgets/custom_passwordfield.dart';

import '../../utils/custom_snackbar.dart';

class DeleteAccountPage extends StatefulWidget {
  const DeleteAccountPage({Key? key}) : super(key: key);

  @override
  State<DeleteAccountPage> createState() => _DeleteAccounttate();
}

class _DeleteAccounttate extends State<DeleteAccountPage> {
  final TextEditingController _pass = TextEditingController();
  bool obscureText = true;

  @override
  void dispose() {
    super.dispose();
    _pass.dispose();
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
                    MaterialPageRoute(
                        builder: (context) => const AccountInformationPage()),
                  );
                }),
                CustomSubheader(
                  headerText: "Delete Account",
                  headerSize: 28,
                  headerColor: const Color(0xffbc2d21),
                ),
                const SizedBox(height: 30),
                CustomPasswordFormField(
                  textController: _pass,
                  headingText: "Type your password",
                  validatorFunction: (value) =>
                      (value != null && value.length < 6)
                          ? 'Enter a min. of 6 characters'
                          : null,
                  onTapFunction: () {
                    setState(() {
                      obscureText = !obscureText;
                    });
                  },
                  hintingText: "Enter New Password",
                  obscureTextBool: obscureText,
                  textColor: Provider.of<ThemeProvider>(context).themeMode ==
                          ThemeMode.dark
                      ? Colors.white
                      : Colors.black,
                ),
                const SizedBox(height: 30),
                CustomSubheader(
                  headerText: "All your data will be lost.",
                  headerSize: 18,
                  headerColor: const Color(0xffa0a0a0),
                ),
                CustomSubheader(
                    headerText: "Are you sure you want to delete your account?",
                    headerSize: 18,
                    headerColor: const Color(0xffa0a0a0)),
                const SizedBox(height: 30),
                CustomTextButton(
                  buttonBorderRadius: BorderRadius.circular(35),
                  buttonFunction: () async {
                    try {
                      final FirebaseAuth _auth = FirebaseAuth.instance;
                      final user = _auth.currentUser!;
                      final credentials = EmailAuthProvider.credential(
                          email: user.email!, password: _pass.text);
                      final result =
                          await user.reauthenticateWithCredential(credentials);
                      if (result != null) {
                        final userSnap = await FirebaseFirestore.instance
                            .collection('users')
                            .doc(user.uid)
                            .get();
                        final userData = userSnap.data()!;
                        final url = userData['photoUrl'];
                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(user.uid)
                            .delete();
                        await user.delete();
                        url != ""
                            ? await FirebaseStorage.instance
                                .refFromURL(url)
                                .delete()
                            : null;
                      }
                      // ignore: use_build_context_synchronously
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const WelcomePage(),
                          ));
                    } catch (e) {
                      // ignore: avoid_print
                      print(e);
                      final regex = RegExp(r'^\[(.*)\]\s(.*)$');
                      final match = regex.firstMatch(e.toString())?.group(2);
                      if (!mounted) {
                        return;
                      }
                      CustomSnackBar.showSnackBar(context, match);
                    }
                    ;
                  },
                  buttonText: "Confirm",
                  buttonColor: const Color(0xffbc2d21),
                  buttonTextColor: Colors.white,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
