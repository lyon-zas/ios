import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:page_transition/page_transition.dart';
import 'package:tritek_lms/FRS/db/database.dart';
import 'package:tritek_lms/FRS/services/facenet.service.dart';
import 'package:tritek_lms/FRS/services/ml_kit_service.dart';
import 'package:tritek_lms/appTheme/appTheme.dart';
import 'package:tritek_lms/custom/form.validators.dart';
import 'package:tritek_lms/data/repository/user.repository.dart';
import 'package:tritek_lms/http/google.login.dart';
import 'package:tritek_lms/http/user.dart';
import 'package:tritek_lms/pages/common/dialog.dart';
import 'package:tritek_lms/pages/home/home.dart';
import 'package:tritek_lms/pages/login_signup/captureSignUp.dart';
import 'package:tritek_lms/pages/login_signup/login.dart';
import 'package:tritek_lms/pages/login_signup/otp_screen.dart';
import 'package:tritek_lms/pages/login_signup/termsAndcond.dart';
import 'package:tritek_lms/pages/settings/help.dart';
import 'package:tritek_lms/pages/settings/privacy_policy.dart';
import 'package:tritek_lms/pages/settings/terms_condition.dart';
import 'package:url_launcher/url_launcher.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  // Initially password is obscure
  bool _obscureText = true;
  String _firstName, _lastName, _email, _username, _password, _phoneNo = '';

  final _formKey = GlobalKey<FormState>();
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  final UserRepository _repository = UserRepository();
  final GoogleLogin _googleLogin = GoogleLogin();

  FocusNode _usernameFocusNode = FocusNode();
  FocusNode _firstNameFocusNode = FocusNode();
  FocusNode _lastNameFocusNode = FocusNode();
  FocusNode _emailFocusNode = FocusNode();
  FocusNode _passwordFocusNode = FocusNode();

  get onPhoneNumberChange => null;

  // Toggles the password show status
  void _viewPassword() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  // Services injection
  FaceNetService _faceNetService = FaceNetService();
  MLKitService _mlKitService = MLKitService();
  DataBaseService _dataBaseService = DataBaseService();

  CameraDescription cameraDescription;
  bool loading = false;

  /// 1 Obtain a list of the availaPble cameras on the device.
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
  void initState() {
    super.initState();
    _startUp();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    void fieldFocusChange(
        BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
      currentFocus.unfocus();
      FocusScope.of(context).requestFocus(nextFocus);
    }

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
                      padding: EdgeInsets.only(top: 10, left: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Register',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 30.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 50.0),
                    Padding(
                      padding: EdgeInsets.only(left: 20.0),
                      child: Text(
                        'First Name',
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
                          focusNode: _firstNameFocusNode,
                          autofocus: true,
                          textCapitalization: TextCapitalization.words,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            return Validator.required(
                                value, 3, 'First Name is required');
                          },
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.0,
                            fontWeight: FontWeight.w500,
                          ),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left: 20.0),
                            hintStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 14.0,
                              fontWeight: FontWeight.w500,
                            ),
                            border: InputBorder.none,
                          ),
                          onSaved: (firstName) => _firstName = firstName,
                          onFieldSubmitted: (_) {
                            fieldFocusChange(context, _firstNameFocusNode,
                                _lastNameFocusNode);
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Padding(
                      padding: EdgeInsets.only(left: 20.0),
                      child: Text(
                        'Last Name',
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
                          focusNode: _lastNameFocusNode,
                          textCapitalization: TextCapitalization.words,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            return Validator.required(
                                value, 3, 'Last Name is required');
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
                              fontSize: 14.0,
                              fontWeight: FontWeight.w500,
                            ),
                            border: InputBorder.none,
                          ),
                          onSaved: (lastName) => _lastName = lastName,
                          onFieldSubmitted: (_) {
                            fieldFocusChange(
                                context, _lastNameFocusNode, _emailFocusNode);
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Padding(
                      padding: EdgeInsets.only(left: 20.0),
                      child: Text(
                        'E-mail',
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
                          focusNode: _emailFocusNode,
                          textCapitalization: TextCapitalization.none,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            return Validator.email(value);
                          },
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.0,
                            fontWeight: FontWeight.w500,
                          ),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left: 20.0),
                            hintStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 14.0,
                              fontWeight: FontWeight.w500,
                            ),
                            border: InputBorder.none,
                          ),
                          onSaved: (email) => _email = email,
                          onFieldSubmitted: (_) {
                            fieldFocusChange(
                                context, _emailFocusNode, _usernameFocusNode);
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Padding(
                      padding: EdgeInsets.only(left: 20.0),
                      child: Text(
                        'Username',
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
                            return Validator.required(
                                value, 5, 'Username is required');
                          },
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.0,
                            fontWeight: FontWeight.w500,
                          ),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left: 20.0),
                            hintStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 14.0,
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
                    SizedBox(height: 20.0),
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
                            onPressed: () {
                              if (_formKey.currentState.validate()) {
                                _formKey.currentState.save();
                                submitDetails(context);
                              }
                            },
                            color: Colors.transparent,
                            child: Text(
                              'Create my account',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Already have an account? ',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    PageTransition(
                                        type: PageTransitionType.rightToLeft,
                                        child: Login(null, null)));
                              },
                              child: Text(
                                'Sign in',
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  color: Colors.blue[200],
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            )
                          ]),
                    ),
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
                          "Or register with",
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
                    SizedBox(height: 40),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Container(
                        alignment: Alignment.center,
                        child: Text(
                          "By Creating an account, you accept our",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        alignment: Alignment.center,
                        child: Row(
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
                    // SizedBox(height: 30.0),
                    // Padding(
                    //   padding: EdgeInsets.symmetric(horizontal: 20.0),
                    //   child: InkWell(
                    //     borderRadius: BorderRadius.circular(30.0),
                    //     onTap: () {

                    //       _googleLogin.handleSignIn().then((acc) =>
                    //       {
                    //         if (acc != null) {
                    //           _loginGoogle(acc),
                    //         }
                    //       });
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
                    //             's with Google',
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

  Future<void> submitDetails(
    BuildContext context,
  ) async {
    try {
      LoadingDialogs.showLoadingDialog(
          context, _keyLoader, 'Processing your details'); //invoking login
      RegisterResponse _response = await _repository.register(
          _username, _password, _firstName, _lastName, _phoneNo, _email);
      if (_response.otp == null) {
        Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
        ServerValidationDialog.errorDialog(
            context, _response.error, _response.eTitle); //invoking log
      } else {
        Navigator.of(_keyLoader.currentContext, rootNavigator: true)
            .pop(); //close the dialoge
        Navigator.push(
            context,
            PageTransition(
                type: PageTransitionType.rightToLeft,
                child: OTPScreen(_response.otp, _email, 1)));
      }
    } catch (error) {
      Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
      ServerValidationDialog.errorDialog(
          context, error.toString(), ''); //invoking log
      print(error);
    }
  }

  _loginGoogle(GoogleSignInAccount acc) async {
    LoadingDialogs.showLoadingDialog(
        context, _keyLoader, 'Signing you up in...');
    try {
      final resp = await _repository.googleLogin(acc);

      if (resp.results != null) {
        _successRoute(resp);
      }
    } catch (e) {
      Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
      ServerValidationDialog.errorDialog(
          context, 'An Error Occurred, Please try again', ''); //invoking log
    }
  }

  _successRoute(UserResponse response) {
    Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();

    Navigator.push(context,
        PageTransition(type: PageTransitionType.rightToLeft, child: Home()));
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
