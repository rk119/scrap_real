// ignore_for_file: must_be_immutable

import 'dart:io';
import 'package:flutter/material.dart';

class CustomProfilePicture2 extends StatelessWidget {
  CustomProfilePicture2({
    required this.context,
    required this.profileFunction1,
    required this.profileFunction2,
    this.photoUrl,
    required this.alt,
    this.path = "",
    Key? key,
  }) : super(key: key);

  BuildContext context;
  void Function()? profileFunction1;
  void Function()? profileFunction2;
  String? photoUrl;
  String alt;
  String path;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: InkWell(
        onTap: () {
          showModalBottomSheet(
            context: context,
            builder: ((builder) => buildBottomSheet()),
          );
        },
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(75.0),
              child: path != ""
                  ? Image.file(
                      File(path),
                      width: 150,
                      height: 150,
                      fit: BoxFit.cover,
                    )
                  : photoUrl != ""
                      ? CircleAvatar(
                          backgroundColor: Colors.grey,
                          backgroundImage: NetworkImage(
                            photoUrl!,
                          ),
                          radius: 75,
                        )
                      : Image.asset(
                          alt,
                          width: 150,
                          height: 150,
                        ),
            ),
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
                onPressed: profileFunction1,
                child: const Icon(Icons.camera_alt_rounded),
              ),
              const Text("Camera"),
              const SizedBox(width: 30),
              TextButton(
                onPressed: profileFunction2,
                child: const Icon(Icons.image),
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
