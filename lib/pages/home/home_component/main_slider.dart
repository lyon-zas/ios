import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:tritek_lms/blocs/course.bloc.dart';
import 'package:tritek_lms/data/entity/courses.dart';
import 'package:tritek_lms/http/courses.dart';
import 'package:tritek_lms/pages/common/carousel_image_item.dart';
import 'package:tritek_lms/pages/common/utils.dart';

class MainSlider extends StatefulWidget {
  @override
  _MainSliderState createState() => _MainSliderState();
}

class _MainSliderState extends State<MainSlider> {
  @override
  void initState() {
    super.initState();
    bloc.getCourses();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Container(
        padding: EdgeInsets.only(bottom: 0.0),
        child: StreamBuilder<CoursesResponse>(
          stream: bloc.subject.stream,
          builder: (context, AsyncSnapshot<CoursesResponse> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.error != null &&
                  snapshot.data.error.length > 0) {
                return HttpErrorWidget(snapshot.data.error, width, height);
              }
              return _buildCarouselWidget(snapshot.data.results, width, height);
            } else if (snapshot.hasError) {
              return HttpErrorWidget(snapshot.error, width, height);
            } else {
              return LoadingWidget(width, height);
            }
          },
        )
        );
  }

  Widget _buildCarouselWidget(List<Course> data, double width, double height) {
    return CarouselSlider(
      options: CarouselOptions(
        height: (height / 4.0),
        enlargeCenterPage: true,
        autoPlay: true,
        aspectRatio: 16 / 9,
        autoPlayInterval: const Duration(seconds: 6),
        autoPlayCurve: Curves.fastOutSlowIn,
        enableInfiniteScroll: true,
        autoPlayAnimationDuration: const Duration(milliseconds: 800),
        viewportFraction: 1.0,
      ),
      items: data.map((i) {
        return Builder(
          builder: (BuildContext context) {
            return CarouselImageItem(i, width);
          },
        );
      }).toList(),
    );
  }
}
