import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scrap_real/welcome.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.fromLTRB(10, 30, 30, 0),
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Color(0xffffffff),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextButton(
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
            Container(
              margin: const EdgeInsets.fromLTRB(40, 0, 0, 0),
              width: 315,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(42, 0, 41, 140),
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          margin: const EdgeInsets.fromLTRB(0, 0, 0, 14),
                          child: Text(
                            'Login',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 30,
                              fontWeight: FontWeight.w600,
                              height: 1.5,
                              color: const Color(0xff918ef4),
                            ),
                          ),
                        ),
                        Text(
                          'Sign in to your account',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            height: 1.5,
                            color: Color(0xffa09f9f),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SingleChildScrollView(
                    child: Stack(
                      children: const <Widget>[
                        TextField(
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              labelText: 'Username',
                              hintText: 'Enter Your Username'),
                        ),
                      ],
                    ),
                  ),
//   decoration:  BoxDecoration (
//     borderRadius:  BorderRadius.circular(6),
//   ),
//   child:
// Column(
//   crossAxisAlignment:  CrossAxisAlignment.start,
//   children:  [
// Container(
//   // usernameZGz (2:190)
//   margin:  EdgeInsets.fromLTRB(0, 0, 0, 6),
//   width:  double.infinity,
//   child:
// Text(
//   'Username',
//   textAlign:  TextAlign.center,
//   style:  SafeGoogleFont (
//     'Poppins',
//     fontSize:  18*ffem,
//     fontWeight:  FontWeight.w500,
//     height:  1.5*ffem/fem,
//     color:  Color(0xff141b41),
//   ),
// ),
// ),
// Container(
//   // autogrouparectKG (SAQZfcd9RC3nL6aJjiAReC)
//   padding:  EdgeInsets.fromLTRB(21.5, 12, 21.5, 12),
//   width:  double.infinity,
//   decoration:  BoxDecoration (
//     color:  Color(0xfffdfbfb),
//     borderRadius:  BorderRadius.circular(6),
//     boxShadow:  [
//       BoxShadow(
//         color:  Color(0x3f000000),
//         offset:  Offset(0, 1),
//         blurRadius:  2,
//       ),
//     ],
//   ),
//   child:
// Text(
//   'Enter Username',
//   textAlign:  TextAlign.center,
//   style:  SafeGoogleFont (
//     'Poppins',
//     fontSize:  16*ffem,
//     fontWeight:  FontWeight.w500,
//     height:  1.5*ffem/fem,
//     color:  Color(0xffc4c4c4),
//   ),
// ),
// ),
//   ],
// ),
// ),
// Container(
//   // passwordgroupjan (78:333)
//   width:  double.infinity,
//   child:
// Column(
//   crossAxisAlignment:  CrossAxisAlignment.start,
//   children:  [
// Container(
//   // passwordhGi (2:192)
//   margin:  EdgeInsets.fromLTRB(0, 0, 0, 4),
//   width:  double.infinity,
//   child:
// Text(
//   'Password',
//   textAlign:  TextAlign.center,
//   style:  SafeGoogleFont (
//     'Poppins',
//     fontSize:  18*ffem,
//     fontWeight:  FontWeight.w500,
//     height:  1.5*ffem/fem,
//     color:  Color(0xff141b41),
//   ),
// ),
// ),
// Container(
//   // autogroupwh5vpcE (SAQZtC6XGUwrvSK58sWh5v)
//   margin:  EdgeInsets.fromLTRB(0, 0, 0, 7),
//   padding:  EdgeInsets.fromLTRB(22.5, 12, 17.31, 12),
//   width:  double.infinity,
//   decoration:  BoxDecoration (
//     color:  Color(0xfffdfbfb),
//     borderRadius:  BorderRadius.circular(6),
//     boxShadow:  [
//       BoxShadow(
//         color:  Color(0x3f000000),
//         offset:  Offset(0, 1),
//         blurRadius:  2,
//       ),
//     ],
//   ),
//   child:
// Row(
//   crossAxisAlignment:  CrossAxisAlignment.center,
//   children:  [
// Container(
//   // enterpasswordK3C (2:202)
//   margin:  EdgeInsets.fromLTRB(0, 0, 130.56, 0),
//   child:
// Text(
//   'Enter Password',
//   textAlign:  TextAlign.center,
//   style:  SafeGoogleFont (
//     'Poppins',
//     fontSize:  16*ffem,
//     fontWeight:  FontWeight.w500,
//     height:  1.5*ffem/fem,
//     color:  Color(0xffc4c4c4),
//   ),
// ),
// ),
// Container(
//   // akariconseyeslashedER4 (2:205)
//   width:  21.63,
//   height:  16,
//   child:
// Image.network(
//   [Image url]
//   width:  21.63,
//   height:  16,
// ),
// ),
//   ],
// ),
// ),
// TextButton(
//   // forgotpasswordxrr (2:193)
//   onPressed:  () {},
//   style:  TextButton.styleFrom (
//     padding:  EdgeInsets.zero,
//   ),
//   child:
// Container(
//   width:  double.infinity,
//   child:
// Text(
//   'Forgot Password?',
//   textAlign:  TextAlign.center,
//   style:  SafeGoogleFont (
//     'Poppins',
//     fontSize:  16*ffem,
//     fontWeight:  FontWeight.w500,
//     height:  1.5*ffem/fem,
//     color:  Color(0xffbc2c20),
//   ),
// ),
// ),
// ),
//   ],
// ),
// ),
// Container(
//   // autogroupfu1e6TG (SAQZE3XRJKBDBMNeKffu1e)
//   padding:  EdgeInsets.fromLTRB(4, 63, 4, 0),
//   width:  double.infinity,
//   child:
// Column(
//   crossAxisAlignment:  CrossAxisAlignment.center,
//   children:  [
// Container(
//   // group11437c (8:227)
//   margin:  EdgeInsets.fromLTRB(59, 0, 69.27, 62),
//   child:
// TextButton(
//   onPressed:  () {},
//   style:  TextButton.styleFrom (
//     padding:  EdgeInsets.zero,
//   ),
//   child:
// Container(
//   width:  double.infinity,
//   child:
// Row(
//   crossAxisAlignment:  CrossAxisAlignment.center,
//   children:  [
// Container(
//   // group1139wL (2:211)
//   margin:  EdgeInsets.fromLTRB(0, 0, 42.12, 0),
//   width:  31.61,
//   height:  30,
//   child:
// Image.network(
//   [Image url]
//   width:  31.61,
//   height:  30,
// ),
// ),
// Container(
//   // facebook1gRU (2:218)
//   margin:  EdgeInsets.fromLTRB(0, 0, 42, 0),
//   width:  31,
//   height:  30,
//   child:
// Image.network(
//   [Image url]
//   fit:  BoxFit.cover,
// ),
// ),
// Container(
//   // instagramDwC (2:219)
//   width:  32,
//   height:  30,
//   child:
// Image.network(
//   [Image url]
//   fit:  BoxFit.cover,
// ),
// ),
//   ],
// ),
// ),
// ),
// ),
// Container(
//   // logingroupa14 (78:467)
//   margin:  EdgeInsets.fromLTRB(0, 0, 12, 0),
//   width:  295,
//   height:  48,
//   decoration:  BoxDecoration (
//     color:  Color(0xff7be5e7),
//     borderRadius:  BorderRadius.circular(22),
//     boxShadow:  [
//       BoxShadow(
//         color:  Color(0x3f000000),
//         offset:  Offset(0, 1),
//         blurRadius:  2,
//       ),
//     ],
//   ),
//   child:
// Center(
//   child:
// Text(
//   'Login',
//   textAlign:  TextAlign.center,
//   style:  SafeGoogleFont (
//     'Poppins',
//     fontSize:  20*ffem,
//     fontWeight:  FontWeight.w600,
//     height:  1.5*ffem/fem,
//     color:  Color(0xff000000),
//   ),
// ),
// ),
// ),
//   ],
// ),
// ),
//   ],
// ),
// ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
