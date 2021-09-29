import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tritek_lms/appTheme/appTheme.dart';
import 'package:tritek_lms/blocs/course.bloc.dart';
import 'package:tritek_lms/blocs/user.bloc.dart';
import 'package:tritek_lms/data/entity/courses.dart';
import 'package:tritek_lms/data/entity/users.dart';
import 'package:tritek_lms/pages/login_signup/login.dart';
import 'package:tritek_lms/pages/notifications.dart';
import 'package:tritek_lms/pages/search.dart';
import 'package:tritek_lms/pages/welcome.dart';

class Progress extends StatefulWidget {
  @override
  _ProgressState createState() => _ProgressState();
}

class _ProgressState extends State<Progress> {
  File _image;
  Users _user;
  UserLevel _level;
  List<Course> courses;
  bool routed = false;

  final userBloc = UserBloc();

  @override
  void initState() {
    super.initState();
    userBloc.userSubject.listen((value) {
      if (!mounted) {
        return;
      }

      if (value != null && value.results != null) {
        userBloc.getUserLevel(value.results.id);
        bloc.getMyCourses(value.results.id);
      }

      setState(() {
        _user = value.results;
      });
    });

    userBloc.userLevel.listen((value) {
      if (!mounted) {
        return;
      }
      print('UserLevel: ${value.data}');
      setState(() {
        _level = value.data;
      });
    });

    bloc.myCourses.listen((value) {
      if (!mounted) {
        return;
      }
      setState(() {
        courses = value.results;
      });
    });

    userBloc.userStatus.listen((value) {
      if (!mounted) {
        return;
      }
      if (value == false && !routed) {
        logout();
        routed = true;
        return;
      }
    });

    userBloc.image.listen((value) {
      if (!mounted) {
        return;
      }

      setState(() {
        _image = value;
      });
    });

    userBloc.getUser();
    userBloc.getImage();
  }

  @override
  void dispose() {
    userBloc.dispose();
    super.dispose();
  }

  itemSummary(String item, String value, _width) {
    return Container(
      width: (_width - 80) / 3,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AutoSizeText(
              item,
              maxLines: 2,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.bold,
                color: themeBlue,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
                color: themeGold,
              ),
            ),
          ]),
    );
  }

  itemTile(width, icon, title, subtitle) {
    return Container(
      width: width,
      padding: EdgeInsets.fromLTRB(30.0, 5, 30, 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, size: 28.0, color: themeGold),
          SizedBox(width: 12.0),
          Text(
            title + ': ',
            style: TextStyle(
              fontSize: 17.0,
              fontWeight: FontWeight.bold,
              color: themeBlue,
            ),
          ),
          SizedBox(width: 12.0),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 15.0,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  divider() {
    return Container(
      width: double.infinity,
      height: 1.0,
      color: Colors.grey[300],
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        automaticallyImplyLeading: false,
        backgroundColor: themeBlue,
        title: Row(
          children: [
            Container(
                      height: 26.0,
                      width: 26.0,
                      margin: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/logo.png",),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(height:5),
            Text(
              "Dashboard",
              style: TextStyle(
                fontFamily: 'Signika Negative',
                fontWeight: FontWeight.w700,
                fontSize: 25.0,
                color: themeGold,
              ),
            ),
          ],
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            iconSize: 30,
            color: themeGold,
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Search()));
            },
          ),
          IconButton(
            icon: Icon(Icons.notifications),
            iconSize: 30,
            color: themeGold,
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Notifications()));
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          Container(
            width: double.infinity,
            height: 340.0,
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 250.0,
                  // color: themeBlue,
                ),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(top: 40.0),
                  child: Row(
                     mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Column(
                      //   mainAxisAlignment: MainAxisAlignment.start,
                      //   crossAxisAlignment: CrossAxisAlignment.center,
                      //   children: [
                      //     Center(
                      //       child: GestureDetector(
                      //         onTap: () {},
                      //         child: CircleAvatar(
                      //           radius: 30,
                      //           backgroundColor: themeGold,
                      //           child: Text(
                      //             _level != null
                      //                 ? _level.points + ' Points'
                      //                 : '.. Points',
                      //             style: TextStyle(
                      //               fontSize: 17.0,
                      //               color: Color(0xFF838DAF),
                      //             ),
                      //           ),
                      //         ),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Center(
                            child: GestureDetector(
                              onTap: () {},
                              child: CircleAvatar(
                                radius: 55,
                                // backgroundColor: themeGold,
                                child: _image != null
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(50),
                                        child: Image.file(
                                          _image,
                                          width: 100,
                                          height: 100,
                                          fit: BoxFit.fitHeight,
                                        ),
                                      )
                                    : Container(
                                        decoration: BoxDecoration(
                                            color: Colors.grey[200],
                                            borderRadius:
                                                BorderRadius.circular(50)),
                                        width: 100,
                                        height: 100,
                                        child: Icon(
                                          Icons.camera_alt,
                                          color: Colors.grey[800],
                                        ),
                                      ),
                              ),
                            ),
                          ),
                          SizedBox(height: 10.0),
                          Text(
                            ("${_user?.firstName} ${_user?.lastName}")
                                .toUpperCase(),
                            style: TextStyle(
                              color: themeGold,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      // Column(
                      //    mainAxisAlignment: MainAxisAlignment.start,
                      //   crossAxisAlignment: CrossAxisAlignment.center,
                      //   children: [
                      //     Center(
                      //       child: GestureDetector(
                      //         onTap: () {},
                      //         child: CircleAvatar(
                      //           radius: 30,
                      //           backgroundColor: themeGold,
                      //           child: Center(
                      //             child: Text(
                      //               _level != null
                      //                   ? _level.points + ' Points'
                      //                   : '.. Points',
                      //               style: TextStyle(
                      //                 fontSize: 17.0,
                      //                 color: Color(0xFF838DAF),
                      //               ),
                      //             ),
                      //           ),
                      //         ),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                    ],
                  ),
                ),
                if (_user != null)
                  Positioned(
                    bottom: 3.0,
                    left: 0.0,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: Material(
                        elevation: 3.0,
                        borderRadius: BorderRadius.circular(10.0),
                        child: Container(
                          height: 120.0,
                          padding: EdgeInsets.all(20.0),
                          width: MediaQuery.of(context).size.width - 40.0,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.white,
                          ),
                          child: courses != null
                              ? Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    itemSummary('Registered Courses',
                                        courses.length.toString(), width),
                                    itemSummary('Completed Lessons',
                                        getCompletedLessons(courses), width),
                                    itemSummary('Completed Quiz',
                                        getCompletedQuize(courses), width),
                                  ],
                                )
                              : Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    itemSummary(
                                        'Registered Courses', '..', width),
                                    itemSummary(
                                        'Completed Lessons', '..', width),
                                    itemSummary('Completed Quiz', '..', width),
                                  ],
                                ),
                        ),
                      ),
                    ),
                  ),
                if (_user == null)
                  Positioned(
                    bottom: 3.0,
                    left: 0.0,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: Material(
                        elevation: 3.0,
                        borderRadius: BorderRadius.circular(10.0),
                        child: Container(
                          height: 100.0,
                          padding: EdgeInsets.all(20.0),
                          width: MediaQuery.of(context).size.width - 40.0,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.white,
                          ),
                          child: Text(
                            'You are yet to login',
                            style: TextStyle(
                              fontSize: 28.0,
                              fontWeight: FontWeight.bold,
                              color: themeBlue,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(height: 10),
          divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: (width - 1.0) / 2.0,
                height: 100.0,
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.star,
                      size: 40.0,
                      color: themeGold,
                    ),
                    SizedBox(height: 7.0),
                    Text(
                      _level != null ? _level.points + ' Points' : '.. Points',
                      style: TextStyle(
                        fontSize: 17.0,
                        color: Color(0xFF838DAF),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 1.0,
                height: 100.0,
                color: Colors.grey[300],
              ),
              Container(
                width: (width - 1.0) / 2.0,
                height: 100.0,
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (_level != null && _level.badge != null)
                      Container(
                        height: 30.0,
                        width: 30.0,
                        margin: EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(_level.badge),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    if (_level == null)
                      Container(
                        height: 30.0,
                        width: 30.0,
                        margin: EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/icon.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    SizedBox(height: 7.0),
                    Text(
                      _level != null
                          ? _level.level != "0"
                              ? 'Level ' + _level.level
                              : 'Level 1'
                          : 'Level ..',
                      style: TextStyle(
                        fontSize: 17.0,
                        color: Color(0xFF838DAF),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          divider(),
          SizedBox(
            height: 15,
          ),
          if (_user == null)
            Container(
              width: double.infinity,
              alignment: Alignment.center,
              child: InkWell(
                onTap: () {
                  logout();
                },
                borderRadius: BorderRadius.circular(30.0),
                child: Material(
                  elevation: 1.0,
                  borderRadius: BorderRadius.circular(30.0),
                  child: Container(
                    padding: EdgeInsets.fromLTRB(40.0, 15.0, 40.0, 15.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.0),
                      color: themeGold,
                    ),
                    child: Text(
                      'Login'.toUpperCase(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          SizedBox(height: 10),
          if (_level != null)
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                'Points Summary',
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: themeBlue,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Signika Negative',
                  letterSpacing: 0.7,
                ),
              ),
            ),
          if (_level != null)
            itemTile(width, Icons.star_border, 'New Point', _level.newPoint),
          if (_level != null)
            itemTile(width, Icons.stars_rounded, 'Total Points Awarded',
                _level.award),
          if (_level != null)
            itemTile(
                width, Icons.email, 'Total Points Deducted', _level.deducted),
        ],
      ),
    );
  }

  profileTile(icon, title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: Color(0xFF0BC9E3),
            size: 28.0,
          ),
          SizedBox(width: 10.0),
          Text(
            title,
            style: TextStyle(
              color: Colors.black,
              fontSize: 16.0,
            ),
          )
        ],
      ),
    );
  }

  void logout() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => WelcomeSreen()));
  }

  String getDate(Users user) {
    DateTime tempDate =
        new DateFormat("yyyy-MM-dd hh:mm:ss").parse(user.endDate);
    return DateFormat("MMMM dd, yyyy").format(tempDate);
  }

  bool dateDiff(Users user) {
    DateTime tempDate =
        new DateFormat("yyyy-MM-dd hh:mm:ss").parse(user.endDate);
    DateTime n = DateTime.now();
    return tempDate.difference(n).inDays > 40;
  }

  String getCompletedLessons(List<Course> courses) {
    int com = 0;
    for (Course course in courses) {
      for (Sections sec in course.sections) {
        for (Lessons les in sec.lessons) {
          if (les.viewed && les.quizCount == null) {
            com = com + 1;
          }
        }
      }
    }
    return com.toString();
  }

  String getCompletedQuize(List<Course> courses) {
    int com = 0;
    for (Course course in courses) {
      for (Sections sec in course.sections) {
        for (Lessons les in sec.lessons) {
          if (les.viewed && les.quizCount != null) {
            com = com + 1;
          }
        }
      }
    }
    return com.toString();
  }
}
