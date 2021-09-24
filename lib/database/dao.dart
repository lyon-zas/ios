import 'package:floor/floor.dart';
import 'package:tritek_lms/data/entity/courses.dart';
import 'package:tritek_lms/data/entity/note.dart';
import 'package:tritek_lms/data/entity/users.dart';

@dao
abstract class CourseDao {
  @Query('SELECT * FROM course')
  Future<List<Course>> findAll();

  @Query('SELECT * FROM course WHERE id = :id')
  Future<Course> findById(int id);

  @Query('SELECT * FROM course WHERE subId = :id')
  Future<List<Course>> findMyCourses(int id);

  @Query('SELECT * FROM course WHERE wishList = :id')
  Future<List<Course>> getWishList(bool id);

  @insert
  Future<void> save(Course course);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> update(Course course);

  @Query('Delete FROM course')
  Future<void> deleteAll();
}

@dao
abstract class SectionsDao {
  @Query('SELECT * FROM sections')
  Future<List<Sections>> findAll();

  @Query('SELECT * FROM sections WHERE courseId = :courseId')
  Future<List<Sections>> findByCourseId(int courseId);

  @Query('SELECT * FROM sections WHERE id = :id')
  Stream<Sections> findById(int id);

  @insert
  Future<void> save(Sections sections);

  @Query('Delete FROM sections')
  Future<void> deleteAll();
}

@dao
abstract class LessonsDao {
  @Query('SELECT * FROM lessons')
  Future<List<Lessons>> findAll();

  // @Query('SELECT DISTINCT postTitle FROM lessons')
  // Future<List<String>> lessonsStringList();

  @Query('SELECT * FROM lessons WHERE sectionId = :sectionId')
  Future<List<Lessons>> findBySectionId(int sectionId);

  @Query('SELECT * FROM lessons WHERE id = :id')
  Stream<Lessons> findById(int id);

  @insert
  Future<void> save(Lessons lessons);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> update(Lessons lessons);

  @Query('Delete FROM lessons')
  Future<void> deleteAll();
}

@dao
abstract class LessonSearchDao {
  @Query('SELECT * FROM lessonSearch WHERE lesson LIKE :term')
  Future<List<LessonSearch>> search(String term);
}

@dao
abstract class InstructorDao {
  @Query('SELECT * FROM instructor')
  Future<List<Instructor>> findAll();

  @Query('SELECT * FROM instructor WHERE userId = :id')
  Future<Instructor> findById(int id);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> save(Instructor lessons);

  @Query('Delete FROM instructor')
  Future<void> deleteAll();
}

@dao
abstract class CommentsDao {
  @Query('SELECT * FROM comments')
  Future<List<Comments>> findAll();

  @insert
  Future<void> save(Comments lessons);

  @Query('Delete FROM comments')
  Future<void> deleteAll();

  @Query('SELECT * FROM comments WHERE courseId = :courseId')
  Future<List<Comments>> findByCourseId(int courseId);
}

@dao
abstract class TestimonialDao {
  @Query('SELECT * FROM testimonial')
  Future<List<Testimonial>> findAll();

  @insert
  Future<void> save(Testimonial lessons);

  @Query('Delete FROM testimonial')
  Future<void> deleteAll();
}

@dao
abstract class UserDao {
  @Query('SELECT * FROM users LIMIT 1')
  Future<Users> findAll();

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> save(Users user);

  @Query('Delete FROM users')
  Future<void> deleteAll();
}

@dao
abstract class UserLevelDao {
  @Query('SELECT * FROM userLevel LIMIT 1')
  Future<UserLevel> findAll();

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> save(UserLevel level);

  @Query('Delete FROM userLevel')
  Future<void> deleteAll();
}

@dao
abstract class LevelLogsDao {
  @Query('SELECT * FROM levelLogs')
  Future<List<LevelLogs>> findAll();

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> save(LevelLogs level);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> saveAll(List<LevelLogs> level);

  @Query('Delete FROM levelLogs')
  Future<void> deleteAll();
}

@dao
abstract class NotesDao {
  @Query('SELECT * FROM notes')
  Future<List<Notes>> findAll();

  @Query('SELECT * FROM notes WHERE sectionId = :sectionId')
  Future<List<Notes>> findBySectionId(int sectionId);

  @Query('SELECT * FROM notes WHERE sectionId = :courseId')
  Future<List<Notes>> findByCourseId(int courseId);

  @Query('SELECT * FROM notes WHERE synced = 0')
  Future<List<Notes>> findNotSynced();

  @Query('SELECT * FROM notes WHERE lesson = :lessonId')
  Future<List<Notes>> findByLessonId(int lessonId);

  @Query('SELECT * FROM notes WHERE lesson LIKE :lesson')
  Future<List<Notes>> search(String lesson);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<int> save(Notes note);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<int> update(Notes note);

  @Query('Delete FROM notes')
  Future<void> deleteAll();

  @Query('DELETE FROM notes WHERE id = :id')
  Future<void> delete(int id);
}
