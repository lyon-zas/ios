import 'dart:ui';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:tritek_lms/FRS/db/database.dart';
import 'package:tritek_lms/FRS/models/user.model.dart';
import 'package:tritek_lms/FRS/services/facenet.service.dart';
import 'package:tritek_lms/FRS/services/ml_kit_service.dart';
import 'package:tritek_lms/pages/home/home.dart';
import 'package:tritek_lms/pages/login_signup/captureSignUp.dart';
import 'package:tritek_lms/pages/login_signup/securityQuestion.dart';
import 'package:tritek_lms/pages/login_signup/termsAndcond.dart';

class   BlurryDialog extends StatefulWidget {
  String title;
  String content;
 

  BlurryDialog(
    this.title,
    this.content,
    
  );
 
  @override
  _BlurryDialogState createState() => _BlurryDialogState();
}

class _BlurryDialogState extends State<BlurryDialog> {
  TextStyle textStyle = TextStyle(color: Colors.black);
   // Services injection
  FaceNetService _faceNetService = FaceNetService();
  MLKitService _mlKitService = MLKitService();
  DataBaseService _dataBaseService = DataBaseService();

  CameraDescription cameraDescription;
  bool loading = false;

 
  @override
  void initState() {
    super.initState();
    _startUp();
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

  User predictedUser;

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: AlertDialog(
          title: new Text(
            widget.title,
            style: textStyle,
          ),
          content: new Text(
            widget.content,
            style: textStyle,
          ),
          actions: <Widget>[
            new FlatButton(
              child: Text("No"),
              onPressed: () {
                Navigator.push(
                    context,
                    PageTransition(
                        type: PageTransitionType.rightToLeft, child: TermsAndConditions()));
              },
            ),
            new FlatButton(
              child: new Text("Yes"),
              onPressed: () {
                Navigator.push(
                    context,
                    PageTransition(
                        type: PageTransitionType.rightToLeft, child: CaptureSignUp(cameraDescription: cameraDescription))); 
                
              },
            ),
          ],
        ));
  }
}
