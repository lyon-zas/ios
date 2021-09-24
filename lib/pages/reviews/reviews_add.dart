import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:tritek_lms/appTheme/appTheme.dart';
import 'package:tritek_lms/custom/form.validators.dart';
import 'package:tritek_lms/data/entity/courses.dart';
import 'package:tritek_lms/data/entity/users.dart';
import 'package:tritek_lms/http/courses.dart';
import 'package:tritek_lms/pages/common/dialog.dart';

class CourseAddReview extends StatefulWidget {
  final Course _course;
  final Users _users;

  CourseAddReview(this._course, this._users);

  @override
  _CourseAddReviewState createState() => _CourseAddReviewState();
}

class _CourseAddReviewState extends State<CourseAddReview> {
  final ratings = ['All', 5, 4, 3, 2, 1];
  final CoursesApiProvider _apiProvider = CoursesApiProvider();
  int selectedIndex = 0;
  List<Comments> comments;
  String mine = '';

  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  final _contentController = TextEditingController();
  final _titleController = TextEditingController();
  final _contentFocus = FocusNode();
  double _rating = 3;

  @override
  void initState() {
    super.initState();
    comments = widget._course.comments;
    var mine = widget._course.comments
        .where((e) => e.email == widget._users.email)
        .toList();

    if (mine.length > 0) {
      _contentController.text = mine[0].comment;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: themeBlue,
        title: AutoSizeText(
          widget._course.title + ': Add Review',
          style: TextStyle(color: themeGold),
          maxLines: 1,
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: iconColor,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            Text(
              'Rate Course',
              style: TextStyle(
                  color: themeBlue, fontWeight: FontWeight.bold, fontSize: 25),
            ),
            Text(
              'Slide on the Rating Star Bar Below',
              style: TextStyle(fontSize: 10),
            ),
            SizedBox(
              height: 10,
            ),
            RatingBar.builder(
              initialRating: 3,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                setState(() {
                  _rating = rating;
                });
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Your rating: ',
                  style: TextStyle(
                      color: themeBlue,
                      fontWeight: FontWeight.bold,
                      fontSize: 12),
                ),
                Text(
                  _rating.toString(),
                  style: TextStyle(
                      color: themeGold,
                      fontWeight: FontWeight.bold,
                      fontSize: 12),
                ),
              ],
            ),
            Divider(),
            Container(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: TextField(
                  decoration: InputDecoration(hintText: 'Review Title'),
                  maxLines: 1,
                  controller: _titleController,
                  focusNode: _contentFocus,
                  style: TextStyle(color: Colors.black, fontSize: 20),
                  //backgroundCursorColor: Colors.red,
                  cursorColor: themeBlue,
                )),
            SizedBox(
              height: 10,
            ),
            Flexible(
                child: Container(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: TextField(
                      decoration: InputDecoration(hintText: 'Review content'),
                      maxLines: 50,
                      controller: _contentController,
                      focusNode: _contentFocus,
                      style: TextStyle(color: Colors.black, fontSize: 20),
                      //backgroundCursorColor: Colors.red,
                      cursorColor: themeBlue,
                    ))),
            RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              onPressed: () {
                _postReview();
              },
              color: themeBlue,
              child: Text(
                'Post Review',
                style: TextStyle(
                  color: themeGold,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        left: true,
        right: true,
        top: false,
        bottom: false,
      ),
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

  void _postReview() async {
    Comments comments = new Comments();
    comments.email = widget._users.email;
    comments.author = widget._users.name;
    comments.comment = _contentController.value.text;
    comments.rating = _rating.toString();
    comments.courseId = widget._course.id;
    comments.title = _titleController.value.text;

    if (Validator.required(comments.comment, 10,
        'Your review is too short! Please write in excess of 3 words') !=
        null) {
      ServerValidationDialog.errorDialog(
          context,
          'Your review is too short! Please write in excess of 3 words', "");

      return;
    }

    if (Validator.required(comments.title, 8,
        'Your review is too short! Please write in excess of 3 words') !=
        null) {
      ServerValidationDialog.errorDialog(
          context, 'Review Title is required in at least 2 words!', "");

      return;
    }

    LoadingDialogs.showLoadingDialog(
        context, _keyLoader, 'Submitting your review');

    try {
      await _apiProvider.postComment(comments);
      Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();

      showDialog<void>(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext context) {
            return new WillPopScope(
                onWillPop: () async => false,
                child: Dialog(
                    backgroundColor: themeBlue,
                    child: Container(
                      padding: EdgeInsets.all(20.0),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AutoSizeText(
                              'Review Submitted!',
                              style: TextStyle(
                                color: themeGold,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            AutoSizeText(
                              'Your review has been submitted for moderation by admin. Thank You',
                              style: TextStyle(color: themeGold,),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.pop(context);
                                _navigateBack();
                              },
                              child: Container(
                                width: 100,
                                alignment: Alignment.center,
                                padding: EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                  color: themeGold,
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                child: Text(
                                  'Ok',
                                  style: TextStyle(
                                    fontFamily: 'Signika Negative',
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ]),
                    )));
          });
    } catch (e) {
      Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
      ServerValidationDialog.errorDialog(
          context, 'An Error Occurred, Please try again', ''); //invoking log
    }
  }

  void _navigateBack() {
    Navigator.pop(context);
  }
}
