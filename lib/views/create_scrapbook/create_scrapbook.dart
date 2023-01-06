// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:scrap_real/views/create_scrapbook/create1.dart';

class CreateScrapbookPage extends StatefulWidget {
  const CreateScrapbookPage({Key? key}) : super(key: key);

  @override
  State<CreateScrapbookPage> createState() => _CreateScrapbookPageState();
}

class _CreateScrapbookPageState extends State<CreateScrapbookPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Create Scrapbook",
              style: TextStyle(fontSize: 28),
            ),
            SizedBox(height: 20),
            Text(
              "some information about scrapbooks, challenges, etc",
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CreateScrapbookPage1()),
                );
              },
              child: Icon(
                Icons.add,
                size: 35,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
