import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:scrap_real/views/main_views/splash.dart';
import 'package:scrap_real/views/scrapbook_views/create1.dart';
import 'package:scrap_real/views/main_views/explore.dart';
import 'package:scrap_real/views/main_views/home.dart';
import 'package:scrap_real/views/main_views/notifications.dart';
import 'package:scrap_real/views/main_views/user_profile.dart';

class NavBar extends StatefulWidget {
  const NavBar({Key? key}) : super(key: key);

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  PersistentTabController _controller =
      PersistentTabController(initialIndex: 4);

  List<Widget> _NavScreens() {
    return [
      const HomePage(),
      const Splash(),
      const CreateScrapbookPage1(),
      const NotificationsPage(),
      UserProfilePage(
        uid: FirebaseAuth.instance.currentUser!.uid,
        implyLeading: false,
      ),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(Icons.home),
        // activeColorPrimary: const Color(0xff918ef4),
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.explore),
        // activeColorPrimary: const Color(0xff918ef4),
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.add_circle_outlined),
        // activeColorPrimary: const Color(0xff918ef4),
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.notifications),
        // activeColorPrimary: const Color(0xff918ef4),
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.account_circle),
        // activeColorPrimary: const Color(0xff918ef4),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: PersistentTabView(
        context,
        controller: _controller,
        screens: _NavScreens(),
        items: _navBarsItems(),
        confineInSafeArea: true,
        backgroundColor: Color.fromARGB(239, 255, 255, 255),
        handleAndroidBackButtonPress: true,
        resizeToAvoidBottomInset: true,
        hideNavigationBarWhenKeyboardShows: true,
        decoration: NavBarDecoration(
          borderRadius: BorderRadius.circular(10.0),
        ),
        popAllScreensOnTapOfSelectedTab: true,
        navBarStyle: NavBarStyle.style9,
      ),
    );
    // return Scaffold(
    //  bottomNavigationBar: BottomNavigationBar(
    //     currentIndex: _currentIndex,
    //     onTap: navigate,
    //     type: BottomNavigationBarType.fixed,
    //     showSelectedLabels: false,
    //     showUnselectedLabels: false,
    //     selectedItemColor: const Color(0xff918ef4),
    //     iconSize: 30,
    //     items: const [
    //       BottomNavigationBarItem(
    //         icon: Icon(Icons.home),
    //         label: "Home",
    //       ),
    //       BottomNavigationBarItem(
    //         icon: Icon(Icons.explore),
    //         label: "Explore",
    //       ),
    //       BottomNavigationBarItem(
    //         icon: Icon(Icons.add_circle_outlined),
    //         label: "Create Scrapbook",
    //       ),
    //       BottomNavigationBarItem(
    //         icon: Icon(Icons.notifications),
    //         label: "Notifications",
    //       ),
    //       BottomNavigationBarItem(
    //         icon: Icon(Icons.account_circle),
    //         label: "User Profile",
    //       ),
    //     ],
    //   ),
    // );      body: _pages[_currentIndex],
  }
}
