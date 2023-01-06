// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomBackButton extends StatelessWidget {
  CustomBackButton({
    required this.buttonFunction,
    Key? key,
  }) : super(key: key);

  void Function()? buttonFunction;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: const Alignment(-1.15, 0),
      child: TextButton(
        onPressed: buttonFunction,
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
}
