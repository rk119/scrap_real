import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:provider/provider.dart';
import 'package:scrap_real/models/user_class.dart';
import 'package:scrap_real/themes/theme_provider.dart';
import 'package:scrap_real/views/login_signup/send_verification.dart';
import 'package:scrap_real/views/login_signup/welcome.dart';
import 'package:scrap_real/widgets/buttons/custom_backbutton.dart';
import 'package:scrap_real/widgets/text_widgets/custom_header.dart';
import 'package:scrap_real/widgets/text_widgets/custom_subheader.dart';
import 'package:scrap_real/widgets/text_fields/custom_textformfield.dart';
import 'package:scrap_real/widgets/text_fields/custom_passwordfield.dart';
import 'package:scrap_real/widgets/buttons/custom_textbutton.dart';

import '../../widgets/custom_snackbar.dart';

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

  Future<void> addToFirestore(String email, String userName) async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    users.add({'email': email, 'userName': userName});
    return;
  }

  Future registerUser() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) return;

    // username exists
    final docUser = FirebaseFirestore.instance
        .collection('users')
        .where('userName', isEqualTo: _username.text.trim());
    final docUserSnapshot = await docUser.get();
    if (docUserSnapshot.docs.isNotEmpty) {
      CustomSnackBar.showSnackBar(context, "Username already exists");
      return;
    }
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(
          color: Color(0xff918ef4),
        ),
      ),
    );

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _email.text.trim(), password: _password1.text.trim());

      final uid = FirebaseAuth.instance.currentUser!.uid;
      final docUser = FirebaseFirestore.instance.collection('users').doc(uid);

      final userModel = UserModel(
        uid: docUser.id,
        email: _email.text.trim(),
        userName: _username.text.trim(),
        name: "",
        bio: "",
        followers: [],
        following: [],
      );
      final json = userModel.toJson();
      await docUser.set(json);

      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SendVerificationPage()),
      );
    } catch (e) {
      // ignore: avoid_print
      print(e);
      final regex = RegExp(r'^\[(.*)\]\s(.*)$');
      final match = regex.firstMatch(e.toString());
      CustomSnackBar.showSnackBar(context, match?.group(2));
      Navigator.of(context).pop();
    }
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
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
                  ),
                  const SizedBox(height: 28),
                  CustomTextFormField(
                    textController: _email,
                    headingText: "Email",
                    validatorFunction: (email) =>
                        email != null && !EmailValidator.validate(email)
                            ? 'Invalid email'
                            : null,
                    hintingText: "Enter Email",
                  ),
                  const SizedBox(height: 28),
                  CustomPasswordFormField(
                    textColor: Provider.of<ThemeProvider>(context).themeMode ==
                            ThemeMode.dark
                        ? Colors.white
                        : Colors.black,
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
                  const SizedBox(height: 28),
                  CustomPasswordFormField(
                    textColor: Provider.of<ThemeProvider>(context).themeMode ==
                            ThemeMode.dark
                        ? Colors.white
                        : Colors.black,
                    textController: _password2,
                    headingText: "Confirm Password",
                    validatorFunction: (value) =>
                        (value != null && value != _password1.text)
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
                  const SizedBox(height: 44),
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
