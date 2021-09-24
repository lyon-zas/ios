import 'package:tritek_lms/http/testimonials.dart';

class TestimonialRepository {
  TestimonialApiProvider _apiProvider = TestimonialApiProvider();

  Future<TestimonialResponse> getTestimonial() {
    return _apiProvider.getTestimonial();
  }
}
