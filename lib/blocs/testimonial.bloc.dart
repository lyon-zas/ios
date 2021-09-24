import 'package:rxdart/rxdart.dart';
import 'package:tritek_lms/data/repository/testimonial.repository.dart';
import 'package:tritek_lms/http/testimonials.dart';

class TestimonialBloc {
  final TestimonialRepository _repository = TestimonialRepository();
  final BehaviorSubject<TestimonialResponse> _testimonialSubject =
      BehaviorSubject<TestimonialResponse>();

  getTestimonial() async {
    TestimonialResponse response = await _repository.getTestimonial();
    _testimonialSubject.sink.add(response);
  }

  dispose() {
    _testimonialSubject.close();
  }

  BehaviorSubject<TestimonialResponse> get subject => _testimonialSubject;
}

final testimonialBloc = TestimonialBloc();
