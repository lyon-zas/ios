import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:tritek_lms/data/entity/ccagents.dart';
import 'package:tritek_lms/http/endpoints.dart';
import 'package:tritek_lms/http/http.client.dart';

class AgentResponse {
  final List<Agents> data;
  final String error;
  final String eTitle;

  AgentResponse(this.data, this.error, this.eTitle);

  AgentResponse.fromJson(json)
      : data = (json as List).map((i) => new Agents.fromJson(i)).toList(),
        error = "",
        eTitle = "";

  AgentResponse.withError(String msg, String title)
      : data = null,
        error = msg,
        eTitle = title;
}

class AgentsApiProvider {
  Future<AgentResponse> getAgents() async {
    try {
      final Dio _dio = await HttpClient.http();
      Response response = await _dio.get(agentsEndpoint);
      return AgentResponse.fromJson(response.data);
    } catch (e) {
      if (e.response != null) {
        Map<String, dynamic> error = json.decode(e.response.toString());
        return AgentResponse.withError(error['message'], error['error']);
      }
      print('Network Error: ${e.message}');
      return AgentResponse.withError(
          "Network Error. Please check your network connection",
          "Network Error");
    }
  }
}
