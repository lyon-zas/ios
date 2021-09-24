import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:tritek_lms/appTheme/appTheme.dart';
import 'package:tritek_lms/blocs/testimonial.bloc.dart';
import 'package:tritek_lms/data/entity/courses.dart';
import 'package:tritek_lms/http/testimonials.dart';
import 'package:tritek_lms/pages/common/carousel_testimonial.dart';
import 'package:tritek_lms/pages/common/utils.dart';

class TestimonialSlider extends StatefulWidget {
  @override
  _TestimonialSlider createState() => _TestimonialSlider();
}

class _TestimonialSlider extends State<TestimonialSlider> {
  @override
  void initState() {
    super.initState();
    testimonialBloc.getTestimonial();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Container(
        width: width,
        height: 160.0,
        color: Theme.of(context).appBarTheme.color,
        child: StreamBuilder<TestimonialResponse>(
          stream: testimonialBloc.subject.stream,
          builder: (context, AsyncSnapshot<TestimonialResponse> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.error != null &&
                  snapshot.data.error.length > 0) {
                return HttpErrorWidget(snapshot.data.error, width, 160);
              }
              return _buildCarouselWidget(snapshot.data.results, width, height);
            } else if (snapshot.hasError) {
              return HttpErrorWidget(snapshot.error, width, 160);
            } else {
              return LoadingWidget(width, height);
            }
          },
        ));
  }

  Widget _buildCarouselWidget(
      List<Testimonial> data, double width, double height) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.fromLTRB(10.0, 0, 10, 2),
            child: Text(
              'Testimonials',
              textAlign: TextAlign.start,
              style: TextStyle(
                color: themeGold,
                fontSize: 18.0,
                fontWeight: FontWeight.w700,
                fontFamily: 'Signika Negative',
                letterSpacing: 0.7,
              ),
            ),
          ),
          Container(
            height: 125.0,
            child: CarouselSlider(
              options: CarouselOptions(
                height: (height / 4.0),
                enlargeCenterPage: true,
                autoPlay: true,
                aspectRatio: 16 / 9,
                autoPlayInterval: const Duration(seconds: 20),
                autoPlayCurve: Curves.fastOutSlowIn,
                enableInfiniteScroll: true,
                autoPlayAnimationDuration: const Duration(milliseconds: 800),
                viewportFraction: 1.0,

              ),
              items: [
                for(var item in data )
                  CarouselTestimonial(width, item),
              ],
            ),
          )
        ]
    );
  }
}