import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scrap_real/router/route_constants.dart';
import 'package:scrap_real/router/routing.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  bool obscureText = true;

  late final TextEditingController _password;
  late final TextEditingController _email;

  @override
  void initState() {
    _password = TextEditingController();
    _email = TextEditingController();
    super.initState();
  }

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

  Widget buildBackBtn(BuildContext context) {
    return Container(
      alignment: const Alignment(-1.15, 0),
      child: TextButton(
        onPressed: () {
          // context.pushReplacementNamed(RouteConstants.welcome);
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
                  offset: Offset(1, 2),
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
          // context.pushNamed(RouteConstants.forgotPass);
          routePush(context, RouteConstants.forgotPass);
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
      child: TextButton(
        onPressed: loginUser,
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
      ),
    );
  }

  Future loginUser() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) return;

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: _email.text, password: _password.text);
      print(userCredential);
      // TODO: Navigate to user profile
    } catch (e) {
      print(e);
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
                  buildBackBtn(context),
                  textLogin(),
                  const SizedBox(height: 15),
                  textSignIn(),
                  const SizedBox(height: 137),
                  buildEmail(),
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
                          controller: _password,
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
                  const SizedBox(height: 125),
                  buildLogin(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
