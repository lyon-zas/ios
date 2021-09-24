// import 'package:auto_size_text/auto_size_text.dart';
// import 'package:flutter/material.dart';
// import 'package:page_transition/page_transition.dart';
// import 'package:share/share.dart';
// import 'package:tritek_lms/appTheme/appTheme.dart';
// import 'package:tritek_lms/blocs/course.bloc.dart';
// import 'package:tritek_lms/blocs/user.bloc.dart';
// import 'package:tritek_lms/data/entity/courses.dart';
// import 'package:tritek_lms/data/entity/users.dart';
// import 'package:tritek_lms/pages/course/lessons.dart';
// import 'package:tritek_lms/pages/course/overview.dart';
// import 'package:tritek_lms/pages/login_signup/login.dart';
// import 'package:tritek_lms/pages/payment/select_plan.dart';
// import 'package:tritek_lms/pages/reviews/reviews.dart';

// import 'lesson.view.dart';

// class CoursePage extends StatefulWidget {
//   final Course courseData;
//   final int lang;

//   CoursePage({Key key, @required this.courseData, this.lang}) : super(key: key);

//   @override
//   _CoursePageState createState() => _CoursePageState();
// }

// class _CoursePageState extends State<CoursePage> {
//   bool wishlist;
//   bool subscribed = false;
//   bool preview = false;
//   final _scaffoldKey = GlobalKey<ScaffoldState>();

//   Users _user;
//   Course _course;
//   String token;

//   @override
//   void initState() {
//     super.initState();
//     _course = widget.courseData;
//     bloc.userSubject.listen((value) {
//       if (!mounted) {
//         return;
//       }
//       setState(() {
//         _course = widget.courseData;
//         _user = value.results;
//         if (_user != null) {
//           bloc.getMyCourseById(_user.id, widget.courseData.id);
//         } else {
//           _course = widget.courseData;
//         }
//       });
//     });

//     bloc.course.listen((value) {
//       if (!mounted) {
//         return;
//       }
//       setState(() {
//         if (value.result != null && value.result.title != null) {
//           _course = value.result;
//         }
//       });
//     });

//     userBloc.token.listen((value) {
//       if (!mounted) {
//         return;
//       }
//       setState(() {
//         token = value;
//       });
//     });

//     userBloc.getToken();

//     bloc.getUser();
//     wishlist = widget.courseData.wishList ?? false;
//   }

//   // onAddedInWishlist() {
//   //   setState(() {
//   //     if (wishlist) {
//   //       wishlist = false;
//   //       bloc.setWishlist(widget.courseData, false);
//   //       Fluttertoast.showToast(
//   //         msg: 'Course Removed from WishList',
//   //         backgroundColor: Colors.black,
//   //         textColor: Theme.of(context).appBarTheme.color,
//   //       );
//   //     } else {
//   //       wishlist = true;
//   //       bloc.setWishlist(widget.courseData, true);
//   //       Fluttertoast.showToast(
//   //         msg: 'Course Added to WishList',
//   //         backgroundColor: Colors.black,
//   //         textColor: Theme
//   //             .of(context)
//   //             .appBarTheme
//   //             .color,
//   //       );
//   //     }
//   //   });
//   // }

//   getRatings(Course course) {
//     int r = 0;
//     if (course.comments.length > 0) {
//       course.comments.forEach((c) {
//         r = r + int.parse(c.rating.replaceAll(RegExp('[^0-9]'), ''));
//       });
//       return ((r / course.comments.length).round()).toString() + '/5';
//     }
//     return '0/5';
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Course _course = widget.courseData;
//     double width = MediaQuery.of(context).size.width;

//     nestedAppBar(_scaffoldKey) {
//       if (_course != null)
//         return NestedScrollView(
//           headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
//             return <Widget>[
//               SliverAppBar(
//                 expandedHeight: 400,
//                 pinned: true,
//                 forceElevated: true,
//                 automaticallyImplyLeading: false,
//                 backgroundColor: themeBlue,
//                 elevation: 0.0,
//                 leading: IconButton(
//                   icon: Icon(
//                     Icons.arrow_back_ios,
//                     color: iconColor,
//                   ),
//                   onPressed: () {
//                     Navigator.pop(context);
//                   },
//                 ),
//                 title: AutoSizeText(
//                   _course.title,
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                   style: TextStyle(
//                     color: themeGold,
//                     fontSize: 18.0,
//                     fontWeight: FontWeight.w700,
//                     fontFamily: 'Signika Negative',
//                   ),
//                 ),
//                 actions: <Widget>[
//                   // Padding(
//                   //   padding: EdgeInsets.symmetric(horizontal: 12),
//                   //   child:
//                   //   InkWell(
//                   //     onTap: () {
//                   //       onAddedInWishlist();
//                   //     },
//                   //     child:
//                   //     Icon(
//                   //       (wishlist) ? Icons.favorite : Icons.favorite_border,
//                   //       color: iconColor,
//                   //     ),
//                   //   ),
//                   // ),
//                   Padding(
//                       padding: EdgeInsets.symmetric(horizontal: 12),
//                       child: InkWell(
//                         onTap: () {
//                           share();
//                         },
//                         child: Icon(
//                           Icons.share,
//                           color: iconColor,
//                         ),
//                       )),
//                 ],
//                 flexibleSpace: FlexibleSpaceBar(
//                   background: Stack(
//                     children: <Widget>[
//                       Positioned(
//                         top: 0.0,
//                         left: 0.0,
//                         child: Container(
//                           width: width,
//                           height: 370.0,
//                           padding: EdgeInsets.all(20.0),
//                           alignment: Alignment.bottomCenter,
//                           decoration: BoxDecoration(
//                             image: DecorationImage(
//                               image: NetworkImage(_course.image),
//                               fit: BoxFit.cover,
//                             ),
//                             borderRadius: BorderRadius.only(
//                               bottomLeft: Radius.circular(20.0),
//                               bottomRight: Radius.circular(20.0),
//                             ),
//                           ),
//                         ),
//                       ),
//                       Positioned(
//                         child: Container(
//                           width: width,
//                           height: 370.0,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.only(
//                               bottomLeft: Radius.circular(20.0),
//                               bottomRight: Radius.circular(20.0),
//                             ),
//                             color: Colors.black.withOpacity(0.5),
//                           ),
//                         ),
//                       ),
//                       Positioned(
//                         bottom: 50.0,
//                         left: 0.0,
//                         child: Container(
//                           height: 210.0,
//                           width: width,
//                           padding: EdgeInsets.all(15.0),
//                           alignment: Alignment.bottomCenter,
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: <Widget>[
//                               Text(
//                                 'Instructor - ' + _course.author,
//                                 style: TextStyle(
//                                   color: themeGold,
//                                   fontSize: 14.0,
//                                   fontFamily: 'Signika Negative',
//                                 ),
//                               ),
//                               // SizedBox(height: 5.0),
//                               Spacer(),
//                               AutoSizeText(
//                                 _course.title,
//                                 minFontSize: 16,
//                                 maxLines: 2,
//                                 overflow: TextOverflow.ellipsis,
//                                 style: TextStyle(
//                                   color: themeGold,
//                                   fontSize: 30.0,
//                                   fontWeight: FontWeight.w700,
//                                   fontFamily: 'Signika Negative',
//                                 ),
//                               ),
//                               Spacer(),
//                               Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 crossAxisAlignment: CrossAxisAlignment.center,
//                                 children: <Widget>[
//                                   Column(
//                                     children: <Widget>[
//                                       Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.start,
//                                         children: <Widget>[
//                                           Text(
//                                             getRatings(_course),
//                                             style: TextStyle(
//                                               color: themeGold,
//                                               fontSize: 14.0,
//                                               fontFamily: 'Signika Negative',
//                                             ),
//                                           ),
//                                           SizedBox(width: 2.0),
//                                           Icon(
//                                             Icons.star,
//                                             color: iconColor,
//                                             size: 15.0,
//                                           ),
//                                           SizedBox(width: 5.0),
//                                           Text(
//                                             '(${_course.comments.length} Reviews)',
//                                             style: TextStyle(
//                                               color: themeGold,
//                                               fontSize: 14.0,
//                                               fontFamily: 'Signika Negative',
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ],
//                                   ),
//                                   if (_user != null &&
//                                       _user.status != null &&
//                                       _user.status.toLowerCase() != 'active')
//                                     InkWell(
//                                       onTap: () {
//                                         Navigator.push(
//                                             context,
//                                             PageTransition(
//                                                 type: PageTransitionType
//                                                     .rightToLeft,
//                                                 child: SelectPlan(
//                                                   course: _course,
//                                                 )));
//                                       },
//                                       child: Container(
//                                         padding: EdgeInsets.all(5.0),
//                                         alignment: Alignment.center,
//                                         decoration: BoxDecoration(
//                                           color: Colors.transparent,
//                                         ),
//                                         child: Text(
//                                           'Buy Membership',
//                                           style: TextStyle(
//                                             fontFamily: 'Signika Negative',
//                                             fontSize: 20.0,
//                                             color: themeGold,
//                                             fontWeight: FontWeight.w700,
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   if (_user != null &&
//                                       _user.status != null &&
//                                       _user.status.toLowerCase() == 'active')
//                                     InkWell(
//                                       onTap: () {
//                                         Navigator.push(
//                                             context,
//                                             PageTransition(
//                                                 type: PageTransitionType
//                                                     .rightToLeft,
//                                                 child: CourseReview(
//                                                     _course, _user)));
//                                       },
//                                       child: Container(
//                                         padding: EdgeInsets.all(5.0),
//                                         alignment: Alignment.center,
//                                         decoration: BoxDecoration(
//                                           color: Colors.transparent,
//                                         ),
//                                         child: Text(
//                                           'Add Review',
//                                           style: TextStyle(
//                                             fontFamily: 'Signika Negative',
//                                             fontSize: 20.0,
//                                             color: themeGold,
//                                             fontWeight: FontWeight.w700,
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                 ],
//                               ),
//                               if (_user == null ||
//                                   (_user != null && _user.status != 'active'))
//                                 Spacer(),

//                               if (_user == null)
//                                 InkWell(
//                                   onTap: () {
//                                     Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                             builder: (context) =>
//                                                 Login(_course, null)));
//                                   },
//                                   child: Container(
//                                     width: width,
//                                     alignment: Alignment.center,
//                                     padding: EdgeInsets.all(13.0),
//                                     decoration: BoxDecoration(
//                                         color: buttonColor,
//                                         borderRadius:
//                                             BorderRadius.circular(5.0)),
//                                     child: Text(
//                                       'Login To View Course',
//                                       style: TextStyle(
//                                         fontFamily: 'Signika Negative',
//                                         fontSize: 16.0,
//                                         color: Colors.black,
//                                         fontWeight: FontWeight.w700,
//                                         wordSpacing: 3.0,
//                                         letterSpacing: 0.6,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               if (_user != null && _user.status != 'active')
//                                 InkWell(
//                                   onTap: () {
//                                     Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                             builder: (context) => SelectPlan(
//                                                   course: _course,
//                                                 )));
//                                   },
//                                   child: Container(
//                                     width: width,
//                                     alignment: Alignment.center,
//                                     padding: EdgeInsets.all(13.0),
//                                     decoration: BoxDecoration(
//                                         color: themeBlue,
//                                         borderRadius:
//                                             BorderRadius.circular(5.0)),
//                                     child: Text(
//                                       'Buy Membership',
//                                       style: TextStyle(
//                                         fontFamily: 'Signika Negative',
//                                         fontSize: 16.0,
//                                         color: themeGold,
//                                         fontWeight: FontWeight.w700,
//                                         wordSpacing: 3.0,
//                                         letterSpacing: 0.6,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               if (_user != null &&
//                                   _user.status == 'active' &&
//                                   _course.sections.length > 0 &&
//                                   _course.sections[0].lessons.length > 0)
//                                 InkWell(
//                                   onTap: () {
//                                     if (token != null) {
//                                       Navigator.push(
//                                           context,
//                                           MaterialPageRoute(
//                                               builder: (context) =>
//                                                   InAppLessonView(
//                                                       _course.sections[0]
//                                                           .lessons[0].postId,
//                                                       token)));
//                                     }
//                                   },
//                                   child: Container(
//                                     width: width,
//                                     alignment: Alignment.center,
//                                     padding: EdgeInsets.all(13.0),
//                                     decoration: BoxDecoration(
//                                         color: themeBlue,
//                                         borderRadius:
//                                             BorderRadius.circular(5.0)),
//                                     child: Text(
//                                       'Continue Course',
//                                       style: TextStyle(
//                                         fontFamily: 'Signika Negative',
//                                         fontSize: 16.0,
//                                         color: themeGold,
//                                         fontWeight: FontWeight.w700,
//                                         wordSpacing: 3.0,
//                                         letterSpacing: 0.6,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               if (preview) SizedBox(height: 10.0),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 bottom: TabBar(
//                   tabs: [
//                     Tab(
//                       child: Text(
//                         'Overview',
//                         style: TextStyle(
//                             fontFamily: 'Signika Negative',
//                             fontSize: 16.0,
//                             fontWeight: FontWeight.w700,
//                             color: themeGold),
//                       ),
//                     ),
//                     Tab(
//                       child: Text(
//                         'Curriculum',
//                         style: TextStyle(
//                             fontFamily: 'Signika Negative',
//                             fontSize: 16.0,
//                             fontWeight: FontWeight.w700,
//                             color: themeGold),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ];
//           },
//           body: TabBarView(
//             children: [
//               ListView(
//                 children: <Widget>[
//                   OverviewCoursePage(_course, _user),
//                 ],
//               ),
//               LessonView(
//                   scaffoldKey: _scaffoldKey,
//                   sections: _course.sections,
//                   user: _user),
//             ],
//           ),
//         );
//     }

//     return DefaultTabController(
//       length: 2,
//       child: Scaffold(
//         key: _scaffoldKey,
//         body: nestedAppBar(_scaffoldKey),
//       ),
//     );
//   }

//   void share() async {
//     final RenderBox box = context.findRenderObject();
//     await Share.share(
//         'Check out this amazing course: ${widget.courseData.title} on https://mytritek.co.uk',
//         subject: widget.courseData.title,
//         sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
//   }
// }
