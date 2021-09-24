import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tritek_lms/appTheme/appTheme.dart';

class LoadingDialogs {
  static Future<void> showLoadingDialog(
      BuildContext context, GlobalKey key, String msg) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new WillPopScope(
              onWillPop: () async => false,
              child: Dialog(
                  key: key,
                  backgroundColor: themeBlue,
                  child: Container(
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(
                            height: 10,
                          ),
                          AutoSizeText(
                            msg,
                            maxLines: 2,
                            style: TextStyle(color: themeGold),
                          ),
                        ]),
                  )));
        });
  }
}

class ServerValidationDialog {
  static Future<void> errorDialog(
      BuildContext context, String msg, String title) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return new WillPopScope(
              onWillPop: () async => false,
              child: Dialog(
                  backgroundColor: themeBlue,
                  child: Container(
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AutoSizeText(
                            title,
                            style: TextStyle(
                              color: themeGold,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          AutoSizeText(
                            msg,
                            style: TextStyle(color: themeGold),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              width: 100,
                              alignment: Alignment.center,
                              padding: EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                color: themeGold,
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              child: Text(
                                'Ok',
                                style: TextStyle(
                                  fontFamily: 'Signika Negative',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ]),
                  )));
        });
  }
}
