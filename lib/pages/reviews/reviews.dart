import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:tritek_lms/appTheme/appTheme.dart';
import 'package:tritek_lms/data/entity/courses.dart';
import 'package:tritek_lms/data/entity/users.dart';
import 'package:tritek_lms/pages/reviews/reviews_add.dart';

class CourseReview extends StatefulWidget {
  final Course _course;
  final Users _users;

  CourseReview(this._course, this._users);

  @override
  _CourseReviewState createState() => _CourseReviewState();
}

class _CourseReviewState extends State<CourseReview> {
  final ratings = ['All', 5, 4, 3, 2, 1];
  int selectedIndex = 0;
  List<Comments> comments;
  Users _user;
  @override
  void initState() {
    super.initState();
    comments = widget._course.comments;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
        height: MediaQuery.of(context).size.height,

          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  FocusScope.of(context).requestFocus(new FocusNode());
                },
                child: SafeArea(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                          padding: EdgeInsets.all(10),
                          height: 60,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: 6,
                              itemBuilder: (BuildContext context, int i) =>
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        selectedIndex = i;
                                      });
                                      setReviewsVars(i);
                                    },
                                    child: Container(
                                      width: 70.0,
                                      height: 50.0,
                                      margin:
                                          EdgeInsets.only(left: 10, right: 10),
                                      decoration: BoxDecoration(
                                          color: selectedIndex == i
                                              ? themeBlue
                                              : themeBlue.withOpacity(0.7),
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                          border: Border.all(
                                              color: themeGold, width: 1.0)),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            ratings[i].toString(),
                                            style: TextStyle(
                                              color: themeGold,
                                              fontSize: 14.0,
                                              fontFamily: 'Signika Negative',
                                            ),
                                          ),
                                          if (ratings[i] != 'All')
                                            SizedBox(width: 2.0),
                                          if (ratings[i] != 'All')
                                            Icon(
                                              Icons.star,
                                              color: iconColor,
                                              size: 15.0,
                                            ),
                                        ],
                                      ),
                                    ),
                                  ))),
                      Divider(),
                      // Text(
                      //   "Reviews",
                      //   style: TextStyle(
                      //     color: themeGold,
                      //     fontSize: 14.0,
                      //     fontFamily: 'Signika Negative',
                      //   ),
                      // ),
                      for (var item in comments)
                        Container(
                            padding: EdgeInsets.all(20),
                            margin: EdgeInsets.only(bottom: 20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: Column(children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 56.0,
                                    width: 56.0,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20.0),
                                      image: DecorationImage(
                                        image: item.image != null
                                            ? NetworkImage(item.image)
                                            : AssetImage(
                                                "assets/user_profile/profile.png"),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    alignment: Alignment.center,
                                  ),
                                  SizedBox(width: 12.0),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.author,
                                          style: TextStyle(
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold,
                                            color: themeBlue,
                                          ),
                                        ),
                                        SizedBox(height: 5.0),
                                        RatingBarIndicator(
                                          rating: double.parse(item.rating
                                              .replaceAll(RegExp('[^0-9]'), '')),
                                          itemBuilder: (context, index) => Icon(
                                            Icons.star,
                                            color: themeGold,
                                          ),
                                          itemCount: 5,
                                          itemSize: 35.0,
                                          direction: Axis.horizontal,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Text(item.comment),
                              Divider(),
                              
                            ])),
                                        //  if (_user != null && _user.status != 'active')
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CourseAddReview(
                                    widget._course, widget._users)));
                      },
                      child: Container(
                          decoration: BoxDecoration(
                              color: themeBlue,
                              borderRadius: BorderRadius.circular(5.0)),
                          height: 50,
                          width: 100,
                          child: Center(
                              child: Text("Write a Review",
                                  style: TextStyle(
                                    color: themeGold,
                                  )))),
                    ),
                  ],
                ),
              )
                    ],
                  ),
                ),
              ),

            ],
          ),
        ),
      ),

      // floatingActionButton:
      //                         FloatingActionButton(
      //   onPressed: () {

      //     Navigator.push(
      //         context,
      //         MaterialPageRoute(
      //             builder: (context) =>
      //                 CourseAddReview(widget._course, widget._users)));
      //   },
      //   child: Icon(
      //     Icons.edit,
      //     color: themeGold,
      //   ),
      //   backgroundColor: themeBlue,
      // ),
    );
  }

  void setReviewsVars(int i) {
    if (ratings[i] == 'All') {
      return;
    }
    List<Comments> _comm = widget._course.comments
        .where((e) =>
            (double.parse(e.rating.replaceAll(RegExp('[^0-9]'), '')) <=
                ratings[i]))
        .toList();

    setState(() {
      comments = _comm;
    });
  }
}
