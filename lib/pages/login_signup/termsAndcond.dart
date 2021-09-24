import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:path/path.dart';
import 'package:tritek_lms/FRS/db/database.dart';
import 'package:tritek_lms/pages/login_signup/dialog.dart';
import 'package:tritek_lms/pages/login_signup/signup.dart';

class TermsAndConditions extends StatefulWidget {
  

  @override
  _TermsAndConditionsState createState() => _TermsAndConditionsState();
}

class _TermsAndConditionsState extends State<TermsAndConditions> {

  final String text =
''' 1. Introduction
These terms and conditions apply to Services provided by Tritek Consulting Limited
You may contact us on info@tritekconsulting.co.uk and/or +44 (0) 7401 262 066/+44 (0) 2030 111 420
These terms and conditions are in addition to the Website Disclaimer and apply to the sale of any courses/services. Please read these terms and conditions carefully, print off a copy for your records.
These terms of use (“TERMS”) bind you, the company you represent, and the company that registered you
By using any of Tritek’s services, you are agreeing to this terms and condition or by clicking on the “Accept” button on our website, you agree to the terms of this agreement which will bind you. If you do not agree to these terms and conditions you must cease to continue to purchase any services from us.

1.1.	UK – Data protection Act. 1998
The Data Protection Act (DPA) is a United Kingdom Act of Parliament which was passed in 1988. It was developed to control how personal or customer information is used by organisations or government bodies. It protects people and lays down rules about how data about people can be used.

1.2.	 GDPR – Data Protection Act. 2018
GDPR cookie consent in brief
The General Data Protection Regulation (GDPR) is a European law that governs all collection and processing of personal data from individuals inside the EU.
Under the GDPR, it is the legal responsibility of website owners and operators to make sure that personal data is collected and processed lawfully.
GDPR requires a website to only collect personal data from users after they have given their explicit consent to the specific purposes of its use.
Websites must comply with the following GDPR cookie consent requirements Prior and explicit consent must be obtained before any activation of cookies (apart from whitelisted, necessary cookies).
Consent must be freely given, i.e. not allowed to be forced.
Consents must be securely stored as legal documentation.
Consent must be renewed at least once per year. However, some national data protection guidelines recommend more frequent renewal, e.g. 6 months. Check your local data protection guidelines for compliance.
2. The Services
2.1. A description of the Services together with the dates on which the Services will begin are available on your payment invoice. We will provide the Services with reasonable care and skill in accordance with the description set out.
2.2. Candidates will have access to all tools (LMS and Basecamp) for 12 months only after which you will be charged to have access on a monthly or quarterly basis.
3. General
3.2. The main communication platform for the administrative and program office will be via whatsApp. You are advised to ensure that you remain in the designated groups all through the duration of the program.
3.3. Candidates must ensure they adhere to the governance processes when reporting issues.  All contents on Basecamp as well as recording from our tutorial sessions inclusive of the details of projects worked on during your program at Tritek Consulting are not to be disclosed, distributed or reproduced.
3.4. The duration for the program is 12 months, there will be no exemptions given for holidays or travel purposes. Participation and active involvement are highly required in projects and all learning platforms and this will be monitored regularly
8. Miscellaneous
All tutorial sessions are recorded and made available on our LMS platform within 48 to 72 hours. Occasionally, pictures and videos will be taken during classroom sessions and this may be used for social media purposes.
You can contact us by any of the following methods:
9. Complaints Policy
All complaints must be in writing using the Tritek Email address. A response will be made within 48hours.
Email: info@tritekconsulting.co.uk
Telephone:
+44 (0) 7401 262 066
+44 (0) 2030 111 420
''';
 
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
        body: Scrollbar(
          isAlwaysShown: true,
          controller: ScrollController(),
          child: ListView(
            children: [
              Column(
              children: [
              Container(
                  margin: EdgeInsets.only(top: 64.0, left: 28.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text.rich(TextSpan(children: [
                            TextSpan(
                                text: "Welcome to MyTritek",
                                style: TextStyle(
                                    fontSize: 36.0,
                                    fontFamily: "HellixBold",
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black)),
                           
                          ])),
                        ),
                        SizedBox(height: 10),
                         Align(
                           alignment: Alignment.topLeft,
                           child: Text( "Terms and Conditions",
                              style: TextStyle(
                                  fontSize: 26.0,
                                  fontFamily: "Signika Negative",
                                  color: Colors.black)),
                         ),
                        SizedBox(height: 50),
                        Text(text,   
                            style: TextStyle(
                                fontSize: 16.0,
                                fontFamily: "Signika Negative",
                                color: Colors.black))
                      ])),
              SizedBox(height: 100,),
              Container(
                child: Align(
         
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.end,
                   children: [
                      RaisedButton(
                          child: Text(
                            "Decline",
                          ),
                          onPressed: () {
                            Navigator.push(
                                      context,
                                      PageTransition(
                                          type: PageTransitionType.rightToLeft,
                                          child: SignUp()));
                          }),
                      RaisedButton(child: Text("Accept"), onPressed: () {
                        _showDialogg(context);
                      })
                    ],
                  ),
                ),
              )
              ],
            ),
            ],
          ),
        ));
  }
}
