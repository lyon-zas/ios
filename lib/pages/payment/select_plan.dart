import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tritek_lms/appTheme/appTheme.dart';
import 'package:tritek_lms/blocs/agents.bloc.dart';
import 'package:tritek_lms/blocs/subs.plan.bloc.dart';
import 'package:tritek_lms/blocs/user.bloc.dart';
import 'package:tritek_lms/data/entity/ccagents.dart';
import 'package:tritek_lms/data/entity/courses.dart';
import 'package:tritek_lms/data/entity/subscription.plans.dart';
import 'package:tritek_lms/data/entity/users.dart';
import 'package:tritek_lms/http/customer.agent.dart';
import 'package:tritek_lms/http/subscription.plan.dart';
import 'package:tritek_lms/pages/common/utils.dart';
import 'package:tritek_lms/pages/payment/payment.dart';
import 'package:tritek_lms/pages/payment/transfer.dart';

class SelectPlan extends StatefulWidget {
  final Course course;

  SelectPlan({Key key, this.course}) : super(key: key);

  @override
  _SelectPlanState createState() => _SelectPlanState();
}

class _SelectPlanState extends State<SelectPlan> {
  SubscriptionPlans selectedPlan;
  Users _user;
  bool _paypal = false;

  @override
  initState() {
    super.initState();
    subBloc.getSubs();
    agentBloc.getAgents();

    userBloc.userSubject.listen((value) {
      if (!mounted) {
        return;
      }

      setState(() {
        _user = value.results;
      });
    });

    subBloc.paypal.listen((value) {
      if (!mounted) {
        return;
      }

      setState(() {
        _paypal = value;
      });
    });

    userBloc.getUser();
    subBloc.getPayPal();
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

  Widget _buildListWidget(
      List<SubscriptionPlans> data, double width, double height) {
    return ListView(
      children: <Widget>[
        for (SubscriptionPlans item in data) getSubItem(item),
        Container(
            padding: EdgeInsets.fromLTRB(20.0, 10, 20, 10),
            child: RaisedButton.icon(
              textColor: Colors.white,
              color: selectedPlan != null ? themeBlue : Colors.black54,
              onPressed: () {
                if (selectedPlan == null || _user == null) {
                  print(_user.toString());
                  Fluttertoast.showToast(msg: "Select first your desired plan");
                  return;
                }

                showModalBottomSheet(
                    context: context, builder: _paymentMethodModal);
              },
              icon: Icon(
                Icons.credit_card,
                size: 45,
                color: themeGold,
              ),
              label: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Pay For Selected Plan",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: themeGold,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  AutoSizeText(
                    selectedPlan == null
                        ? "Select Plan"
                        : "for ${selectedPlan.name}",
                    style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            )),
        SizedBox(
          height: 30,
        ),
        Container(
          padding: EdgeInsets.fromLTRB(20.0, 10, 20, 10),
          child: RaisedButton.icon(
            textColor: Colors.white,
            color: Colors.green.withGreen(120),
            // .withOpacity(0.9),
            onPressed: () {
              showModalBottomSheet(context: context, builder: _bottomSheet);
            },
            icon: InkWell(
              child: Container(
                height: 30.0,
                width: 30.0,
                margin: EdgeInsets.fromLTRB(1.0, 10.0, 1.0, 10.0),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/whatsapp.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            label: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Need Help?",
                  style: TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                Text(
                  "Chat With Us",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: themeGold,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
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

  Widget _paymentMethodModal(BuildContext context) {

    return SafeArea(
      child: Container(
        child: new Wrap(
          spacing: 15,
          children: [
            SizedBox(height: 15.0),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              child: InkWell(
                onTap: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => StripePayment(selectedPlan, _user),
                    ),
                  );
                },
                child: Container(
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.white,
                    border: Border.all(width: 0.3, color: Colors.grey),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        blurRadius: 1.0,
                        spreadRadius: 1.0,
                        color: Colors.grey[300],
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/payment_icon/card.png',
                        height: 40.0,
                        fit: BoxFit.contain,
                      ),
                      SizedBox(width: 10.0),
                      AutoSizeText(
                        'Pay With Credit/Debit Card',
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 15.0),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              child: InkWell(
                onTap: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TransferPayment(selectedPlan),
                    ),
                  );
                },
                child: Container(
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.white,
                    border: Border.all(width: 0.3, color: Colors.grey),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        blurRadius: 1.0,
                        spreadRadius: 1.0,
                        color: Colors.grey[300],
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.monetization_on_outlined,
                        size: 40.0,
                        color: themeBlue,
                      ),
                      SizedBox(width: 10.0),
                      AutoSizeText(
                        'Pay With Bank Transfer',
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (_paypal) SizedBox(height: 15.0),
            if (_paypal)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.0),
                child: InkWell(
                  onTap: () async {},
                  child: Container(
                    padding: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.white,
                      border: Border.all(width: 0.3, color: Colors.grey),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          blurRadius: 1.0,
                          spreadRadius: 1.0,
                          color: Colors.grey[300],
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/payment_icon/paypal.png',
                          height: 40.0,
                          fit: BoxFit.contain,
                        ),
                        SizedBox(width: 10.0),
                        AutoSizeText(
                          'Pay With PayPal',
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            SizedBox(height: 15.0),
          ],
        ),
      ),
    );
  }

  Widget getSubItem(SubscriptionPlans plan) {
    return InkWell(
      onTap: () {
        setState(() {
          selectedPlan = plan;
        });
      },
      child: Container(
        // width: 230.0,
        margin: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: selectedPlan == plan ? themeBlue : Colors.black54,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              blurRadius: 5.0,
              spreadRadius: 3.5,
              color: Colors.grey[300],
            )
          ],
        ),
        child: Container(
          padding: EdgeInsets.fromLTRB(20.0, 1.0, 20.0, 2.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(height: 5.0),
              AutoSizeText(
                plan.name,
                maxLines: 2,
                style: TextStyle(
                  color: themeGold,
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5.0),
              for (var item in plan.properties)
                AutoSizeText(
                  item.length > 0 ? "\u2022 " + item : "",
                  maxLines: 2,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.0,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              SizedBox(height: 5.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    'Price: ' + '\u00A3${plan.price}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: themeGold,
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),
                  if (selectedPlan != null && selectedPlan == plan)
                    Icon(
                      Icons.check,
                      size: 30,
                      color: themeGold,
                    )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    nestedAppBar() {
      return NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                expandedHeight: 150.0,
                pinned: true,
                forceElevated: true,
                automaticallyImplyLeading: false,
                backgroundColor: themeBlue,
                elevation: 0.0,
                leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: iconColor,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
                    alignment: Alignment.bottomLeft,
                    decoration: BoxDecoration(
                        color: themeBlue
                    ),
                    child: AutoSizeText(
                      'Membership/Subscriptions',
                      maxLines: 1,
                      style: TextStyle(
                        fontFamily: 'Signika Negative',
                        fontWeight: FontWeight.w700,
                        fontSize: 20.0,
                        color: themeGold,
                      ),
                    ),
                  ),
                ),
              ),
            ];
          },
          body:
          StreamBuilder<SubscriptionPlanResponse>(
            stream: subBloc.subject.stream,
            builder: (context,
                AsyncSnapshot<SubscriptionPlanResponse> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data.error != null &&
                    snapshot.data.error.length > 0) {
                  return HttpErrorWidget(snapshot.data.error, width, height);
                }
                return _buildListWidget(snapshot.data.results, width, height);
              } else if (snapshot.hasError) {
                return HttpErrorWidget(snapshot.error, width, height);
              } else {
                return LoadingWidget(width, height);
              }
            },
          )
      );
    }

    return Scaffold(
      body: nestedAppBar(),
      backgroundColor: themeBg,
    );
  }
}

