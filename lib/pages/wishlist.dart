import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tritek_lms/appTheme/appTheme.dart';
import 'package:tritek_lms/blocs/user.bloc.dart';
import 'package:tritek_lms/blocs/wishlist.bloc.dart';
import 'package:tritek_lms/data/entity/users.dart';
import 'package:tritek_lms/data/entity/wishlist.dart';
import 'package:tritek_lms/http/wishlist.provider.dart';
import 'package:tritek_lms/pages/course/lesson.view.dart';
import 'package:tritek_lms/pages/notifications.dart';
import 'package:tritek_lms/pages/search.dart';
import 'package:tritek_lms/pages/settings/account.settings.dart';

import 'common/utils.dart';

class Wishlist extends StatefulWidget {
  @override
  _WishlistState createState() => _WishlistState();
}

class _WishlistState extends State<Wishlist> {
  Users _user = Users();
  File _image;
  String token;

  @override
  void initState() {
    super.initState();
    if (_user != null && _user.id == null) {
      userBloc.userSubject.listen((value) {
        if (!mounted) {
          return;
        }
        setState(() {
          _user = value != null ? value.results : null;

          if (value != null && value.results != null) {
            wishListBloc.getList();
          }
        });
      });

      userBloc.token.listen((value) {
        if (!mounted) {
          return;
        }
        setState(() {
          token = value;
        });
      });

      userBloc.getUser();
      userBloc.getToken();
    }

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
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    getCourseTile(WishList wishlist) {
      return Slidable(
          actionPane: SlidableDrawerActionPane(),
          actionExtentRatio: 0.25,
          secondaryActions: <Widget>[
            Container(
              margin: EdgeInsets.only(
                top: 5.0,
                bottom: 5.0,
              ),
              child: IconSlideAction(
                caption: 'Delete',
                color: Colors.red,
                icon: Icons.delete,
                onTap: () {
                  _deleteList(wishlist);
                },
              ),
            ),
          ],
          child: InkWell(
            onTap: () {
              if (_user != null &&
                  _user.status != null &&
                  _user.status == 'active') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        InAppLessonView(wishlist.lessonId, token),
                  ),
                );
              }
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
              child: Container(
                width: width - 40.0,
                child: Row(
                  children: [
                    //       Container(
                    //   height: 150.0,
                    //   width: width - 270,
                    //   decoration: BoxDecoration(
                    //       borderRadius: BorderRadius.only(
                    //         topLeft: Radius.circular(20.0),
                    //         bottomLeft: Radius.circular(20.0),
                    //       ),
                    //       image: DecorationImage(
                    //         image: NetworkImage( wishlist.image),
                    //         fit: BoxFit.cover,
                    //       )),
                    //  ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(
                              top: 8.0, bottom: 4.0, right: 8.0, left: 8.0),
                          child: AutoSizeText(
                            wishlist.course,
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
                              top: 8.0, bottom: 4.0, right: 8.0, left: 8.0),
                          child: AutoSizeText(
                            wishlist.lesson,
                            maxLines: 2,
                            style: TextStyle(
                              color: themeBlue,
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
                            "Section - ${wishlist.section}",
                            style: TextStyle(
                              fontSize: 14.0,
                              fontFamily: 'Signika Negative',
                              letterSpacing: 0.7,
                              color: headingColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ));
    }

    Widget _listCoursesWidget(
        List<WishList> data, double width, double height) {
      return ListView(
        children: <Widget>[
          for (WishList item in data) getCourseTile(item),
        ],
      );
    }

    Widget _noItemWidget(double width, double height) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.do_not_disturb_off,
              color: Colors.grey,
              size: 60.0,
            ),
            SizedBox(
              height: 20.0,
            ),
            Text(
              'No Item in Favourites',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 18.0,
                fontFamily: 'Signika Negative',
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      );
    }

    nestedAppBar() {
      return NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
             SliverAppBar(
             
              pinned: true,
              backgroundColor: themeBlue,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                // crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
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
                    SizedBox(height:5),
                  Text(
                    "Favourites",
                    style: TextStyle(
                      fontFamily: 'Signika Negative',
                      fontWeight: FontWeight.w700,
                      fontSize: 25.0,
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
              automaticallyImplyLeading: false,
            ),
          ];
        },
          body: StreamBuilder<WishListResponse>(
            stream: wishListBloc.list.stream,
            builder: (context, AsyncSnapshot<WishListResponse> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data.error != null &&
                    snapshot.data.error.length > 0) {
                  return HttpErrorWidget(snapshot.data.error, width, height);
                }

                if (snapshot.data.results.length < 1) {
                  return _noItemWidget(width, height);
                }
                return _listCoursesWidget(snapshot.data.results, width, height);
              } else if (snapshot.hasError) {
                return HttpErrorWidget(snapshot.error, width, height);
              } else if (_user != null && _user.id == null) {
                return LoadingWidget(width, height);
              }

              return _noItemWidget(width, height);
            },
          ));
    }

    return Scaffold(
      backgroundColor: themeBg,
      body: nestedAppBar(),
    );
  }

  void _deleteList(WishList wishlist) {
    wishListBloc.delete(wishlist);
    Fluttertoast.showToast(
      msg: 'Lesson Removed from WishList!',
      backgroundColor: Colors.black,
      textColor: Theme.of(context).appBarTheme.color,
    );
  }
}
