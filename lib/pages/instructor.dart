import 'package:flutter/material.dart';
import 'package:tritek_lms/appTheme/appTheme.dart';

class Instructor extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    getLessonTile(String title, String img, String videoLength, double width) {
      return Container(
        padding: EdgeInsets.all(10.0),
        margin: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: <BoxShadow>[
            BoxShadow(
              blurRadius: 1.5,
              spreadRadius: 1.5,
              color: Colors.grey[200],
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 100.0,
              height: 100.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(img),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
            Container(
              width: width - 140.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 8.0, bottom: 4.0, right: 8.0, left: 8.0),
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 16.0,
                        fontFamily: 'Signika Negative',
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.7,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 0.0, right: 8.0, left: 8.0, bottom: 8.0),
                    child: Text(
                      'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
                      style: TextStyle(
                        fontSize: 14.0,
                        height: 1.6,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: 0.0, right: 8.0, left: 8.0, bottom: 8.0),
                    child: Text(
                      videoLength,
                      style: TextStyle(
                        fontSize: 14.0,
                        fontFamily: 'Signika Negative',
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.7,
                        color: headingColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text('Information'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView(
        children: <Widget>[
          SizedBox(height: 10.0),
          Container(
            margin: EdgeInsets.only(right: 20.0, left: 20.0),
            alignment: Alignment.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 100.0,
                  height: 100.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50.0),
                    image: DecorationImage(
                        image: AssetImage('assets/user_profile/user_8.jpg'),
                        fit: BoxFit.cover),
                  ),
                ),
                SizedBox(height: 15.0),
                Text(
                  'Gordon Ramsey',
                  style: TextStyle(
                    fontFamily: 'Signika Negative',
                    fontSize: 20.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 15.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: 120.0,
                      padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                      child: Text(
                        'Born',
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                      child: Text(
                        'Nov 8th, 1966',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontFamily: 'Signika Negative',
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                Divider(),
                SizedBox(height: 15.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: 120.0,
                      padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                      child: Text(
                        'Country',
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                      child: Text(
                        'Scotland',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontFamily: 'Signika Negative',
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                Divider(),
                SizedBox(height: 15.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: 120.0,
                      padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                      child: Text(
                        'Style',
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                      child: Text(
                        'French, Italian, British',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontFamily: 'Signika Negative',
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                Divider(),
                SizedBox(height: 15.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: 120.0,
                      padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                      child: Text(
                        'Rating',
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            '4.5',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontFamily: 'Signika Negative',
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(width: 3.0),
                          Icon(Icons.star, size: 18.0),
                        ],
                      ),
                    ),
                  ],
                ),
                Divider(),
                SizedBox(height: 15.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: 120.0,
                      padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                      child: Text(
                        'Website',
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                      child: Text(
                        'www.example.com',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontFamily: 'Signika Negative',
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                Divider(),
              ],
            ),
          ),
          SizedBox(height: 15.0),
          Padding(
            padding: const EdgeInsets.only(right: 20.0, left: 20.0),
            child: Text(
              'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.',
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontSize: 16.0,
                letterSpacing: 0.7,
                height: 1.5,
                fontFamily: 'Signika Negative',
              ),
            ),
          ),
          SizedBox(height: 15.0),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              'Courses',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontFamily: 'Signika Negative',
                fontSize: 20.0,
              ),
            ),
          ),
          getLessonTile('Alice Water', 'assets/new_course/new_course_1.png',
              '20 Videos', width),
          getLessonTile('Gordon Ramsey', 'assets/new_course/new_course_2.png',
              '12 Videos', width),
        ],
      ),
    );
  }
}
