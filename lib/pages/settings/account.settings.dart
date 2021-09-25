import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tritek_lms/appTheme/appTheme.dart';
import 'package:tritek_lms/blocs/user.bloc.dart';
import 'package:tritek_lms/custom/form.validators.dart';
import 'package:tritek_lms/data/entity/users.dart';
import 'package:tritek_lms/data/repository/user.repository.dart';
import 'package:tritek_lms/http/user.dart';
import 'package:tritek_lms/pages/common/dialog.dart';
import 'package:tritek_lms/pages/login_signup/login.dart';
import 'package:tritek_lms/pages/notifications.dart';
import 'package:tritek_lms/pages/search.dart';
import 'package:tritek_lms/pages/settings/edit.profile.dart';

class AccountSettings extends StatefulWidget {
  @override
  _AccountSettingsState createState() => _AccountSettingsState();
}

class _AccountSettingsState extends State<AccountSettings> {
  File _image;
  Users _user;
  bool routed = false;

  final _formKey = GlobalKey<FormState>();
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  final bloc = UserBloc();
  final UserRepository _repository = UserRepository();

  String oldPassword;
  String password;
  String cPassword;

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

    bloc.userStatus.listen((value) {
      if (!mounted) {
        return;
      }
      if (value == false && !routed) {
        logout();
        routed = true;
        return;
      }
    });

    bloc.image.listen((value) {
      if (!mounted) {
        return;
      }
      setState(() {
        _image = value;
      });
    });

    bloc.getUser();
    bloc.getImage();
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    changePassword() {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          // return object of type Dialog
          return Dialog(
            elevation: 0.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            child: Container(
              height: 295.0,
              padding: EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Change Your Password",
                      style: TextStyle(
                        fontFamily: 'Signika Negative',
                        fontSize: 21.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    TextFormField(
                      obscureText: true,
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Signika Negative',
                      ),
                      validator: (value) {
                        return Validator.required(
                            value, 1, 'Old Password is required');
                      },
                      onSaved: (_op) => oldPassword = _op,
                      decoration: InputDecoration(
                        hintText: 'Old Password',
                        hintStyle: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 16.0,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Signika Negative',
                        ),
                      ),
                    ),
                    TextFormField(
                      obscureText: true,
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Signika Negative',
                      ),
                      validator: (value) {
                        return Validator.password(value);
                      },
                      onSaved: (_password) => password = _password,
                      decoration: InputDecoration(
                        hintText: 'New Password',
                        hintStyle: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 16.0,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Signika Negative',
                        ),
                      ),
                    ),
                    TextFormField(
                      obscureText: true,
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Signika Negative',
                      ),
                      validator: (value) {
                        return Validator.password(value);
                      },
                      onSaved: (_cpassword) => cPassword = _cpassword,
                      decoration: InputDecoration(
                        hintText: 'Confirm New Password',
                        hintStyle: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 16.0,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Signika Negative',
                        ),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            width: (width / 3.5),
                            alignment: Alignment.center,
                            padding: EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                fontFamily: 'Signika Negative',
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            if (_formKey.currentState.validate()) {
                              _formKey.currentState.save();
                              Navigator.pop(context);
                              _changePassword();
                            }
                          },
                          child: Container(
                            width: (width / 3.5),
                            alignment: Alignment.center,
                            padding: EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              color: textColor,
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: Text(
                              'Okay',
                              style: TextStyle(
                                fontFamily: 'Signika Negative',
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    }

    logoutDialogue() {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return WillPopScope(
              onWillPop: () async => false,
              child: Dialog(
                elevation: 0.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                child: Container(
                  height: 200.0,
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "You sure want to logout?",
                        style: TextStyle(
                          fontFamily: 'Signika Negative',
                          fontSize: 21.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              width: (width / 3.5),
                              alignment: Alignment.center,
                              padding: EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              child: Text(
                                'Cancel',
                                style: TextStyle(
                                  fontFamily: 'Signika Negative',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                              LoadingDialogs.showLoadingDialog(
                                  context, _keyLoader, 'Log out in process...');
                              userBloc.logout().then((_) =>
                              {
                                setState(() {
                                  _user = null;
                                }),

                                Navigator.of(_keyLoader.currentContext,
                                    rootNavigator: true)
                                    .pop(),
                                logout(),
                              });
                            },
                            child: Container(
                              width: (width / 3.5),
                              alignment: Alignment.center,
                              padding: EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                color: textColor,
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              child: Text(
                                'Log out',
                                style: TextStyle(
                                  fontFamily: 'Signika Negative',
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
          );
        },
      );
    }

    itemTile(width, icon, title, subtitle) {
      return Container(
        width: width,
        padding: EdgeInsets.fromLTRB(30.0, 5, 30, 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 56.0,
                  width: 56.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(28.0),
                    color: Colors.grey[300],
                  ),
                  alignment: Alignment.center,
                  child: Icon(icon, size: 28.0, color: themeBlue),
                ),
                SizedBox(width: 12.0),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 17.0,
                          fontWeight: FontWeight.bold,
                          color: themeBlue,
                        ),
                      ),
                      SizedBox(height: 5.0),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 15.0,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.0),
            Container(
              width: width - 30.0,
              height: 1.0,
              margin: EdgeInsets.symmetric(horizontal: 15.0),
              color: Colors.grey[200],
            ),
          ],
        ),
      );
    }

    return Scaffold(
      
        appBar: AppBar(
          leading: Container(
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
          backgroundColor: themeBlue,
        centerTitle: true,
        title: Text(
          "Account",
          style: TextStyle(color: themeGold),
        ),
        actions: <Widget>[
         
          IconButton(
            icon: Icon(Icons.notifications),
            color: themeGold,
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Notifications()));
            },
          ),
          IconButton(
            icon: Icon(Icons.search),
            color: themeGold,
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Search()));
            },
          ),
        ],
        automaticallyImplyLeading: false,
      ),
      
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          Container(
            width: double.infinity,
            height: 150.0,
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 100.0,
                  color: Colors.white,
                ),
                Container(
                  width: double.infinity,
                 
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                        child: GestureDetector(
                          onTap: () {},
                          child: CircleAvatar(
                            radius: 55,
                            backgroundColor: Color(0xffFDCF09),
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
                     
                     
                      
                      if (_user != null)
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                       SizedBox(width: 10.0),
                        SizedBox(height: 60.0),
                    Container(
                  
                      child: Text(
                        ("${_user?.firstName} ${_user?.lastName}")
                            .toUpperCase(),
                        style: TextStyle(
                          color: themeGold,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                      Row(
                        children: [
                          Text(
                            _user.subscription != null
                                ? 'Membership Plan: '
                                : '',
                            style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                           AutoSizeText(
                        _user.subscription != null
                            ? _user.subscription
                            : 'You Have No Active Subscription',
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: themeGold,
                        ),
                      ),
                        ],
                      ),
                      SizedBox(height:5),
                      AutoSizeText(
                        _user.subscription != null
                            ? 'Valid Until ' + getDate(_user)
                            : '',
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                          color: themeBlue,
                        ),
                      ), 
                    ],
                  ),
                  SizedBox(height:20),
                  Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                              height: 56.0,
                              width: 56.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(28.0),
                                color: themeBlue,
                              ),
                              alignment: Alignment.center,
                              child: IconButton(
                                onPressed: () {
                                  if (_user != null)
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                EditProfile(_user, _image)));
                                },
                                iconSize: 48,
                                icon: Icon(Icons.edit,
                                    size: 28.0, color: themeGold),
                              ),
                            ),
                    ],
                  ),
                    ],
                  ),
                ),
                // if (_user != null)
                //   Positioned(
                //     bottom: 3.0,
                //     left: 0.0,
                //     child: Padding(
                //       padding: EdgeInsets.symmetric(horizontal: 20.0),
                //       child: Material(
                //         elevation: 3.0,
                //         borderRadius: BorderRadius.circular(10.0),
                //         child: Container(
                //           height: 100.0,
                //           padding: EdgeInsets.all(20.0),
                //         width: MediaQuery.of(context).size.width - 40.0,
                //         alignment: Alignment.center,
                //         decoration: BoxDecoration(
                //           borderRadius: BorderRadius.circular(10.0),
                //           color: Colors.white,
                //         ),
                //         child: Row(
                //           mainAxisAlignment: MainAxisAlignment.start,
                //           children: [
                //             Text(
                //               'Account Info',
                //               style: TextStyle(
                //                 fontSize: 28.0,
                //                 fontWeight: FontWeight.bold,
                //                 color: themeBlue,
                //               ),
                //             ),
                //             Spacer(),
                //             Container(
                //               height: 56.0,
                //               width: 56.0,
                //               decoration: BoxDecoration(
                //                 borderRadius: BorderRadius.circular(28.0),
                //                 color: themeBlue,
                //               ),
                //               alignment: Alignment.center,
                //               child: IconButton(
                //                 onPressed: () {
                //                   if (_user != null)
                //                     Navigator.push(
                //                         context,
                //                         MaterialPageRoute(
                //                             builder: (context) =>
                //                                 EditProfile(_user, _image)));
                //                 },
                //                 iconSize: 48,
                //                 icon: Icon(Icons.edit,
                //                     size: 28.0, color: themeGold),
                //               ),
                //             ),
                //           ],
                //         ),
                //         ),
                //       ),
                //     ),
                //   ),

                // if (_user == null)
                //   Positioned(
                //     bottom: 3.0,
                //     left: 0.0,
                //     child: Padding(
                //       padding: EdgeInsets.symmetric(horizontal: 20.0),
                //       child: Material(
                //         elevation: 3.0,
                //         borderRadius: BorderRadius.circular(10.0),
                //         child: Container(
                //           height: 100.0,
                //           padding: EdgeInsets.all(20.0),
                //           width: MediaQuery
                //               .of(context)
                //               .size
                //               .width - 40.0,
                //           alignment: Alignment.center,
                //           decoration: BoxDecoration(
                //             borderRadius: BorderRadius.circular(10.0),
                //             color: Colors.white,
                //           ),
                //           child: Text(
                //             'You are yet to login',
                //             style: TextStyle(
                //               fontSize: 28.0,
                //               fontWeight: FontWeight.bold,
                //               color: themeBlue,
                //             ),
                //           ),
                //         ),
                //       ),
                //     ),
                //   ),
                //  Container(
                //           height: 56.0,
                //           width: 56.0,
                //           decoration: BoxDecoration(
                //             borderRadius: BorderRadius.circular(28.0),
                //             color: themeBlue,
                //           ),
                //           alignment: Alignment.center,
                //           child: IconButton(
                //             onPressed: () {
                //               if (_user != null)
                //                 Navigator.push(
                //                     context,
                //                     MaterialPageRoute(
                //                         builder: (context) =>
                //                             EditProfile(_user, _image)));
                //             },
                //             iconSize: 48,
                //             icon: Icon(Icons.edit,
                //                 size: 28.0, color: themeGold),
                //           ),
                //         ),
              ],
            ),
          ),
          
          SizedBox(height: 25.0),
          Divider(),
          if (_user != null)
            Container(
              padding: EdgeInsets.fromLTRB(20.0, 4, 20, 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10.0),
                  itemTile(width, Icons.person, 'Username', _user?.username),
                  // itemTile(width, Icons.phone, 'Mobile', '+1 123456789'),
                  itemTile(width, Icons.email, 'Email', _user?.email),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        itemTile(width - 100, Icons.lock, 'Password',
                            '\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022'),
                        // Spacer(),
                        Container(
                          height: 56.0,
                          width: 56.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(28.0),
                            color: themeBlue,
                          ),
                          alignment: Alignment.center,
                          child: IconButton(
                            onPressed: () {
                              changePassword();
                            },
                            iconSize: 48,
                            icon:
                            Icon(Icons.edit, size: 28.0, color: themeGold),
                          ),
                        ),
                      ])
                ],
              ),
            ),

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
        context,
        MaterialPageRoute(
            builder: (context) => Login(null, null)));
  }

  Future<void> _changePassword() async {
    if (password != cPassword) {
      ServerValidationDialog.errorDialog(
          context, 'Password does NOT match', '');
      return;
    }

    try {
      LoadingDialogs.showLoadingDialog(
          context, _keyLoader, 'Processing your update...');

      RegisterResponse _response = await _repository.changePassword(
          _user.email, password, oldPassword);
      if (_response.error.length > 0) {
        Navigator.of(_keyLoader.currentContext, rootNavigator: true)
            .pop();
        ServerValidationDialog.errorDialog(
            context, _response.error, _response.eTitle); //invoking log
      } else {
        Navigator.of(_keyLoader.currentContext, rootNavigator: true)
            .pop();

        ServerValidationDialog.errorDialog(
            context, 'Password Changed Successfully', ''); //invoking log
      }
    } catch (error) {
      Navigator.of(_keyLoader.currentContext, rootNavigator: true)
          .pop();
      ServerValidationDialog.errorDialog(
          context, 'An Error Occurred! Please try again', ''); //invoking log
      print(error);
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
    return tempDate
        .difference(n)
        .inDays < 40;
  }

}
