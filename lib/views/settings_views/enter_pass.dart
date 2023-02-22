import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scrap_real/utils/custom_snackbar.dart';
import 'package:scrap_real/views/navigation.dart';
import 'package:scrap_real/views/settings_views/account_info.dart';
import 'package:scrap_real/widgets/button_widgets/custom_backbutton.dart';
import 'package:scrap_real/widgets/button_widgets/custom_textbutton.dart';
import 'package:scrap_real/widgets/text_widgets/custom_header.dart';
import 'package:scrap_real/widgets/text_widgets/custom_passwordfield.dart';

class EnterPassPage extends StatefulWidget {
  final String email;
  const EnterPassPage({Key? key, required this.email}) : super(key: key);

  @override
  State<EnterPassPage> createState() => _EnterPassPageState();
}

class _EnterPassPageState extends State<EnterPassPage> {
  final _formKey = GlobalKey<FormState>();
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
            child: Form(
              key: _formKey,
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
                  CustomHeader(headerText: "Password"),
                  const SizedBox(height: 30),
                  CustomPasswordFormField(
                    textController: _pass,
                    headingText: "Enter Password",
                    validatorFunction: (value) =>
                        (value != null && value.length < 6)
                            ? 'Enter a min. of 6 characters'
                            : null,
                    onTapFunction: () {
                      setState(
                        () {
                          obscureText = !obscureText;
                        },
                      );
                    },
                    hintingText: "Enter your Password",
                    obscureTextBool: obscureText,
                    textColor: const Color(0xffa0a0a0),
                  ),
                  const SizedBox(height: 30),
                  CustomTextButton(
                    buttonBorderRadius: BorderRadius.circular(35),
                    buttonFunction: () {
                      final isValid = _formKey.currentState!.validate();
                      if (!isValid) return;
                      try {
                        final user = FirebaseAuth.instance.currentUser!;
                        final credential = EmailAuthProvider.credential(
                            email: user.email!, password: _pass.text);
                        user.reauthenticateWithCredential(credential).then(
                            (value) => user
                                .updateEmail(widget.email)
                                .then((value) => CustomSnackBar.snackBarAlert(
                                      context,
                                      "Email Updated!",
                                    )));
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NavBar(),
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
                    },
                    buttonText: "Save",
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
