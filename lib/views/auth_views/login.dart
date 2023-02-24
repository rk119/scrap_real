import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:scrap_real/themes/theme_provider.dart';
import 'package:scrap_real/utils/auth_methods.dart';
import 'package:scrap_real/views/auth_views/forgot_pass.dart';
import 'package:scrap_real/views/auth_views/welcome.dart';
import 'package:scrap_real/widgets/button_widgets/custom_backbutton.dart';
import 'package:scrap_real/widgets/text_widgets/custom_header.dart';
import 'package:scrap_real/widgets/text_widgets/custom_subheader.dart';
import 'package:scrap_real/widgets/text_widgets/custom_textformfield.dart';
import 'package:scrap_real/widgets/text_widgets/custom_passwordfield.dart';
import 'package:scrap_real/widgets/button_widgets/custom_textbutton.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  bool obscureText = true;

  final TextEditingController _password = TextEditingController();
  final TextEditingController _email = TextEditingController();

  @override
  void dispose() {
    _password.dispose();
    _email.dispose();
    super.dispose();
  }

  Widget buildForgotPassword(BuildContext context) {
    return Container(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ForgotPassPage()),
          );
        },
        child: Text(
          'Forgot Password?',
          style: GoogleFonts.poppins(
            fontSize: 17,
            color: const Color(0xff918ef4),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Future loginUser() async {
    AuthMethods().loginUser(
      _email.text.trim(),
      _password.text.trim(),
      context,
      mounted,
      _formKey,
    );
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
                  CustomBackButton(
                      key: const Key('loginBack'),
                      buttonFunction: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const WelcomePage()),
                        );
                      }),
                  CustomHeader(headerText: "Login"),
                  const SizedBox(height: 15),
                  CustomSubheader(
                    headerText: "Sign in to your account",
                    headerSize: 20,
                    headerColor: const Color(0xffa09f9f),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.15),
                  CustomTextFormField(
                    key: const Key('loginEmail'),
                    textController: _email,
                    headingText: "Email",
                    validatorFunction: (email) =>
                        email != null && !EmailValidator.validate(email.trim())
                            ? 'Invalid email'
                            : null,
                    hintingText: "Enter Email",
                    textColor: Provider.of<ThemeProvider>(context).themeMode ==
                            ThemeMode.dark
                        ? Colors.white
                        : const Color(0xff141B41),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.07),
                  CustomPasswordFormField(
                    key: const Key('loginPass'),
                    textColor: Provider.of<ThemeProvider>(context).themeMode ==
                            ThemeMode.dark
                        ? Colors.white
                        : const Color(0xff141B41),
                    textController: _password,
                    headingText: "Password",
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
                    hintingText: "Enter Password",
                    obscureTextBool: obscureText,
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                  buildForgotPassword(context),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.16),
                  CustomTextButton(
                    key: const Key('loginButton'),
                    buttonBorderRadius: BorderRadius.circular(30),
                    buttonFunction: loginUser,
                    buttonText: "Login",
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
