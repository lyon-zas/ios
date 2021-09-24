import 'package:flutter/material.dart';
import 'package:tritek_lms/appTheme/appTheme.dart';
import 'package:tritek_lms/data/entity/courses.dart';

class WhatYouWillGet extends StatefulWidget {
  final Course course;

  WhatYouWillGet(this.course);

  @override
  _WhatYouWillGetState createState() => _WhatYouWillGetState();
}

class _WhatYouWillGetState extends State<WhatYouWillGet> {
  @override
  Widget build(BuildContext context) {
    Course course = widget.course;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Course Features',
          style: TextStyle(
            fontFamily: 'Signika Negative',
            fontSize: 18.0,
            fontWeight: FontWeight.w700,
            color: headingColor,
          ),
        ),

        // ListTile(
        //   dense: true,
        //   visualDensity: VisualDensity(horizontal: 0, vertical: -4),
        //   leading: Icon(
        //     Icons.menu,
        //     color: themeGold,
        //     size: 25.0,
        //   ),
        //   title: Row(
        //     mainAxisAlignment: MainAxisAlignment.start,
        //     mainAxisSize: MainAxisSize.min,
        //     children: [
        //       Text(
        //         'Quizzes',
        //         style: TextStyle(
        //           fontWeight: FontWeight.w700,
        //           fontFamily: 'Signika Negative',
        //           fontSize: 18.0,
        //           color: themeBlue
        //         ),
        //       ),
        //       Spacer(),
        //       Text(
        //         '250',
        //         style: TextStyle(
        //           fontWeight: FontWeight.w700,
        //           fontFamily: 'Signika Negative',
        //           fontSize: 18.0,
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
        ListTile(
          dense: true,
          visualDensity: VisualDensity(horizontal: 0, vertical: -4),
          leading: Icon(
            Icons.av_timer,
            color: themeGold,
            size: 25.0,
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Duration',
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Signika Negative',
                    fontSize: 18.0,
                    color: themeBlue
                ),
              ),
              Spacer(),
              Text(
                course.duration,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Signika Negative',
                  fontSize: 18.0,
                ),
              ),
            ],
          ),
        ),
        ListTile(
          dense: true,
          visualDensity: VisualDensity(horizontal: 0, vertical: -4),
          leading: Icon(
            Icons.people,
            color: themeGold,
            size: 25.0,
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Enrolled',
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Signika Negative',
                    fontSize: 18.0,
                    color: themeBlue
                ),
              ),
              Spacer(),
              Text(
                course.enrolled,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Signika Negative',
                  fontSize: 18.0,
                ),
              ),
            ],
          ),
        ),
        ListTile(
          dense: true,
          visualDensity: VisualDensity(horizontal: 0, vertical: -4),
          leading: Icon(
            Icons.redo_rounded,
            color: themeGold,
            size: 25.0,
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Re-Take Course',
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Signika Negative',
                    fontSize: 18.0,
                    color: themeBlue
                ),
              ),
              Spacer(),
              Text(
                course.retake,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Signika Negative',
                  fontSize: 18.0,
                ),
              ),
            ],
          ),
        ),
        ListTile(
          dense: true,
          visualDensity: VisualDensity(horizontal: 0, vertical: -4),
          leading: Icon(
            Icons.sticky_note_2_outlined,
            color: themeGold,
            size: 25.0,
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Assessment',
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Signika Negative',
                    fontSize: 18.0,
                    color: themeBlue
                ),
              ),
              Spacer(),
              Text(
                'Self',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Signika Negative',
                  fontSize: 18.0,
                ),
              ),
            ],
          ),
        ),

      ],
    );
  }
}
