// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:scrap_real/themes/theme_provider.dart';
import 'package:scrap_real/views/main_views/search.dart';
import 'package:scrap_real/widgets/scrapbook_widgets/custom_scrapbooklarge.dart';

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
                        pushNewScreen(
                          context,
                          screen: SearchPage(),
                          withNavBar: false,
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
                scrapbooksView(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget scrapbooksView() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('scrapbooks').snapshots(),
      builder: (context, snapshots) {
        if (!snapshots.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return (snapshots.connectionState == ConnectionState.waiting)
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: snapshots.data!.docs.length,
                itemBuilder: (context, index) {
                  var data = snapshots.data!.docs[index].data()
                      as Map<String, dynamic>;

                  return Column(
                    children: [
                      CustomScrapbookLarge(
                        scrapbookId: data['scrapbookId'],
                        title: data['title'],
                      ),
                      SizedBox(height: 10),
                    ],
                  );
                },
              );
      },
    );
  }
}
