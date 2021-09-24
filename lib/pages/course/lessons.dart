import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:tritek_lms/blocs/user.bloc.dart';
import 'package:tritek_lms/data/entity/courses.dart';
import 'package:tritek_lms/data/entity/users.dart';
import 'package:tritek_lms/pages/course/lesson.view.dart';

class LessonView extends StatefulWidget {
  final scaffoldKey;
  final List<Sections> sections;
  final Users user;

  LessonView({Key key, this.scaffoldKey, this.sections, this.user})
      : super(key: key);

  @override
  _LessonViewState createState() => _LessonViewState();
}

class _LessonViewState extends State<LessonView> {
  String token;

  @override
  void initState() {
    super.initState();
    userBloc.token.listen((value) {
      if (!mounted) {
        return;
      }
      setState(() {
        token = value;
      });
    });

    userBloc.getToken();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    Users user = widget.user;

    _checkStatus(Lessons status) {
      if (user == null && status.preview == 'no') {
        widget.scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text(
          'First Login and Subscribe to one of the membership plans, then you can view the course.',
          style: TextStyle(fontSize: 14.0),
        )));
      } else if (user != null && user.status != 'active') {
        widget.scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text(
              'Buy one of the membership plans, then you can view the course.',
          style: TextStyle(fontSize: 14.0),
        )));
      } else if (token != null) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => InAppLessonView(status.postId, token)));
      } else {
        widget.scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text(
              'Unidentified Error, try again',
              style: TextStyle(fontSize: 14.0),
            )));
      }
    }

    if (token == null) {
      userBloc.getToken();
    }

    return ListView(children: [
      for (var item in widget.sections)
        ExpansionTile(
            title: AutoSizeText(
              item.sectionName,
              maxLines: 2,
              style: TextStyle(
                fontSize: 16.0,
                fontFamily: 'Signika Negative',
                fontWeight: FontWeight.w700,
                letterSpacing: 0.7,
              ),
            ),
            children: [
              for (var les in item.lessons)
                InkWell(
                  onTap: () {
                    _checkStatus(les);
                  },
                  child: Container(
                    padding: EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: width - 25,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 8.0,
                                    bottom: 4.0,
                                    right: 8.0,
                                    left: 8.0),
                                child: AutoSizeText(
                                  les.postTitle,
                                  maxLines: 2,
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontFamily: 'Signika Negative',
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.7,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 0.0,
                                    right: 8.0,
                                    left: 8.0,
                                    bottom: 8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(
                                      Icons.av_timer,
                                      size: 20.0,
                                    ),
                                    SizedBox(width: 3.0),
                                    Text(
                                      getLessonTime(les),
                                      style: TextStyle(
                                        fontSize: 14.0,
                                        height: 1.6,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Spacer(),
                                    if (les.quizCount != null)
                                      Icon(
                                        Icons.description,
                                        size: 20.0,
                                      ),
                                    if (les.quizCount != null)
                                      SizedBox(width: 3.0),
                                    if (les.quizCount != null)
                                      Text(
                                        '${les.quizCount} Quizzes',
                                        style: TextStyle(
                                          fontSize: 14.0,
                                          height: 1.6,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    SizedBox(width: 3.0),
                                    if (user == null)
                                      Icon(
                                        (les.preview == 'no')
                                            ? Icons.lock
                                            : Icons.lock_open,
                                        size: 20.0,
                                      ),
                                    if (_checkViewed(user, les))
                                      Icon(
                                        Icons.check,
                                        size: 20.0,
                                      ),
                                    if (!_checkViewed(user, les) &&
                                        les.quizCount == null)
                                      Icon(
                                        Icons.check_box_outline_blank,
                                        size: 20.0,
                                      ),
                                    if (checkGrade(user, les))
                                      Icon(
                                        (les.grade == 'failed') ?
                                        Icons.close : Icons.check,
                                        color: (les.grade == 'failed') ?
                                        Colors.deepOrange : Colors.green,
                                        size: 20.0,
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ])
    ]);
  }

  String getLessonTime(Lessons lessons) {
    var time = int.parse(lessons.duration.replaceAll(RegExp('[^0-9]'), ''));
    var d = Duration(minutes: time);
    List<String> parts = d.toString().split(':');
    if (parts[0] == '0') {
      return '${parts[1]} minutes';
    }
    if (parts[1] == '0') {
      return '${parts[0]} hour, ${parts[1]} minutes';
    }
    return '${parts[0]} hours, ${parts[1]} minutes';
  }

  checkGrade(Users user, Lessons les) {
    if (user == null) {
      return false;
    } else if (les.viewed == null) {
      return false;
    } else if (les.viewed && les.quizCount != null) {
      return true;
    }
    return false;
  }

  _checkViewed(Users user, Lessons les) {
    if (user == null) {
      return false;
    } else if (les.viewed == null) {
      return false;
    } else if (les.viewed && les.quizCount == null) {
      return true;
    }

    return false;
  }
}

