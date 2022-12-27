import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../firebase_options.dart';
import 'package:scrap_real/views/forgot_pass.dart';

class SetNewPassPage extends StatefulWidget {
  const SetNewPassPage({Key? key}) : super(key: key);
  @override
  State<SetNewPassPage> createState() => _SetNewPassPageState();
}

Widget buildBackBtn(BuildContext context) {
  return Container(
    alignment: const Alignment(-1.15, 0),
    child: TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ForgotPassPage()),
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

Text textSetNew() {
  return Text(
    'Set New Password',
    textAlign: TextAlign.center,
    style: GoogleFonts.poppins(
      fontSize: 30,
      fontWeight: FontWeight.w600,
      height: 1.5,
      color: const Color(0xff918ef4),
    ),
  );
}

Text textSetNewPass() {
  return Text(
    'Update your account password',
    textAlign: TextAlign.center,
    style: GoogleFonts.poppins(
      fontSize: 20,
      fontWeight: FontWeight.w500,
      height: 1.5,
      color: const Color(0xffa09f9f),
    ),
  );
}

Widget buildUpdate() {
  return TextButton(
    onPressed: () {},
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
          'Update Password',
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

class _SetNewPassPageState extends State<SetNewPassPage> {
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
                    textSetNew(),
                    const SizedBox(height: 15),
                    textSetNewPass(),
                    const SizedBox(height: 137),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'New Password',
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
                              hintText: 'Enter your New Password',
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
                    const SizedBox(height: 30),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Confirm Password',
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
                              hintText: 'Conform New Password',
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
                    const SizedBox(height: 182),
                    buildUpdate(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
