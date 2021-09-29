import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:tritek_lms/appTheme/appTheme.dart';
import 'package:tritek_lms/blocs/notificationsBloc.dart';
import 'package:tritek_lms/blocs/user.bloc.dart';
import 'package:tritek_lms/pages/welcome.dart';

import 'home/home.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _ping = false;
  bool _error = false;

  @override
  void initState() {
    super.initState();

    userBloc.pingSubject.listen((value) {
      if (!mounted) {
        return;
      }

      if (value != null && value.data != null && !_ping) {
        setState(() {
          _ping = true;
        });
        Timer(
            Duration(seconds: 2),
            () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Home()),
                ));
      }

      if (value != null && value.error != null && !_error) {
        setState(() {
          _error = true;
        });
      }
    });

    if (_ping) {
      Timer(
          Duration(seconds: 1),
          () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => WelcomeSreen()),
              ));
    }

    userBloc.pingServer();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    initNotifications();

    return Scaffold(
      backgroundColor: themeBlue,
      body: Container(
        height: height,
        width: width,
        color: themeBlue,
        margin: EdgeInsets.all(10.0),
        child: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 50),
                Image.asset("assets/logo.png",
                    height: 100, fit: BoxFit.fitHeight),
                SizedBox(height: 50),
              ]),
        ),
      ),
      bottomSheet: Container(
        height: 20,
        width: width,
        color: themeBlue,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            if (!_error) SpinKitRipple(color: themeGold),
            Text(
              _error
                  ? 'An error has occurred. Please check your internet connection'
                  : '...loading',
              style: TextStyle(
                fontFamily: 'Signika Negative',
                fontWeight: FontWeight.w700,
                fontSize: 12.0,
                color: themeGold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void initNotifications() async {
    await _configureLocalTimeZone();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    /// Note: permissions aren't requested here just to demonstrate that can be
    /// done later
    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
            requestAlertPermission: false,
            requestBadgePermission: false,
            requestSoundPermission: false,
            onDidReceiveLocalNotification:
                (int id, String title, String body, String payload) async {
              notificationsBloc.didReceiveLocalNotificationSubject.add(
                  ReceivedNotification(
                      id: id, title: title, body: body, payload: payload));
            });
    const MacOSInitializationSettings initializationSettingsMacOS =
        MacOSInitializationSettings(
            requestAlertPermission: false,
            requestBadgePermission: false,
            requestSoundPermission: false);
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS,
            macOS: initializationSettingsMacOS);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String payload) async {
      if (payload != null) {
        debugPrint('notification payload: $payload');
      }
      notificationsBloc.selectNotificationSubject.add(payload);
    });
  }

  Future<void> _configureLocalTimeZone() async {
    tz.initializeTimeZones();
    // final String currentTimeZone = await FlutterNativeTimezone.getLocalTimezone();
    // tz.setLocalLocation(tz.getLocation(currentTimeZone));
  }
}
