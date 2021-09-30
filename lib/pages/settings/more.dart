import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/file.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:tritek_lms/appTheme/appTheme.dart';
import 'package:tritek_lms/blocs/user.bloc.dart';
import 'package:tritek_lms/data/entity/users.dart';
import 'package:tritek_lms/pages/common/dialog.dart';
import 'package:tritek_lms/pages/login_signup/login.dart';
import 'package:tritek_lms/pages/login_signup/termsAndcond.dart';
import 'package:tritek_lms/pages/notes/controller/HomePage.dart';
import 'package:tritek_lms/pages/notifications.dart';
import 'package:tritek_lms/pages/search.dart';
import 'package:tritek_lms/pages/settings/account.settings.dart';
import 'package:tritek_lms/pages/settings/app_settings.dart';
import 'package:tritek_lms/pages/settings/help.dart';
import 'package:tritek_lms/pages/settings/inapp.webview.dart';
import 'package:tritek_lms/pages/settings/privacy_policy.dart';
import 'package:tritek_lms/pages/settings/saved_video.dart';
import 'package:tritek_lms/pages/settings/terms_condition.dart';
import 'package:tritek_lms/pages/settings/testoooo.dart';
import 'package:tritek_lms/pages/settings/traning_videos.dart';
import 'package:tritek_lms/pages/welcome.dart';
import 'package:url_launcher/url_launcher.dart';

class More extends StatefulWidget {
  @override
  _MoreState createState() => _MoreState();
}

class _MoreState extends State<More> {
  File _image;
  Users _user;
  bool routed = false;

  final _formKey = GlobalKey<FormState>();
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  final bloc = UserBloc();

  void logout() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => WelcomeSreen()));
  }

  @override
  void initState() {
    super.initState();

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
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          automaticallyImplyLeading: false,
          backgroundColor: themeBlue,
          title: Row(
            children: [
              Container(
                height: 26.0,
                width: 26.0,
                margin: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/logo.png"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 5),
              Text(
                "More",
                style: TextStyle(
                  fontFamily: 'Signika Negative',
                  fontWeight: FontWeight.w700,
                  fontSize: 30.0,
                  color: themeGold,
                ),
              ),
            ],
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search),
              iconSize: 30,
              color: themeGold,
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Search()));
              },
            ),
            IconButton(
              icon: Icon(Icons.notifications),
              iconSize: 30,
              color: themeGold,
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Notifications()));
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: ListView(
            children: [
              SizedBox(height: 40.0),
              Container(
                  margin: EdgeInsets.only(right: 15.0, left: 15.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AccountSettings()));
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.account_circle,
                                size: 20.0,
                              ),
                              SizedBox(width: 15),
                              Text(
                                'Account',
                                style: TextStyle(
                                    fontSize: 19.0,
                                    color: themeBlue,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'Signika Negative'),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10.0),
                        Divider(),
                        SizedBox(height: 10.0),
                        InkWell(
                          onTap: () {
                            // _launchURL('https://mytritek.co.uk/about-us');
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        testoo())); //WebviewInApp('https://mytritek.co.uk/about-us')
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.info,
                                size: 20.0,
                              ),
                              SizedBox(width: 15),
                              Text(
                                'About Us',
                                style: TextStyle(
                                    fontSize: 19.0,
                                    color: themeBlue,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'Signika Negative'),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10.0),
                       
                        // SizedBox(height: 10.0),
                        // InkWell(
                        //   onTap: () {
                        //     Navigator.push(
                        //         context,
                        //         MaterialPageRoute(
                        //             builder: (context) => TrainingVideos()));
                        //   },
                        //   child: Row(
                        //     crossAxisAlignment: CrossAxisAlignment.center,
                        //     children: <Widget>[
                        //       Icon(
                        //         Icons.menu_book_sharp,
                        //         size: 20.0,
                        //       ),
                        //       SizedBox(width: 15),
                        //       Text(
                        //         'Training Materials',
                        //         style: TextStyle(
                        //             fontSize: 19.0,
                        //             color: themeBlue,
                        //             fontWeight: FontWeight.w700,
                        //             fontFamily: 'Signika Negative'),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        // SizedBox(height: 10.0),
                        // Divider(),
                        // SizedBox(height: 10.0),
                        // InkWell(
                        //   onTap: () {},
                        //   child: Row(
                        //     crossAxisAlignment: CrossAxisAlignment.center,
                        //     children: <Widget>[
                        //       FaIcon(
                        //         FontAwesomeIcons.certificate,
                        //         size: 20.0,
                        //       ),
                        //       SizedBox(width: 15),
                        //       Text(
                        //         'Certificates',
                        //         style: TextStyle(
                        //             fontSize: 19.0,
                        //             color: themeBlue,
                        //             fontWeight: FontWeight.w700,
                        //             fontFamily: 'Signika Negative'),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        // SizedBox(height: 10.0),
                        Divider(),
                        SizedBox(height: 10.0),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomePage()));
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.note_add,
                                size: 20.0,
                              ),
                              SizedBox(width: 15.0),
                              Text(
                                'My Notes',
                                style: TextStyle(
                                    fontSize: 19.0,
                                    color: themeBlue,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'Signika Negative'),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10.0),
                        Divider(),
                        // SizedBox(height: 10.0),
                        // InkWell(
                        //   onTap: () {
                        //     Navigator.push(
                        //         context,
                        //         MaterialPageRoute(
                        //             builder: (context) => SavedVideos()));
                        //   },
                        //   child: Row(
                        //     crossAxisAlignment: CrossAxisAlignment.center,
                        //     children: <Widget>[
                        //       Icon(
                        //         Icons.bookmark,
                        //         size: 20.0,
                        //       ),
                        //       SizedBox(width: 15.0),
                        //       Text(
                        //         'Saved Videos',
                        //         style: TextStyle(
                        //             fontSize: 19.0,
                        //             color: themeBlue,
                        //             fontWeight: FontWeight.w700,
                        //             fontFamily: 'Signika Negative'),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        // SizedBox(height: 10.0),
                        // Divider(),
                        SizedBox(height: 10.0),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Help()));
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.help_rounded,
                                size: 20.0,
                              ),
                              SizedBox(width: 15.0),
                              Text(
                                'Help',
                                style: TextStyle(
                                    fontSize: 19.0,
                                    color: themeBlue,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'Signika Negative'),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10.0),
                        Divider(),
                        SizedBox(height: 10.0),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AppSettings()));
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.settings,
                                size: 20.0,
                              ),
                              SizedBox(width: 15.0),
                              Text(
                                'Settings',
                                style: TextStyle(
                                    fontSize: 19.0,
                                    color: themeBlue,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'Signika Negative'),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10.0),
                        Divider(),
                        SizedBox(height: 10.0),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Terms()));
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.save_alt_rounded,
                                size: 20.0,
                              ),
                              SizedBox(width: 15.0),
                              Text(
                                'Terms & Conditions',
                                style: TextStyle(
                                    fontSize: 19.0,
                                    color: themeBlue,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'Signika Negative'),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10.0),
                        Divider(),
                        SizedBox(height: 10.0),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                PageTransition(
                                    type: PageTransitionType.rightToLeft,
                                    child: Privacy()));
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.lock_rounded,
                                size: 20.0,
                              ),
                              SizedBox(width: 15.0),
                              Text(
                                'Privacy Policy',
                                style: TextStyle(
                                    fontSize: 19.0,
                                    color: themeBlue,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'Signika Negative'),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10.0),
                        Divider(),
                        SizedBox(height: 10.0),
                      ])),
              SizedBox(height: 40.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Version 1.0",
                    style: TextStyle(
                        fontSize: 18.0,
                        color: themeBlue,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Signika Negative'),
                  ),
                  SizedBox(height: 20),
                  InkWell(
                    onTap: () {
                      logoutDialogue();
                    },
                    child: Text(
                      "Sign Out",
                      style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.red,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Signika Negative'),
                    ),
                  ),
                  SizedBox(height: 60),
                ],
              )
            ],
          ),
        ));
  }

  logoutDialogue() {
    double width = MediaQuery.of(context).size.width;
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
                      "Are you sure want you to \n Sign out?",
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
                            userBloc.logout().then((_) => {
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
                              'Sign out',
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
            ));
      },
    );
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
