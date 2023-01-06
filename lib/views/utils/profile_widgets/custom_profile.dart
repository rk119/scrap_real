// ignore_for_file: must_be_immutable

import 'dart:io';
import 'package:flutter/material.dart';

class CustomProfilePicture extends StatelessWidget {
  CustomProfilePicture({
    required this.image,
    required this.context,
    required this.profileFunction1,
    required this.profileFunction2,
    Key? key,
  }) : super(key: key);

  File? image;
  BuildContext context;
  void Function()? profileFunction1;
  void Function()? profileFunction2;

  @override
  Widget build(BuildContext context) {
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
                        ),
                      ],
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: const SizedBox(),
                  )
                : const SizedBox(),
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
                    child: const SizedBox(),
                  )
                : const SizedBox(),
          ],
        ),
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
                // onPressed: () {
                //   takePhoto(ImageSource.camera);
                // },
                onPressed: profileFunction1,
                child: const Icon(Icons.camera_alt_rounded),
              ),
              const Text("Camera"),
              const SizedBox(width: 30),
              TextButton(
                onPressed: profileFunction2,
                child: const Icon(Icons.image),
                // onPressed: () {
                //   takePhoto(ImageSource.gallery);
                // },
              ),
              const Text("Gallery"),
              // const SizedBox(width: 30), // remove later
            ],
          )
        ],
      ),
    );
  }
}
