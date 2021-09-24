import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:tritek_lms/data/entity/subscription.plans.dart';
import 'package:tritek_lms/http/endpoints.dart';
import 'package:tritek_lms/http/http.client.dart';

class StripeSecret {
  final String secret;
  final String error;

  StripeSecret(this.secret, this.error);

  StripeSecret.fromJson(json)
      : secret = json['secret'],
        error = "";

  StripeSecret.withError(String msg, String title)
      : secret = null,
        error = msg;
}

class StripeSecretApiProvider {
  Future<StripeSecret> getSecret(
      String email, String paymentMethodId, SubscriptionPlans plan) async {
    try {
      final Dio _dio = await HttpClient.http();
      Response response = await _dio.post(secretEndpoint, data: {
        'email': email,
        'payment_method_id': paymentMethodId,
        'plan': plan
      });
      return StripeSecret.fromJson(response.data);
    } catch (e) {
      if (e.response != null) {
        Map<String, dynamic> error = json.decode(e.response.toString());
        return StripeSecret.withError(error['message'], error['error']);
      }
      return StripeSecret.withError(e.message, "Network Error");
    }
  }

  Future<bool> savePayment(
      String email, String paymentResp, SubscriptionPlans plan) async {
    try {
      final Dio _dio = await HttpClient.http();
      Response response = await _dio.put(paymentLogEndpoint,
          data: {'email': email, 'paymentResp': paymentResp, 'plan': plan});
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }
}
