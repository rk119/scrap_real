import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scrap_real/utils/custom_snackbar.dart';
import 'package:scrap_real/views/navigation.dart';
import 'package:scrap_real/views/settings_views/delete_account.dart';
import 'package:scrap_real/views/settings_views/enter_pass.dart';
import 'package:scrap_real/views/settings_views/user_settings.dart';
import 'package:scrap_real/widgets/button_widgets/custom_backbutton.dart';
import 'package:scrap_real/widgets/button_widgets/custom_textbutton.dart';
import 'package:scrap_real/widgets/card_widgets/custom_namecard.dart';
import 'package:scrap_real/widgets/text_widgets/custom_header.dart';
import 'package:scrap_real/widgets/text_widgets/custom_passwordfield.dart';

class AccountInformationPage extends StatefulWidget {
  const AccountInformationPage({Key? key}) : super(key: key);

  @override
  State<AccountInformationPage> createState() => _AccountInformationPageState();
}

class _AccountInformationPageState extends State<AccountInformationPage> {
  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  final TextEditingController _email =
      TextEditingController(text: FirebaseAuth.instance.currentUser!.email!);
  final TextEditingController _oldpass = TextEditingController();
  final TextEditingController _pass1 = TextEditingController();
  final TextEditingController _pass2 = TextEditingController();
  bool obscureTextOld = true;
  bool obscureTextNew = true;
  bool obscureTextConfirm = true;

  @override
  void dispose() {
    super.dispose();
    _email.dispose();
    _oldpass.dispose();
    _pass1.dispose();
    _pass2.dispose();
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
                        builder: (context) => const UserSettingsPage()),
                  );
                }),
                CustomHeader(headerText: "Account Information"),
                const SizedBox(height: 30),
                Form(
                  key: _formKey1,
                  child: CustomNameCard(
                    textName: "Change Email",
                    hintingText: "Enter New Email",
                    textController: _email,
                    validatorFunction: (value) =>
                        value != null && !EmailValidator.validate(value.trim())
                            ? 'Invalid email'
                            : null,
                  ),
                ),
                const SizedBox(height: 30),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Change Password",
                    textAlign: TextAlign.left,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xff918ef4),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Form(
                  key: _formKey2,
                  child: Column(
                    children: [
                      CustomPasswordFormField(
                        textController: _oldpass,
                        headingText: "Old Password",
                        validatorFunction: (value) =>
                            (value != null && value.length < 6)
                                ? 'Enter a min. of 6 characters'
                                : null,
                        onTapFunction: () {
                          setState(
                            () {
                              obscureTextOld = !obscureTextOld;
                            },
                          );
                        },
                        hintingText: "Enter Old Password",
                        obscureTextBool: obscureTextOld,
                        textColor: const Color(0xffa0a0a0),
                      ),
                      const SizedBox(height: 30),
                      CustomPasswordFormField(
                        textController: _pass1,
                        headingText: "New Password",
                        validatorFunction: (value) =>
                            (value != null && value.length < 6)
                                ? 'Enter a min. of 6 characters'
                                : null,
                        onTapFunction: () {
                          setState(
                            () {
                              obscureTextNew = !obscureTextNew;
                            },
                          );
                        },
                        hintingText: "Enter New Password",
                        obscureTextBool: obscureTextNew,
                        textColor: const Color(0xffa0a0a0),
                      ),
                      const SizedBox(height: 30),
                      CustomPasswordFormField(
                        textController: _pass2,
                        headingText: "Confirm New Password",
                        validatorFunction: (value) =>
                            (value != null && value != _pass1.text)
                                ? 'Passwords do not match'
                                : null,
                        onTapFunction: () {
                          setState(
                            () {
                              obscureTextConfirm = !obscureTextConfirm;
                            },
                          );
                        },
                        hintingText: "Retype Password",
                        obscureTextBool: obscureTextConfirm,
                        textColor: const Color(0xffa0a0a0),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: 210,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const DeleteAccountPage()),
                      );
                    },
                    child: Row(children: [
                      SvgPicture.asset(
                        "assets/trash_can.svg",
                        height: 35,
                        width: 35,
                        color: const Color(0xffbc2d21),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "Delete Account",
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xffbc2d21),
                        ),
                      ),
                    ]),
                  ),
                ),
                const SizedBox(height: 30),
                CustomTextButton(
                  buttonBorderRadius: BorderRadius.circular(35),
                  buttonFunction: () {
                    if (_email.text.isNotEmpty) {
                      // update email
                      bool isValid = _formKey1.currentState!.validate();
                      if (!isValid) return;
                      if (FirebaseAuth.instance.currentUser!.email! ==
                          _email.text.trim()) {
                        CustomSnackBar.showSnackBar(
                            context, "Email is already in use!");
                        return;
                      }
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                EnterPassPage(email: _email.text),
                          ));
                    } else if (_pass1.text.isNotEmpty &&
                        _pass2.text.isNotEmpty &&
                        _oldpass.text.isNotEmpty) {
                      // update password
                      bool isValid = _formKey2.currentState!.validate();
                      if (!isValid) return;
                      try {
                        final user = FirebaseAuth.instance.currentUser!;
                        final credential = EmailAuthProvider.credential(
                            email: user.email!, password: _oldpass.text);
                        user.reauthenticateWithCredential(credential).then(
                            (value) => user
                                .updatePassword(_pass1.text)
                                .then((value) => CustomSnackBar.snackBarAlert(
                                      context,
                                      "Password Updated!",
                                    )));
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NavBar(),
                          ),
                        );
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
                    }
                  },
                  buttonText: "Save",
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
