import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:tritek_lms/appTheme/appTheme.dart';
import 'package:tritek_lms/pages/course/course.dart';
import 'package:tritek_lms/pages/notifications.dart';
import 'package:tritek_lms/pages/search.dart';

class SavedVideos extends StatefulWidget {
  @override
  _SavedVideosState createState() => _SavedVideosState();
}

class _SavedVideosState extends State<SavedVideos> {
  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
              height: 30,
              width: 30,
              child: Center(
                child: Icon(
                  Icons.arrow_back_ios,
                  size: 30,
                  color: themeGold,
                ),
              )), // this should route to the previous screen
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
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          Padding(
              padding: EdgeInsets.only(top: 50.0, left: 20.0),
              child: Row(children: [
                Text(
                  'Saved Videos',
                  style: TextStyle(
                    color: themeGold,
                    fontSize: 30.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ])),
          SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Divider(
                  thickness: 3.0,
                ),
                SizedBox(height: 20.0),
                InkWell(
                  onTap: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => CoursePage(
                    //       courseData: course,
                    //     ),
                    //   ),
                    // );
                  },
                  child: Container(
                      width: _width - 20,
                      margin: EdgeInsets.only(bottom: 30.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.0),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 2.0,
                            spreadRadius: 1.5,
                            color: Colors.grey[300],
                          )
                        ],
                      ),
                      child: Row(
                        children: [
                          // Hero(
                          // tag: course.id.toString(),
                          Container(
                            height: 150.0,
                            width: _width - 270,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20.0),
                                  bottomLeft: Radius.circular(20.0),
                                ),
                                image: DecorationImage(
                                  image: NetworkImage(
                                    "https://tritekconsulting.co.uk/wp-content/uploads/2021/01/business-analysis.jpg",
                                  ),
                                  fit: BoxFit.cover,
                                )),
                            // ),
                          ),

                          // ),
                          SizedBox(width: 5),
                          Column(children: [
                            Container(
                              padding: EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  AutoSizeText(
                                    "Business Analysis",
                                    maxLines: 2,
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12.0,
                                    ),
                                  ),
                                  SizedBox(height: 10.0),
                                  AutoSizeText(
                                    'BA Trainig Part 1',
                                    style: TextStyle(
                                      color: themeBlue,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ])
                        ],
                      )),
                ),
                Divider(
                  thickness: 3.0,
                ),
                SizedBox(height: 20.0),
              ],
            ),
          )
        ],
      ),
    );
  }
}
