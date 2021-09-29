import 'dart:io';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tritek_lms/FRS/db/database.dart';
import 'package:tritek_lms/FRS/models/user.model.dart';
import 'package:tritek_lms/FRS/services/facenet.service.dart';
import 'package:tritek_lms/FRS/services/ml_kit_service.dart';
import 'package:tritek_lms/FRS/widgets/auth-action-button.dart';
import 'package:tritek_lms/appTheme/appTheme.dart';
import 'package:tritek_lms/blocs/user.bloc.dart';
import 'package:tritek_lms/custom/form.validators.dart';
import 'package:tritek_lms/data/entity/courses.dart';
import 'package:tritek_lms/data/entity/subscription.plans.dart';
import 'package:tritek_lms/data/repository/user.repository.dart';
import 'package:tritek_lms/http/google.login.dart';
import 'package:tritek_lms/http/user.dart';
import 'package:tritek_lms/pages/common/dialog.dart';
import 'package:tritek_lms/pages/course/course.dart';
import 'package:tritek_lms/pages/course/courses.dart';
import 'package:tritek_lms/pages/home/home.dart';
import 'package:tritek_lms/pages/login_signup/captureSignUp.dart';
import 'package:tritek_lms/pages/login_signup/captureSignIn.dart';
import 'package:tritek_lms/pages/login_signup/dialog.dart';
import 'package:tritek_lms/pages/login_signup/forgot_password.dart';
import 'package:tritek_lms/pages/login_signup/signup.dart';
import 'package:tritek_lms/pages/login_signup/termsAndcond.dart';
import 'package:tritek_lms/pages/payment/select_plan.dart';
import 'package:tritek_lms/pages/settings/help.dart';
import 'package:tritek_lms/pages/settings/privacy_policy.dart';
import 'package:tritek_lms/pages/settings/terms_condition.dart';
import 'package:url_launcher/url_launcher.dart';

class Login extends StatefulWidget {
  final Course _course;
  final SubscriptionPlans _subscriptionPlans;

  Login(this._course, this._subscriptionPlans);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _obscureText = true;
  DateTime currentBackPressTime;

  final GoogleLogin _googleLogin = GoogleLogin();
  final _formKey = GlobalKey<FormState>();
  final UserRepository _repository = UserRepository();
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  final userBloc = UserBloc();
  // Services injection
  FaceNetService _faceNetService = FaceNetService();
  MLKitService _mlKitService = MLKitService();
  DataBaseService _dataBaseService = DataBaseService();

  CameraDescription cameraDescription;
  bool loading = false;
  User predictedUser;
  bool remember = false;

  @override
  void initState() {
    _loadUserEmailPassword();
    super.initState();
    super.initState();
    _startUp();
    userBloc.userStatus.listen((value) {
      if (!mounted) {
        return;
      }
      if (value == true) {
        // userBloc.dispose();
        Navigator.push(
            context,
            PageTransition(
                type: PageTransitionType.rightToLeft, child: Home()));
        return;
      }
    });

    userBloc.getUser();
  }

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

  String _username;
  var _password;

  FocusNode _usernameFocusNode = FocusNode();
  FocusNode _passwordFocusNode = FocusNode();

  @override
  void dispose() {
    userBloc.dispose();
    super.dispose();
  }

  // Toggles the password show status
  void _viewPassword() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  _showDialogg(BuildContext context) {
    VoidCallback continueCallBack = () => {
          Navigator.of(context).pop(),
          // code on continue comes here
        };
    BlurryDialog alert = BlurryDialog(
      "Face Recognition System",
      "Would you like to enable facial recognition for MyTritekApp?",
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  //handle remember me function
  void _handleRemeberme(bool value) {
    remember = value;
    SharedPreferences.getInstance().then(
      (prefs) {
        prefs.setBool("remember_me", value);
        prefs.setString('email', _usernameFocusNode.toString());
        prefs.setString('password', _passwordFocusNode.toString());
      },
    );
    setState(() {
      remember = value;
    });
  }

  void _loadUserEmailPassword() async {
    print("Load Email");
    try {
      SharedPreferences _prefs = await SharedPreferences.getInstance();
      var _email = _prefs.getString("email") ?? "";
      var _password = _prefs.getString("password") ?? "";
      var _remeberMe = _prefs.getBool("remember_me") ?? false;

      print(_remeberMe);
      print(_email);
      print(_password);
      if (_remeberMe) {
        setState(() {
          remember = true;
        });
        _usernameFocusNode = (_email ?? "") as FocusNode;
        _passwordFocusNode = (_password ?? "") as FocusNode;
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/appbar_bg.png'), fit: BoxFit.cover),
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
          Positioned(
            child: Scaffold(
              appBar: AppBar(
                elevation: 0.0,
                backgroundColor: Colors.transparent,
                leadingWidth: 60,
                leading: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                      height: 30,
                      width: 30,
                      child: Center(
                        child: Icon(Icons.arrow_back_ios, color: Colors.white),
                      )), // this should route to the previous screen
                ),
              ),
              backgroundColor: Colors.transparent,
              body: Form(
                key: _formKey,
                child: ListView(
                  physics: BouncingScrollPhysics(),
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 20.0, left: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Sign In',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 30.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          // SizedBox(width: 10),
                          // Text(
                          //   'MyTritek',
                          //   style: TextStyle(
                          //     color: themeGold,
                          //     fontSize: 30.0,
                          //     fontWeight: FontWeight.w600,
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                    // SizedBox(height: 10.0),
                    // Padding(
                    //   padding: EdgeInsets.only(left: 20.0),
                    //   child: Text(
                    //     'Login to your account',
                    //     style: TextStyle(
                    //       color: Colors.white,
                    //       fontSize: 12.0,
                    //       fontWeight: FontWeight.w400,
                    //     ),
                    //   ),
                    // ),
                    SizedBox(height: 50.0),

                    Padding(
                      padding: EdgeInsets.only(left: 20.0),
                      child: Text(
                        'Email or username',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Padding(
                      padding: EdgeInsets.only(right: 20.0, left: 20.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200].withOpacity(0.3),
                        ),
                        child: TextFormField(
                          focusNode: _usernameFocusNode,
                          textCapitalization: TextCapitalization.none,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            return Validator.required(value, 3,
                                'Username is required, min length is 4');
                          },
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500,
                          ),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left: 20.0),
                            hintStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                              fontWeight: FontWeight.w500,
                            ),
                            border: InputBorder.none,
                          ),
                          onSaved: (username) => _username = username,
                          onFieldSubmitted: (_) {
                            fieldFocusChange(context, _usernameFocusNode,
                                _passwordFocusNode);
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 30.0),
                    Padding(
                      padding: EdgeInsets.only(left: 20.0),
                      child: Text(
                        'Password',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Padding(
                      padding: EdgeInsets.only(right: 20.0, left: 20.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200].withOpacity(0.3),
                        ),
                        child: TextFormField(
                          focusNode: _passwordFocusNode,
                          textCapitalization: TextCapitalization.none,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            return Validator.required(value, 5,
                                'Password is required, min length is 6');
                          },
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500,
                          ),
                          obscureText: _obscureText,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(
                                left: 20.0, top: 13.0, bottom: 12.0),
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
                    SizedBox(height: 20.0),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            PageTransition(
                                type: PageTransitionType.rightToLeft,
                                child: ForgotPassword()));
                      },
                      child: Container(
                        padding: EdgeInsets.all(5.0),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                        ),
                        child: Text(
                          'Forgot your password?',
                          style: TextStyle(
                            fontFamily: 'Signika Negative',
                            fontSize: 17.0,
                            color: Colors.blue[200],
                            fontWeight: FontWeight.w700,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 25.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: Text(
                              'Remember me',
                              style: TextStyle(
                                fontFamily: 'Signika Negative',
                                fontSize: 17.0,
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          Container(
                            child: Switch(
                              activeColor: textColor,
                              value: remember,
                              onChanged: (value) {
                                setState(() {
                                  remember = value;
                                  _handleRemeberme;
                                });
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 30),
                    Padding(
                      padding: EdgeInsets.only(right: 10.0, left: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(
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
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      PageTransition(
                                          type: PageTransitionType.rightToLeft,
                                          child: CaptureSignIn(
                                            cameraDescription:
                                                cameraDescription,
                                          )));
                                },
                                color: Colors.transparent,
                                child: Text(
                                  'Face ID',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
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
                                onPressed: () {
                                  if (_formKey.currentState.validate()) {
                                    _formKey.currentState.save();
                                    login(context);
                                  }
                                },
                                color: Colors.transparent,
                                child: Text(
                                  'Sign In',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // SizedBox(height: 30.0),
                    // InkWell(
                    //   onTap: () {
                    //     Navigator.push(
                    //         context,
                    //         PageTransition(
                    //             type: PageTransitionType.rightToLeft,
                    //             child: SignUp()));
                    //   },
                    //   child: Container(
                    //     padding: EdgeInsets.all(5.0),
                    //     alignment: Alignment.center,
                    //     decoration: BoxDecoration(
                    //       color: Colors.transparent,
                    //     ),
                    //     child: Text(
                    //       'Sign up',
                    //       style: TextStyle(
                    //         fontFamily: 'Signika Negative',
                    //         fontSize: 17.0,
                    //         color: Colors.white,
                    //         fontWeight: FontWeight.w700,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    // SizedBox(height: 10.0),
                    // InkWell(
                    //   onTap: () {
                    //     Navigator.push(
                    //         context,
                    //         PageTransition(
                    //             type: PageTransitionType.rightToLeft,
                    //             child: ForgotPassword()));
                    //   },
                    //   child: Container(
                    //     padding: EdgeInsets.all(5.0),
                    //     alignment: Alignment.center,
                    //     decoration: BoxDecoration(
                    //       color: Colors.transparent,
                    //     ),
                    //     child: Text(
                    //       'Forgot your password?',
                    //       style: TextStyle(
                    //         fontFamily: 'Signika Negative',
                    //         fontSize: 17.0,
                    //         color: Colors.white,
                    //         fontWeight: FontWeight.w700,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    // SizedBox(height: 50),
                    // Padding(
                    //   padding: EdgeInsets.symmetric(horizontal: 20.0),
                    //   child: InkWell(
                    //     borderRadius: BorderRadius.circular(30.0),
                    //     onTap: () {
                    //       Navigator.push(
                    //           context,
                    //           PageTransition(
                    //               type: PageTransitionType.rightToLeft,
                    //               child: CaptureSignIn(
                    //                 cameraDescription: cameraDescription,
                    //               )));
                    //     },
                    //     child: Container(
                    //       padding: EdgeInsets.all(15.0),
                    //       alignment: Alignment.center,
                    //       decoration: BoxDecoration(
                    //         borderRadius: BorderRadius.circular(30.0),
                    //         color: Colors.white,
                    //       ),
                    //       child: Row(
                    //         mainAxisAlignment: MainAxisAlignment.center,
                    //         crossAxisAlignment: CrossAxisAlignment.center,
                    //         children: <Widget>[
                    //           Image.asset(
                    //             'assets/FaceNetAuthentication-Logo.png',
                    //             height: 25.0,
                    //             fit: BoxFit.fitHeight,
                    //           ),
                    //           SizedBox(width: 10.0),
                    //           Text(
                    //             'Login with Face ID',
                    //             style: TextStyle(
                    //               fontSize: 16.0,
                    //               color: Colors.black,
                    //               fontWeight: FontWeight.w500,
                    //             ),
                    //           ),
                    //         ],
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    SizedBox(height: 30),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(children: <Widget>[
                        Expanded(
                          child: new Container(
                              margin: const EdgeInsets.only(
                                  left: 10.0, right: 20.0),
                              child: Divider(
                                color: Colors.white,
                                height: 36,
                                thickness: 2.0,
                              )),
                        ),
                        Text(
                          "Or sign in with",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Expanded(
                          child: new Container(
                              margin: const EdgeInsets.only(
                                  left: 20.0, right: 10.0),
                              child: Divider(
                                color: Colors.white,
                                height: 36,
                                thickness: 2.0,
                              )),
                        ),
                      ]),
                    ),
                    SizedBox(height: 30),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          InkWell(
                            onTap: () {
                                  _googleLogin.handleSignIn().then((acc) => {
                                        if (acc != null)
                                          {
                                            _loginGoogle(acc),
                                          }
                                      });
                                },
                            child: Container(
                               width:50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Center(
                                child: Image.asset(
                                  'assets/google.png',
                                  height: 25.0,
                                  fit: BoxFit.fitHeight,
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: (){ FacebookAuth.instance.login(permissions: [
                                    "public_profile",
                                    "email"
                                  ]).then((value) {
                                    FacebookAuth.instance
                                        .getUserData()
                                        .then((userData) {
                                      setState(() {
                                        Navigator.push(
                                            context,
                                            PageTransition(
                                                type: PageTransitionType
                                                    .rightToLeft,
                                                child: Home()));
                                      });
                                    });
                                  });},
                            child: Container(
                              width:50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Center(
                                child: FaIcon(FontAwesomeIcons.facebookF,
                                    size: 30, color: Colors.blue),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: (){},
                            child: Container(
                              width:50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Center(
                                child: FaIcon(
                                  FontAwesomeIcons.apple,
                                  color: Colors.black,
                                  size: 30,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 40),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
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
                                'Need help?',
                                style: TextStyle(
                                  color: Colors.blue[200],
                                    decoration: TextDecoration.underline,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            // InkWell(
                            //   onTap: () {
                            //     Navigator.push(
                            //         context,
                            //         PageTransition(
                            //             type: PageTransitionType.rightToLeft,
                            //             child: Help()));
                            //   },
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
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Container(
                        alignment: Alignment.center,
                        child: Text(
                          'By signing in, you accept our',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment:MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Terms()));
                          },
                              child: Text(
                                'Terms and Conditions',
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  color: Colors.blue[200],
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Text(
                              ' and acknowledge the',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                            Navigator.push(
                                context,
                                PageTransition(
                                    type: PageTransitionType.rightToLeft,
                                    child: Privacy()));
                          },
                              child: Text(
                                ' Privacy Policy.',
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  color: Colors.blue[200],
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 15)
                    // Padding(
                    //   padding: EdgeInsets.symmetric(horizontal: 20.0),
                    //   child: InkWell(
                    //     borderRadius: BorderRadius.circular(30.0),
                    //     onTap: () {
                    //       _googleLogin.handleSignIn().then((acc) => {
                    //             if (acc != null)
                    //               {
                    //                 _loginGoogle(acc),
                    //               }
                    //           });
                    //     },
                    //     child: Container(
                    //       padding: EdgeInsets.all(15.0),
                    //       alignment: Alignment.center,
                    //       decoration: BoxDecoration(
                    //         borderRadius: BorderRadius.circular(30.0),
                    //         color: Colors.white,
                    //       ),
                    //       child: Row(
                    //         mainAxisAlignment: MainAxisAlignment.center,
                    //         crossAxisAlignment: CrossAxisAlignment.center,
                    //         children: <Widget>[
                    //           Image.asset(
                    //             'assets/google.png',
                    //             height: 25.0,
                    //             fit: BoxFit.fitHeight,
                    //           ),
                    //           SizedBox(width: 10.0),
                    //           Text(
                    //             'Login with Google',
                    //             style: TextStyle(
                    //               fontSize: 16.0,
                    //               color: Colors.black,
                    //               fontWeight: FontWeight.w500,
                    //             ),
                    //           ),
                    //         ],
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(
        msg: 'Press Back Once Again to Exit.',
        backgroundColor: Colors.black,
        textColor: Theme.of(context).appBarTheme.color,
      );
      return Future.value(false);
    }
    exit(0);
  }

  Future<void> login(BuildContext context) async {
    try {
      LoadingDialogs.showLoadingDialog(
          context, _keyLoader, 'Login you in...'); //invoking login
      UserResponse _response = await _repository.login(_username, _password);
      if (_response.error.length > 0) {
        Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
        ServerValidationDialog.errorDialog(
            context, _response.error, _response.eTitle); //invoking log
      } else {
        _successRoute(_response);
      }
    } catch (error) {
      Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
      ServerValidationDialog.errorDialog(
          context, 'Invalid credentials', ''); //invoking log
    }
  }

  _successRoute(UserResponse response) {
    Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();

    if (widget._course != null && response.results.status == 'active') {
      Navigator.push(
          context,
          PageTransition(
              type: PageTransitionType.rightToLeft,
              child: CoursesNew(
                courseData: widget._course,
              )));
    } else if (response.results.status != 'active' &&
        widget._subscriptionPlans != null) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => SelectPlan(course: widget._course)));
    } else {
      Navigator.push(context,
          PageTransition(type: PageTransitionType.rightToLeft, child: Home()));
    }
  }

  _loginGoogle(GoogleSignInAccount acc) async {
    LoadingDialogs.showLoadingDialog(context, _keyLoader, 'Signing you in...');
    print(acc);
    try {
      final resp = await _repository.googleLogin(acc);

      print(resp.results?.email);
      if (resp.results != null) {
        _successRoute(resp);
      } else {
        Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
      }
    } catch (e) {
      Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
      ServerValidationDialog.errorDialog(
          context, 'An Error Occurred, Please try again', ''); //invoking log
    }
  }

  var users = DataBaseService().loadDB();

  _capturedData() {
    Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
    if (users != null) {
      Navigator.push(
          context,
          PageTransition(
              type: PageTransitionType.rightToLeft,
              child: CaptureSignIn(
                cameraDescription: cameraDescription,
              )));
    } else {
      // ignore: unnecessary_statements
      _showDialogg(context);
    }
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
