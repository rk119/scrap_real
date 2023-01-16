// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:scrap_real/views/scrapbook_views/expanded_image.dart';

class CustomScrapbookImage extends StatelessWidget {
  const CustomScrapbookImage({
    Key? key,
    required this.postId,
  }) : super(key: key);

  final String postId;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.grey.shade300,
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ExpandedImagePage(postId: postId),
            ),
          );
        },
      ),
    );
  }
}
