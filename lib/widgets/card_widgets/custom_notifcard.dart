// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scrap_real/themes/theme_provider.dart';
import 'package:scrap_real/widgets/text_widgets/custom_text.dart';

class CustomNotifCard extends StatelessWidget {
  CustomNotifCard({
    Key? key,
    this.photoUrl,
    required this.postImageUrl,
    required this.alt,
    required this.type,
    required this.notifText,
  }) : super(key: key);

  String? photoUrl;
  String postImageUrl;
  String alt;
  String type;
  String notifText;

  @override
  Widget build(BuildContext context) {
    if (type == 'follow' || postImageUrl == '') {
      return Column(
        children: [
          Container(
            width: double.infinity,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(
                width: 1,
                color: Provider.of<ThemeProvider>(context).themeMode ==
                        ThemeMode.dark
                    ? Colors.grey.shade800
                    : Colors.white,
              ),
              borderRadius: BorderRadius.circular(15),
              color: Provider.of<ThemeProvider>(context).themeMode ==
                      ThemeMode.dark
                  ? Colors.black
                  : Colors.white,
              // boxShadow: const [
              //   BoxShadow(
              //     color: Color(0x3f000000),
              //     blurRadius: 2,
              //     offset: Offset(0, 1),
              //   )
              // ],
            ),
            child: Row(children: [
              const SizedBox(width: 20),
              photoUrl == ""
                  ? Image.asset(
                      alt,
                      width: 50,
                      height: 50,
                    )
                  : CircleAvatar(
                      backgroundColor: Colors.grey,
                      backgroundImage: NetworkImage(
                        photoUrl!,
                      ),
                      radius: 25,
                    ),
              const SizedBox(width: 15),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.65,
                child: CustomText(
                  text: notifText,
                  textSize: 15,
                  textAlignment: TextAlign.left,
                  textWeight: FontWeight.w400,
                ),
              ),
            ]),
          ),
          const SizedBox(height: 20),
        ],
      );
    } else {
      return Column(
        children: [
          Container(
            width: double.infinity,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(
                width: 1,
                color: Provider.of<ThemeProvider>(context).themeMode ==
                        ThemeMode.dark
                    ? Colors.grey.shade800
                    : Colors.white,
              ),
              borderRadius: BorderRadius.circular(15),
              color: Provider.of<ThemeProvider>(context).themeMode ==
                      ThemeMode.dark
                  ? Colors.black
                  : Colors.white,
              // boxShadow: const [
              //   BoxShadow(
              //     color: Color(0x3f000000),
              //     blurRadius: 2,
              //     offset: Offset(0, 1),
              //   )
              // ],
            ),
            child: Row(children: [
              const SizedBox(width: 20),
              photoUrl == ""
                  ? Image.asset(
                      alt,
                      width: 50,
                      height: 50,
                    )
                  : CircleAvatar(
                      backgroundColor: Colors.grey,
                      backgroundImage: NetworkImage(
                        photoUrl!,
                      ),
                      radius: 25,
                    ),
              const SizedBox(width: 15),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                child: CustomText(
                  text: notifText,
                  textSize: 15,
                  textAlignment: TextAlign.left,
                  textWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(width: 30),
              ClipRRect(
                borderRadius: BorderRadius.circular(3.0),
                child: ColorFiltered(
                  colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.20), BlendMode.darken),
                  child: Image.network(
                    postImageUrl,
                    height: 40,
                    width: 60,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ]),
          ),
          const SizedBox(height: 20),
        ],
      );
    }
  }
}
