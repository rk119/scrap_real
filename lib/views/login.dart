import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scrap_real/views/welcome.dart';

import '../firebase_options.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  @override
  State<LoginPage> createState() => _LoginPageState();
}

Widget buildBackBtn(BuildContext context) {
  return Container(
    alignment: const Alignment(-1.15, 0),
    child: TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const WelcomePage()),
        );
      },
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
      ),
      child: SizedBox(
        width: 20,
        height: 20,
        child: SvgPicture.asset(
          'assets/back.svg',
        ),
      ),
    ),
  );
}

Text textLogin() {
  return Text(
    'Login',
    textAlign: TextAlign.center,
    style: GoogleFonts.poppins(
      fontSize: 30,
      fontWeight: FontWeight.w600,
      height: 1.5,
      color: const Color(0xff918ef4),
    ),
  );
}

Text textSignIn() {
  return Text(
    'Sign in to your account',
    textAlign: TextAlign.center,
    style: GoogleFonts.poppins(
      fontSize: 20,
      fontWeight: FontWeight.w500,
      height: 1.5,
      color: Color(0xffa09f9f),
    ),
  );
}

Widget buildUsername() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      const Text(
        'Username',
        style: TextStyle(
          color: Color(0xff141b41),
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 10),
      Container(
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
            color: const Color(0xffFEFCFC),
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(
                  color: Colors.black26, blurRadius: 4, offset: Offset(0, 1))
            ]),
        height: 60,
        child: const TextField(
          keyboardType: TextInputType.emailAddress,
          style: TextStyle(color: Colors.black87),
          decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(14),
              hintText: 'Enter Username',
              hintStyle: TextStyle(color: Colors.black38)),
        ),
      ),
    ],
  );
}

Widget buildForgotPassword() {
  return Container(
    alignment: Alignment.centerRight,
    child: TextButton(
      onPressed: () => print("Forgot Password pressed"),
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

Widget buildAltLogin() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Container(
        alignment: Alignment.centerLeft,
        child: TextButton(
          onPressed: () {},
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
          ),
          child: SizedBox(
            width: 35,
            height: 35,
            child: SvgPicture.asset(
              'assets/icons/googlelogo.svg',
            ),
          ),
        ),
      ),
      const SizedBox(width: 40),
      Container(
        alignment: Alignment.centerLeft,
        child: TextButton(
          onPressed: () {},
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
          ),
          child: SizedBox(
            width: 35,
            height: 35,
            child: SvgPicture.asset(
              'assets/icons/facebooklogo.svg',
            ),
          ),
        ),
      ),
      const SizedBox(width: 40),
      Container(
        alignment: Alignment.centerLeft,
        child: TextButton(
          onPressed: () {},
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
          ),
          child: SizedBox(
            width: 35,
            height: 35,
            child: SvgPicture.asset(
              'assets/icons/twitterlogo.svg',
            ),
          ),
        ),
      ),
    ],
  );
}

Widget buildLogin() {
  return Container(
    width: double.infinity,
    height: 50,
    decoration: BoxDecoration(
      color: const Color(0xff7be5e7),
      borderRadius: BorderRadius.circular(30),
      boxShadow: const [
        BoxShadow(
          color: Color(0x19000000),
          offset: Offset(0, 2),
        ),
      ],
    ),
    child: Center(
      child: Text(
        'Login',
        textAlign: TextAlign.center,
        style: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          height: 1.5,
          color: Colors.black,
        ),
      ),
    ),
  );
}

class _LoginPageState extends State<LoginPage> {
  bool obscureText = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform,
          ),
          builder: (context, snapshot) {
            return AnnotatedRegion<SystemUiOverlayStyle>(
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
                      buildBackBtn(context),
                      textLogin(),
                      const SizedBox(height: 15),
                      textSignIn(),
                      const SizedBox(height: 137),
                      buildUsername(),
                      const SizedBox(height: 30),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Text(
                            'Password',
                            style: TextStyle(
                              color: Color(0xff141b41),
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            alignment: Alignment.centerLeft,
                            decoration: BoxDecoration(
                              color: const Color(0xffFEFCFC),
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 4,
                                  offset: Offset(0, 1),
                                )
                              ],
                            ),
                            height: 60,
                            child: TextField(
                              obscureText: obscureText,
                              style: const TextStyle(color: Colors.black87),
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.all(14),
                                  suffixIcon: GestureDetector(
                                    onTap: () {
                                      setState(
                                        () {
                                          obscureText = !obscureText;
                                        },
                                      );
                                    },
                                    child: Icon(
                                      obscureText
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      color: const Color(0xffc4c4c4),
                                    ),
                                  ),
                                  hintText: 'Enter Password',
                                  hintStyle:
                                      const TextStyle(color: Colors.black38)),
                            ),
                          )
                        ],
                      ),
                      buildForgotPassword(),
                      const SizedBox(height: 45),
                      buildAltLogin(),
                      const SizedBox(height: 55),
                      buildLogin(),
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }
}
