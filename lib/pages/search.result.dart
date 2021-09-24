import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tritek_lms/appTheme/appTheme.dart';
import 'package:tritek_lms/blocs/course.bloc.dart';
import 'package:tritek_lms/data/entity/courses.dart';
import 'package:tritek_lms/http/http.client.dart';
import 'package:tritek_lms/pages/course/lesson.view.dart';

class SearchResult extends StatefulWidget {
  final String searchTerm;
  final List<Course> courses;

  SearchResult(this.searchTerm, this.courses);

  @override
  _SearchResultState createState() => _SearchResultState();
}

class _SearchResultState extends State<SearchResult> {
  String _token;

  @override
  void initState() {
    super.initState();
    // bloc.searchLessons(widget.searchTerm);
    bloc.searchLessonsFromCourses(widget.searchTerm, widget.courses);
    getToken();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    InkWell tagTile(String tag) {
      return InkWell(
        onTap: () {},
        child: Text(
          tag,
          style: TextStyle(
            fontSize: 18.0,
            fontFamily: 'Signika Negative',
            color: Colors.grey,
          ),
        ),
      );
    }

    InkWell _listResult(LessonSearch lesson) {
      return InkWell(
          onTap: () {
            if (_token != null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => InAppLessonView(lesson.itemId, _token),
                ),
              );
            } else {
              Fluttertoast.showToast(
                msg: 'You have to login first',
                backgroundColor: Colors.black,
                textColor: Theme.of(context).appBarTheme.color,
              );
            }
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AutoSizeText(
                lesson.lesson,
                style: TextStyle(
                  fontSize: 18.0,
                  fontFamily: 'Signika Negative',
                  color: themeBlue,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              AutoSizeText(
                'Course: ${lesson.course}',
                style: TextStyle(
                  fontSize: 12.0,
                  fontFamily: 'Signika Negative',
                  color: themeGold,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              AutoSizeText(
                'Section: ${lesson.section}',
                style: TextStyle(
                  fontSize: 12.0,
                  fontFamily: 'Signika Negative',
                  color: Colors.grey,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Divider(),
            ],
          ));
    }

    Widget _searchResponse(
        List<LessonSearch> data, double width, double height) {
      return ListView(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Lessons Search Result',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontFamily: 'Signika Negative',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                for (LessonSearch item in data) _listResult(item),
              ],
            ),
          ),
        ],
      );
    }

    nestedAppBar() {
      return NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                expandedHeight: 150,
                pinned: true,
                titleSpacing: 0.0,
                backgroundColor: themeBlue,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    padding: EdgeInsets.all(20.0),
                    alignment: Alignment.bottomCenter,
                    decoration: BoxDecoration(
                      color: themeBlue,
                    ),
                    child: Container(
                        // width: width - 20.0,
                        decoration: BoxDecoration(
                          color: themeBlue,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            AutoSizeText(
                              'Search result for:',
                              maxLines: 1,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            AutoSizeText(
                              widget.searchTerm,
                              maxLines: 2,
                              style: TextStyle(
                                  color: themeGold,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        )),
                  ),
                ),
                leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: themeGold,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                automaticallyImplyLeading: false,
              ),
            ];
          },
          body: StreamBuilder<List<LessonSearch>>(
              stream: bloc.search.stream,
              builder: (context, AsyncSnapshot<List<LessonSearch>> snapshot) {
                if (snapshot.hasData) {
                  return _searchResponse(snapshot.data, width, height);
                } else {
                  return tagTile("");
                }
              }));
    }

    return Scaffold(
      body: nestedAppBar(),
    );
  }

  void getToken() async {
    _token = await HttpClient.getToken();
  }
}
