import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scrap_real/welcome.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

Widget buildBackBtn(BuildContext context) {
  return Container(
    alignment: Alignment.centerLeft,
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

Text textRegister() {
  return Text(
    'Register',
    textAlign: TextAlign.center,
    style: GoogleFonts.poppins(
      fontSize: 30,
      fontWeight: FontWeight.w600,
      height: 1.5,
      color: const Color(0xff918ef4),
    ),
  );
}

Text textCreate() {
  return Text(
    'Create a new account',
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
          ))
    ],
  );
}

Widget buildEmail() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      const Text(
        'Email',
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
                hintText: 'Enter Email',
                hintStyle: TextStyle(color: Colors.black38)),
          ))
    ],
  );
}

Widget buildRegister() {
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
        'Register',
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

class _RegisterPageState extends State<RegisterPage> {
  bool obscurePText = true;
  bool obscureCPText = true;
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
              vertical: 25,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                buildBackBtn(context),
                textRegister(),
                const SizedBox(height: 15),
                textCreate(),
                const SizedBox(height: 50),
                buildUsername(),
                const SizedBox(height: 30),
                buildEmail(),
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
                        obscureText: obscurePText,
                        style: const TextStyle(color: Colors.black87),
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.all(14),
                            suffixIcon: GestureDetector(
                              onTap: () {
                                setState(
                                  () {
                                    obscurePText = !obscurePText;
                                  },
                                );
                              },
                              child: Icon(
                                obscurePText
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: const Color(0xffc4c4c4),
                              ),
                            ),
                            hintText: 'Enter Password',
                            hintStyle: const TextStyle(color: Colors.black38)),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 30),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      'Confirm Password',
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
                        obscureText: obscureCPText,
                        style: const TextStyle(color: Colors.black87),
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.all(14),
                            suffixIcon: GestureDetector(
                              onTap: () {
                                setState(
                                  () {
                                    obscureCPText = !obscureCPText;
                                  },
                                );
                              },
                              child: Icon(
                                obscureCPText
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: const Color(0xffc4c4c4),
                              ),
                            ),
                            hintText: 'Retype Password',
                            hintStyle: const TextStyle(color: Colors.black38)),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 60),
                buildRegister(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
