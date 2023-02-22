import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:scrap_real/views/scrapbook_views/create1.dart';
import 'package:scrap_real/views/main_views/explore.dart';
import 'package:scrap_real/views/main_views/home.dart';
import 'package:scrap_real/views/main_views/notifications.dart';
import 'package:scrap_real/views/main_views/user_profile.dart';

// ignore: must_be_immutable
class NavBar extends StatefulWidget {
  int? currentIndex;
  NavBar({Key? key, this.currentIndex}) : super(key: key);

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  void navigate(int index) {
    setState(() {
      widget.currentIndex = index;
    });
  }

  final List<Widget> _pages = [
    const HomePage(),
    const ExplorePage(),
    const CreateScrapbookPage1(),
    const NotificationsPage(),
    UserProfilePage(
      uid: FirebaseAuth.instance.currentUser!.uid,
      implyLeading: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    int current = widget.currentIndex ?? 4;
    return Scaffold(
      body: _pages[current],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: current,
        onTap: navigate,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: const Color(0xff918ef4),
        iconSize: 30,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: "Explore",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outlined),
            label: "Create Scrapbook",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: "Notifications",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: "User Profile",
          ),
        ],
      ),
    );
  }
}
