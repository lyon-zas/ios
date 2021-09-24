import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:tritek_lms/FRS/db/database.dart';
import 'package:tritek_lms/appTheme/appTheme.dart';
import 'package:tritek_lms/blocs/course.bloc.dart';
import 'package:tritek_lms/blocs/notificationsBloc.dart';
import 'package:tritek_lms/blocs/settings.bloc.dart';
import 'package:tritek_lms/data/entity/users.dart';
import 'package:tritek_lms/pages/login_signup/termsAndcond.dart';
import 'package:tritek_lms/pages/notifications.dart';
import 'package:tritek_lms/pages/search.dart';

class AppSettings extends StatefulWidget {
  @override
  _AppSettingsState createState() => _AppSettingsState();
}

class _AppSettingsState extends State<AppSettings> {
  // bool cellularData;
  bool cellularData = true;
  bool notifications = false;
  String notificationTime = '..:..';
  bool standard = true;
  bool high = false;
  bool delete = true;
  bool frt = false;
  Users _user;
  DataBaseService _dataBaseService = DataBaseService();
  @override
  void initState() {
    super.initState();

    bloc.userSubject.listen((value) {
      if (!mounted) {
        return;
      }
      setState(() {
        _user = value?.results;
      });
    });
    settingsBloc.getSettings();

    settingsBloc.notifications.listen((value) {
      if (!mounted) {
        return;
      }

      setState(() {
        notifications = value;
      });
    });

    settingsBloc.cellularData.listen((value) {
      if (!mounted) {
        return;
      }

      setState(() {
        cellularData = value;
      });
    });

    settingsBloc.notificationTime.listen((value) {
      if (!mounted) {
        return;
      }

      setState(() {
        notificationTime = value;
      });
    });

    settingsBloc.frt.listen((switchValue) {
      if (!mounted) {
        return;
      }

      setState(() {
        frt = switchValue;
      });
    });

    settingsBloc.videoQuality.listen((value) {
      if (!mounted) {
        return;
      }

      setState(() {
        high = value == 2;
        standard = value == 1;
      });
    });
    bloc.getUser();
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    Container getDivider(Color color) {
      return Container(
        height: 1.0,
        width: width,
        margin: EdgeInsets.only(top: 15.0, bottom: 15.0),
        color: color,
      );
    }

    nestedAppBar() {
      return NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: 50,
              backgroundColor: themeBlue,
              pinned: true,
              leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: themeGold,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              actions: <Widget>[
                Container(
                    margin: EdgeInsets.only(top: 60, left: 20),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                          height: 30,
                          width: 30,
                          child: Center(
                            child: Icon(Icons.arrow_back_ios, color: themeGold),
                          )), // this should route to the previous screen
                    )),
                IconButton(
                  icon: Icon(Icons.notifications),
                  color: themeGold,
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Notifications()));
                  },
                ),
                IconButton(
                  icon: Icon(Icons.search),
                  color: themeGold,
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Search()));
                  },
                ),
              ],
              flexibleSpace: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                // top = constraints.biggest.height;
                return FlexibleSpaceBar(
                    centerTitle: true,
                    title: AnimatedOpacity(
                      duration: Duration(milliseconds: 300),
                      //opacity: top == 80.0 ? 1.0 : 0.0,
                      opacity: 1.0,
                      child: Text(
                        'SETTINGS',
                        style: TextStyle(
                          fontFamily: 'Signika Negative',
                          fontWeight: FontWeight.w700,
                          fontSize: 20.0,
                          color: themeGold,
                        ),
                      ),
                    ),
                    background: Container(
                      padding: EdgeInsets.all(20.0),
                      alignment: Alignment.bottomLeft,
                      decoration: BoxDecoration(color: themeBlue),
                    ));
              }),
              automaticallyImplyLeading: false,
            ),
          ];
        },
        body: ListView(
          children: <Widget>[
            SizedBox(height: 5.0),
            Container(
               padding: const EdgeInsets.symmetric(horizontal: 20.0),
               alignment: Alignment.centerLeft,
              child: Text(
                "Subscription",
                style: TextStyle(
                  color: themeBlue,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Signika Negative',
                ),
              ),
            ),
             Container(
               padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical:5),
               alignment: Alignment.centerLeft,
               child: Text(
                        _user.subscription != null
                            ? 'Your Current Membership Plan is'
                            : '',
                        style: TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
             ),
                    Spacer(),
                    Container(
               padding: const EdgeInsets.symmetric(horizontal: 20.0),
               alignment: Alignment.centerLeft,
                      child: AutoSizeText(
                        _user.subscription != null
                            ? _user.subscription
                            : 'You Have No Active Subscription',
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold,
                          color: themeGold,
                        ),
                      ),
                    ),

                   Container(
               padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical:5),
               alignment: Alignment.centerLeft,
                      child: AutoSizeText(
                        _user.subscription != null
                            ? 'Valid Until ' + getDate(_user)
                            : '',
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold,
                          color: themeBlue,
                        ),
                      ),
                    ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right:230),
              child: Container(
                 
                 alignment: Alignment.centerLeft,
                color: themeBlue,
                height: 50,
                width: 170,
                child: RaisedButton(
                  elevation: 5.0,
                  color: themeBlue,
                  onPressed: () {},
                  child: Center(
                      child: Text("Change Subscription",
                          style: TextStyle(
                            color: themeGold,
                          ))),
                ),
              ),
            ),
            getDivider(Colors.grey[300]),
            SizedBox(height: 10.0),
            Container(
              margin: EdgeInsets.only(right: 20.0, left: 20.0),
              width: width - 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Cellular',
                    style: TextStyle(
                      color: themeBlue,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Signika Negative',
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Cellular Data for Videos',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Signika Negative',
                        ),
                      ),
                      // if (cellularData)
                      //   CustomSwitch(
                      //     activeColor: textColor,
                      //     value: false,
                      //     onChanged: (value) {
                      //       settingsBloc.setCellularData(value);
                      //     },
                      //   ),
                      // if (!cellularData)
                      Switch(
                        activeColor: textColor,
                        value: cellularData,
                        onChanged: (value) {
                          settingsBloc.setCellularData(value);
                        },
                      ),
                    ],
                  ),
                  getDivider(Colors.grey[300]),
                  SizedBox(height: 10.0),
                  Text(
                    'Video Quality',
                    style: TextStyle(
                      color: themeBlue,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Signika Negative',
                    ),
                  ),
                  SizedBox(height: 15.0),
                  InkWell(
                    onTap: () {
                      settingsBloc.setVideoQuality(1);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Standard (recommended)',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Signika Negative',
                              ),
                            ),
                            SizedBox(height: 8.0),
                            Text(
                              'Load faster and uses less data',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w700,
                                color: Colors.grey[400],
                                fontFamily: 'Signika Negative',
                              ),
                            ),
                          ],
                        ),
                        Icon(
                          (standard) ? Icons.check : null,
                          size: 25.0,
                        ),
                      ],
                    ),
                  ),
                  getDivider(Colors.grey[300]),
                  InkWell(
                    onTap: () {
                      settingsBloc.setVideoQuality(2);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'High Definition',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Signika Negative',
                              ),
                            ),
                            SizedBox(height: 8.0),
                            Text(
                              'Use more data',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w700,
                                color: Colors.grey[400],
                                fontFamily: 'Signika Negative',
                              ),
                            ),
                          ],
                        ),
                        Icon(
                          (high) ? Icons.check : null,
                          size: 25.0,
                        ),
                      ],
                    ),
                  ),
                  getDivider(Colors.grey[300]),
                  SizedBox(height: 10.0),
                  Text(
                    'Notifications',
                    style: TextStyle(
                      color: themeBlue,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Signika Negative',
                    ),
                  ),
                  SizedBox(height: 15.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Turn on Daily Notifications',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Signika Negative',
                        ),
                      ),
                      Switch(
                        activeColor: textColor,
                        value: notifications,
                        onChanged: (value) {
                          settingsBloc.setNotifications(value);
                          if (value) {
                            turnOnNotifications();
                          } else {
                            notificationsBloc.cancelAllNotifications();
                          }
                        },
                      ),
                    ],
                  ),
                  getDivider(Colors.grey[300]),
                  InkWell(
                    onTap: () {
                      if (!notifications) {
                        return;
                      }
                      setTime();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Notification Time',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Signika Negative',
                              ),
                            ),
                            SizedBox(height: 8.0),
                            Text(
                              notificationTime,
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w700,
                                color: Colors.grey[400],
                                fontFamily: 'Signika Negative',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  getDivider(Colors.grey[300]),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Enable Facial Recognition',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Signika Negative',
                        ),
                      ),
                      Switch(
                        activeColor: textColor,
                        value: frt,
                        onChanged: (switchValue) {
                          settingsBloc.setFRT(switchValue);
                          if (switchValue) {
                            Navigator.push(
                                context,
                                PageTransition(
                                    type: PageTransitionType.rightToLeft,
                                    child: TermsAndConditions()));
                          } else {
                            showDialog(
                                context: context,
                                builder: (ctxt) => new AlertDialog(
                                      title: Text(
                                          "Are you sure you want to delete FRT data?"),
                                      actions: <Widget>[
                                        new FlatButton(
                                          child: Text("No"),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                        new FlatButton(
                                          child: new Text("Yes"),
                                          onPressed: () async {
                                            await _dataBaseService.cleanDB();
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ],
                                    ));
                            // _dataBaseService.cleanDB();
                          }
                        },
                      ),
                    ],
                  ),
                  getDivider(Colors.grey[300]),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      body: nestedAppBar(),
    );
  }

  void setTime() async {
    Future<TimeOfDay> selectedTime = showTimePicker(
      initialTime: TimeOfDay.now(),
      context: context,
    );

    String twoDigits(int n) => n.toString().padLeft(2, "0");
    selectedTime.then((value) => {
          settingsBloc.setNotificationTime(
              twoDigits(value.hour) + ':' + twoDigits(value.minute)),
          notificationsBloc.scheduleDailyTenAMNotification(
              'Time to continue your lessons!',
              'Continue your lessons on MyTritek App',
              value.hour,
              value.minute),
          print(value.toString())
        });
  }

  void turnOnNotifications() async {
    if (Platform.isIOS) {
      final bool result = await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );

      if (result) {
        notificationsBloc.displayNotification(
            'MyTritek Notifications', 'Notifications turned On', '');
        settingsBloc.setNotifications(true);
      }
    } else {
      notificationsBloc.displayNotification(
          'MyTritek Notifications', 'Notifications turned On', '');
      settingsBloc.setNotifications(true);
    }
  }

  String getDate(Users user) {
    if (user.endDate == null) {
      return "..";
    }

    DateTime tempDate =
        new DateFormat("yyyy-MM-dd hh:mm:ss").parse(user.endDate);
    return DateFormat("MMMM dd, yyyy").format(tempDate);
  }

  bool dateDiff(Users user) {
    if (user.endDate == null) {
      return true;
    }

    DateTime tempDate =
        new DateFormat("yyyy-MM-dd hh:mm:ss").parse(user.endDate);
    DateTime n = DateTime.now();
    return tempDate.difference(n).inDays < 40;
  }
}
