import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scrap_real/router/route_constants.dart';
import 'package:scrap_real/router/routing.dart';
import 'package:scrap_real/views/set_profile.dart';
import 'package:scrap_real/views/send_verification.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import 'package:email_validator/email_validator.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
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
          // context.pushReplacementNamed(RouteConstants.welcome, extra: Offset(-1, 0));
          routePushReplacement(context, RouteConstants.welcome);
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
            child: TextFormField(
              controller: _username,
              keyboardType: TextInputType.emailAddress,
              style: const TextStyle(color: Colors.black87),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) => (value != null && value.length > 10)
                  ? 'Username can be max of 10 characters'
                  : null,
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
            child: TextFormField(
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              style: const TextStyle(color: Colors.black87),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (email) =>
                  email != null && !EmailValidator.validate(email)
                      ? 'Invalid email'
                      : null,
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
        onPressed: registerUser,
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

  Future registerUser() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) return;
    // showDialog(
    //   context: context,
    //   barrierDismissible: false,
    //   builder: (context) => const Center(
    //     child: CircularProgressIndicator(
    //       color: Color(0xff918ef4),
    //     ),
    //   ),
    // );

    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      CollectionReference users = firestore.collection('users');
      users.where('userName', isEqualTo: _username.text.trim()).get().then(
        (QuerySnapshot documentSnapshot) async {
          if (documentSnapshot.docs.isEmpty) {
            final userInfo = await FirebaseAuth.instance
                .createUserWithEmailAndPassword(
                    email: _email.text.trim(), password: _password.text.trim());
            // ignore: avoid_print
            print(userInfo);
            addToFirestore(_email.text.trim(), _username.text.trim());
          } else {
            showSnackBar('Username already exists');
          }
        },
      );
      MaterialPageRoute(
        builder: (context) => const SendVerificationPage(),
      );
    } catch (e) {
      // ignore: avoid_print
      print(e);
      final regex = RegExp(r'^\[(.*)\]\s(.*)$');
      final match = regex.firstMatch(e.toString());
      showSnackBar(match?.group(2));
    }
    // navigatorKey.currentState!.popUntil((route) => route.send_v);
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
                        child: TextFormField(
                          controller: _password,
                          obscureText: obscurePText,
                          style: const TextStyle(color: Colors.black87),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) =>
                              (value != null && value.length < 6)
                                  ? 'Enter a min. of 6 characters'
                                  : null,
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
                              color: const Color.fromARGB(255, 193, 193, 193),
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
                        child: TextFormField(
                          obscureText: obscureCPText,
                          style: const TextStyle(color: Colors.black87),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) =>
                              (value != null && value != _password.text)
                                  ? 'Passwords do not match'
                                  : null,
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
                              color: const Color.fromARGB(255, 193, 193, 193),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 44),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SetProfilePage()),
                      );
                    },
                    child: const Text('Set Profile'),
                  ),
                  buildRegister(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
