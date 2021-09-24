import 'package:flutter/material.dart';
import 'package:tritek_lms/appTheme/appTheme.dart';
import 'package:tritek_lms/blocs/subs.plan.bloc.dart';
import 'package:tritek_lms/data/entity/subscription.plans.dart';
import 'package:tritek_lms/http/subscription.plan.dart';
import 'package:tritek_lms/pages/common/utils.dart';
import 'package:tritek_lms/pages/home/home_component/subs.list.dart';

class SubscriptionSlider extends StatefulWidget {
  @override
  _SubscriptionSlider createState() => _SubscriptionSlider();
}

class _SubscriptionSlider extends State<SubscriptionSlider> {
  @override
  void initState() {
    super.initState();
    subBloc.getSubs();
  }

  @override
  Widget build(BuildContext context) {
    double height = 190;
    double width = MediaQuery.of(context).size.width;

    return Container(
        width: width,
        height: 190.0,
        color: Theme.of(context).appBarTheme.color,
        child: StreamBuilder<SubscriptionPlanResponse>(
          stream: subBloc.subject.stream,
          builder: (context, AsyncSnapshot<SubscriptionPlanResponse> snapshot) {
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
        ));
  }

  Widget _buildCarouselWidget(
      List<SubscriptionPlans> data, double width, double height) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: Text(
            'Membership/Subscription',
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
            height: 150.0,
            child: ListView(
                scrollDirection: Axis.horizontal,
                physics: BouncingScrollPhysics(),
                children: [
                  for(var item in data)
                    SubsListWidget(width, item)
                ]
            )
        ),
      ],
    );
  }
}



