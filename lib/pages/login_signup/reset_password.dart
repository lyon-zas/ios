import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:tritek_lms/appTheme/appTheme.dart';
import 'package:tritek_lms/custom/form.validators.dart';
import 'package:tritek_lms/data/repository/user.repository.dart';
import 'package:tritek_lms/http/user.dart';
import 'package:tritek_lms/pages/common/dialog.dart';
import 'package:tritek_lms/pages/login_signup/login.dart';

class ResetPasswordScreen extends StatefulWidget {
  final data;
  final email;
  final mode;

  ResetPasswordScreen(this.data, this.email, this.mode);

  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  var firstController = TextEditingController();
  var secondController = TextEditingController();
  var thirdController = TextEditingController();
  var fourthController = TextEditingController();
  var passwordController = TextEditingController();
  FocusNode secondFocusNode = FocusNode();
  FocusNode thirdFocusNode = FocusNode();
  FocusNode fourthFocusNode = FocusNode();
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  final UserRepository _repository = UserRepository();

  FocusNode _passwordFocusNode = FocusNode();
  bool _obscureText = true;
  bool _otpCorrect = false;
  String _password;

  Timer _timer;
  int _start = 60;

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
  void initState() {
    super.initState();
    _start = 60;
    startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

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
            Container(
              margin: EdgeInsets.only(top: 60, left: 20),
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                    height: 30,
                    width: 30,
                    child: Center(
                      child: Icon(Icons.arrow_back_ios, color: Colors.white),
                    )), // this should route to the previous screen
              )),
            Positioned(
              child: Scaffold(
                backgroundColor: Colors.transparent,
                body: ListView(
                  physics: BouncingScrollPhysics(),
                  children: <Widget>[
                    Padding(
                    padding: EdgeInsets.only(
                      top: 25.0,
                    ),
                    child: Center(
                      child: Text(
                        'Reset Password',
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
                      child: Text(
                        'Enter the OTP you received on your registered Email:',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.0,
                          fontWeight: FontWeight.w400,
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
                          SizedBox(width: 10.0),
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
                    if (_otpCorrect) SizedBox(height: 20.0),
                    if (_otpCorrect)
                      Padding(
                        padding: EdgeInsets.only(right: 20.0, left: 20.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[200].withOpacity(0.3),
                            
                          ),
                          child: TextFormField(
                            focusNode: _passwordFocusNode,
                            controller: passwordController,
                            textCapitalization: TextCapitalization.none,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            validator: (value) {
                              return Validator.password(value);
                            },
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.0,
                              fontWeight: FontWeight.w500,
                            ),
                            obscureText: _obscureText,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(
                                  left: 20.0, top: 13.0, bottom: 12.0),
                              hintText: 'Password',
                              hintStyle: TextStyle(
                                color: Colors.white,
                                // fontSize: 16.0,
                                fontWeight: FontWeight.w500,
                              ),
                              border: InputBorder.none,
                              suffixIcon: IconButton(
                                icon: Icon(Icons.remove_red_eye),
                                onPressed: _viewPassword,
                              ),
                            ),
                            onSaved: (password) => _password = password,
                          ),
                        ),
                      ),
                    if (_otpCorrect) SizedBox(height: 20.0),
                    Padding(
                      padding: EdgeInsets.only(right: 20.0, left: 20.0),
                      child: SizedBox(
                        height: 50.0,
                        child: Container(
                          decoration: BoxDecoration(
                            
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
                             
                            ),
                            onPressed: () {
                              if (_otpCorrect) {
                                changePassword();
                              } else {
                                checkPin('d', context);
                              }
                            },
                            color: Colors.transparent,
                            child: Text(
                              _otpCorrect ? 'Change Password' : 'Verify OTP',
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
        setState(() {
          _otpCorrect = true;
        });
      } else {
        ServerValidationDialog.errorDialog(
            context, 'Please check again.', 'Invalid input'); //invoking log
      }
    } catch (error) {
      ServerValidationDialog.errorDialog(
          context, 'An Error Occurred. Pls try again', ""); //invoking log
    }
  }

  void _viewPassword() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  Future<void> changePassword() async {
    try {
      _password = passwordController.value.text;
      var validate = Validator.password(_password);
      if (validate != null) {
        print('Validate Error: $validate');
        ServerValidationDialog.errorDialog(
            context, validate, ""); //invoking log
        return;
      }

      LoadingDialogs.showLoadingDialog(
          context, _keyLoader, 'Processing your request...'); //invoking login

      RegisterResponse _response = await _repository.setNewPassword(
          widget.email, _password, widget.data);

      if (_response.error.length > 0) {
        Navigator.of(_keyLoader.currentContext, rootNavigator: true)
            .pop(); //close the dialog

        ServerValidationDialog.errorDialog(
            context, _response.error, ""); //invoking log
      } else {
        Navigator.of(_keyLoader.currentContext, rootNavigator: true)
            .pop(); //close the dialog

        showDialog<void>(
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
                                'Password Reset Success',
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
                                'Your Password has been reset successfully. Click Ok to proceed to  Login',
                                style: TextStyle(color: themeGold),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                  Navigator.push(
                                      context,
                                      PageTransition(
                                          type: PageTransitionType.rightToLeft,
                                          child: Login(null, null)));
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
    } catch (e) {
      Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();

      ServerValidationDialog.errorDialog(
          context,
          'An Error Occurred. Pls check your Network Connection and try again',
          "");
    }
  }

  Future<void> resendOtp() async {
    Navigator.pop(context);
  }
}
