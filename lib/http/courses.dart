import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:tritek_lms/data/entity/courses.dart';
import 'package:tritek_lms/http/endpoints.dart';
import 'package:tritek_lms/http/http.client.dart';

class CoursesResponse {
  final List<Course> results;
  final String error;
  final String eTitle;
  final int length;

  CoursesResponse(this.results, this.error, this.eTitle, this.length);

  CoursesResponse.fromJson(json, len)
      : results = (json as List).map((i) => new Course.fromJson(i)).toList(),
        error = "",
        eTitle = "",
        length = len;

  CoursesResponse.withError(String error, String title)
      : results = [],
        error = error,
        eTitle = title,
        length = 0;
}

class CourseResponse {
  final Course result;
  final String error;
  final String eTitle;
  final int length;

  CourseResponse(this.result, this.error, this.eTitle, this.length);

  CourseResponse.fromJson(json, len)
      : result = new Course.fromJson(json),
        error = "",
        eTitle = "",
        length = len;

  CourseResponse.withError(String error, String title)
      : result = null,
        error = error,
        eTitle = title,
        length = 0;
}

class CoursesApiProvider {
  Future<CoursesResponse> getCourses() async {
    try {
      final Dio _dio = await HttpClient.http();
      Response response = await _dio.get(coursesEndpoint,
          options: Options(method: 'GET', responseType: ResponseType.plain));
      return CoursesResponse.fromJson(
          json.decode(response.data), response.data.length);
    } catch (e) {
      if (e.response != null) {
        Map<String, dynamic> error = json.decode(e.response.toString());
        return CoursesResponse.withError(error['message'], error['error']);
      }
      print('Network Error: ${e.message}');
      return CoursesResponse.withError(
          "Network Error. Please check your network connection",
          "Network Error");
    }
  }

  Future<CoursesResponse> getMyCourses(int userId) async {
    try {
      final Dio _dio = await HttpClient.http();
      Response response = await _dio.get(myCoursesEndpoint + userId.toString(),
          options: Options(method: 'GET', responseType: ResponseType.plain));
      return CoursesResponse.fromJson(
          json.decode(response.data), response.data.length);
    } catch (e) {
      if (e.response != null) {
        Map<String, dynamic> error = json.decode(e.response.toString());
        return CoursesResponse.withError(error['message'], error['error']);
      }
      print('Network Error: ${e.message}');
      return CoursesResponse.withError(
          "Network Error. Please check your network connection",
          "Network Error");
    }
  }

  Future<bool> postComment(Comments comment) async {
    try {
      final Dio _dio = await HttpClient.http();
      await _dio.post(commentEndpoint, data: comment);

      return true;
    } catch (e) {
      print(e.response.toString());
      return false;
    }
  }

  Future<CourseResponse> getMyCourse(int userId, int courseId) async {
    try {
      final Dio _dio = await HttpClient.http();
      Response response = await _dio.get(
          myCoursesEndpoint + userId.toString() + '/' + courseId.toString());

      return CourseResponse.fromJson(response.data, response.data.length);
    } catch (e) {
      if (e.response != null) {
        Map<String, dynamic> error = json.decode(e.response.toString());
        return CourseResponse.withError(error['message'], error['error']);
      }
      return CourseResponse.withError(e.message, "Network Error");
    }
  }
}
