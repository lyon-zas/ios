import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tritek_lms/appTheme/appTheme.dart';
import 'package:tritek_lms/blocs/user.bloc.dart';
import 'package:tritek_lms/data/entity/users.dart';
import 'package:tritek_lms/pages/login_signup/login.dart';
import 'package:tritek_lms/pages/payment/select_plan.dart';

class MembershipSettings extends StatefulWidget {
  @override
  _MembershipSettingsState createState() => _MembershipSettingsState();
}

class _MembershipSettingsState extends State<MembershipSettings> {
  File _image;
  Users _user;
  bool routed = false;

  @override
  void initState() {
    super.initState();
    userBloc.userSubject.listen((value) {
      if (!mounted) {
        return;
      }
      setState(() {
        _user = value.results;
      });
    });

    userBloc.userStatus.listen((value) {
      if (!mounted) {
        return;
      }
      if (value == false && !routed) {
        logout();
        routed = true;
        return;
      }
    });

    userBloc.image.listen((value) {
      if (!mounted) {
        return;
      }

      setState(() {
        _image = value;
      });
    });

    userBloc.getUser();
    userBloc.getImage();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: themeBg,
      body: ListView(
        children: [
          Container(
            width: double.infinity,
            height: 350.0,
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 300.0,
                  color: themeBlue,
                ),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(top: 70.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                        child: GestureDetector(
                          onTap: () {},
                          child: CircleAvatar(
                            radius: 55,
                            backgroundColor: themeGold,
                            child: _image != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: Image.file(
                                      _image,
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.fitHeight,
                                    ),
                                  )
                                : Container(
                                    decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius:
                                            BorderRadius.circular(50)),
                                    width: 100,
                                    height: 100,
                                    child: Icon(
                                      Icons.camera_alt,
                                      color: Colors.grey[800],
                                    ),
                                  ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Text(
                        ("${_user?.firstName} ${_user?.lastName}")
                            .toUpperCase(),
                        style: TextStyle(
                          color: themeGold,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                if (_user != null)
                  Positioned(
                    bottom: 3.0,
                    left: 0.0,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: Material(
                        elevation: 3.0,
                        borderRadius: BorderRadius.circular(10.0),
                        child: Container(
                          height: 110.0,
                          padding: EdgeInsets.all(20.0),
                          width: MediaQuery.of(context).size.width - 40.0,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.white,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                _user.endDate != null
                                    ? 'Your Current Membership Plan is'
                                    : '',
                                style: TextStyle(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              Spacer(),
                              AutoSizeText(
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
                              Spacer(),
                              AutoSizeText(
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
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                if (_user == null)
                  Positioned(
                    bottom: 3.0,
                    left: 0.0,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: Material(
                        elevation: 3.0,
                        borderRadius: BorderRadius.circular(10.0),
                        child: Container(
                          height: 100.0,
                          padding: EdgeInsets.all(20.0),
                          width: MediaQuery.of(context).size.width - 40.0,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.white,
                          ),
                          child: Text(
                            'You are yet to login',
                            style: TextStyle(
                              fontSize: 28.0,
                              fontWeight: FontWeight.bold,
                              color: themeBlue,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(height: 10),
          if (_user != null && dateDiff(_user))
            Container(
              width: double.infinity,
              alignment: Alignment.center,
              child: InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SelectPlan()));
                },
                borderRadius: BorderRadius.circular(30.0),
                child: Material(
                  elevation: 1.0,
                  borderRadius: BorderRadius.circular(30.0),
                  child: Container(
                    padding: EdgeInsets.fromLTRB(40.0, 15.0, 40.0, 15.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.0),
                      color: themeBlue,
                    ),
                    child: Text(
                      _user.endDate != null
                          ? 'Renew Subscription'.toUpperCase()
                          : 'Buy Subscription'.toUpperCase(),
                      style: TextStyle(
                        color: themeGold,
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          SizedBox(height: 10.0),
          if (_user == null)
            Container(
              width: double.infinity,
              alignment: Alignment.center,
              child: InkWell(
                onTap: () {
                  logout();
                },
                borderRadius: BorderRadius.circular(30.0),
                child: Material(
                  elevation: 1.0,
                  borderRadius: BorderRadius.circular(30.0),
                  child: Container(
                    padding: EdgeInsets.fromLTRB(40.0, 15.0, 40.0, 15.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.0),
                      color: themeGold,
                    ),
                    child: Text(
                      'Login'.toUpperCase(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          SizedBox(height: 10)
        ],
      ),
    );
  }

  profileTile(icon, title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: Color(0xFF0BC9E3),
            size: 28.0,
          ),
          SizedBox(width: 10.0),
          Text(
            title,
            style: TextStyle(
              color: Colors.black,
              fontSize: 16.0,
            ),
          )
        ],
      ),
    );
  }

  void logout() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => Login(null, null)));
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
    return tempDate
        .difference(n)
        .inDays < 40;
  }
}
