import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scrap_real/views/login_signup/forgot_pass.dart';
import 'package:scrap_real/views/navigation.dart';
import 'package:scrap_real/views/login_signup/welcome.dart';
import 'package:scrap_real/views/utils/buttons/custom_backbutton.dart';
import 'package:scrap_real/views/utils/headers/custom_header.dart';
import 'package:scrap_real/views/utils/headers/custom_subheader.dart';
import 'package:scrap_real/views/utils/text_fields/custom_textformfield.dart';
import 'package:scrap_real/views/utils/text_fields/custom_passwordfield.dart';
import 'package:scrap_real/views/utils/buttons/custom_textbutton.dart';

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

  // Future<Null> getUserFirestore(String userName) async {
  //   FirebaseFirestore firestore = FirebaseFirestore.instance;
  //   CollectionReference users = firestore.collection('users');
  //   String email = "";
  //   String trimmedUser = userName.trim();
  //   users
  //       .where('userName', isEqualTo: trimmedUser)
  //       .get()
  //       .then((QuerySnapshot documentSnapshot) {
  //     if (documentSnapshot.docs.isNotEmpty) {
  //       print('Document data: ${documentSnapshot.docs[0].data()}');
  //       Map<String, dynamic> userDocument =
  //           documentSnapshot.docs[0].data() as Map<String, dynamic>;

  //       //Sumant coding = 💩;
  //       email = userDocument['email'];
  //       _email.text = email.toString();
  //     } else {
  //       _email.text = email;
  //       print('Document does not exist on the database');
  //     }
  //   });
  //   return;
  // }

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
    final isValid = _formKey.currentState!.validate();
    if (!isValid) return;
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _email.text.trim(),
        password: _password.text.trim(),
      );
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const NavBar()),
      );
    } catch (e) {
      final regex = RegExp(r'^\[(.*)\]\s(.*)$');
      final match = regex.firstMatch(e.toString());
      showSnackBar(match?.group(2));
    }
  }

  showSnackBar(String? message) {
    if (message == null) return;
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: const Color(0xffBC2D21),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
                  CustomHeader(headerText: "Login"),
                  const SizedBox(height: 15),
                  CustomSubheader(
                    headerText: "Sign in to your account",
                    headerSize: 20,
                    headerColor: const Color(0xffa09f9f),
                  ),
                  const SizedBox(height: 137),
                  CustomTextFormField(
                      textController: _email,
                      headingText: "Email",
                      validatorFunction: (email) =>
                          email != null && !EmailValidator.validate(email)
                              ? 'Invalid email'
                              : null,
                      hintingText: "Enter Email"),
                  const SizedBox(height: 30),
                  CustomPasswordFormField(
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
                  buildForgotPassword(context),
                  const SizedBox(height: 136),
                  CustomTextButton(
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
