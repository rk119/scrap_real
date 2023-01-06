// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scrap_real/views/main_views/search.dart';
import 'package:scrap_real/views/utils/headers/custom_subheader.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _value = "Home";
  // final List<DropdownMenuItem> _items = [
  //   DropdownMenuItem(
  //     value: "Home",
  //     child: Text("Home"),
  //   ),
  //   DropdownMenuItem(
  //     value: "Groups",
  //     child: Text("Groups"),
  //   ),
  //   DropdownMenuItem(
  //     value: "Nearby Challenges",
  //     child: Text("Nearby Challenges"),
  //   ),
  // ];

  final List<DropdownMenuItem> _items = [
    DropdownMenuItem(
      value: "Home",
      child: Text("Home"),
    ),
    DropdownMenuItem(
      value: "Groups",
      child: Text("Groups"),
    ),
    DropdownMenuItem(
      value: "Nearby Challenges",
      child: Text("Nearby Challenges"),
    ),
  ];

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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: DropdownButton<dynamic>(
                        onChanged: (value) => setState(() {
                          _value = value;
                        }),
                        value: _value,
                        isExpanded: true,
                        items: _items,
                      ),
                    ),
                    SizedBox(width: 10),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SearchPage()),
                        );
                      },
                      child: Icon(
                        Icons.search,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                _value == "Home"
                    ? homeView()
                    : _value == "Groups"
                        ? groupsView()
                        : challengeView(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget homeView() {
    return Column(
      children: [
        const SizedBox(height: 20),
        scrapbookLargeSize("New Scrapbook"),
        const SizedBox(height: 20),
        scrapbookLargeSize("New Scrapbook"),
        const SizedBox(height: 20),
        scrapbookLargeSize("New Scrapbook"),
        const SizedBox(height: 20),
        scrapbookLargeSize("New Scrapbook"),
        const SizedBox(height: 20),
        scrapbookLargeSize("New Scrapbook"),
      ],
    );
  }

  Widget groupsView() {
    return Column(
      children: [
        const SizedBox(height: 20),
        scrapbookLargeSize("Group Scrapbook"),
        const SizedBox(height: 20),
        scrapbookLargeSize("Group Scrapbook"),
        const SizedBox(height: 20),
        scrapbookLargeSize("Group Scrapbook"),
        const SizedBox(height: 20),
        scrapbookLargeSize("Group Scrapbook"),
        const SizedBox(height: 20),
        scrapbookLargeSize("Group Scrapbook"),
      ],
    );
  }

  Widget challengeView() {
    return Column(
      children: [
        const SizedBox(height: 20),
        scrapbookLargeSize("Challenge Scrapbook"),
        const SizedBox(height: 20),
        scrapbookLargeSize("Challenge Scrapbook"),
        const SizedBox(height: 20),
        scrapbookLargeSize("Challenge Scrapbook"),
        const SizedBox(height: 20),
        scrapbookLargeSize("Challenge Scrapbook"),
        const SizedBox(height: 20),
        scrapbookLargeSize("Challenge Scrapbook"),
      ],
    );
  }

  Widget scrapbookLargeSize(String text) {
    return Container(
      width: 350,
      height: 205,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 43, 43, 43),
        border: Border.all(
          width: 5,
          color: Color.fromARGB(255, 69, 69, 69),
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(children: [
        const SizedBox(height: 40),
        SizedBox(
          height: 100,
          child: Center(
            child: CustomSubheader(
              headerText: text, // max 22 char
              headerColor: Colors.white,
              headerSize: 23,
            ),
          ),
        ),
        Container(
          height: 40,
        ),
      ]),
    );
  }
}
