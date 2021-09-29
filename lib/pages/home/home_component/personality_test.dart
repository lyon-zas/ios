import 'package:flutter/material.dart';
import 'package:tritek_lms/appTheme/appTheme.dart';
import 'package:tritek_lms/pages/home/home_component/p_test2.dart';
import 'package:tritek_lms/pages/notifications.dart';
import 'package:tritek_lms/pages/search.dart';

class PersonalityTest extends StatefulWidget {
  @override
  _PersonalityTestState createState() => _PersonalityTestState();
}

class _PersonalityTestState extends State<PersonalityTest> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      
      child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            elevation: 0.0,
            backgroundColor: Colors.white,
            centerTitle: true,
            title:  Text(
                          'Personality Test',
                          style: TextStyle(
                            color: themeGold,
                            fontSize: 20.0,
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
          body: ListView(
            physics: BouncingScrollPhysics(),
            children: [
              
              SizedBox(
                height: 20,
              ),
              Center(
                child: Text(
                  "Welcome to your Personality Test",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Center(
                child: Text(
                  "Find Out Which Role Suits You Best.",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Container(
                height: height - 550,
                width: width - 400,
                margin: EdgeInsets.all(10.0),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 55),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                         Image.asset(
                  "assets/personality_test.JPG",
                            // course.image
                            height: height - 550,
                            fit: BoxFit.fitHeight,
                          ),
                          // Image.asset(
                          //       'assets\FaceNetAuthentication-Logo.png',
                          //       height: 25.0,
                          //       fit: BoxFit.fitHeight,
                        ]),
                  ),
                ),
              ),
              SizedBox(
                height: 70,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 50.0,
                    width: 200,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.bottomRight,
                          stops: [0.1, 0.5, 0.9],
                          colors: [
                            Colors.yellow[300].withOpacity(0.6),
                            Colors.yellow[500].withOpacity(0.8),
                            Colors.yellow[600].withOpacity(1.0),
                          ],
                        ),
                      ),
                      child: RaisedButton(
                        onPressed: () { Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Test()));},
                        color: Colors.transparent,
                        child: Text(
                          'Get Started',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          )),
    );
  }
}
