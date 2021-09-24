import 'package:rxdart/rxdart.dart';
import 'package:tritek_lms/data/entity/courses.dart';
import 'package:tritek_lms/data/repository/course.repository.dart';
import 'package:tritek_lms/data/repository/user.repository.dart';
import 'package:tritek_lms/http/courses.dart';
import 'package:tritek_lms/http/user.dart';

class CourseBloc {
  final CourseRepository _repository = CourseRepository();
  final BehaviorSubject<CoursesResponse> _coursesSubject =
      BehaviorSubject<CoursesResponse>();

  final BehaviorSubject<List<String>> _lessonStringList =
      BehaviorSubject<List<String>>();

  final BehaviorSubject<CoursesResponse> _myCoursesSubject =
      BehaviorSubject<CoursesResponse>();

  final BehaviorSubject<CourseResponse> _courseSubject =
      BehaviorSubject<CourseResponse>();

  final BehaviorSubject<CoursesResponse> _wishList =
      BehaviorSubject<CoursesResponse>();

  final UserRepository _userRepository = UserRepository();

  final BehaviorSubject<UserResponse> _userSubject =
  BehaviorSubject<UserResponse>();

  final BehaviorSubject<List<LessonSearch>> _search =
  BehaviorSubject<List<LessonSearch>>();

  BehaviorSubject<UserResponse> get userSubject => _userSubject;

  BehaviorSubject<List<String>> get lessonStringList => _lessonStringList;

  void getUser() async {
    UserResponse resp = await _userRepository.getDbUser();
    _userSubject.sink.add(resp);
  }

  void setWishlist(Course course, bool add) async {
    await _repository.setWishList(course, add);
  }

  getCourses() async {
    CoursesResponse response = await _repository.getCourses();
    _coursesSubject.sink.add(response);
  }

  getWishList() async {
    CoursesResponse response = await _repository.getWishList();
    _wishList.sink.add(response);
  }

  getMyCourses(int userId) async {
    CoursesResponse response = await _repository.getMyCourses(userId);
    if (_myCoursesSubject.isClosed) return;
    _myCoursesSubject.sink.add(response);
  }

  getMyCourseById(int userId, int courseId) async {
    CourseResponse response = await _repository.getMyCourse(userId, courseId);
    _courseSubject.sink.add(response);
  }

  // searchLessons(String term) async {
  //   List<LessonSearch> response = await _repository.searchLesson(term);
  //   debugPrint('Searching lesson...');
  //   _search.sink.add(response);
  // }

  searchLessonsFromCourses(String term, List<Course> courses) async {
    List<LessonSearch> response =
        _repository.searchLessonFromCourses(term, courses);
    _search.sink.add(response);
  }

  getLessonStringList() async {
    List<String> response = await _repository.lessonsStringList();
    if (!_lessonStringList.isClosed) {
      _lessonStringList.sink.add(response);
    }
  }

  dispose() {
    _coursesSubject.close();
    _courseSubject.close();
    _userSubject.close();
    _myCoursesSubject.close();
    _wishList.close();
    _search.close();
    _lessonStringList.close();
  }

  BehaviorSubject<CoursesResponse> get subject => _coursesSubject;

  BehaviorSubject<CoursesResponse> get myCourses => _myCoursesSubject;

  BehaviorSubject<CourseResponse> get course => _courseSubject;

  BehaviorSubject<CoursesResponse> get wishList => _wishList;

  BehaviorSubject<List<LessonSearch>> get search => _search;
}

final bloc = CourseBloc();
