import 'package:flutter/material.dart';
import 'package:tritek_lms/appTheme/appTheme.dart';
import 'package:tritek_lms/pages/notifications.dart';
import 'package:tritek_lms/pages/search.dart';

class TrainingVideos extends StatefulWidget {

  @override
  _TrainingVideosState createState() => _TrainingVideosState();
}

class _TrainingVideosState extends State<TrainingVideos> {
   String chosenValue;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
              height: 30,
              width: 30,
              child: Center(
                child: Icon(
                  Icons.arrow_back_ios,
                   size: 30,
                  color: themeGold,
                ),
              )), // this should route to the previous screen
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            iconSize: 30,
            color: themeGold,
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Search()));
            },
          ),
          IconButton(
            icon: Icon(Icons.notifications),
            iconSize: 30,
            color: themeGold,
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Notifications()));
            },
          ),
        ],
      ),
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          Padding(
              padding: EdgeInsets.only(top: 50.0, left: 20.0),
              child:
                  Row( children: [
                Text(
                  'Training Videos',
                  style: TextStyle(
                    color: themeGold,
                    fontSize: 30.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ])),
              SizedBox(height:40),
              Center(
                child: Text("Tritek Lms how to Guide",style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.0,
  
                  ),),
              ),
              SizedBox(height:40),
               Padding(
                    padding: const EdgeInsets.symmetric(horizontal:80),
                    child: DropdownButton<String>(
                      dropdownColor: Colors.grey[200],
                value: chosenValue,
                elevation: 10,
                style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w400),
                items: <String>[
                    'Dowlnoad Training materials',
                    'Download Training timetable',
                    'Tritek terms and condiditons ',

                 
                ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      
                      value: value,
                      child: Text(value),
                    );
                }).toList(),
                focusColor: Colors.grey[200],
                hint: Text(
                    "Onboarding materials",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 17,
                        fontWeight: FontWeight.w500),
                ),
                onChanged: (String value) {
                    setState(() {
                      chosenValue = value;
                    });
                },
              ),
                  ),
        ],
      ),
    );
  }
}