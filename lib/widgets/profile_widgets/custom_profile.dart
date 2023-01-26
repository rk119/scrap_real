// ignore_for_file: must_be_immutable

import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class CustomProfilePicture extends StatelessWidget {
  CustomProfilePicture({
    required this.context,
    required this.onTapFunc,
    this.photoUrl,
    required this.alt,
    this.pickedFile,
    Key? key,
  }) : super(key: key);

  BuildContext context;
  Future<dynamic> Function() onTapFunc;
  String? photoUrl;
  String alt;
  PlatformFile? pickedFile;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTapFunc,
      child: Stack(children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(75.0),
          child: pickedFile != null
              ? Image.file(
                  File(pickedFile!.path!),
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
      ]),
    );
  }
}
