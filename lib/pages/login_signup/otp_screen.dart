import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:tritek_lms/FRS/db/database.dart';
import 'package:tritek_lms/FRS/services/facenet.service.dart';
import 'package:tritek_lms/FRS/services/ml_kit_service.dart';
import 'package:tritek_lms/appTheme/appTheme.dart';
import 'package:tritek_lms/custom/form.validators.dart';
import 'package:tritek_lms/data/repository/user.repository.dart';
import 'package:tritek_lms/http/user.dart';
import 'package:tritek_lms/pages/common/dialog.dart';
import 'package:tritek_lms/pages/home/home.dart';
import 'package:tritek_lms/pages/login_signup/captureSignUp.dart';
import 'package:tritek_lms/pages/login_signup/termsAndcond.dart';
import 'package:tritek_lms/pages/settings/help.dart';

class OTPScreen extends StatefulWidget {
  final data;
  final email;
  final mode;

  OTPScreen(this.data, this.email, this.mode);

  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  var firstController = TextEditingController();
  var secondController = TextEditingController();
  var thirdController = TextEditingController();
  var fourthController = TextEditingController();
  FocusNode secondFocusNode = FocusNode();
  FocusNode thirdFocusNode = FocusNode();
  FocusNode fourthFocusNode = FocusNode();
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  final UserRepository _repository = UserRepository();

  Timer _timer;
  int _start = 180;

  void startTimer() {
    _timer = new Timer.periodic(
      Duration(seconds: 1),
      (Timer timer) {
        if (_start == 0) {
          if (mounted) {
            setState(() {
              timer.cancel();
            });
          }
        } else {
          if (mounted) {
            setState(() {
              _start--;
            });
          }
        }
      },
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _start = 180;
    startTimer();
    _startUp();
  }

  // Services injection
  FaceNetService _faceNetService = FaceNetService();
  MLKitService _mlKitService = MLKitService();
  DataBaseService _dataBaseService = DataBaseService();

  CameraDescription cameraDescription;
  bool loading = false;

  /// 1 Obtain a list of the available cameras on the device.
  /// 2 loads the face net model
  _startUp() async {
    _setLoading(true);

    List<CameraDescription> cameras = await availableCameras();

    /// takes the front camera
    cameraDescription = cameras.firstWhere(
      (CameraDescription camera) =>
          camera.lensDirection == CameraLensDirection.front,
    );

    // start the services
    await _faceNetService.loadModel();
    await _dataBaseService.loadDB();
    _mlKitService.initialize();

    _setLoading(false);
  }

  // shows or hides the circular progress indicator
  _setLoading(bool value) {
    setState(() {
      loading = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    int mode = widget.mode;

    otp() {
      return Container(
        decoration: BoxDecoration(
          color: themeBlue,
        ),
        child: Stack(
          children: <Widget>[
            Positioned(
              top: 0.0,
              left: 0.0,
              child: Container(
                width: width,
                height: height,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.1, 0.3, 0.5, 0.7, 0.9],
                    colors: [
                      Colors.black.withOpacity(0.3),
                      Colors.black.withOpacity(0.4),
                      Colors.black.withOpacity(0.55),
                      Colors.black.withOpacity(0.67),
                      Colors.black.withOpacity(0.79),
                    ],
                  ),
                ),
              ),
            ),
            // Container(
            //     margin: EdgeInsets.only(top: 60, left: 20),
            //     child: GestureDetector(
            //       onTap: () {
            //         Navigator.pop(context);
            //       },
            //       child: Container(
            //           height: 30,
            //           width: 30,
            //           child: Center(
            //             child: Icon(Icons.arrow_back_ios, color: Colors.white),
            //           )), // this should route to the previous screen
            //     )),
            Positioned(
              child: Scaffold(
                appBar: AppBar(leading: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                      height: 30,
                      width: 30,
                      child: Center(
                        child: Icon(Icons.arrow_back_ios, color: Colors.white),
                      )), // this should route to the previous screen
                ),),
                backgroundColor: Colors.transparent,
                body: ListView(
                  physics: BouncingScrollPhysics(),
                  children: <Widget>[
                   
                    Padding(
                      padding: EdgeInsets.only(
                          top: 35,left:0 ),
                      child: Center(
                        child: Text(
                          mode == 1
                              ? 'Enter Code'
                              : 'Password Reset Request',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 30.0,
                              fontWeight: FontWeight.w600,
                            ),
                        ),
                      ),
                    ),
                    SizedBox(height: 90.0),
                    Padding(
                      padding:
                          EdgeInsets.only(left: 25.0, right: 25, bottom: 20),
                      child: Center(
                        child: Column(
                          children: [
                            Text(
                              'Please enter the One Time Password (OTP) in the email \n sent to  \n to complete your registration',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12.0,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Text(
                              ' sent to ',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12.0,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Text(
                              'to complete your registration',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12.0,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // OTP Box Start
                    Padding(
                      padding: EdgeInsets.only(left: 50.0, right: 50),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          // 1 Start
                          Container(
                            width: 50.0,
                            height: 50.0,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5.0),
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                  blurRadius: 1.5,
                                  spreadRadius: 1.5,
                                  color: Colors.grey[200],
                                ),
                              ],
                            ),
                            child: TextFormField(
                              controller: firstController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(18.0),
                                border: InputBorder.none,
                              ),
                              onChanged: (v) {
                                FocusScope.of(context)
                                    .requestFocus(secondFocusNode);
                              },
                              validator: (value) {
                                return Validator.required(value, 0, '');
                              },
                            ),
                          ),
                          // 1 End
                          // 2 Start
                          Container(
                            width: 50.0,
                            height: 50.0,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5.0),
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                  blurRadius: 1.5,
                                  spreadRadius: 1.5,
                                  color: Colors.grey[200],
                                ),
                              ],
                            ),
                            child: TextFormField(
                              focusNode: secondFocusNode,
                              controller: secondController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(18.0),
                                border: InputBorder.none,
                              ),
                              validator: (value) {
                                return Validator.required(value, 0, '');
                              },
                              onChanged: (v) {
                                FocusScope.of(context)
                                    .requestFocus(thirdFocusNode);
                              },
                            ),
                          ),
                          // 2 End
                          // 3 Start
                          Container(
                            width: 50.0,
                            height: 50.0,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5.0),
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                  blurRadius: 1.5,
                                  spreadRadius: 1.5,
                                  color: Colors.grey[200],
                                ),
                              ],
                            ),
                            child: TextFormField(
                              focusNode: thirdFocusNode,
                              controller: thirdController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(18.0),
                                border: InputBorder.none,
                              ),
                              validator: (value) {
                                return Validator.required(value, 0, '');
                              },
                              onChanged: (v) {
                                FocusScope.of(context)
                                    .requestFocus(fourthFocusNode);
                              },
                            ),
                          ),
                          // 3 End
                          // 4 Start
                          Container(
                            width: 50.0,
                            height: 50.0,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5.0),
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                  blurRadius: 1.5,
                                  spreadRadius: 1.5,
                                  color: Colors.grey[200],
                                ),
                              ],
                            ),
                            child: TextFormField(
                              focusNode: fourthFocusNode,
                              controller: fourthController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(18.0),
                                border: InputBorder.none,
                              ),
                              validator: (value) {
                                return Validator.required(value, 0, '');
                              },
                              onChanged: (v) {
                                checkPin(v, context);
                              },
                            ),
                          ),
                          // 4 End
                        ],
                      ),
                    ), // OTP Box End
                    SizedBox(height: 40.0),
                    Padding(
                      padding: EdgeInsets.only(left: 50.0, right: 50),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        // crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            _start == 0
                                ? 'Didn\'t receive OTP Code!'
                                : 'Email Sent! Check Your Inbox',
                            style: TextStyle(
                              fontSize: 13.0,
                              fontFamily: 'Signika Negative',
                              color: Colors.grey[500],
                            ),
                          ),
                          SizedBox(width: 20.0),
                          InkWell(
                            onTap: () {
                              if (_start == 0) {
                                resendOtp();
                              }
                            },
                            child: Text(
                              _start == 0 ? 'Resend' : _start.toString(),
                              style: TextStyle(
                                fontSize: 13.0,
                                fontFamily: 'Signika Negative',
                                color: themeGold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Padding(
                      padding: EdgeInsets.only(right: 20.0, left: 20.0),
                      child: SizedBox(
                        height: 50.0,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30.0),
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.bottomRight,
                              stops: [0.1, 0.5, 0.9],
                              colors: [
                                Colors.yellow[300].withOpacity(0.6),
                                Colors.yellow[500].withOpacity(0.8),
                                Colors.yellow[600].withOpacity(1.0),
                              ],
                            ),
                          ),
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            onPressed: () {},
                            color: Colors.transparent,
                            child: Text(
                              _start == 0 ? 'Submit OTP' : "send",
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
                    SizedBox(height: 200),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal:30),
                      child: Row( mainAxisAlignment:MainAxisAlignment.center,
                        children: [
                         InkWell(
                          onTap: () {
                            Navigator.push(
                                    context,
                                    PageTransition(
                                        type: PageTransitionType.rightToLeft,
                                        child: Help()));
                              },
                          child: Text(
                            'Need help? ',
                            style: TextStyle(
                              color: Colors.blue[200],
                              decoration: TextDecoration.underline,
                              fontSize: 16.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        // InkWell(
                        //   onTap: () {},
                        //   child: Text(
                        //     'Contact Tritek Support',
                        //     style: TextStyle(
                        //       decoration: TextDecoration.underline,
                        //       color: Colors.blue[200],
                        //       fontSize: 16.0,
                        //       fontWeight: FontWeight.w500,
                        //     ),
                        //   ),
                        // )
                      ]),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      body: otp(),
    );
  }

  Future<void> checkPin(String v, BuildContext context) async {
    try {
      if (v.length < 1) {
        return;
      }
      String otp = firstController.value.text +
          secondController.value.text +
          thirdController.value.text +
          fourthController.value.text;
      if (otp == widget.data) {
        LoadingDialogs.showLoadingDialog(
            context, _keyLoader, 'Processing your details'); //invoking login
        if (widget.mode == 1) {
          UserResponse _response = await _repository.verify(otp, widget.email);

          if (_response.error.length > 0) {
            Navigator.of(_keyLoader.currentContext, rootNavigator: true)
                .pop(); //close the dialoge

            ServerValidationDialog.errorDialog(
                context, _response.error, ""); //invoking log
          } else {
            Navigator.of(_keyLoader.currentContext, rootNavigator: true)
                .pop(); //close the dialoge
            Navigator.push(
                context,
                PageTransition(
                    type: PageTransitionType.rightToLeft,
                    child: TermsAndConditions()
                    //Home()
                    ));
          }
        } else {
          Navigator.push(
              context,
              PageTransition(
                  type: PageTransitionType.rightToLeft,
                  child: TermsAndConditions()
                  //Home()
                  ));
        }
      } else {
        ServerValidationDialog.errorDialog(
            context, 'Please check again.', 'Invalid input'); //invoking log
      }
    } catch (error) {
      Navigator.of(_keyLoader.currentContext, rootNavigator: true)
          .pop(); //close the dialoge

      ServerValidationDialog.errorDialog(
          context, 'An Error Occurred. Pls try again', ""); //invoking log
    }
  }

  Future<void> resendOtp() async {
    Navigator.pop(context);
  }
}
