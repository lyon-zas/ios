import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tritek_lms/appTheme/appTheme.dart';
import 'package:tritek_lms/pages/course/course.dart';
import 'package:tritek_lms/pages/course/courses.dart';

class CarouselImageItem extends StatelessWidget {
  final course;
  final width;

  // final course;

  @override
  Widget build(BuildContext context) {
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
        width: width,
        margin: EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          image: DecorationImage(
            image: NetworkImage(course.image),
            fit: BoxFit.cover,
          ),
        ),
        child: BackdropFilter(
          // filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
          filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
          child: Container(
            decoration: new BoxDecoration(color: Colors.black.withOpacity(0.3)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                  Text(
                    course.title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25.0,
                      fontFamily: 'Signika Negative',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    course.author,
                    style: TextStyle(
                      color: themeGold,
                      fontSize: 15.0,
                      fontFamily: 'Signika Negative',
                    ),
                  ),
                ],
            ),
          )
          // Column(
          //
          // ),
        ),
      ),
    );
  }

  CarouselImageItem(this.course, this.width);
}