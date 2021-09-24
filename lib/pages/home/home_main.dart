import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tritek_lms/blocs/course.bloc.dart';
import 'package:tritek_lms/blocs/user.bloc.dart';
import 'package:tritek_lms/data/entity/users.dart';
import 'package:tritek_lms/pages/home/home_component/CoursesList.dart';
import 'package:tritek_lms/pages/home/home_component/courses.home.dart';
import 'package:tritek_lms/pages/home/home_component/main_slider.dart';
import 'package:tritek_lms/pages/home/home_component/meeting.dart';
import 'package:tritek_lms/pages/home/home_component/personality_test.dart';
import 'package:tritek_lms/pages/notifications.dart';
import 'package:tritek_lms/pages/search.dart';
import 'package:tritek_lms/pages/settings/account.settings.dart';

import '../../appTheme/appTheme.dart';

class HomeMain extends StatefulWidget {
  @override
  _HomeMainState createState() => _HomeMainState();
}

class _HomeMainState extends State<HomeMain> {
  File _image;
  final userBloc = UserBloc();
  Users _user;
  @override
  void initState() {
    super.initState();
    bloc.userSubject.listen((value) {
      if (!mounted) {
        return;
      }
      setState(() {
        _user = value?.results;
      });
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

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    nestedAppBar() {
      return NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: 50,
              pinned: true,
              backgroundColor: themeBlue,
              title: _user != null
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      // crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            // Navigator.push(context,
                            //     MaterialPageRoute(builder: (context) => AccountSettings()));
                          },
                          child: Container(
                            height: 26.0,
                            width: 26.0,
                            margin: EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('assets/icon.png'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Text(
                          appName,
                          style: TextStyle(
                            fontFamily: 'Signika Negative',
                            fontWeight: FontWeight.w700,
                            fontSize: 25.0,
                            color: themeGold,
                          ),
                        ),
                      ],
                    )
                  :
                  // _user?.username
                  Row(
                      children: [
                        Text(
                          "Hi ",
                          style: TextStyle(
                            fontFamily: 'Signika Negative',
                            fontWeight: FontWeight.w700,
                            fontSize: 25.0,
                            color: Colors.white,
                          ),
                        ),
                        // itemTile( _user?.username),
                        Text(
                        ("${_user?.firstName}")
                            .toUpperCase(),
                        style: TextStyle(
                          color: themeGold,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ],
                    ),
             actions: <Widget>[
         
          IconButton(
            icon: Icon(Icons.notifications),
            color: themeGold,
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Notifications()));
            },
          ),
          IconButton(
            icon: Icon(Icons.search),
            color: themeGold,
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Search()));
            },
          ),
        ],
              automaticallyImplyLeading: false,
            ),
          ];
        },
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 2, bottom: 6.0),
                child: InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => CoursesList()));
                  },
                  child: Text(
                    "Courses",
                    style: TextStyle(
                      fontFamily: 'Signika Negative',
                      fontWeight: FontWeight.w700,
                      fontSize: 25.0,
                      color: themeBlue,
                    ),
                  ),
                ),
              ),
              MainSlider(),
              // Container(
              //     child: Column(
              //         crossAxisAlignment: CrossAxisAlignment.start,
              //         children: [
              //       Padding(
              //         padding: const EdgeInsets.only(top: 20, bottom: 6.0),
              //         child: Text(
              //           "Continue Watching",
              //           style: TextStyle(
              //             fontFamily: 'Signika Negative',
              //             fontWeight: FontWeight.w700,
              //             fontSize: 25.0,
              //             color: themeBlue,
              //           ),
              //         ),
              //       ),
                    
              //     ])),
              InkWell(
                onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UpcomingMeeting()));
                },
                child: Container(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 20, bottom: 6.0),
                        child: Text(
                          "Upcoming Meeting",
                          style: TextStyle(
                            fontFamily: 'Signika Negative',
                            fontWeight: FontWeight.w700,
                            fontSize: 25.0,
                            color: themeBlue,
                          ),
                        ),
                      ), Image.asset(
                        "assets/calender.JPG",
                        height: (height / 4),
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.cover,
                      ),
                    ])),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PersonalityTest()));
                },
                child: Container(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 20, bottom: 6.0),
                        child: Text(
                          "Personality Test",
                          style: TextStyle(
                            fontFamily: 'Signika Negative',
                            fontWeight: FontWeight.w700,
                            fontSize: 25.0,
                            color: themeBlue,
                          ),
                        ),
                      ),
                      Image.asset(
                        "assets/personality_test.JPG",
                        height: (height / 4),
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.cover,
                      ),
                    ])),
              ),
              SizedBox(height:30)
            ],
          ),
        ), //remove
      );
    }

    return Scaffold(
      backgroundColor: themeBg,
      body: nestedAppBar(),
    );
  }

  itemTile(
    title,
  ) {
    return Container(
      child: Text(
        title,
        style: TextStyle(
          fontFamily: 'Signika Negative',
          fontWeight: FontWeight.w700,
          fontSize: 25.0,
          color: themeGold,
        ),
      ),
    );
  }
}
