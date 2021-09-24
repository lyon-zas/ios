import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';
import 'package:tritek_lms/appTheme/appTheme.dart';
import 'package:tritek_lms/blocs/agents.bloc.dart';
import 'package:tritek_lms/custom/form.validators.dart';
import 'package:tritek_lms/data/entity/ccagents.dart';
import 'package:tritek_lms/http/customer.agent.dart';
import 'package:tritek_lms/pages/common/utils.dart';
import 'package:tritek_lms/pages/notifications.dart';
import 'package:tritek_lms/pages/search.dart';

class Help extends StatefulWidget {
  @override
  _HelpState createState() => _HelpState();
}

class _HelpState extends State<Help> {
  final _formKey = GlobalKey<FormState>();
  String _firstName, _lastName, _email, _username, _password, _phoneNo = '';
  final TextEditingController _passwordTextEditingController =
      TextEditingController(text: '');
 String chosenValue;
  FocusNode _firstNameFocusNode = FocusNode();
  FocusNode _lastNameFocusNode = FocusNode();
  FocusNode _emailFocusNode = FocusNode();
 
  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    void fieldFocusChange(
        BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
      currentFocus.unfocus();
      FocusScope.of(context).requestFocus(nextFocus);
    }
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
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: _formKey,
            child: ListView(physics: BouncingScrollPhysics(), children: [
               Padding(
            padding: EdgeInsets.only(top: 30.0, left: 10.0),
            child:
                Row( children: [
              Text(
                'Help',
                style: TextStyle(
                  color: themeGold,
                  fontSize: 30.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ])),
        SizedBox(
          height: 50,
        ),
               Padding(
                    padding: EdgeInsets.only(right: 20.0, left: 20.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        
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
                          color: Colors.black,
                          fontSize: 14.0,
                          fontWeight: FontWeight.w500,
                        ),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(left: 20.0),
                         hintText: "First Name",
                          hintStyle: TextStyle(
                            color:  Colors.black,
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
                   SizedBox(height: 30.0),
                  Padding(
                    padding: EdgeInsets.only(right: 20.0, left: 20.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                      
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
                          color: Colors.black,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500,
                        ),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(left: 20.0),
                           hintText: "Last Name",
                          hintStyle: TextStyle(
                            color: Colors.black,
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
                  SizedBox(height:30),
                  Padding(
                    padding: EdgeInsets.only(right: 20.0, left: 20.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        
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
                          color: Colors.black,
                          fontSize: 14.0,
                          fontWeight: FontWeight.w500,
                        ),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(left: 20.0),
                          hintText: "Email Address",
                          hintStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 14.0,
                            fontWeight: FontWeight.w500,
                          ),
                          border: InputBorder.none,
                        ),
                        onSaved: (email) => _email = email,
                        onFieldSubmitted: (_) {
                         
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 30.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal:20),
                    child: DropdownButton<String>(
                      dropdownColor: Colors.grey[200],
                value: chosenValue,
                elevation: 5,
                style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w400),
                items: <String>[
                    'IT Support',
                    'BA Support Team',
                    'PMO Support Team',
                    'Programming Office',
                 
                ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      
                      value: value,
                      child: Text(value),
                    );
                }).toList(),
                focusColor: Colors.grey[200],
                hint: Text(
                    "what would you like to discuss",
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
            SizedBox(
              height: 10,
            ),
            Padding(
             padding: EdgeInsets.only(right: 20.0, left: 20.0),
              child: SizedBox(
                height:70,
                
                child: TextField(
                  maxLines:100,
  
                  controller: _passwordTextEditingController,
                  cursorColor: Color(0xFF5BC8AA),
                  decoration: InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    labelText: "How can we help you?",
                    
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
              ),
            ),
            SizedBox(height:30),
             
        
                  SizedBox(height: 20.0),
                  Padding(
                    padding: EdgeInsets.only(right: 100.0, left: 100.0),
                    child: SizedBox(
                      height: 50.0,
                      child: Container(
                        
                        child: RaisedButton(
                          
                          onPressed: () {
                            // if (_formKey.currentState.validate()) {
                            //   _formKey.currentState.save();
                            //   submitDetails(context);
                            // }
                          },
                          color: themeBlue,
                          child: Text(
                            'Send',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 40),
                  InkWell(
               onTap: () {
            showModalBottomSheet(context: context, builder: _bottomSheet);
          },
               child: Row(
                 mainAxisAlignment:MainAxisAlignment.center,
                 children: [
                        
                     
                     InkWell(
                         child: Container(
                    height: 30.0,
                    width: 30.0,
                    margin: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/whatsapp.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                         ),
                       ),
                       Column(
                         mainAxisAlignment: MainAxisAlignment.start,
                         mainAxisSize: MainAxisSize.min,
                         children: [
                    Text(
                      "Need Help?",
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    Text(
                      "Chat With Us",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: themeGold,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                         ],
                       ),
                     
                 ],
               ),
             ),
            ]),
          ),
        ));
  }
   Widget _bottomSheet(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return StreamBuilder<AgentResponse>(
        stream: agentBloc.subject.stream,
        builder: (context, AsyncSnapshot<AgentResponse> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.error != null && snapshot.data.error.length > 0) {
              return HttpErrorWidget(snapshot.data.error, width, height);
            }
            return _buildAgentWidget(snapshot.data.data, width, height);
          } else if (snapshot.hasError) {
            return HttpErrorWidget(snapshot.error, width, height);
          } else {
            return LoadingWidget(width, height);
          }
        });
  }
  
  Widget _buildAgentWidget(List<Agents> data, double width, double height) {
    return ListView(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(10),
          alignment: Alignment.center,
          child: AutoSizeText(
            "Select Who to Chat With",
            maxLines: 1,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        for (Agents item in data) getAgentTile(item, width, height),
        SizedBox(
          height: 10,
        ),
        Container(
          padding: EdgeInsets.all(10),
          alignment: Alignment.center,
          child: AutoSizeText(
            "This Continue in your WhatsApp App",
            maxLines: 1,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  
  Widget getAgentTile(Agents agent, double width, double height) {
    return InkWell(
      onTap: () {
        FlutterOpenWhatsapp.sendSingleMessage(agent.number,
            "Hi, I'll like to know more about MyTritek Consulting! (Sent from MyTritek Mobile App)");
      },
      child: Container(
        padding: EdgeInsets.all(10.0),
        margin: EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: <BoxShadow>[
            BoxShadow(
              blurRadius: 1.5,
              spreadRadius: 1.5,
              color: Colors.grey[200],
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 100.0,
              height: 100.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(agent.image),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
            Container(
              width: width - 140.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 8.0, bottom: 4.0, right: 8.0, left: 8.0),
                    child: AutoSizeText(
                      agent.name,
                      maxLines: 2,
                      style: TextStyle(
                        color: themeGold,
                        fontSize: 20.0,
                        fontFamily: 'Signika Negative',
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.7,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: 0.0, right: 8.0, left: 8.0, bottom: 8.0),
                    child: Text(
                      agent.title,
                      style: TextStyle(
                        fontSize: 14.0,
                        fontFamily: 'Signika Negative',
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.7,
                        color: Colors.green,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: 0.0, right: 8.0, left: 8.0, bottom: 8.0),
                    child: AutoSizeText(
                      agent.available,
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 12.0,
                        fontFamily: 'Signika Negative',
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.7,
                        color: headingColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
