import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tritek_lms/custom/bubble_bottom_bar.dart';
import 'package:tritek_lms/pages/forum/forum_main.dart';
import 'package:tritek_lms/pages/home/home_component/CoursesList.dart';
import 'package:tritek_lms/pages/home/home_main.dart';
import 'package:tritek_lms/pages/my_course.dart';
import 'package:tritek_lms/pages/search.dart';
import 'package:tritek_lms/pages/settings/more.dart';
import 'package:tritek_lms/pages/settings/progress.settings.dart';
import 'package:tritek_lms/pages/settings/settings.dart';
import 'package:tritek_lms/pages/wishlist.dart';

import '../../appTheme/appTheme.dart';
import '../my_course.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentIndex;
  DateTime currentBackPressTime;
  @override
  void initState() {
    super.initState();
    currentIndex = 0;
  }

  void changePage(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        onTap: changePage, // new
        currentIndex: currentIndex,
        showUnselectedLabels: true,

        selectedItemColor: themeGold,
        unselectedItemColor: Colors.white,
        items: [
          BottomNavigationBarItem(
            backgroundColor: themeBlue,
            icon: Icon(
              Icons.home,
              color: Colors.white,
            ),
            activeIcon: Icon(
              Icons.home,
              color: themeGold,
            ),
            title: Text(
              'Home',
              style: TextStyle(fontSize: 10.0),
            ),
          ),
          BottomNavigationBarItem(
            backgroundColor: themeBlue,
            icon: Icon(
              Icons.dashboard_outlined,
              color: Colors.white,
            ),
            activeIcon: Icon(
              Icons.dashboard_outlined,
              color: themeGold,
            ),
            title: Text(
              'Dashboard',
              style: TextStyle(fontSize: 10.0),
            ),
          ),
          BottomNavigationBarItem(
              backgroundColor: themeBlue,
              icon: Icon(
                Icons.favorite,
                color: Colors.white,
              ),
              activeIcon: Icon(
                Icons.favorite,
                color: themeGold,
              ),
              title: Text(
                'Favourite',
                style: TextStyle(fontSize: 10.0),
              )),
          BottomNavigationBarItem(
            backgroundColor: themeBlue,
            icon: Icon(
              Icons.forum_rounded,
              color: Colors.white,
            ),
            activeIcon: Icon(
              Icons.forum_rounded,
              color: themeGold,
            ),
            title: Text(
              'Forum',
              style: TextStyle(fontSize: 10.0),
            ),
          ),
          BottomNavigationBarItem(
              backgroundColor: themeBlue,

              // color: themeGold,
              icon: Icon(
                Icons.menu,
                color: Colors.white,
              ),
              activeIcon: Icon(
                Icons.menu,
                color: themeGold,
              ),
              title: Text(
                'More',
                style: TextStyle(fontSize: 10.0),
              ))
        ],
      ),
      body: WillPopScope(
        child: (currentIndex == 0)
            ? HomeMain()
            : (currentIndex == 1)
                ? Progress()
                : (currentIndex == 2)
                    ? Wishlist()
                    : (currentIndex == 3)
                        ? ForumHome()
                        : More(),
        onWillPop: onWillPop,
      ),
    );
  }

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(
        msg: 'Press Back Once Again to Exit.',
        backgroundColor: Colors.black,
        textColor: Theme.of(context).appBarTheme.color,
      );
      return Future.value(false);
    }
    exit(0);
    return Future.value(true);
  }
}
