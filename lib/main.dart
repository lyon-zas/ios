import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tritek_lms/appTheme/appTheme.dart';
import 'package:tritek_lms/appTheme/my_behaviour.dart';
import 'package:tritek_lms/pages/course/courses.dart';
import 'package:tritek_lms/pages/search.dart';
import 'package:tritek_lms/pages/search.result.dart';



import 'package:tritek_lms/pages/splashscreen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // SharedPreferences.setMockInitialValues({});

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyTritek',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.amber,
        primaryColor: themeGold,
        cursorColor: Colors.black,
      ),
      builder: (context, child) {
        return ScrollConfiguration(
          behavior: MyBehavior(),
          child: child,
        );
      },
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return SplashScreen();
  }
}
