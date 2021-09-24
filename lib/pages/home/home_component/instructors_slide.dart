import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tritek_lms/pages/instructor.dart';

class InstructorHomeSlide extends StatefulWidget {
  @override
  _InstructorHomeSlideState createState() => _InstructorHomeSlideState();
}

class _InstructorHomeSlideState extends State<InstructorHomeSlide> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Container(
      width: width,
      height: 340.0,
      color: Theme.of(context).appBarTheme.color,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              'Instructors',
              textAlign: TextAlign.start,
              style: TextStyle(
                color: Colors.black,
                fontSize: 18.0,
                fontWeight: FontWeight.w700,
                fontFamily: 'Signika Negative',
                letterSpacing: 0.7,
              ),
            ),
          ),
          Container(
            height: 280.0,
            child: FutureBuilder<List<Instructors>>(
              future: loadInstructors(),
              builder: (context, snapshot) {
                if (snapshot.hasError) print(snapshot.error);

                return snapshot.hasData
                    ? ListView.builder(
                        itemCount: snapshot.data.length,
                        scrollDirection: Axis.horizontal,
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (BuildContext ctxt, int index) {
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Instructor()));
                            },
                            child: Container(
                              width: 180.0,
                              height: 200.0,
                              margin: EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20.0),
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 1.5,
                                    spreadRadius: 1.5,
                                    color: Colors.grey[300],
                                  )
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    height: 150.0,
                                    width: 200.0,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20.0),
                                        topRight: Radius.circular(20.0),
                                      ),
                                    ),
                                    child: Container(
                                      height: 130.0,
                                      width: 130.0,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(65.0),
                                        image: DecorationImage(
                                          image: AssetImage(snapshot
                                              .data[index].instructorImage),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(10.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          snapshot.data[index].instructorName,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 10.0),
                                        Text(
                                          snapshot.data[index].instructorRole,
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 14.0,
                                          ),
                                        ),
                                        Divider(),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                              snapshot
                                                  .data[index].instructorRating,
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Icon(
                                              Icons.star,
                                              size: 17.0,
                                            ),
                                            SizedBox(
                                              width: 5.0,
                                            ),
                                            Text(
                                              '(${snapshot.data[index].instructorNumberOfRating} Reviews)',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        })
                    : Center(
                        child: SpinKitRipple(color: Colors.red),
                      );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class Instructors {
  int instructorId;
  String instructorImage;
  String instructorName;
  String instructorRole;
  String instructorRating;
  String instructorNumberOfRating;

  Instructors(
      this.instructorId,
      this.instructorImage,
      this.instructorName,
      this.instructorRole,
      this.instructorRating,
      this.instructorNumberOfRating);
}

Future<List<Instructors>> loadInstructors() async {
  var jsonString = await rootBundle.loadString('assets/json/instructors.json');
  final jsonResponse = json.decode(jsonString);

  List<Instructors> instructors = [];

  for (var o in jsonResponse) {
    Instructors course = Instructors(
        o["instructorId"],
        o["image"],
        o["instructorName"],
        o["instructorRole"],
        o["instructorRating"],
        o["instructorNumberOfRating"]);

    instructors.add(course);
  }

  return instructors;
}
