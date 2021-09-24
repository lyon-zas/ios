import 'package:dio/dio.dart';
import 'package:tritek_lms/data/entity/courses.dart';
import 'package:tritek_lms/http/endpoints.dart';
import 'package:tritek_lms/http/http.client.dart';

class TestimonialResponse {
  final List<Testimonial> results;
  final String error;

  TestimonialResponse(this.results, this.error);

  TestimonialResponse.fromJson(json)
      : results =
            (json as List).map((i) => new Testimonial.fromJson(i)).toList(),
        error = "";

  TestimonialResponse.withError(String errorValue)
      : results = List(),
        error = errorValue;
}

class TestimonialApiProvider {

  Future<TestimonialResponse> getTestimonial() async {
    try {
      final Dio _dio = await HttpClient.http();
      Response response = await _dio.get(testimonialEndpoint);
      return TestimonialResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      // @todo
      print("Exception occurred: $error stackTrace: $stacktrace");
      return TestimonialResponse.withError("$error");
    }
  }
}
