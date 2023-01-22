import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scrap_real/utils/custom_snackbar.dart';
import 'package:scrap_real/views/navigation.dart';
import 'package:scrap_real/views/settings_views/delete_account.dart';
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
  final TextEditingController _email = TextEditingController();
  final TextEditingController _oldpass = TextEditingController();
  final TextEditingController _pass1 = TextEditingController();
  final TextEditingController _pass2 = TextEditingController();

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
                CustomNameCard(
                  textName: "Change Email",
                  hintingText: "Enter New Email",
                  textController: _email,
                  validatorFunction: (value) {
                    return null;
                  },
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
                CustomPasswordFormField(
                  textController: _oldpass,
                  headingText: "Old Password",
                  validatorFunction: (value) =>
                      (value != null && value.length < 6)
                          ? 'Enter a min. of 6 characters'
                          : null,
                  onTapFunction: () {},
                  hintingText: "Enter Old Password",
                  obscureTextBool: true,
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
                  onTapFunction: () {},
                  hintingText: "Enter New Password",
                  obscureTextBool: true,
                  textColor: const Color(0xffa0a0a0),
                ),
                const SizedBox(height: 30),
                CustomPasswordFormField(
                  textController: _pass2,
                  headingText: "Confirm New Password",
                  validatorFunction: (value) =>
                      (value != null && value.length < 6)
                          ? 'Enter a min. of 6 characters'
                          : null,
                  onTapFunction: () {},
                  hintingText: "Retype Password",
                  obscureTextBool: true,
                  textColor: const Color(0xffa0a0a0),
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
                    // add the rest of the functionality here
                    CustomSnackBar.snackBarAlert(
                      context,
                      "Account Updated!",
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const NavBar(),
                      ),
                    );
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
