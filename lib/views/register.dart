import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scrap_real/firebase_options.dart';
import 'package:scrap_real/views/welcome.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool obscurePText = true;
  bool obscureCPText = true;

  late final TextEditingController _username;
  late final TextEditingController _email;
  late final TextEditingController _password;

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    _username = TextEditingController();
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _username.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> addToFirestore(String email, String userName) async {
    CollectionReference users = firestore.collection('users');
    users.add({'email': email, 'userName': userName});
    return;
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
              controller: _username,
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
            ))
      ],
    );
  }

  Widget buildEmail() {
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
                    offset: Offset(1, 1.8),
                  )
                ]),
            height: 60,
            child: TextField(
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              style: const TextStyle(color: Colors.black87),
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(10),
                hintText: 'Enter Email',
                hintStyle: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  height: 1.5,
                  color: const Color.fromARGB(255, 193, 193, 193),
                ),
              ),
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
      child: TextButton(
        onPressed: () async {
          try {
            final userInfo = await FirebaseAuth.instance
                .createUserWithEmailAndPassword(
                    email: _email.text, password: _password.text);
            print(userInfo);
            addToFirestore(_email.text, _username.text);
          } catch (e) {
            print(e);
            _username.text = "";
            _email.text = "";
            _password.text = "";
          }
        },
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
      ),
    );
  }

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
                      textRegister(),
                      const SizedBox(height: 15),
                      textCreate(),
                      const SizedBox(height: 30),
                      buildUsername(),
                      const SizedBox(height: 28),
                      buildEmail(),
                      const SizedBox(height: 28),
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
                              controller: _password,
                              obscureText: obscurePText,
                              style: const TextStyle(color: Colors.black87),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.all(10),
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
                                hintStyle: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  height: 1.5,
                                  color:
                                      const Color.fromARGB(255, 193, 193, 193),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 28),
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
                              obscureText: obscureCPText,
                              style: const TextStyle(color: Colors.black87),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.all(10),
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
                                hintStyle: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  height: 1.5,
                                  color:
                                      const Color.fromARGB(255, 193, 193, 193),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 44),
                      buildRegister(),
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }
}
