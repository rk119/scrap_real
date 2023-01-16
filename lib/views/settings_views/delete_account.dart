import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:scrap_real/themes/theme_provider.dart';
import 'package:scrap_real/views/settings_views/account_info.dart';
import 'package:scrap_real/widgets/button_widgets/custom_backbutton.dart';
import 'package:scrap_real/widgets/button_widgets/custom_textbutton.dart';
import 'package:scrap_real/widgets/text_widgets/custom_subheader.dart';
import 'package:scrap_real/widgets/text_widgets/custom_passwordfield.dart';

class DeleteAccountPage extends StatefulWidget {
  const DeleteAccountPage({Key? key}) : super(key: key);

  @override
  State<DeleteAccountPage> createState() => _DeleteAccounttate();
}

class _DeleteAccounttate extends State<DeleteAccountPage> {
  final TextEditingController _pass1 = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _pass1.dispose();
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
                  textController: _pass1,
                  headingText: "Type your password",
                  validatorFunction: (value) =>
                      (value != null && value.length < 6)
                          ? 'Enter a min. of 6 characters'
                          : null,
                  onTapFunction: () {},
                  hintingText: "Enter New Password",
                  obscureTextBool: true,
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
                  buttonFunction: () {},
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
