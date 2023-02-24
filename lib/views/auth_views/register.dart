import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:email_validator/email_validator.dart';
import 'package:provider/provider.dart';
import 'package:scrap_real/themes/theme_provider.dart';
import 'package:scrap_real/utils/auth_methods.dart';
import 'package:scrap_real/views/auth_views/welcome.dart';
import 'package:scrap_real/widgets/button_widgets/custom_backbutton.dart';
import 'package:scrap_real/widgets/text_widgets/custom_header.dart';
import 'package:scrap_real/widgets/text_widgets/custom_subheader.dart';
import 'package:scrap_real/widgets/text_widgets/custom_textformfield.dart';
import 'package:scrap_real/widgets/text_widgets/custom_passwordfield.dart';
import 'package:scrap_real/widgets/button_widgets/custom_textbutton.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  bool obscurePText = true;
  bool obscureCPText = true;

  late final TextEditingController _username = TextEditingController();
  late final TextEditingController _email = TextEditingController();
  late final TextEditingController _password1 = TextEditingController();
  late final TextEditingController _password2 = TextEditingController();

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  void dispose() {
    _username.dispose();
    _email.dispose();
    _password1.dispose();
    _password2.dispose();
    super.dispose();
  }

  Future registerUser() async {
    AuthMethods().registerUser(
      _username.text.trim(),
      _email.text.trim(),
      _password1.text.trim(),
      context,
      mounted,
      _formKey,
      navigatorKey,
    );
  }

  @override
  Widget build(BuildContext context) {
    var formColor =
        Provider.of<ThemeProvider>(context).themeMode == ThemeMode.dark
            ? Colors.white
            : const Color(0xff141B41);

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
                          builder: (context) => const WelcomePage()),
                    );
                  }),
                  CustomHeader(headerText: "Register"),
                  const SizedBox(height: 15),
                  CustomSubheader(
                    headerText: "Create a new account",
                    headerSize: 20,
                    headerColor: const Color(0xffa09f9f),
                  ),
                  const SizedBox(height: 30),
                  CustomTextFormField(
                    textController: _username,
                    headingText: "Username",
                    validatorFunction: (value) =>
                        (value != null && value.length > 10)
                            ? 'Username can be max of 10 characters'
                            : null,
                    hintingText: "Enter Username",
                    textColor: formColor,
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                  CustomTextFormField(
                    textController: _email,
                    headingText: "Email",
                    validatorFunction: (email) =>
                        email != null && !EmailValidator.validate(email.trim())
                            ? 'Invalid email'
                            : null,
                    hintingText: "Enter Email",
                    textColor: formColor,
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                  CustomPasswordFormField(
                    textColor: formColor,
                    textController: _password1,
                    headingText: "Password",
                    validatorFunction: (value) =>
                        (value != null && value.length < 6)
                            ? 'Enter a min. of 6 characters'
                            : null,
                    onTapFunction: () {
                      setState(
                        () {
                          obscurePText = !obscurePText;
                        },
                      );
                    },
                    hintingText: "Enter Password",
                    obscureTextBool: obscurePText,
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                  CustomPasswordFormField(
                    textColor: formColor,
                    textController: _password2,
                    headingText: "Confirm Password",
                    validatorFunction: (value) => (value != null &&
                            value.trim() != _password1.text.trim())
                        ? 'Passwords do not match'
                        : null,
                    onTapFunction: () {
                      setState(
                        () {
                          obscureCPText = !obscureCPText;
                        },
                      );
                    },
                    hintingText: "Retype Password",
                    obscureTextBool: obscureCPText,
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.08),
                  CustomTextButton(
                    buttonBorderRadius: BorderRadius.circular(30),
                    buttonFunction: registerUser,
                    buttonText: "Register",
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
