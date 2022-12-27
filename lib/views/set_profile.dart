import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scrap_real/views/register.dart';
import 'package:image_picker/image_picker.dart';

class SetProfilePage extends StatefulWidget {
  const SetProfilePage({Key? key}) : super(key: key);
  @override
  State<SetProfilePage> createState() => _SetProfilePageState();
}

class _SetProfilePageState extends State<SetProfilePage> {
  File? image; // image used as the user's profile
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
                buildBackBtn(),
                textProfileSetup(),
                const SizedBox(height: 28),
                buildProfile(),
                const SizedBox(height: 7),
                textEdit(),
                const SizedBox(height: 10),
                buildName(),
                const SizedBox(height: 28),
                buildBio(),
                const SizedBox(height: 44),
                buildSetProfilePageBtn(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildBackBtn() {
    return Container(
      alignment: const Alignment(-1.15, 0),
      child: TextButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const RegisterPage()),
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

  Text textProfileSetup() {
    return Text(
      'Profile Setup',
      textAlign: TextAlign.center,
      style: GoogleFonts.poppins(
        fontSize: 30,
        fontWeight: FontWeight.w600,
        height: 1.5,
        color: const Color(0xff918ef4),
      ),
    );
  }

  Widget buildProfile() {
    return Center(
      child: TextButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: ((builder) => buildBottomSheet()),
          );
        },
        child: Stack(
          children: [
            // back shadow
            image != null
                ? Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 5,
                        color: const Color.fromARGB(255, 241, 241, 241),
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x3f000000),
                          blurRadius: 2,
                          offset: Offset(1, 2),
                        )
                      ],
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: SizedBox(),
                  )
                : SizedBox(),
            // profile image
            ClipRRect(
              borderRadius: BorderRadius.circular(75.0), // add border radius
              child: image != null
                  ? Image.file(
                      image!,
                      width: 150,
                      height: 150,
                    )
                  : Image.asset(
                      "assets/images/profile.png",
                      width: 150,
                      height: 150,
                    ),
            ),
            // white profile border
            image != null
                ? Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 5,
                        color: const Color.fromARGB(255, 241, 241, 241),
                      ),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: SizedBox(),
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }

  Text textEdit() {
    return Text(
      'Edit',
      textAlign: TextAlign.center,
      style: GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.w500,
        height: 1.5,
        color: const Color(0xffa09f9f),
      ),
    );
  }

  Widget buildBottomSheet() {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: <Widget>[
          const Text(
            "Choose Profile Photo",
            style: TextStyle(fontSize: 20.0),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextButton(
                child: const Icon(Icons.camera_alt_rounded),
                onPressed: () {
                  takePhoto(ImageSource.camera);
                },
              ),
              const Text("Camera"),
              const SizedBox(width: 30),
              TextButton(
                child: const Icon(Icons.image),
                onPressed: () {
                  takePhoto(ImageSource.gallery);
                },
              ),
              const Text("Gallery"),
              // const SizedBox(width: 30), // remove later
            ],
          )
        ],
      ),
    );
  }

  Future takePhoto(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;
      final imageTmp = File(image.path);
      setState(() => this.image = imageTmp);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Widget buildName() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Name',
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
            keyboardType: TextInputType.emailAddress,
            style: const TextStyle(color: Colors.black87),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(10),
              hintText: 'Enter Name',
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
    );
  }

  Widget buildBio() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Bio',
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
          alignment: Alignment.topLeft,
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
          height: 208,
          child: Wrap(
            children: [
              TextField(
                maxLength: 150,
                maxLines: 8,
                keyboardType: TextInputType.name,
                style: const TextStyle(color: Colors.black87),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(10),
                  hintText: 'Enter your bio',
                  hintStyle: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    height: 1.5,
                    color: const Color.fromARGB(255, 193, 193, 193),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildSetProfilePageBtn() {
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SetProfilePage()),
        );
      },
      child: Container(
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
            'Set Profile',
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
}
