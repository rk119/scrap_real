import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:drop_shadow/drop_shadow.dart';
import 'package:scrap_real/router/route_constants.dart';
import 'package:scrap_real/views/user_profile.dart';

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
              decoration: const BoxDecoration(
                color: Color(0xffffffff),
              ),
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
                          color: const Color(0xff000000),
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
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 0, 0, 23),
                    child: TextButton(
                      onPressed: () {
                        context.pushNamed(RouteConstants.register);
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                      ),
                      child: Container(
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                          color: const Color(0xff7be5e7),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x19000000),
                              offset: Offset(0, 2),
                              blurRadius: 1,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Center(
                            child: Text(
                              'Get Started',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                height: 1.5,
                                color: const Color(0xff000000),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      context.pushNamed(RouteConstants.login);
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                    ),
                    child: Container(
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                        color: const Color(0xfff8f5f5),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x19000000),
                            offset: Offset(0, 0),
                            blurRadius: 1,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Center(
                          child: Text(
                            'I already have an account',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              height: 1.5,
                              color: const Color(0xff000000),
                            ),
                          ),
                        ),
                      ),
                    ),
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
