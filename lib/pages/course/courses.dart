import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:tritek_lms/appTheme/appTheme.dart';
import 'package:tritek_lms/blocs/course.bloc.dart';
import 'package:tritek_lms/blocs/user.bloc.dart';
import 'package:tritek_lms/data/entity/courses.dart';
import 'package:tritek_lms/data/entity/users.dart';
import 'package:tritek_lms/pages/course/lesson.view.dart';
import 'package:tritek_lms/pages/course/lessons.dart';
import 'package:tritek_lms/pages/course/overview.dart';
import 'package:tritek_lms/pages/login_signup/login.dart';
import 'package:tritek_lms/pages/notifications.dart';
import 'package:tritek_lms/pages/payment/select_plan.dart';
import 'package:tritek_lms/pages/reviews/reviews.dart';
import 'package:tritek_lms/pages/search.dart';

class CoursesNew extends StatefulWidget {
  final Course courseData;
  final int lang;

  CoursesNew({Key key, @required this.courseData, this.lang}) : super(key: key);
  @override
  _CoursesNewState createState() => _CoursesNewState();
}

class _CoursesNewState extends State<CoursesNew> {
  bool wishlist;
  bool subscribed = false;
  bool preview = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  Users _user;
  Course _course;
  String token;
  @override
  void initState() {
    super.initState();
    _course = widget.courseData;
    bloc.userSubject.listen((value) {
      if (!mounted) {
        return;
      }
      setState(() {
        _course = widget.courseData;
        _user = value.results;
        if (_user != null) {
          bloc.getMyCourseById(_user.id, widget.courseData.id);
        } else {
          _course = widget.courseData;
        }
      });
    });

    bloc.course.listen((value) {
      if (!mounted) {
        return;
      }
      setState(() {
        if (value.result != null && value.result.title != null) {
          _course = value.result;
        }
      });
    });

    userBloc.token.listen((value) {
      if (!mounted) {
        return;
      }
      setState(() {
        token = value;
      });
    });

    userBloc.getToken();

    bloc.getUser();
    wishlist = widget.courseData.wishList ?? false;
  }

  getRatings(Course course) {
    int r = 0;
    if (course.comments.length > 0) {
      course.comments.forEach((c) {
        r = r + int.parse(c.rating.replaceAll(RegExp('[^0-9]'), ''));
      });
      return ((r / course.comments.length).round()).toString() + '/5';
    }
    return '0/5';
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: themeBlue,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: iconColor,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
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
        body: SingleChildScrollView(  // by posi
          child: Container(
            height: MediaQuery.of(context).size.height,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                SizedBox(
                  height: 8,
                ),
                Container(
                  width: width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _course.title,
                        style: TextStyle(
                          color: themeGold,
                          fontSize: 30.0,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Signika Negative',
                        ),
                      ),
                      Text(
                        'Instructor - ' + _course.author,
                        style: TextStyle(
                          color: themeGold,
                          fontSize: 14.0,
                          fontFamily: 'Signika Negative',
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    getRatings(_course),
                                    style: TextStyle(
                                      color: themeGold,
                                      fontSize: 14.0,
                                      fontFamily: 'Signika Negative',
                                    ),
                                  ),
                                  SizedBox(width: 2.0),
                                  Icon(
                                    Icons.star,
                                    color: iconColor,
                                    size: 15.0,
                                  ),
                                  SizedBox(width: 5.0),
                                  Text(
                                    '(${_course.comments.length} Reviews)',
                                    style: TextStyle(
                                      color: themeGold,
                                      fontSize: 14.0,
                                      fontFamily: 'Signika Negative',
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          if (_user != null &&
                              _user.status != null &&
                              _user.status.toLowerCase() != 'active')
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    PageTransition(
                                        type: PageTransitionType.rightToLeft,
                                        child: SelectPlan(
                                          course: _course,
                                        )));
                              },
                              child: Container(
                                padding: EdgeInsets.all(5.0),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                ),
                                child: Text(
                                  'Buy Membership',
                                  style: TextStyle(
                                    fontFamily: 'Signika Negative',
                                    fontSize: 20.0,
                                    color: themeGold,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Container(
                  width: width,
                  height: 270.0,
                  padding: EdgeInsets.all(20.0),
                  alignment: Alignment.bottomCenter,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(_course.image),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20.0),
                      bottomLeft: Radius.circular(20.0),
                      bottomRight: Radius.circular(20.0),
                    ),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                if (_user == null || (_user != null && _user.status != 'active'))
                 
                if (_user == null)
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Login(_course, null)));
                    },
                    child: Container(
                      width: width,
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(13.0),
                      decoration: BoxDecoration(
                          color: buttonColor,
                          borderRadius: BorderRadius.circular(5.0)),
                      child: Text(
                        'Login To View Course',
                        style: TextStyle(
                          fontFamily: 'Signika Negative',
                          fontSize: 16.0,
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                          wordSpacing: 3.0,
                          letterSpacing: 0.6,
                        ),
                      ),
                    ),
                  ),
                if (_user != null && _user.status != 'active')
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SelectPlan(
                                    course: _course,
                                  )));
                    },
                    child: Container(
                      width: width,
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(13.0),
                      decoration: BoxDecoration(
                          color: themeBlue,
                          borderRadius: BorderRadius.circular(5.0)),
                      child: Text(
                        'Buy Membership',
                        style: TextStyle(
                          fontFamily: 'Signika Negative',
                          fontSize: 16.0,
                          color: themeGold,
                          fontWeight: FontWeight.w700,
                          wordSpacing: 3.0,
                          letterSpacing: 0.6,
                        ),
                      ),
                    ),
                  ),
                if (_user != null &&
                    _user.status == 'active' &&
                    _course.sections.length > 0 &&
                    _course.sections[0].lessons.length > 0)
                  InkWell(
                    onTap: () {
                      if (token != null) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => InAppLessonView(
                                    _course.sections[0].lessons[0].postId, token)));
                      }
                    },
                    child: Container(
                      width: width,
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(13.0),
                      decoration: BoxDecoration(
                          color: themeBlue,
                          borderRadius: BorderRadius.circular(5.0)),
                      child: Text(
                        'Continue Course',
                        style: TextStyle(
                          fontFamily: 'Signika Negative',
                          fontSize: 16.0,
                          color: themeGold,
                          fontWeight: FontWeight.w700,
                          wordSpacing: 3.0,
                          letterSpacing: 0.6,
                        ),
                      ),
                    ),
                  ),
                if (preview) SizedBox(height: 10.0),
                SizedBox(
                  height: 5,
                ),
                SizedBox(
                  height: 50,
                  child: AppBar(
                    bottom: TabBar(
                      unselectedLabelColor: Colors.black,
                      tabs: [
                        Tab(
                          child: Container(
                            child: Text(
                              'Overview',
                              style: TextStyle(
                                  fontFamily: 'Signika Negative',
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                        Tab(
                          child: Text(
                            'Curriculum',
                            style: TextStyle(
                                fontFamily: 'Signika Negative',
                                fontSize: 16.0,
                                fontWeight: FontWeight.w700,
                                color: Colors.white),
                          ),
                        ),
                        Tab(
                          child: Text(
                            'Reviews',
                            style: TextStyle(
                                fontFamily: 'Signika Negative',
                                fontSize: 16.0,
                                fontWeight: FontWeight.w700,
                                color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      ListView(
                        children: <Widget>[
                          OverviewCoursePage(_course, _user),
                        ],
                      ),
                      LessonView(
                          
                          sections: _course.sections,
                          user: _user),
                      CourseReview(_course, _user)
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
