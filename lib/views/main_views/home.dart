// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:scrap_real/themes/theme_provider.dart';
import 'package:scrap_real/views/main_views/search.dart';
import 'package:scrap_real/widgets/profile_widgets/custom_scrapbooklarge.dart';
import 'package:scrap_real/widgets/text_widgets/custom_subheader.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _value = "Home";
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
                        color: Provider.of<ThemeProvider>(context).themeMode ==
                                ThemeMode.dark
                            ? Colors.white
                            : Colors.black,
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
        CustomScrapbookLarge(text: "New Scrapbook"),
        const SizedBox(height: 20),
        CustomScrapbookLarge(text: "New Scrapbook"),
        const SizedBox(height: 20),
        CustomScrapbookLarge(text: "New Scrapbook"),
        const SizedBox(height: 20),
        CustomScrapbookLarge(text: "New Scrapbook"),
        const SizedBox(height: 20),
        CustomScrapbookLarge(text: "New Scrapbook"),
      ],
    );
  }

  Widget groupsView() {
    return Column(
      children: [
        const SizedBox(height: 20),
        CustomScrapbookLarge(text: "Group Scrapbook"),
        const SizedBox(height: 20),
        CustomScrapbookLarge(text: "Group Scrapbook"),
        const SizedBox(height: 20),
        CustomScrapbookLarge(text: "Group Scrapbook"),
        const SizedBox(height: 20),
        CustomScrapbookLarge(text: "Group Scrapbook"),
        const SizedBox(height: 20),
        CustomScrapbookLarge(text: "Group Scrapbook"),
      ],
    );
  }

  Widget challengeView() {
    return Column(
      children: [
        const SizedBox(height: 20),
        CustomScrapbookLarge(text: "Challenge Scrapbook"),
        const SizedBox(height: 20),
        CustomScrapbookLarge(text: "Challenge Scrapbook"),
        const SizedBox(height: 20),
        CustomScrapbookLarge(text: "Challenge Scrapbook"),
        const SizedBox(height: 20),
        CustomScrapbookLarge(text: "Challenge Scrapbook"),
        const SizedBox(height: 20),
        CustomScrapbookLarge(text: "Challenge Scrapbook"),
      ],
    );
  }
}
