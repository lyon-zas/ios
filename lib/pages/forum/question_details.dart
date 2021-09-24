import 'package:flutter/material.dart';
import 'package:tritek_lms/appTheme/appTheme.dart';
import 'package:tritek_lms/pages/notifications.dart';
import 'package:tritek_lms/pages/search.dart';

class QuestionDetails extends StatefulWidget {
  @override
  _QuestionDetailsState createState() => _QuestionDetailsState();
}

class _QuestionDetailsState extends State<QuestionDetails> {
  @override
  Widget build(BuildContext context) {
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
        body: ListView(physics: BouncingScrollPhysics(), children: [
          Padding(
              padding: EdgeInsets.only(top: 10.0, left: 20.0),
              child: Row(children: [
                Text(
                  'Forum',
                  style: TextStyle(
                    color: themeGold,
                    fontSize: 30.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ])),
          Container(
            margin: EdgeInsets.only(top: 8, bottom: 8, left: 20, right: 20),
            child: Divider(
              thickness: 3.0,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 30, right: 20),
            child: Column(
              children: [
                Row(
                  children: [
                    InkWell(
                      child: // _image != null
                          //     ? ClipRRect(
                          //         borderRadius: BorderRadius.circular(20),
                          //         child: Image.file(
                          //           _image,
                          //           width: 40.0,
                          //           height: 40.0,
                          //           fit: BoxFit.fitHeight,
                          //         ),
                          //       ):
                          Container(
                        height: 60.0,
                        width: 60.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          color: Colors.black,
                          image: DecorationImage(
                            image:
                                AssetImage('assets/user_profile/profile.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 5),
                    Column(
                      children: [
                        Text(
                          "Project Trios",
                          // ("${_user?.firstName} ${_user?.lastName}")
                          //     .toUpperCase(),
                          style: TextStyle(
                            color: themeGold,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text("August 20,2021") //date
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Q: "),
                    Text("What is governance?") //question
                  ],
                ),
                SizedBox(height: 5),
                Row(children: [
                  Column(
                    children: [
                      IconButton(
                        icon: Icon(Icons.note_alt_outlined),
                        iconSize: 30,
                        color: Colors.black,
                        onPressed: () {
                          // Navigator.push(context,
                          //     MaterialPageRoute(builder: (context) => Notifications()));
                        },
                      ),
                      Text("Answer")
                    ],
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Column(
                    children: [
                      IconButton(
                        icon: Icon(Icons.file_upload_outlined),
                        iconSize: 30,
                        color: Colors.black,
                        onPressed: () {
                          // Navigator.push(context,
                          //     MaterialPageRoute(builder: (context) => Notifications()));
                        },
                      ),
                      Text("Share")
                    ],
                  ),
                ])
              ],
            ),
          ),
          Container(
              color: Colors.grey,
              margin: EdgeInsets.only(top: 5, bottom: 5),
              child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("2 Answers", // no of answers
                          style: TextStyle(color: Colors.black)),
                      IconButton(onPressed: () {}, icon: Icon(Icons.filter))
                    ],
                  ))),
          Padding(
            padding: const EdgeInsets.only(left: 30, right: 20, top: 5),
            child: Column(
              children: [
                Row(
                  children: [
                    InkWell(
                      child: // _image != null
                          //     ? ClipRRect(
                          //         borderRadius: BorderRadius.circular(20),
                          //         child: Image.file(
                          //           _image,
                          //           width: 40.0,
                          //           height: 40.0,
                          //           fit: BoxFit.fitHeight,
                          //         ),
                          //       ):
                          Container(
                        height: 60.0,
                        width: 60.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          color: Colors.black,
                          image: DecorationImage(
                            image:
                                AssetImage('assets/user_profile/profile.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Column(
                      children: [
                        Text("Anwered by: ", textAlign: TextAlign.left),
                        SizedBox(height: 5),
                        Text(
                          "Project Trios",
                          // ("${_user?.firstName} ${_user?.lastName}")
                          //     .toUpperCase(),
                          style: TextStyle(
                            color: themeGold,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text("August 21,2021") //date
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                        height: 30,
                        child: Text(
                            "enum MainAxisAlignment package:flutter/src/rendering/flex.dart How the children should be placed along the main axis in a flex layout. See also: [Column], [Row], and [Flex], the flex widgets. [RenderFlex], the flex render object.",
                            overflow: TextOverflow.ellipsis))
                  ],
                ),
                SizedBox(height: 5),
                Row(children: [
                  Column(
                    children: [
                      IconButton(
                        icon: Icon(Icons.note_alt_outlined),
                        iconSize: 30,
                        color: Colors.black,
                        onPressed: () {
                          // Navigator.push(context,
                          //     MaterialPageRoute(builder: (context) => Notifications()));
                        },
                      ),
                      Text("Answer")
                    ],
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Column(
                    children: [
                      IconButton(
                        icon: Icon(Icons.file_upload_outlined),
                        iconSize: 30,
                        color: Colors.black,
                        onPressed: () {
                          // Navigator.push(context,
                          //     MaterialPageRoute(builder: (context) => Notifications()));
                        },
                      ),
                      Text("Share")
                    ],
                  ),
                ])
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 8, bottom: 8, left: 20, right: 20),
            child: Divider(
              thickness: 3.0,
            ),
          ),
        ]));
  }
}
