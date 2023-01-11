// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scrap_real/views/navigation.dart';
import 'package:scrap_real/widgets/buttons/custom_backbutton.dart';
import 'package:scrap_real/widgets/cards/custom_usercard.dart';
import 'package:scrap_real/widgets/profile_widgets/custom_scrapbooklarge.dart';
import 'package:scrap_real/widgets/text_widgets/custom_subheader.dart';
import 'package:scrap_real/widgets/selection_widgets/custom_selectiontab3.dart';
import 'package:scrap_real/widgets/text_fields/custom_searchfield.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  bool users = true;
  final TextEditingController _searchQuery = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _searchQuery.dispose();
  }

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
                CustomBackButton(buttonFunction: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const NavBar()),
                  );
                }),
                SizedBox(height: 20),
                CustomSearchField(
                    textController: _searchQuery,
                    validatorFunction: (query) =>
                        (query != null && query.length < 6)
                            ? 'Enter a min. of 6 characters'
                            : null,
                    hintingText: "Search"),
                SizedBox(height: 20),
                CustomSelectionTab3(
                  selection: users,
                  selection1: "Users",
                  selecion2: "Scrapbooks",
                  func1: () {
                    if (users == false) {
                      setState(() {
                        users = true;
                      });
                    }
                  },
                  func2: () {
                    if (users == true) {
                      setState(() {
                        users = false;
                      });
                    }
                  },
                ),
                users ? usersView() : scrapbooksView(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget usersView() {
    return Column(
      children: [
        const SizedBox(height: 20),
        CustomUserCard(username: "@queen_zuella"),
        const SizedBox(height: 20),
        CustomUserCard(username: "@quail_birb"),
        const SizedBox(height: 20),
        CustomUserCard(username: "@qumanny"),
        const SizedBox(height: 20),
        CustomUserCard(username: "@sumant_bravo"),
        const SizedBox(height: 20),
        CustomUserCard(username: "@fat_fries"),
        const SizedBox(height: 20),
        CustomUserCard(username: "@catboy_nidal"),
        const SizedBox(height: 20),
        CustomUserCard(username: "@bdm.or"),
        const SizedBox(height: 20),
        CustomUserCard(username: "@oops_ezzah"),
      ],
    );
  }

  Widget scrapbooksView() {
    return Column(
      children: [
        const SizedBox(height: 20),
        CustomScrapbookLarge(text: "Scrapbook"),
        const SizedBox(height: 20),
        CustomScrapbookLarge(text: "Scrapbook"),
        const SizedBox(height: 20),
        CustomScrapbookLarge(text: "Scrapbook"),
        const SizedBox(height: 20),
        CustomScrapbookLarge(text: "Scrapbook"),
        const SizedBox(height: 20),
        CustomScrapbookLarge(text: "Scrapbook"),
      ],
    );
  }
}
