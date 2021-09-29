import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/file.dart';
import 'package:tritek_lms/appTheme/appTheme.dart';
import 'package:tritek_lms/blocs/user.bloc.dart';
import 'package:tritek_lms/data/entity/users.dart';
import 'package:tritek_lms/pages/notifications.dart';
import 'package:tritek_lms/pages/search.dart';

class ForumHome extends StatefulWidget {
  @override
  _ForumHomeState createState() => _ForumHomeState();
}

class _ForumHomeState extends State<ForumHome> {
  File _image;
  final userBloc = UserBloc();
  Users _user;
  @override
  void initState() {
    super.initState();
    userBloc.image.listen((value) {
      if (!mounted) {
        return;
      }

      setState(() {
        _image = value;
      });
    });

    userBloc.getImage();
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
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
                'Forum',
                style: TextStyle(
                  color: themeGold,
                  fontSize: 30.0,
                  fontWeight: FontWeight.w700,
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
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ListView(children: [
            SizedBox(height: 30),
            Divider(
              thickness: 3.0,
            ),
            SizedBox(height: 15),
            SizedBox(
              height: 100,
              width: _width - 20,
              child: Column(
                children: [
                  Row(
                    children: [
                      InkWell(
                        child: _image != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.file(
                                  _image,
                                  width: 40.0,
                                  height: 40.0,
                                  fit: BoxFit.fitHeight,
                                ),
                              )
                            : Container(
                                height: 60.0,
                                width: 60.0,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20.0),
                                  color: Colors.black,
                                  image: DecorationImage(
                                    image: AssetImage(
                                        'assets/user_profile/profile.png'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                      ),
                      SizedBox(width: 5),
                      Column(
                        children: [
                          Text(
                            "Project Trios",
                            // ("${_user?.firstName} ${_user?.lastName}")
                            //     .toUpperCase(),
                            style: TextStyle(
                              color: themeGold,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text("Ask a question....")
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Container(
                    alignment: Alignment.centerRight,
                    child: SizedBox(
                      height: 25.0,
                      width: 100,
                      child: Container(
                        child: RaisedButton(
                          onPressed: () {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) =>
                            //   ),
                            // );
                          },
                          color: themeGold,
                          child: Text(
                            'Post',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 15),
            Divider(
              thickness: 3.0,
            ),
            Container(
                color: Colors.grey,
                alignment: Alignment.centerRight,
                child: IconButton(onPressed: () {}, icon: Icon(Icons.filter))),
            Divider(
              thickness: 3.0,
            ),
            InkWell(
              onTap: () {},
              child: Column(
                children: [
                  Row(
                    children: [
                      InkWell(
                        child: _image != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.file(
                                  _image,
                                  width: 40.0,
                                  height: 40.0,
                                  fit: BoxFit.fitHeight,
                                ),
                              )
                            : Container(
                                height: 60.0,
                                width: 60.0,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20.0),
                                  color: Colors.black,
                                  image: DecorationImage(
                                    image: AssetImage(
                                        'assets/user_profile/profile.png'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                      ),
                      SizedBox(width: 8),
                      Column(
                        children: [
                          Text(
                            "Project Trios",
                            // ("${_user?.firstName} ${_user?.lastName}")
                            //     .toUpperCase(),
                            style: TextStyle(
                              color: themeGold,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text("August 20,2021") //date
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("Q: "),
                      Text("What is governance?") //question
                    ],
                  ),
                  SizedBox(height: 5),
                  Container(
                    alignment: Alignment.bottomLeft,
                    child: InkWell(
                      onTap: () {},
                      child: Text("2 Answers",
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              color: Colors.blue)),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Divider(
                thickness: 3.0,
              ),
            ),
          ]),
        ));
  }
}
