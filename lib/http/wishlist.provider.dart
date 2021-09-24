import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:tritek_lms/data/entity/wishlist.dart';
import 'package:tritek_lms/http/endpoints.dart';
import 'package:tritek_lms/http/http.client.dart';

class WishListResponse {
  final List<WishList> results;
  final String error;
  final String eTitle;

  WishListResponse(this.results, this.error, this.eTitle);

  WishListResponse.fromJson(json)
      : results = (json as List).map((i) => new WishList.fromJson(i)).toList(),
        error = "",
        eTitle = "";

  WishListResponse.withError(String msg, String title)
      : results = null,
        error = msg,
        eTitle = title;
}

class WishListApiProvider {
  Future<WishListResponse> getList() async {
    try {
      final Dio _dio = await HttpClient.http();
      Response response = await _dio.get(wishListEndpoint);
      return WishListResponse.fromJson(response.data);
    } catch (e) {
      if (e.response != null) {
        Map<String, dynamic> error = json.decode(e.response.toString());
        return WishListResponse.withError(error['message'], error['error']);
      }
      return WishListResponse.withError(
          "Network Error. Please check your network connection",
          "Network Error");
    }
  }

  Future<bool> deleteList(WishList wishList) async {
    try {
      final Dio _dio = await HttpClient.http();
      await _dio.delete(deleteListEndpoint + wishList.id.toString());
      return true;
    } catch (e) {
      return false;
    }
  }
}
