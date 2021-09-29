import 'package:flutter/material.dart';
import 'package:tritek_lms/appTheme/appTheme.dart';

import 'StagerredView.dart';

enum viewType { List, Staggered }

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var notesViewType;

  @override
  void initState() {
    super.initState();
    notesViewType = viewType.List;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,     
      appBar: AppBar(
         automaticallyImplyLeading: false,
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
        iconTheme: IconThemeData(
          color: themeGold, //change your color here
        ),
        brightness: Brightness.light,
        // actions: _appBarActions(),
        elevation: 1,
        backgroundColor: themeBlue,
        centerTitle: true,
        title: Text(
          "My Notes",
          style: TextStyle(
              color: themeGold
          ),
        ),
      ),
      body: SafeArea(
        child: _body(),
        right: true,
        left: true,
        top: true,
        bottom: true,
      ),
      // bottomSheet: _bottomBar(),
    );
  }

  Widget _body() {
    return Container(
        child: StaggeredGridPage(
      notesViewType: notesViewType,
    ));
  }

  //sets the viewType to either grid or list based on the noteViewType value
  void _toggleViewType() {
    setState(() {
      if (notesViewType == viewType.List) {
        notesViewType = viewType.Staggered;
      } else {
        notesViewType = viewType.List;
      }
    });
  }

  List<Widget> _appBarActions() {
    return [
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: InkWell(
            onTap: () {
            _toggleViewType();
          },
          child: Icon(
            notesViewType == viewType.List
                ? Icons.developer_board
                : Icons.view_headline,
            color: themeGold,
          ),
        ),
      ),
    ];
  }
}