import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tritek_lms/appTheme/appTheme.dart';
import 'package:tritek_lms/custom/form.validators.dart';
import 'package:tritek_lms/custom/helper.dart';
import 'package:tritek_lms/data/entity/users.dart';
import 'package:tritek_lms/data/repository/user.repository.dart';
import 'package:tritek_lms/http/user.dart';
import 'package:tritek_lms/pages/common/dialog.dart';

class EditProfile extends StatefulWidget {
  final Users user;
  final File profile;

  EditProfile(this.user, this.profile);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  String phoneNo;
  String firstName;
  String lastName;
  final ImagePicker picker = ImagePicker();
  File _image;

  final _formKey = GlobalKey<FormState>();
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  final UserRepository _repository = UserRepository();
  FocusNode _firstNameFocusNode = FocusNode();
  FocusNode _lastNameFocusNode = FocusNode();
  FocusNode _phoneNoFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    firstName = widget.user.firstName;
    lastName = widget.user.lastName;
    phoneNo = widget.user.phoneNo;
    _image = widget.profile;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    void fieldFocusChange(
        BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
      currentFocus.unfocus();
      FocusScope.of(context).requestFocus(nextFocus);
    }

    saveImage(PickedFile file) async {
      setState(() {
        _image = File(file.path);
        // _image = Image.file(File(image.path));
      });

      SaveFile().saveFile(_image, 'profileImage');
    }

    _imgFromCamera() async {
      PickedFile image =
          await picker.getImage(source: ImageSource.camera, imageQuality: 50);

      if (image == null) return;
      saveImage(image);
    }

    _imgFromGallery() async {
      PickedFile image =
          await picker.getImage(source: ImageSource.gallery, imageQuality: 50);

      if (image == null) return;
      saveImage(image);
    }

    _removePic() async {
      SaveFile().deleteImage();
      setState(() {
        _image = null;
      });
    }

    void _showPicker(context) {
      showModalBottomSheet(
          context: context,
          builder: (BuildContext bc) {
            return SafeArea(
              child: Container(
                child: new Wrap(
                  children: <Widget>[
                    new ListTile(
                        leading: new Icon(Icons.photo_library),
                        title: new Text('Photo Library'),
                        onTap: () {
                          _imgFromGallery();
                          Navigator.of(context).pop();
                        }),
                    new ListTile(
                      leading: new Icon(Icons.photo_camera),
                      title: new Text('Camera'),
                      onTap: () {
                        _imgFromCamera();
                        Navigator.of(context).pop();
                      },
                    ),
                    if (_image != null)
                      new ListTile(
                        leading: new Icon(Icons.no_photography_outlined),
                        title: new Text('Remove Profile Pic'),
                        onTap: () {
                          _removePic();
                          Navigator.of(context).pop();
                        },
                      ),
                  ],
                ),
              ),
            );
          });
    }

    return Scaffold(
      backgroundColor: themeBg,
      body: ListView(
        children: [
          Container(
            width: double.infinity,
            height: 200.0,
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 250.0,
                  color: themeBlue,
                ),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(top: 30.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                        child: GestureDetector(
                          onTap: () {
                            _showPicker(context);
                          },
                          child: CircleAvatar(
                            radius: 55,
                            backgroundColor: Color(0xffFDCF09),
                            child: _image != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: Image.file(
                                      _image,
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.fitHeight,
                                    ),
                                  )
                                : Container(
                                    decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius:
                                            BorderRadius.circular(50)),
                                    width: 100,
                                    height: 100,
                                    child: Icon(
                                      Icons.camera_alt,
                                      color: Colors.grey[800],
                                    ),
                                  ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20.0),
                      Text(
                        'Edit Profile',
                        style: TextStyle(
                          color: themeGold,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10.0),
          Container(
            padding: EdgeInsets.fromLTRB(20.0, 5, 20, 5),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 15.0,
                  ),
                  TextFormField(
                    focusNode: _lastNameFocusNode,
                    autofocus: true,
                    textCapitalization: TextCapitalization.words,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      return Validator.required(
                          value, 3, 'Last Name is required');
                    },
                    initialValue: lastName,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Signika Negative',
                    ),
                    decoration: InputDecoration(
                      hintText: 'Enter Last Name',
                      hintStyle: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 16.0,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Signika Negative',
                      ),
                    ),
                    onSaved: (_lastName) => lastName = _lastName,
                    onFieldSubmitted: (_) {
                      fieldFocusChange(
                          context, _lastNameFocusNode, _firstNameFocusNode);
                    },
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  TextFormField(
                    focusNode: _firstNameFocusNode,
                    autofocus: true,
                    textCapitalization: TextCapitalization.words,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      return Validator.required(
                          value, 3, 'First Name is required');
                    },
                    initialValue: firstName,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Signika Negative',
                    ),
                    decoration: InputDecoration(
                      hintText: 'Enter First Name',
                      hintStyle: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 16.0,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Signika Negative',
                      ),
                    ),
                    onSaved: (_firstName) => firstName = _firstName,
                    onFieldSubmitted: (_) {
                      fieldFocusChange(
                          context, _firstNameFocusNode, _phoneNoFocusNode);
                    },
                  ),
                  SizedBox(height: 15.0),
                  // TextFormField(
                  //   focusNode: _phoneNoFocusNode,
                  //   autofocus: true,
                  //   textCapitalization: TextCapitalization.words,
                  //   keyboardType: TextInputType.number,
                  //   textInputAction: TextInputAction.next,
                  //   validator: (value) {
                  //     return Validator.phone(value, 'Invalid Phone Number');
                  //   },
                  //   initialValue: phoneNo,
                  //   style: TextStyle(
                  //     fontSize: 16.0,
                  //     fontWeight: FontWeight.w700,
                  //     fontFamily: 'Signika Negative',
                  //   ),
                  //   decoration: InputDecoration(
                  //     hintText: 'Enter Phone Number',
                  //     hintStyle: TextStyle(
                  //       color: Colors.grey[400],
                  //       fontSize: 16.0,
                  //       fontWeight: FontWeight.w700,
                  //       fontFamily: 'Signika Negative',
                  //     ),
                  //   ),
                  //   onSaved: (_phoneNo) => phoneNo = _phoneNo,
                  // ),
                  SizedBox(height: 15.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          width: (width / 3.5),
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              fontFamily: 'Signika Negative',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          if (_formKey.currentState.validate()) {
                            _formKey.currentState.save();
                            _saveEdit(context);
                            // Navigator.pop(context);
                          }
                        },
                        child: Container(
                          width: (width / 3.5),
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            color: textColor,
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Text(
                            'Okay',
                            style: TextStyle(
                              fontFamily: 'Signika Negative',
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 10)
        ],
      ),
    );
  }

  void _saveEdit(BuildContext context) async {
    Users _user = widget.user;
    _user.firstName = firstName;
    _user.lastName = lastName;
    _user.phoneNo = phoneNo;

    try {
      LoadingDialogs.showLoadingDialog(
          context, _keyLoader, 'Processing your update...'); //invoking login
      UserResponse _response = await _repository.editUser(_user);
      if (_response.error.length > 0) {
        Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
        ServerValidationDialog.errorDialog(
            context, _response.error, _response.eTitle); //invoking log
      } else {
        Navigator.of(_keyLoader.currentContext, rootNavigator: true)
            .pop();

        Navigator.pop(context);
      }
    } catch (error) {
      Navigator.of(_keyLoader.currentContext, rootNavigator: true)
          .pop();
      debugPrint(error.toString());
      ServerValidationDialog.errorDialog(
          context, 'An Error Occurred! Please try again', ''); //invoking log
      print(error);
    }
  }
}
