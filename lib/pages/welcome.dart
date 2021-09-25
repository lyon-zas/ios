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
      backgroundColor: themeBlue,
      body: ListView(
        children: [
          Container(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                SizedBox(height: 70),
                RichText(
                    text: TextSpan(children: [
                  TextSpan(
                    text: "Welcome to ",
                    style: TextStyle(
                      fontFamily: 'Signika Negative',
                      fontWeight: FontWeight.w700,
                      fontSize: 30.0,
                      color: Colors.white,
                    ),
                  ),
                  TextSpan(
                    text: appName,
                    style: TextStyle(
                      fontFamily: 'Signika Negative',
                      fontWeight: FontWeight.w700,
                      fontSize: 30.0,
                      color: themeGold,
                    ),
                  ),
                ])),
                SizedBox(height: 60),
                Image.asset("assets/logo.png",
                    height: 90, fit: BoxFit.fitHeight),
                SizedBox(height: 50),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 65),
                  child: Text(
                    '''These terms and conditions are in addition to the Website Disclaimer and apply to the sale of any courses/services. ''',
                    style: TextStyle(
                      fontFamily: 'Signika Negative',
                      fontWeight: FontWeight.w700,
                      fontSize: 15.0,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height / 7),
                Column(
                  children: [
                    Text(
                      "Already have An account?",
                      style: TextStyle(
                        fontFamily: 'Signika Negative',
                        fontSize: 15.0,
                        color: Colors.white,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 80),
                      child: RaisedButton(
                          elevation: 50.0,
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
                    Text(
                      "New Here?",
                      style: TextStyle(
                        fontFamily: 'Signika Negative',
                        fontSize: 13.0,
                        color: Colors.white,
                      ),
                    ),
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
                SizedBox(height: 45),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Divider(
                    color: Colors.white,
                    height: 1.0,
                    thickness: 1.0,
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height / 8),
                Text(
                  "It's Brewing",
                  style: TextStyle(
                    fontFamily: 'Signika Negative',
                    fontSize: 15.0,
                    color: Colors.white,
                  ),
                ),
              ])),
        ],
      ),
    );
  }
}
