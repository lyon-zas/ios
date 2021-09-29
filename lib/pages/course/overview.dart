import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:tritek_lms/data/entity/courses.dart';
import 'package:tritek_lms/data/entity/users.dart';
import 'package:tritek_lms/pages/course/comments_slide.dart';
import 'package:tritek_lms/pages/course/what_you_will_get.dart';

class OverviewCoursePage extends StatefulWidget {
  var isExpanded = false;
  final Course course;
  final Users users;

  OverviewCoursePage(this.course, this.users);

  @override
  _OverviewCoursePageState createState() => _OverviewCoursePageState();
}

class _OverviewCoursePageState extends State<OverviewCoursePage> with TickerProviderStateMixin<OverviewCoursePage> {
  @override
  Widget build(BuildContext context) {
    Course course = widget.course;

    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.only( top: 10,right: 10.0, left: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            WhatYouWillGet(course),
            new AnimatedSize(
                vsync: this,
                duration: const Duration(milliseconds: 300),
                child: new ConstrainedBox(
                    constraints: widget.isExpanded
                        ? new BoxConstraints()
                        : new BoxConstraints(maxHeight: 250.0),
                    child: Html(
                      data: course.description,
                      //Optional parameters:
                      // onLinkTap: (url) {
                      //   // open url in a webview
                      // },
                      // onImageTap: (src) {
                      //   // Display the image in large form.
                      // },
                    ))),
            // widget.isExpanded
            //     ? new FlatButton(
            //         child: const Text(
            //           'show less',
            //           style: TextStyle(color: Colors.blue),
            //         ),
            //         onPressed: () => setState(() => widget.isExpanded = false))
            //     : new FlatButton(
            //         child: const Text(
            //           'show more',
            //           style: TextStyle(color: Colors.blue),
            //         ),
            //         onPressed: () => setState(() => widget.isExpanded = true)),
            SizedBox(height: 30),
            // CommentSlider(course.comments, widget.users, widget.course),
          ],
        ),
      ),
    );
  }
}
