import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:drop_shadow/drop_shadow.dart';
import 'package:provider/provider.dart';
import 'package:scrap_real/themes/theme_provider.dart';
import 'package:scrap_real/views/login_signup/register.dart';
import 'package:scrap_real/views/main_views/user_profile.dart';
import 'package:scrap_real/views/login_signup/login.dart';
import 'package:scrap_real/widgets/buttons/custom_textbutton.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);
  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const UserProfilePage();
          } else {
            return Container(
              padding: const EdgeInsets.fromLTRB(30, 120, 30, 0),
              width: double.infinity,
              // decoration: const BoxDecoration(
              //   color: Color(0xffffffff),
              // ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  DropShadow(
                    blurRadius: 3,
                    offset: const Offset(4, 4),
                    child: SvgPicture.asset(
                      'assets/logo.svg',
                    ),
                  ),
                  DropShadow(
                    blurRadius: 2,
                    offset: const Offset(0, 2),
                    child: SvgPicture.asset(
                      'assets/pattern.svg',
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 30, 0, 30),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: GoogleFonts.jua(
                          fontSize: 30,
                          fontWeight: FontWeight.w400,
                          height: 1.25,
                          color:
                              Provider.of<ThemeProvider>(context).themeMode ==
                                      ThemeMode.dark
                                  ? Colors.white
                                  : Colors.black,
                        ),
                        children: [
                          const TextSpan(
                            text: 'Welcome to ',
                          ),
                          TextSpan(
                            text: 'ScrapReal',
                            style: GoogleFonts.jua(
                              fontSize: 30,
                              fontWeight: FontWeight.w400,
                              height: 1.25,
                              color: const Color(0xff918ef4),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(4, 0, 0, 40),
                    constraints: const BoxConstraints(
                      maxWidth: 295,
                    ),
                    child: Text(
                      'Make memories and revist them.\nAnytime. Any place.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        height: 1.5,
                        color: const Color(0xffa09f9f),
                      ),
                    ),
                  ),
                  CustomTextButton(
                    buttonBorderRadius: BorderRadius.circular(10),
                    buttonFunction: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RegisterPage()),
                      );
                    },
                    buttonText: "Get Started",
                    buttonColor: const Color(0xfff8f5f5),
                  ),
                  const SizedBox(height: 23),
                  CustomTextButton(
                    buttonBorderRadius: BorderRadius.circular(10),
                    buttonFunction: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginPage()),
                      );
                    },
                    buttonText: "I already have an account",
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
