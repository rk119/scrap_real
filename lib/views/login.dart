import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scrap_real/router/route_constants.dart';
import 'package:scrap_real/views/welcome.dart';
import 'package:scrap_real/views/forgot_pass.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool obscureText = true;

  late final TextEditingController _username;
  late final TextEditingController _password;

  @override
  void initState() {
    _username = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _username.dispose();
    _password.dispose();
    super.dispose();
  }

  Widget buildBackBtn(BuildContext context) {
    return Container(
      alignment: const Alignment(-1.15, 0),
      child: TextButton(
        onPressed: () {
          context.pushReplacementNamed(RouteConstants.welcome);
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
        color: const Color(0xffa09f9f),
      ),
    );
  }

  Widget buildUsername() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Username',
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
              hintText: 'Enter Username',
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

  Widget buildForgotPassword(BuildContext context) {
    return Container(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {
          context.pushNamed(RouteConstants.forgotPass);
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
                textLogin(),
                const SizedBox(height: 15),
                textSignIn(),
                const SizedBox(height: 137),
                buildUsername(),
                const SizedBox(height: 30),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Password',
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
                            offset: Offset(1, 1.8),
                          )
                        ],
                      ),
                      height: 60,
                      child: TextField(
                        obscureText: obscureText,
                        style: const TextStyle(color: Colors.black87),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.all(10),
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
                          hintStyle: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            height: 1.5,
                            color: const Color.fromARGB(255, 193, 193, 193),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                buildForgotPassword(context),
                const SizedBox(height: 136),
                buildLogin(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
