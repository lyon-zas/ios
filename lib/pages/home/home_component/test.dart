// import 'package:auto_size_text/auto_size_text.dart';
// import 'package:flutter/material.dart';
// import 'package:tritek_lms/appTheme/appTheme.dart';
// import 'package:tritek_lms/blocs/course.bloc.dart';
// import 'package:tritek_lms/data/entity/courses.dart';
// import 'package:tritek_lms/http/courses.dart';
// import 'package:tritek_lms/pages/common/utils.dart';
// import 'package:tritek_lms/pages/course/course.dart';

// class HomeCourses extends StatefulWidget {
//   @override
//   _HomeCoursesState createState() => _HomeCoursesState();
// }

// class _HomeCoursesState extends State<HomeCourses> {
//   @override
//   void initState() {
//     super.initState();
//     bloc.getCourses();
//   }

//   @override
//   Widget build(BuildContext context) {
//     double height = MediaQuery.of(context).size.height;
//     double width = MediaQuery.of(context).size.width;

//     return Container(
//         padding: EdgeInsets.only(bottom: 0.0),
//         child: StreamBuilder<CoursesResponse>(
//           stream: bloc.subject.stream,
//           builder: (context, AsyncSnapshot<CoursesResponse> snapshot) {
//             if (snapshot.hasData) {
//               if (snapshot.data.error != null &&
//                   snapshot.data.error.length > 0) {
//                 return HttpErrorWidget(snapshot.data.error, width, height);
//               }
//               return _buildListWidget(snapshot.data.results, width, height);
//             } else if (snapshot.hasError) {
//               return HttpErrorWidget(snapshot.error, width, height);
//             } else {
//               return LoadingWidget(width, height);
//             }
//           },
//         ));
//   }

//   Widget _buildListWidget(List<Course> data, double width, double height) {
//     return ListView(
//       children: <Widget>[
//         for (Course item in data) getCourseTile(item),
//       ],
//     );
//   }

//   Widget getCourseTile(Course course) {
//     double _height = MediaQuery.of(context).size.height;
//     double _width = MediaQuery.of(context).size.width;

//     return InkWell(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => CoursePage(
//               courseData: course,
//             ),
//           ),
//         );
//       },
//       child: Container(
//         width: _width - 20,
//         margin: EdgeInsets.all(10.0),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(20.0),
//           boxShadow: [
//             BoxShadow(
//               blurRadius: 2.0,
//               spreadRadius: 1.5,
//               color: Colors.grey[300],
//             )
//           ],
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             Hero(
//               tag: Text(course.id.toString()),
//               child: Container(
//                 height: 200.0,
//                 width: _width - 20,
//                 decoration: BoxDecoration(
//                     borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(20.0),
//                       topRight: Radius.circular(20.0),
//                     ),
//                     image: DecorationImage(
//                       image: NetworkImage(course.image),
//                       fit: BoxFit.cover,
//                     )),
//               ),
//             ),
//             Container(
//               padding: EdgeInsets.all(10.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: <Widget>[
//                   AutoSizeText(
//                     'Instructor - ${course.author}',
//                     style: TextStyle(
//                       color: Colors.grey,
//                       fontSize: 12.0,
//                     ),
//                   ),
//                   SizedBox(height: 10.0),
//                   AutoSizeText(
//                     course.title,
//                     maxLines: 2,
//                     style: TextStyle(
//                       color: themeBlue,
//                       fontSize: 20.0,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   Divider(),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: <Widget>[
//                       Text(
//                         'Ratings: ',
//                         style: TextStyle(
//                           color: themeBlue,
//                           fontSize: 14.0,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       Text(
//                         getRatings(course),
//                         style: TextStyle(
//                           color: themeGold,
//                           fontSize: 14.0,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       SizedBox(
//                         width: 3.0,
//                       ),
//                       Icon(
//                         Icons.star,
//                         size: 17.0,
//                         color: themeGold,
//                       ),
//                       SizedBox(
//                         width: 5.0,
//                       ),
//                       Text(
//                         '(${course.comments.length} Reviews)',
//                         style: TextStyle(
//                           color: themeBlue,
//                           fontSize: 14.0,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 10.0),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: <Widget>[
//                       Text(
//                         'Price: ',
//                         style: TextStyle(
//                           color: themeBlue,
//                           fontSize: 14.0,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       SizedBox(
//                         width: 5.0,
//                       ),
//                       Text(
//                         'Buy Membership',
//                         style: TextStyle(
//                           color: themeGold,
//                           fontSize: 14.0,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

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
// }