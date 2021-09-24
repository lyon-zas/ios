import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stripe_sdk/stripe_sdk.dart';
import 'package:stripe_sdk/stripe_sdk_ui.dart';
import 'package:tritek_lms/appTheme/appTheme.dart';
import 'package:tritek_lms/data/entity/subscription.plans.dart';
import 'package:tritek_lms/data/entity/users.dart';
import 'package:tritek_lms/http/payment.gateway.dart';
import 'package:tritek_lms/pages/common/dialog.dart';
import 'package:tritek_lms/pages/home/home.dart';
import 'package:url_launcher/url_launcher.dart';

class StripePayment extends StatefulWidget {
  final Users _user;
  final SubscriptionPlans _plan;

  StripePayment(this._plan, this._user);

  @override
  _StripePaymentState createState() => _StripePaymentState();
}

class _StripePaymentState extends State<StripePayment> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final StripeCard card = StripeCard();
  final _provider = StripeSecretApiProvider();

  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  final Stripe stripe = Stripe(
    "pk_live_DcCw5bq0Njn1uwNSuvv3RlOW",
    //Your Publishable Key
    returnUrlForSca: "stripesdk://3ds.stripesdk.io", //Return URL for SCA
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeBlue,
        title: Text(
          "Buying Membership",
          style: TextStyle(color: themeGold),
        ),
        leading: BackButton(
          color: themeGold,
          onPressed: () => Navigator.of(context).pop(),
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
                CardForm(
                  formKey: formKey,
                  card: card,
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
                Container(
                  child: RaisedButton(
                      color: themeBlue,
                      textColor: themeGold,
                      child: const Text('Buy Membership',
                          style: TextStyle(fontSize: 20)),
                      onPressed: () {
                        formKey.currentState.validate();
                        formKey.currentState.save();
                        buy(context);
                      }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void buy(context) async {
    LoadingDialogs.showLoadingDialog(
        context, _keyLoader, 'Processing your card...');

    final StripeCard stripeCard = card;

    if (!stripeCard.validateCVC()) {
      showAlertDialog(context, "Error", "CVC not valid.", false);
      return;
    }
    if (!stripeCard.validateDate()) {
      showAlertDialog(context, "Error", "Date not valid.", false);
      return;
    }
    if (!stripeCard.validateNumber()) {
      showAlertDialog(context, "Error", "Number not valid.", false);
      return;
    }

    Map<String, dynamic> paymentIntentRes =
        await createPaymentIntent(stripeCard, widget._user, widget._plan);
    String clientSecret = paymentIntentRes['client_secret'];
    String paymentMethodId = paymentIntentRes['payment_method'];
    String status = paymentIntentRes['status'];

    if (status == 'requires_action') //3D secure is enable in this card
      paymentIntentRes =
          await confirmPayment3DSecure(clientSecret, paymentMethodId);

    if (paymentIntentRes['status'] != 'succeeded') {
      showAlertDialog(context, "Warning", "Canceled Transaction.", false);
      return;
    }

    if (paymentIntentRes['status'] == 'succeeded') {
      await logPayment(paymentIntentRes);
      showAlertDialog(
          context,
          "Subscription Success",
          "Thanks for buying Membership, your account will be processed within 24hrs",
          true);
      return;
    }
    showAlertDialog(context, "Warning",
        "Transaction rejected.\nSomething went wrong", false);
  }

  Future<Map<String, dynamic>> createPaymentIntent(
      StripeCard stripeCard, Users users, SubscriptionPlans plan) async {
    String clientSecret;
    Map<String, dynamic> paymentIntentRes, paymentMethod;
    try {
      paymentMethod = await stripe.api.createPaymentMethodFromCard(stripeCard);
      StripeSecret clientRes =
          await _provider.getSecret(users.email, paymentMethod['id'], plan);
      if (clientRes.secret == null) {
        throw Exception(clientRes.error);
      }
      clientSecret = clientRes.secret;
      paymentIntentRes = await stripe.api.retrievePaymentIntent(clientSecret);
    } catch (e) {
      print("ERROR_CreatePaymentIntentAndSubmit: $e");
      showAlertDialog(context, "Error", "Something went wrong.", false);
    }
    return paymentIntentRes;
  }

  Future<Map<String, dynamic>> confirmPayment3DSecure(
      String clientSecret, String paymentMethodId) async {
    Map<String, dynamic> paymentIntentRes_3dSecure;
    try {
      await stripe.confirmPayment(clientSecret,
          paymentMethodId: paymentMethodId);
      paymentIntentRes_3dSecure =
          await stripe.api.retrievePaymentIntent(clientSecret);
    } catch (e) {
      print("ERROR_ConfirmPayment3DSecure: $e");
      showAlertDialog(context, "Error", "Something went wrong.", false);
    }
    return paymentIntentRes_3dSecure;
  }

  showAlertDialog(
      BuildContext context, String title, String message, bool success) async {
    await Future.delayed(Duration(seconds: 2));
    Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            FlatButton(
                child: Text("OK"),
                onPressed: () => {
                      Navigator.of(context).pop(),
                      if (success)
                        {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Home(),
                            ),
                          )
                        }
                    }),
          ],
        );
      },
    );
  }

  logPayment(Map<String, dynamic> paymentIntentRes) async {
    _provider.savePayment(
        widget._user.email, paymentIntentRes.toString(), widget._plan);
  }
}
