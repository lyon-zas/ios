import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tritek_lms/appTheme/appTheme.dart';

class LoadingWidget extends StatelessWidget {
  final double height;
  final double width;

  LoadingWidget(this.width, this.height);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SpinKitRipple(color: themeGold),
    );
  }
}

class HttpErrorWidget extends StatelessWidget {
  final String error;
  final double width;
  final double height;

  HttpErrorWidget(this.error, this.width, this.height);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.error_outline,
          size: 50,
          color: Colors.orange,
        ),
        SizedBox(
          height: 10,
        ),
        AutoSizeText(
          error,
          textAlign: TextAlign.center,
        ),
      ],
    ));
  }
}
