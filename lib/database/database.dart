import 'dart:async';

import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:tritek_lms/data/entity/courses.dart';
import 'package:tritek_lms/data/entity/note.dart';
import 'package:tritek_lms/data/entity/users.dart';

import 'dao.dart';

part 'database.g.dart'; // the generated code will be there

@TypeConverters([DateTimeConverter, ColorConverter])
@Database(version: 5, entities: [
  Course,
  Sections,
  Lessons,
  Instructor,
  Comments,
  Testimonial,
  Users,
  UserLevel,
  Notes,
  LevelLogs
], views: [
  LessonSearch
])
abstract class AppDatabase extends FloorDatabase {
  CourseDao get courseDao;

  SectionsDao get sectionsDao;

  LessonsDao get lessonsDao;

  LessonSearchDao get lessonSearchDao;

  InstructorDao get instructorDao;

  CommentsDao get commentsDao;

  TestimonialDao get testimonialDao;

  UserDao get userDao;

  UserLevelDao get userLevelDao;

  NotesDao get notesDao;

  LevelLogsDao get levelLogsDao;
}

