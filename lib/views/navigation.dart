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
        activeColorPrimary: const Color(0xff918ef4),
        inactiveColorPrimary: Colors.grey,
        iconSize: 29,
        contentPadding: 0,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.explore),
        activeColorPrimary: const Color(0xff918ef4),
        inactiveColorPrimary: Colors.grey,
        iconSize: 29,
        contentPadding: 0,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.add_circle_outlined),
        activeColorPrimary: const Color(0xff918ef4),
        inactiveColorPrimary: Colors.grey,
        iconSize: 29,
        contentPadding: 0,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.notifications),
        activeColorPrimary: const Color(0xff918ef4),
        inactiveColorPrimary: Colors.grey,
        iconSize: 29,
        contentPadding: 0,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.account_circle),
        activeColorPrimary: const Color(0xff918ef4),
        inactiveColorPrimary: Colors.grey,
        iconSize: 29,
        contentPadding: 0,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: PersistentTabView(
        context,
        controller: _controller,
        margin: const EdgeInsets.all(0),
        bottomScreenMargin: 55,
        screens: _NavScreens(),
        items: _navBarsItems(),
        confineInSafeArea: true,
        backgroundColor: Color.fromARGB(235, 249, 249, 249),
        handleAndroidBackButtonPress: true,
        resizeToAvoidBottomInset: true,
        hideNavigationBarWhenKeyboardShows: true,
        decoration: const NavBarDecoration(boxShadow: [
          BoxShadow(
            color: Color(0x3f000000),
            blurRadius: 2,
            offset: Offset(5, 5),
            blurStyle: BlurStyle.solid,
          )
        ]),
        popAllScreensOnTapOfSelectedTab: true,
        navBarStyle: NavBarStyle.style3,
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
