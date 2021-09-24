import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:tritek_lms/appTheme/appTheme.dart';
import 'package:tritek_lms/blocs/course.bloc.dart';
import 'package:tritek_lms/blocs/user.bloc.dart';
import 'package:tritek_lms/custom/helper.dart';
import 'package:tritek_lms/data/entity/courses.dart';
import 'package:tritek_lms/data/entity/users.dart';
import 'package:tritek_lms/http/courses.dart';
import 'package:tritek_lms/pages/course/courses.dart';
import 'package:tritek_lms/pages/payment/select_plan.dart';
import 'package:tritek_lms/pages/settings/account.settings.dart';

import 'common/utils.dart';
import 'course/course.dart';
import 'login_signup/login.dart';

class MyCourse extends StatefulWidget {
  @override
  _MyCourseState createState() => _MyCourseState();
}

class _MyCourseState extends State<MyCourse> {
  Users _user = Users();
  File _image;
  String _weeks = '..';

  final bloc = CourseBloc();

  @override
  void initState() {
    super.initState();
    if (_user != null && _user.id == null) {
      userBloc.userSubject.listen((value) {
        if (!mounted) {
          return;
        }

        setState(() {
          _user = value != null ? value.results : null;

          if (value != null && value.results != null) {
            bloc.getMyCourses(_user.id);

            if (_user.startDate != null) {
              _weeks = Jiffy(DateTime.now())
                  .diff(Jiffy(DateFormatter.stringToDate(_user.startDate)),
                      Units.WEEK)
                  .toString();
            }
          }
        });
      });

      userBloc.getUser();
    }
    userBloc.image.listen((value) {
      if (!mounted) {
        return;
      }

      setState(() {
        _image = value;
      });
    });

    userBloc.getImage();
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  var top = 0.0;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    getCourseTile(Course course) {
      return InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CoursesNew(
                courseData: course,
              ),
            ),
          );
        },
        child: Container(
          padding: EdgeInsets.all(10.0),
          margin: EdgeInsets.all(5.0),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(20.0),
            boxShadow: <BoxShadow>[
              BoxShadow(
                blurRadius: 1.5,
                spreadRadius: 1.5,
                color: Colors.grey[200],
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 100.0,
                height: 100.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(course.image),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              Container(
                width: width - 140.0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 8.0, bottom: 4.0, right: 8.0, left: 8.0),
                      child: AutoSizeText(
                        course.title,
                        maxLines: 2,
                        style: TextStyle(
                          color: themeGold,
                          fontSize: 20.0,
                          fontFamily: 'Signika Negative',
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.7,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: 0.0, right: 8.0, left: 8.0, bottom: 8.0),
                      child: Row(
                        children: [
                          Text(
                            _weeks,
                            style: TextStyle(
                              fontSize: 12.0,
                              fontFamily: 'Signika Negative',
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.7,
                              color: Colors.green,
                            ),
                          ),
                          Text(
                            ' / ' + course.duration,
                            style: TextStyle(
                              fontSize: 12.0,
                              fontFamily: 'Signika Negative',
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.7,
                              color: headingColor,
                            ),
                          ),
                          Spacer(),
                          Text(
                            getPercentComplete(course) + '% ',
                            style: TextStyle(
                              fontSize: 12.0,
                              fontFamily: 'Signika Negative',
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.7,
                              color: Colors.green,
                            ),
                          ),
                          Text(
                            'Completed',
                            style: TextStyle(
                              fontSize: 12.0,
                              fontFamily: 'Signika Negative',
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.7,
                              color: headingColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: 0.0, right: 8.0, left: 8.0, bottom: 8.0),
                      child: Text(
                        "Instructor - ${course.author}",
                        style: TextStyle(
                          fontSize: 14.0,
                          fontFamily: 'Signika Negative',
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.7,
                          color: headingColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    Widget _listCoursesWidget(List<Course> data, double width, double height) {
      return ListView(
        children: <Widget>[
          for (Course item in data)
            getCourseTile(item),
        ],
      );
    }

    Widget _noCourseWidget(double width, double height) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.dnd_forwardslash,
              color: Colors.grey,
              size: 60.0,
            ),
            SizedBox(
              height: 20.0,
            ),
            AutoSizeText(
              'You have no registered courses',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 18.0,
                fontFamily: 'Signika Negative',
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 10,),
            Container(
              width: double.infinity,
              alignment: Alignment.center,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SelectPlan()));
                },
                borderRadius: BorderRadius.circular(30.0),
                child: Material(
                  elevation: 1.0,
                  borderRadius: BorderRadius.circular(30.0),
                  child: Container(
                    padding: EdgeInsets.fromLTRB(40.0, 15.0, 40.0, 15.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.0),
                      color: themeBlue,
                    ),
                    child: Text(
                      'Buy Subscription'.toUpperCase(),
                      style: TextStyle(
                        color: themeGold,
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    Widget _subExpiredWidget(double width, double height) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.dnd_forwardslash,
              color: Colors.grey,
              size: 60.0,
            ),
            SizedBox(
              height: 20.0,
            ),
            AutoSizeText(
              _user.startDate != null
                  ? 'Your subscription has expired'
                  : 'You are yet to Buy Membership',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 18.0,
                fontFamily: 'Signika Negative',
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 10,),
            Container(
              width: double.infinity,
              alignment: Alignment.center,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SelectPlan()));
                },
                borderRadius: BorderRadius.circular(30.0),
                child: Material(
                  elevation: 1.0,
                  borderRadius: BorderRadius.circular(30.0),
                  child: Container(
                    padding: EdgeInsets.fromLTRB(40.0, 15.0, 40.0, 15.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.0),
                      color: themeBlue,
                    ),
                    child: Text(
                      'Buy Subscription'.toUpperCase(),
                      style: TextStyle(
                        color: themeGold,
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    Widget _noLoginWidget(double width, double height) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.person_add_disabled,
              color: Colors.grey,
              size: 60.0,
            ),
            SizedBox(
              height: 20.0,
            ),
            AutoSizeText(
              'You are yet to login',
              style: TextStyle(
                color: themeBlue,
                fontSize: 18.0,
                fontFamily: 'Signika Negative',
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 10,),
            Container(
              width: double.infinity,
              alignment: Alignment.center,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Login(null, null)));
                },
                borderRadius: BorderRadius.circular(30.0),
                child: Material(
                  elevation: 1.0,
                  borderRadius: BorderRadius.circular(30.0),
                  child: Container(
                    padding: EdgeInsets.fromLTRB(40.0, 15.0, 40.0, 15.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.0),
                      color: themeBlue,
                    ),
                    child: Text(
                      'Login Here'.toUpperCase(),
                      style: TextStyle(
                        color: themeGold,
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    nestedAppBar() {
      return NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                expandedHeight: 150,
                pinned: true,
                backgroundColor: themeBlue,
                flexibleSpace: LayoutBuilder(builder:
                    (BuildContext context, BoxConstraints constraints) {
                  top = constraints.biggest.height;
                  return FlexibleSpaceBar(
                      centerTitle: false,
                      title: AnimatedOpacity(
                        duration: Duration(milliseconds: 300),
                        //opacity: top == 80.0 ? 1.0 : 0.0,
                        opacity: 1.0,
                        child: Container(
                          padding: EdgeInsets.fromLTRB(0, 10, 20, 0),
                          alignment: Alignment.bottomCenter,
                          decoration: BoxDecoration(
                            color: themeBlue,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Text(
                                'My Courses',
                                style: TextStyle(
                                  fontFamily: 'Signika Negative',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18.0,
                                  color: themeGold,
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              AccountSettings()));
                                },
                                child: _image != null
                                    ? ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.file(
                                    _image,
                                    width: 40.0,
                                    height: 40.0,
                                    fit: BoxFit.fitHeight,
                                  ),
                                )
                                    :
                                Container(
                                  height: 40.0,
                                  width: 40.0,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20.0),
                                    image: DecorationImage(
                                      image: AssetImage(
                                          'assets/user_profile/profile.png'),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      background: Container(
                        padding: EdgeInsets.all(20.0),
                        alignment: Alignment.bottomLeft,
                        decoration: BoxDecoration(
                            color: themeBlue
                        ),
                      ));
                }),
                automaticallyImplyLeading: false,
              ),
            ];
          },
          body:
          StreamBuilder<CoursesResponse>(
            stream: bloc.myCourses.stream,
            builder: (context, AsyncSnapshot<CoursesResponse> snapshot) {
              if (_user != null && _user.status != 'active' &&
                  _user.startDate != null) {
                return _subExpiredWidget(width, height);
              } else if (snapshot.hasData) {
                if (snapshot.data.error != null &&
                    snapshot.data.error.length > 0) {
                  return HttpErrorWidget(snapshot.data.error, width, height);
                }

                if (snapshot.data.results.length < 1) {
                  return _noCourseWidget(width, height);
                }
                return _listCoursesWidget(snapshot.data.results, width, height);
              } else if (snapshot.hasError) {
                return HttpErrorWidget(snapshot.error, width, height);
              } else if (_user == null) {
                return _noLoginWidget(width, height);
              } else if (_user != null && _user.id == null) {
                return LoadingWidget(width, height);
              } else {
                return LoadingWidget(width, height);
              }
            },
          ));
    }

    return Scaffold(
      backgroundColor: themeBg,
      body: nestedAppBar(),
    );
  }

  String getPercentComplete(Course course) {
    int com = 0;
    int total = 0;
    for (Sections sec in course.sections) {
      total = total + sec.lessons.length;

      for (Lessons les in sec.lessons) {
        if (les.viewed) {
          com = com + 1;
        }
      }
    }

    if (com == 0 || total == 0) {
      return '0';
    }
    return (com / total * 100).round().toString();
  }
}

