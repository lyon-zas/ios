import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tritek_lms/data/entity/courses.dart';
import 'package:tritek_lms/database/app.db.dart';
import 'package:tritek_lms/http/courses.dart';

class CourseRepository {
  CoursesApiProvider _apiProvider = CoursesApiProvider();

  Future<CoursesResponse> getCourses() async {
    bool conn = await DataConnectionChecker().hasConnection;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int courseResp = prefs.getInt('courseResp') ?? 0;

    if (!conn && courseResp > 0) {
      print('no connection');
      return getDbCourses();
    }
    CoursesResponse response = await _apiProvider.getCourses();

    if (response.length != courseResp && response.results.length > 0) {
      await saveCourses(response.results);
      await prefs.setInt('courseResp', response.length);
    }

    return response;
  }

  Future<CoursesResponse> getMyCourses(int userId) async {
    bool conn = await DataConnectionChecker().hasConnection;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int courseResp = prefs.getInt('myCourseResp') ?? 0;

    if (!conn && courseResp > 0) {
      return getDbMyCourses(userId);
    }
    // return getDbCourses();

    CoursesResponse response = await _apiProvider.getMyCourses(userId);
    if (response.length != courseResp && response.results.length > 0) {
      await updateMyCourses(response.results, userId);
      await prefs.setInt('myCourseResp', response.length);
    }

    return response;
  }

  Future<CourseResponse> getMyCourse(int userId, int courseId) async {
    bool conn = await DataConnectionChecker().hasConnection;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int myCourseResp = prefs.getInt('myCourseResp') ?? 0;
    int courseResp = prefs.getInt('courseResp') ?? 0;

    if (!conn && (courseResp > 0 || myCourseResp > 0)) {
      return getDbMyCourse(userId, courseId);
    }

    CourseResponse response = await _apiProvider.getMyCourse(userId, courseId);
    if (response != null &&
        response.result != null &&
        response.result.title != null) {
      await updateMyCourse(response.result, userId);
    }

    return response;
  }

  Future<CoursesResponse> getDbCourses() async {
    final database = await AppDB().getDatabase();
    final courseDao = database.courseDao;
    final sectionsDao = database.sectionsDao;
    final lessonsDao = database.lessonsDao;
    final instructorDao = database.instructorDao;
    final commentDao = database.commentsDao;

    final List<Course> courses = await courseDao.findAll();

    for (Course course in courses) {
      final List<Sections> sections =
          await sectionsDao.findByCourseId(course.id);
      for (Sections section in sections) {
        final List<Lessons> lessons =
            await lessonsDao.findBySectionId(section.id);
        section.lessons = lessons;
      }

      final Instructor instructor = await instructorDao.findById(course.userId);
      final List<Comments> comments =
          await commentDao.findByCourseId(course.id);

      course.comments = comments;
      course.instructor = instructor;
      course.sections = sections;
    }

    CoursesResponse response = CoursesResponse(courses, '', '', 0);
    return response;
  }

  Future<CoursesResponse> getDbMyCourses(int userId) async {
    final database = await AppDB().getDatabase();
    final courseDao = database.courseDao;
    final sectionsDao = database.sectionsDao;
    final lessonsDao = database.lessonsDao;
    final instructorDao = database.instructorDao;
    final commentDao = database.commentsDao;

    final List<Course> courses = await courseDao.findMyCourses(userId);

    for (Course course in courses) {
      final List<Sections> sections =
          await sectionsDao.findByCourseId(course.id);
      for (Sections section in sections) {
        final List<Lessons> lessons =
            await lessonsDao.findBySectionId(section.id);
        section.lessons = lessons;
      }

      final Instructor instructor = await instructorDao.findById(course.userId);
      final List<Comments> comments =
          await commentDao.findByCourseId(course.id);

      course.comments = comments;
      course.instructor = instructor;
      course.sections = sections;
    }

    CoursesResponse response = CoursesResponse(courses, '', '', 0);
    return response;
  }

  Future<CoursesResponse> getWishList() async {
    final database = await AppDB().getDatabase();
    final courseDao = database.courseDao;
    final sectionsDao = database.sectionsDao;
    final lessonsDao = database.lessonsDao;
    final instructorDao = database.instructorDao;
    final commentDao = database.commentsDao;

    final List<Course> courses = await courseDao.getWishList(true);

    for (Course course in courses) {
      final List<Sections> sections =
          await sectionsDao.findByCourseId(course.id);
      for (Sections section in sections) {
        final List<Lessons> lessons =
            await lessonsDao.findBySectionId(section.id);
        section.lessons = lessons;
      }

      final Instructor instructor = await instructorDao.findById(course.userId);
      final List<Comments> comments =
          await commentDao.findByCourseId(course.id);

      course.comments = comments;
      course.instructor = instructor;
      course.sections = sections;
    }

    CoursesResponse response = CoursesResponse(courses, '', '', 0);
    return response;
  }

  Future<List<LessonSearch>> searchLesson(String term) async {
    final database = await AppDB().getDatabase();
    final searchDao = database.lessonSearchDao;

    final List<LessonSearch> search = await searchDao.search('%' + term + '%');
    return search;
  }

  Future<List<String>> lessonsStringList() async {
    final database = await AppDB().getDatabase();
    final searchDao = database.lessonsDao;

    final List<Lessons> search = await searchDao.findAll();
    return search.map((e) => e.postTitle).toList().toSet().toList();
  }

  Future<CourseResponse> getDbMyCourse(int userId, int courseId) async {
    final database = await AppDB().getDatabase();
    final courseDao = database.courseDao;
    final sectionsDao = database.sectionsDao;
    final lessonsDao = database.lessonsDao;
    final instructorDao = database.instructorDao;
    final commentDao = database.commentsDao;

    final Course course = await courseDao.findById(courseId);

    final List<Sections> sections = await sectionsDao.findByCourseId(course.id);
    for (Sections section in sections) {
      final List<Lessons> lessons =
          await lessonsDao.findBySectionId(section.id);
      section.lessons = lessons;
    }

    final Instructor instructor = await instructorDao.findById(course.userId);
    final List<Comments> comments = await commentDao.findByCourseId(course.id);

    course.comments = comments;
    course.instructor = instructor;
    course.sections = sections;

    CourseResponse response = CourseResponse(course, '', '', 0);
    return response;
  }

  Future<void> saveCourses(List<Course> courses) async {
    try {
      final database = await AppDB().getDatabase();
      final courseDao = database.courseDao;
      final sectionsDao = database.sectionsDao;
      final lessonsDao = database.lessonsDao;
      final instructorDao = database.instructorDao;
      final commentDao = database.commentsDao;

      await instructorDao.deleteAll();
      await commentDao.deleteAll();
      await lessonsDao.deleteAll();
      await sectionsDao.deleteAll();
      await courseDao.deleteAll();

      for (Course course in courses) {
        courseDao.save(course);
        final List<Sections> sections = course.sections;
        for (Sections section in sections) {
          sectionsDao.save(section);
          final List<Lessons> lessons = section.lessons;
          for (Lessons lesson in lessons) {
            lessonsDao.save(lesson);
          }
        }

        instructorDao.save(course.instructor);
        for (Comments comment in course.comments) {
          commentDao.save(comment);
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> saveComment(Comments comments) async {
    try {
      final database = await AppDB().getDatabase();
      final commentDao = database.commentsDao;
      comments.image = 'local';
      commentDao.save(comments);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> updateMyCourses(List<Course> courses, int userId) async {
    final database = await AppDB().getDatabase();
    final courseDao = database.courseDao;
    final lessonsDao = database.lessonsDao;

    for (Course course in courses) {
      courseDao.update(course);
      final List<Sections> sections = course.sections;
      for (Sections section in sections) {
        final List<Lessons> lessons = section.lessons;
        for (Lessons lesson in lessons) {
          lessonsDao.update(lesson);
        }
      }
    }
  }

  Future<void> updateMyCourse(Course course, int userId) async {
    final database = await AppDB().getDatabase();
    final courseDao = database.courseDao;
    final lessonsDao = database.lessonsDao;

    courseDao.update(course);
    final List<Sections> sections = course.sections;
    for (Sections section in sections) {
      final List<Lessons> lessons = section.lessons;
      for (Lessons lesson in lessons) {
        lessonsDao.update(lesson);
      }
    }
  }

  Future<void> setWishList(Course course, bool add) async {
    final database = await AppDB().getDatabase();
    final courseDao = database.courseDao;

    course.wishList = add;
    courseDao.update(course);
  }

  Future<void> refreshCourses() async {
    final database = await AppDB().getDatabase();
    final courseDao = database.courseDao;
    final sectionsDao = database.sectionsDao;
    final lessonsDao = database.lessonsDao;
    final instructorDao = database.instructorDao;
    final commentDao = database.commentsDao;

    await instructorDao.deleteAll();
    await commentDao.deleteAll();
    await lessonsDao.deleteAll();
    await sectionsDao.deleteAll();
    await courseDao.deleteAll();
  }

  List<LessonSearch> searchLessonFromCourses(
      String term, List<Course> courses) {
    List<LessonSearch> response = [];
    for (Course course in courses) {
      for (Sections section in course.sections) {
        for (Lessons lesson in section.lessons) {
          if (lesson.postTitle.toLowerCase().contains(term.toLowerCase())) {
            var search = LessonSearch();
            search.section = section.sectionName;
            search.lesson = lesson.postTitle;
            search.course = course.title;
            search.itemId = lesson.itemId;

            response.add(search);
          }
        }
      }
    }

    print(response.length.toString());
    return response;
  }
}
