import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:tritek_lms/data/entity/subscription.plans.dart';
import 'package:tritek_lms/http/endpoints.dart';
import 'package:tritek_lms/http/http.client.dart';

class SubscriptionPlanResponse {
  final List<SubscriptionPlans> results;
  final String error;
  final String eTitle;

  SubscriptionPlanResponse(this.results, this.error, this.eTitle);

  SubscriptionPlanResponse.fromJson(json)
      : results = (json as List)
            .map((i) => new SubscriptionPlans.fromJson(i))
            .toList(),
        error = "",
        eTitle = "";

  SubscriptionPlanResponse.withError(String msg, String title)
      : results = [],
        error = msg,
        eTitle = title;
}

class BankResponse {
  final AccountDetails results;
  final String error;
  final String eTitle;

  BankResponse(this.results, this.error, this.eTitle);

  BankResponse.fromJson(json)
      : results = AccountDetails.fromJson(json),
        error = "",
        eTitle = "";

  BankResponse.withError(String msg, String title)
      : results = null,
        error = msg,
        eTitle = title;
}

class SubscriptionPlanApiProvider {
  Future<SubscriptionPlanResponse> getSubscriptionPlans() async {
    try {
      final Dio _dio = await HttpClient.http();
      Response response = await _dio.get(subsEndpoint);
      return SubscriptionPlanResponse.fromJson(response.data);
    } catch (e) {
      if (e.response != null) {
        Map<String, dynamic> error = json.decode(e.response.toString());
        return SubscriptionPlanResponse.withError(
            error['message'], error['error']);
      }
      return SubscriptionPlanResponse.withError(e.message, "Network Error");
    }
  }

  Future<bool> getPayPal() async {
    try {
      final Dio _dio = await HttpClient.http();
      await _dio.get(paypalConfEndpoint);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<BankResponse> getBank() async {
    try {
      final Dio _dio = await HttpClient.http();
      Response response = await _dio.get(bankEndpoint);
      return BankResponse.fromJson(response.data);
    } catch (e) {
      if (e.response != null) {
        Map<String, dynamic> error = json.decode(e.response.toString());
        return BankResponse.withError(
            error['message'], error['error']);
      }
      return BankResponse.withError(e.message, "Network Error");
    }
  }
}
