// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:scrap_real/widgets/text_widgets/custom_text.dart';

class CustomSelectionTab3 extends StatelessWidget {
  CustomSelectionTab3({
    Key? key,
    required this.selection,
    required this.selection1,
    required this.selecion2,
    required this.func1,
    required this.func2,
  }) : super(key: key);

  bool selection;
  String selection1;
  String selecion2;
  void Function()? func1;
  void Function()? func2;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 360,
      height: 38,
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  bottomLeft: Radius.circular(30),
                ),
                color: selection ? const Color(0xffbdbbfa) : null,
                border: Border.all(
                  width: 1,
                  color: const Color(0xffbdbbfa),
                ),
              ),
              child: SizedBox(
                width: 130,
                child: TextButton(
                  onPressed: func1,
                  child: CustomText(
                    text: selection1,
                    textSize: 15.29,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
                color: !selection ? const Color(0xffbdbbfa) : null,
                border: Border.all(
                  width: 1,
                  color: const Color(0xffbdbbfa),
                ),
              ),
              child: SizedBox(
                width: 130,
                child: TextButton(
                  onPressed: func2,
                  child: CustomText(
                    text: selecion2,
                    textSize: 15.29,
                  ),
                ),
              ),
            ),
          ),

          // const SizedBox(width: 50),
        ],
      ),
    );
  }
}
