import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scrap_real/router/route_constants.dart';
import 'package:scrap_real/views/login.dart';
import 'package:scrap_real/views/set_new_pass.dart';
import '../firebase_options.dart';

class ForgotPassPage extends StatefulWidget {
  const ForgotPassPage({Key? key}) : super(key: key);
  @override
  State<ForgotPassPage> createState() => _ForgotPassPageState();
}

Widget buildBackBtn(BuildContext context) {
  return Container(
    alignment: const Alignment(-1.15, 0),
    child: TextButton(
      onPressed: () {
        context.pushReplacementNamed(RouteConstants.login);
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

Text textForgotPass() {
  return Text(
    'Forgot Password',
    textAlign: TextAlign.center,
    style: GoogleFonts.poppins(
      fontSize: 30,
      fontWeight: FontWeight.w600,
      height: 1.5,
      color: const Color(0xff918ef4),
    ),
  );
}

Text textForgot() {
  return Text(
    'Enter your email to receive an OTP to reset your password',
    textAlign: TextAlign.center,
    style: GoogleFonts.poppins(
      fontSize: 20,
      fontWeight: FontWeight.w500,
      height: 1.5,
      color: const Color(0xffa09f9f),
    ),
  );
}

Widget textEmail() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Text(
        'Email',
        textAlign: TextAlign.center,
        style: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          height: 1.5,
          color: const Color(0xff141b41),
        ),
      ),
      const SizedBox(height: 10),
      Container(
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
            color: const Color(0xfffdfbfb),
            borderRadius: BorderRadius.circular(6),
            boxShadow: const [
              BoxShadow(
                color: Color(0x3f000000),
                blurRadius: 2,
                offset: Offset(1, 2),
              )
            ]),
        height: 60,
        child: TextField(
          keyboardType: TextInputType.emailAddress,
          style: const TextStyle(color: Colors.black87),
          decoration: InputDecoration(
            border: InputBorder.none,
            contentPadding: const EdgeInsets.all(10),
            hintText: 'Enter your Email',
            hintStyle: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              height: 1.5,
              color: const Color.fromARGB(255, 193, 193, 193),
            ),
          ),
        ),
      ),
    ],
  );
}

Widget buildForgot(context) {
  return TextButton(
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SetNewPassPage()),
      );
    },
    child: Container(
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
          'Verify Email',
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            height: 1.5,
            color: Colors.black,
          ),
        ),
      ),
    ),
  );
}

class _ForgotPassPageState extends State<ForgotPassPage> {
  bool obscureText = true;
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
                buildBackBtn(context),
                textForgotPass(),
                const SizedBox(height: 15),
                textForgot(),
                const SizedBox(height: 137),
                textEmail(),
                const SizedBox(height: 280),
                buildForgot(context),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
