import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:drop_shadow/drop_shadow.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scrap_real/views/user_settings/user_settings.dart';
import 'package:scrap_real/views/utils/buttons/custom_backbutton.dart';
import 'package:scrap_real/views/utils/headers/custom_header.dart';

class InformationPage extends StatefulWidget {
  const InformationPage({Key? key}) : super(key: key);

  @override
  State<InformationPage> createState() => InformationPageState();
}

class InformationPageState extends State<InformationPage> {
  String longString =
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eius mod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eius mod tempor. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.";

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
                CustomBackButton(buttonFunction: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const UserSettingsPage()),
                  );
                }),
                CustomHeader(headerText: "Information"),
                const SizedBox(height: 30),
                const SizedBox(height: 30),
                Container(
                  width: 360,
                  height: 2400,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x19000000),
                        offset: Offset(2, 4),
                        blurRadius: 2,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      textPiece("What is ScrapReal?"),
                      textPiece("Creating a ScrapBook"),
                      textPiece("Go on an Adventure"),
                      const SizedBox(height: 90),
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
                      Text(
                        'ScrapReal',
                        style: GoogleFonts.jua(
                          fontSize: 50,
                          fontWeight: FontWeight.w400,
                          height: 1.25,
                          color: const Color(0xff918ef4),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget textPiece(String text) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 20, top: 10),
            child: Text(
              text,
              style: GoogleFonts.poppins(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
          child: Text(
            longString,
            style: GoogleFonts.poppins(fontSize: 18),
          ),
        ),
      ],
    );
  }
}
