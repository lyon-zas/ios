import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tritek_lms/appTheme/appTheme.dart';
import 'package:tritek_lms/blocs/subs.plan.bloc.dart';
import 'package:tritek_lms/data/entity/subscription.plans.dart';
import 'package:tritek_lms/pages/common/utils.dart';
import 'package:url_launcher/url_launcher.dart';

class TransferPayment extends StatefulWidget {
  final SubscriptionPlans _plan;

  TransferPayment(this._plan);

  @override
  _TransferPaymentState createState() => _TransferPaymentState();
}

class _TransferPaymentState extends State<TransferPayment> {
  AccountDetails _bank;

  @override
  void initState() {
    super.initState();
    subBloc.getBank();

    subBloc.bank.listen((value) {
      if (!mounted) {
        return;
      }

      setState(() {
        _bank = value.results;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeBlue,
        title: AutoSizeText(
          "Buying Membership: Bank Transfer",
          style: TextStyle(color: themeGold),
          maxLines: 1,
        ),
        leading: Icon(
          Icons.arrow_back_ios,
          color: themeGold,
        ),
      ),
      body: new SingleChildScrollView(
        child: new GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: SafeArea(
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  alignment: Alignment.center,
                  child: AutoSizeText(
                    "Paying for ${widget._plan.name} @ \u00A3${widget._plan.price}",
                    maxLines: 2,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: themeBlue),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                _accountDetails(),
                SizedBox(
                  height: 20,
                ),
                Container(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child:
                  Text('Please contact:', style: TextStyle(fontSize: 20)),
                ),
                SizedBox(
                  height: 7,
                ),
                Container(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Text('info@tritekconsulting.co.uk',
                      style: TextStyle(
                          fontSize: 25,
                          color: themeBlue,
                          fontWeight: FontWeight.bold)),
                ),
                SizedBox(
                  height: 7,
                ),
                Container(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Text(
                    'once your payment is made with your invoice number and full name as reference',
                    style: TextStyle(fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(20),
                  child: InkWell(
                      child: Text(
                        'By making payment, you agree to Terms and Conditions of Tritek Consulting Limited (Tap to View T&C)',
                        style: TextStyle(fontSize: 18, color: Colors.green),
                        textAlign: TextAlign.center,
                      ),
                      onTap: () async {
                        const url =
                            'https://mytritek.co.uk/terms-and-conditions/';
                        if (await canLaunch(url)) {
                          await launch(url);
                        }
                      }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _accountDetails() {
    double cardWidth = MediaQuery.of(context).size.width - 40;
    double cardHeight = (cardWidth / 2) + 10;
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        width: cardWidth,
        height: cardHeight,
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
            color: Colors.black,
            blurRadius: 12.0,
            spreadRadius: 0.2,
            offset: Offset(
              3.0, // horizontal, move right 10
              3.0, // vertical, move down 10
            ),
          )
        ]),
        child: _bank != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Stack(
                  children: <Widget>[
                    // Background for card
                    CardBackgrounds.black,
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          height: 30,
                          child: Center(
                            child: Text(
                              'Bank Name: ',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              _bank.bankName,
                              style: TextStyle(
                                  color: textColor,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          height: 30,
                          child: Center(
                            child: Text(
                              'Account No.: ',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              _bank.accountNo,
                              style: TextStyle(
                                  color: textColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          height: 20,
                          child: Center(
                            child: Text(
                              'Sort Code: ',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              _bank.sortCode,
                              style: TextStyle(
                                  color: textColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          height: 20,
                          child: Center(
                            child: Text(
                              'Account Name: ',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              _bank.name,
                              style: TextStyle(
                                  color: textColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ) : LoadingWidget(cardWidth, cardHeight)
    );
  }
}

class CardBackgrounds {
  CardBackgrounds._();

  static Widget black = new Container(
    width: double.maxFinite,
    height: double.maxFinite,
    color: Color(0xff0B0B0F),
  );

  static Widget white = new Container(
    width: double.maxFinite,
    height: double.maxFinite,
    color: Color(0xffF9F9FA),
  );
}
