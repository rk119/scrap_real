import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scrap_real/welcome.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  @override
  State<LoginPage> createState() => _LoginPageState();
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
          color: Colors.black54,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 10),
      Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                    color: Colors.black26, blurRadius: 6, offset: Offset(0, 2))
              ]),
          height: 60,
          child: const TextField(
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(color: Colors.black87),
            decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(14),
                // prefixIcon: Icon(Icons.boy_outlined, color: Color(0xff5ac18e)),
                hintText: 'Enter Username',
                hintStyle: TextStyle(color: Colors.black38)),
          ))
    ],
  );
}

Widget buildPassword(bool obscureTextVal) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      const Text(
        'Password',
        style: TextStyle(
          color: Colors.black54,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 10),
      Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                    color: Colors.black26, blurRadius: 6, offset: Offset(0, 2))
              ]),
          height: 60,
          child: TextField(
            obscureText: obscureTextVal,
            style: const TextStyle(color: Colors.black87),
            decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(14),
                // suffixIcon: Icon(Icons.lock, color: Color(0xff5ac18e)),
                suffixIcon: GestureDetector(
                    onTap: () {
                      obscureTextVal = !obscureTextVal;
                      print("clicked");
                      print(obscureTextVal);
                    },
                    child: Icon(
                        obscureTextVal
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: const Color(0xffc4c4c4))),
                hintText: 'Enter Password',
                hintStyle: const TextStyle(color: Colors.black38)),
          ))
    ],
  );
}

Widget buildForgotPassword() {
  return Container(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () => print("Forgot Password pressed"),
        child: Text('Forgot Password?',
            style: GoogleFonts.poppins(
              fontSize: 17,
              color: const Color(0xff918ef4),
              fontWeight: FontWeight.w600,
            )),
      ));
}

Widget buildAltLogin() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      SizedBox(
        width: 35,
        height: 35,
        child: SvgPicture.asset(
          'assets/icons/googlelogo.svg',
        ),
      ),
      const SizedBox(width: 40),
      SizedBox(
        width: 35,
        height: 35,
        child: SvgPicture.asset(
          'assets/icons/facebooklogo.svg',
        ),
      ),
      const SizedBox(width: 40),
      SizedBox(
        width: 35,
        height: 35,
        child: SvgPicture.asset(
          'assets/icons/twitterlogo.svg',
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
        body: AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle.light,
            child: GestureDetector(
                child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 25,
                      vertical: 120,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        buildBackBtn(context),
                        textLogin(),
                        const SizedBox(height: 15),
                        textSignIn(),
                        const SizedBox(height: 50),
                        buildUsername(),
                        const SizedBox(height: 30),
                        buildPassword(obscureText),
                        buildForgotPassword(),
                        const SizedBox(height: 45),
                        buildAltLogin(),
                        const SizedBox(height: 55),
                        buildLogin(),
                      ],
                    )))));
  }
}
