import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tritek_lms/appTheme/appTheme.dart';
import 'package:tritek_lms/data/entity/subscription.plans.dart';

class SubsListWidget extends StatelessWidget {
  final SubscriptionPlans data;
  final width;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
// ....
      },
      child: Container(
        margin: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: themeBlue,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              blurRadius: 2.0,
              spreadRadius: 1.5,
              color: Colors.grey[300],
            )
          ],
        ),
        child: Container(
          padding: EdgeInsets.fromLTRB(20.0, 1.0, 20.0, 2.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 5.0),
              Text(
                data.name,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5.0),
              for (var item in data.properties)
                Text(
                  item.length > 0 ? "\u2022 " + item : "",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.0,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              SizedBox(height: 5.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    'Price: \u00A3' + data.price,
                    //+ data.plan.length > 0 ? "  (${data.plan})",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: themeGold,
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  SubsListWidget(this.width, this.data);
}
