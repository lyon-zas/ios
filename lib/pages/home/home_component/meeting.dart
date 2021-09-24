import 'package:flutter/material.dart';
import 'package:tritek_lms/appTheme/appTheme.dart';
import 'package:tritek_lms/pages/notifications.dart';
import 'package:tritek_lms/pages/search.dart';

class UpcomingMeeting extends StatefulWidget {
  
  @override
  _UpcomingMeetingState createState() => _UpcomingMeetingState();
}

class _UpcomingMeetingState extends State<UpcomingMeeting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
                  elevation: 0.0,
                  backgroundColor: Colors.transparent,
                  centerTitle: true,
                  title:  Text(
                                'UPCOMING MEETINGS',
                                style: TextStyle(
                                  color: themeGold,
                                  fontSize: 30.0,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
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
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Search()));
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.notifications),
                      iconSize: 30,
                      color: themeGold,
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Notifications()));
                      },
                    ),
                  ],
                ),
    );
  
  }
}