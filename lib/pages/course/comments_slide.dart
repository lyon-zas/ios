import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:tritek_lms/appTheme/appTheme.dart';
import 'package:tritek_lms/data/entity/courses.dart';
import 'package:tritek_lms/data/entity/users.dart';
import 'package:tritek_lms/pages/common/carousel_comments.dart';
import 'package:tritek_lms/pages/reviews/reviews.dart';

class CommentSlider extends StatefulWidget {
  final List<Comments> comments;
  final Users _users;
  final Course _course;

  CommentSlider(this.comments, this._users, this._course);

  @override
  _CommentSlider createState() => _CommentSlider();
}

class _CommentSlider extends State<CommentSlider> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    List<Comments> comments = widget.comments;

    return Container(
      width: width,
      height: 190.0,
      color: Theme.of(context).appBarTheme.color,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
              padding: const EdgeInsets.fromLTRB(10.0, 0, 10, 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Reviews',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: themeGold,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Signika Negative',
                      letterSpacing: 0.7,
                    ),
                  ),
                  if (widget._users != null &&
                      widget._users.status != null &&
                      widget._users.status.toLowerCase() == 'active')
                    Container(
                      height: 46.0,
                      width: 46.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(28.0),
                        color: themeBlue,
                      ),
                      alignment: Alignment.center,
                      child: IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CourseReview(
                                      widget._course, widget._users)));
                        },
                        iconSize: 48,
                        icon: Icon(Icons.edit, size: 28.0, color: themeGold),
                      ),
                    ),
                ],
              )),
          Container(
            height: 125.0,
            child: comments.length > 0
                ? CarouselSlider(
                    options: CarouselOptions(
                      height: (height / 4.0),
                      enlargeCenterPage: true,
                      autoPlay: true,
                      aspectRatio: 16 / 9,
                      autoPlayInterval: const Duration(seconds: 20),
                      autoPlayCurve: Curves.fastOutSlowIn,
                      enableInfiniteScroll: true,
                      autoPlayAnimationDuration:
                          const Duration(milliseconds: 800),
                      viewportFraction: 1.0,
                    ),
                    items: [
                      for (var item in comments) CarouselComments(width, item),
                    ],
                  )
                : Center(
                    child: Text(
                      'No Comments',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
