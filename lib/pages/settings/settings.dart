import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:tritek_lms/appTheme/appTheme.dart';
import 'package:tritek_lms/blocs/agents.bloc.dart';
import 'package:tritek_lms/data/entity/ccagents.dart';
import 'package:tritek_lms/http/customer.agent.dart';
import 'package:tritek_lms/pages/common/utils.dart';
import 'package:tritek_lms/pages/notes/controller/HomePage.dart';
import 'package:tritek_lms/pages/settings/account.settings.dart';
import 'package:tritek_lms/pages/settings/app_settings.dart';
import 'package:tritek_lms/pages/settings/membership.settings.dart';
import 'package:tritek_lms/pages/settings/progress.settings.dart';
import 'package:url_launcher/url_launcher.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final InAppReview inAppReview = InAppReview.instance;

  @override
  initState() {
    super.initState();
    agentBloc.getAgents();
  }

  Widget getAgentTile(Agents agent, double width, double height) {
    return InkWell(
      onTap: () {
        FlutterOpenWhatsapp.sendSingleMessage(agent.number,
            "Hi, I'll like to know more about MyTritek Consulting! (Sent from MyTritek Mobile App)");
      },
      child: Container(
        padding: EdgeInsets.all(10.0),
        margin: EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: <BoxShadow>[
            BoxShadow(
              blurRadius: 1.5,
              spreadRadius: 1.5,
              color: Colors.grey[200],
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 100.0,
              height: 100.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(agent.image),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
            Container(
              width: width - 140.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 8.0, bottom: 4.0, right: 8.0, left: 8.0),
                    child: AutoSizeText(
                      agent.name,
                      maxLines: 2,
                      style: TextStyle(
                        color: themeGold,
                        fontSize: 20.0,
                        fontFamily: 'Signika Negative',
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.7,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: 0.0, right: 8.0, left: 8.0, bottom: 8.0),
                    child: Text(
                      agent.title,
                      style: TextStyle(
                        fontSize: 14.0,
                        fontFamily: 'Signika Negative',
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.7,
                        color: Colors.green,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: 0.0, right: 8.0, left: 8.0, bottom: 8.0),
                    child: AutoSizeText(
                      agent.available,
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 12.0,
                        fontFamily: 'Signika Negative',
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.7,
                        color: headingColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bottomSheet(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return StreamBuilder<AgentResponse>(
        stream: agentBloc.subject.stream,
        builder: (context, AsyncSnapshot<AgentResponse> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.error != null && snapshot.data.error.length > 0) {
              return HttpErrorWidget(snapshot.data.error, width, height);
            }
            return _buildAgentWidget(snapshot.data.data, width, height);
          } else if (snapshot.hasError) {
            return HttpErrorWidget(snapshot.error, width, height);
          } else {
            return LoadingWidget(width, height);
          }
        });
  }

  Widget _buildAgentWidget(List<Agents> data, double width, double height) {
    return ListView(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(10),
          alignment: Alignment.center,
          child: AutoSizeText(
            "Select Who to Chat With",
            maxLines: 1,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        for (Agents item in data) getAgentTile(item, width, height),
        SizedBox(
          height: 10,
        ),
        Container(
          padding: EdgeInsets.all(10),
          alignment: Alignment.center,
          child: AutoSizeText(
            "This Continue in your WhatsApp App",
            maxLines: 1,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    nestedAppBar() {
      return NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: 150,
              backgroundColor: themeBlue,
              pinned: true,
              flexibleSpace: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                // print('constraints=' + constraints.toString());
                return FlexibleSpaceBar(
                    centerTitle: false,
                    title: AnimatedOpacity(
                      duration: Duration(milliseconds: 300),
                      //opacity: top == 80.0 ? 1.0 : 0.0,
                      opacity: 1.0,
                      child: Text(
                        'Settings',
                        style: TextStyle(
                          fontFamily: 'Signika Negative',
                          fontWeight: FontWeight.w700,
                          color: themeGold,
                          fontSize: 25.0,
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
            SizedBox(height: 20.0),
            Container(
              margin: EdgeInsets.only(right: 15.0, left: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AccountSettings()));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Account Settings',
                          style: TextStyle(
                              fontSize: 16.0,
                              color: themeBlue,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Signika Negative'),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 18.0,
                        ),
                      ],
                    ),
                  ),
                  Divider(),
                  SizedBox(height: 20.0),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MembershipSettings()));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Membership Settings',
                          style: TextStyle(
                              fontSize: 16.0,
                              color: themeBlue,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Signika Negative'),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 18.0,
                        ),
                      ],
                    ),
                  ),
                  Divider(),
                  SizedBox(height: 20.0),
                  InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Progress()));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Progress Tracker',
                          style: TextStyle(
                              fontSize: 16.0,
                              color: themeBlue,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Signika Negative'),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 18.0,
                        ),
                      ],
                    ),
                  ),
                  Divider(),
                  SizedBox(height: 20.0),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AppSettings()));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'App Settings',
                          style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w700,
                              color: themeBlue,
                              fontFamily: 'Signika Negative'),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 18.0,
                        ),
                      ],
                    ),
                  ),
                  Divider(),
                  SizedBox(height: 20.0),
                  InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => HomePage()));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'My Notes',
                          style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w700,
                              color: themeBlue,
                              fontFamily: 'Signika Negative'),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 18.0,
                        ),
                      ],
                    ),
                  ),
                  Divider(),
                  SizedBox(height: 20.0),
                  InkWell(
                    onTap: () {
                      _launchURL('https://mytritek.co.uk/about-us');
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => WebviewInApp(
                      //             'https://mytritek.co.uk/about-us')));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'About Us',
                          style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w700,
                              color: themeBlue,
                              fontFamily: 'Signika Negative'),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 18.0,
                        ),
                      ],
                    ),
                  ),
                  Divider(),
                  SizedBox(height: 20.0),
                  InkWell(
                    onTap: () {
                      _launchURL('https://mytritek.co.uk/terms-and-conditions');
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Terms & Conditions',
                          style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w700,
                              color: themeBlue,
                              fontFamily: 'Signika Negative'),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 18.0,
                        ),
                      ],
                    ),
                  ),
                  Divider(),
                  SizedBox(height: 20.0),
                  InkWell(
                    onTap: () {
                      _launchURL('https://tritekconsulting.co.uk/contact');
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => WebviewInApp('https://mytritek.co.uk/terms-and-conditions')));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Contact Us',
                          style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w700,
                              color: themeBlue,
                              fontFamily: 'Signika Negative'),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 18.0,
                        ),
                      ],
                    ),
                  ),
                  Divider(),
                  SizedBox(height: 20.0),
                  InkWell(
                    onTap: () {
                      showModalBottomSheet(
                          context: context, builder: _bottomSheet);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Chat With Us',
                          style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w700,
                              color: themeBlue,
                              fontFamily: 'Signika Negative'),
                        ),
                        Text(
                          'WhatsApp',
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  Divider(),
                  SizedBox(height: 20.0),
                  InkWell(
                    onTap: () async {
                      if (await inAppReview.isAvailable()) {
                        inAppReview.requestReview();
                      } else {
                        Fluttertoast.showToast(
                          msg: 'Can not review App at this time',
                          backgroundColor: Colors.black,
                          textColor: Theme.of(context).appBarTheme.color,
                        );
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Review App',
                          style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w700,
                              color: themeBlue,
                              fontFamily: 'Signika Negative'),
                        ),
                        Text(
                          Platform.isAndroid
                              ? 'Rate on PlayStore'
                              : 'Rate on AppStore',
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  Divider(),
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

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
