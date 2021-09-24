import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:tritek_lms/FRS/models/ques.model.dart';

import 'package:tritek_lms/pages/home/home.dart';

class SecurityQuestionLogin extends StatefulWidget {
  @override
  _SecurityQuestionLoginState createState() => _SecurityQuestionLoginState();
}

class _SecurityQuestionLoginState extends State<SecurityQuestionLogin> {
  String chosenValue;
  final TextEditingController _passwordTextEditingController =
      TextEditingController(text: '');
 
  Value details;
  _auth(context) async {
    String password = _passwordTextEditingController.text;
    String value = chosenValue;
    if (this.details.value == value && this.details.question == password) {
      Navigator.push(context,
          MaterialPageRoute(builder: (BuildContext context) => Home())); //home
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text('Wrong question or answer!'),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Container(
          margin: EdgeInsets.only(
            top: 64.0,
          ),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Text(
                  'Welcome To MyTritek',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 30.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(height: 30),
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Security Question Login",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 22.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text("Please select a security question stored",
                    style: TextStyle(
                        fontSize: 18.0,
                        fontFamily: "Signika Negative",
                        color: Colors.black)),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                margin: EdgeInsets.only(
                  right: 84.0,
                ),
                child: DropdownButton<String>(
                  value: chosenValue,
                  elevation: 5,
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w600),
                  items: <String>[
                    'Mothers Maiden Name',
                    'First holiday destination',
                    'Place of birth',
                    'Name of First SChool',
                    'First pet',
                    'First Car',
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  hint: Text(
                    "Please select a security question stored",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 17,
                        fontWeight: FontWeight.w600),
                  ),
                  onChanged: (String value) {
                    setState(() {
                      chosenValue = value;
                    });
                  },
                ),
              ),
              SizedBox(height: 80),
              Align(
                alignment: Alignment.centerLeft,
                child: Text("Please enter answer below",
                    style: TextStyle(
                        fontSize: 18.0,
                        fontFamily: "Signika Negative",
                        color: Colors.black)),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: _passwordTextEditingController,
                cursorColor: Color(0xFF5BC8AA),
                decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  labelText: "Answer",
                  border: InputBorder.none,
                  filled: true,
                  fillColor: Colors.grey[200],
                  enabledBorder: new OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(10.0),
                    ),
                  ),
                  focusedBorder: new OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(10.0),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30),
              Align(
                alignment: Alignment.bottomCenter,
                child: Center(
                  child: RaisedButton(
                      child: Text(
                        "Confirm",
                      ),
                      onPressed: () {
                        _auth(context);
                      }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  // _read() async {
  //       try {
  //         final directory = await getApplicationDocumentsDirectory();
  //         final file = File('${directory.path}/my_file.txt');
  //         String text = await file.readAsString();
  //         print(text);
  //       } catch (e) {
  //         print("Couldn't read file");
  //       }
  //     }

  //     _save() async {
  //       final directory = await getApplicationDocumentsDirectory();
  //       final file = File('${directory.path}/my_file.txt');
  //       final text = 'Hello World!';
  //       await file.writeAsString(text);
  //       print('saved');
  //     }
}
