import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:tritek_lms/appTheme/appTheme.dart';
import 'package:tritek_lms/pages/login_signup/login.dart';
import 'package:tritek_lms/pages/login_signup/signup.dart';

class WelcomeSreen extends StatefulWidget {
  @override
  _WelcomeSreenState createState() => _WelcomeSreenState();
}

class _WelcomeSreenState extends State<WelcomeSreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: themeBlue,
      body: Column(children: [
        Container(
          color: Colors.white,
          height: MediaQuery.of(context).size.height / 2,
          child: Center(
              child: Image.asset("assets/tritek-logo.png",
                  height: 70, fit: BoxFit.fitHeight)),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height / 2,
          child: Container(
            color: themeBlue,
            child: Column(
              mainAxisAlignment:MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(height: 20),
                RichText(
                    text: TextSpan(children: [
                  TextSpan(
                    text: "Welcome to ",
                    style: TextStyle(
                      fontFamily: 'Signika Negative',
                      fontWeight: FontWeight.w700,
                      fontSize: 27.0,
                      color: Colors.white,
                    ),
                  ),
                  TextSpan(
                    text: appName,
                    style: TextStyle(
                      fontFamily: 'Signika Negative',
                      fontWeight: FontWeight.w700,
                      fontSize: 27.0,
                      color: themeGold,
                    ),
                  ),
                ])),

                //   ),
                // ),
                SizedBox(height: 15),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 80),
                      child: RaisedButton(
                          elevation: 70.0,
                          child: Center(
                            child: Text(
                              "Sign in",
                              style: TextStyle(
                                fontFamily: 'Signika Negative',
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                PageTransition(
                                    type: PageTransitionType.rightToLeft,
                                    child: Login(null, null)));
                          }),
                    ),
                  ],
                ),
                SizedBox(height: 40),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 80),
                      child: RaisedButton(
                          elevation: 50.0,
                          child: Center(
                            child: Text(
                              "Register",
                              style: TextStyle(
                                fontFamily: 'Signika Negative',
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                PageTransition(
                                    type: PageTransitionType.rightToLeft,
                                    child: SignUp()));
                          }),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Divider(
                    color: Colors.white,
                    height: 1.0,
                    thickness: 1.0,
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  alignment: Alignment.bottomCenter,
                  child: Text(
                    "It's Brewing....",
                    style: TextStyle(
                      fontFamily: 'Signika Negative',
                      fontSize: 15.0,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ]),
    );
  }
}
