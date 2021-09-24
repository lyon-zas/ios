import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:tritek_lms/appTheme/appTheme.dart';
import 'package:tritek_lms/pages/home/home_component/courses.home.dart';
import 'package:tritek_lms/pages/notifications.dart';
import 'package:tritek_lms/pages/search.dart';

class CoursesList extends StatefulWidget {
  @override
  _CoursesListState createState() => _CoursesListState();
}

class _CoursesListState extends State<CoursesList> {
  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        elevation:0.0,
         backgroundColor: themeBlue,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
              height: 30,
              width: 30,
              child: Center(
                child: Icon(Icons.arrow_back_ios, color:themeGold,),
              )), // this should route to the previous screen
        ),
        centerTitle: true,
        title:Text("Courses",style:TextStyle(color: themeGold, fontWeight: FontWeight.bold, fontSize:25) ,),
        actions: <Widget>[
         
          IconButton(
            icon: Icon(Icons.search),
            iconSize:30,
            color: themeGold,
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Search()));
            },
          ), IconButton(
            icon: Icon(Icons.notifications),
            iconSize:30,
            color: themeGold,
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Notifications()));
            },
          ),
        ],
      ),
      body: 
          HomeCourses(),
       
    );
  }
}
