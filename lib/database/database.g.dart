// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder {
  _$AppDatabaseBuilder(this.name);

  final String name;

  final List<Migration> _migrations = [];

  Callback _callback;

  /// Adds migrations to the builder.
  _$AppDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$AppDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String> listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  CourseDao _courseDaoInstance;

  SectionsDao _sectionsDaoInstance;

  LessonsDao _lessonsDaoInstance;

  LessonSearchDao _lessonSearchDaoInstance;

  InstructorDao _instructorDaoInstance;

  CommentsDao _commentsDaoInstance;

  TestimonialDao _testimonialDaoInstance;

  UserDao _userDaoInstance;

  UserLevelDao _userLevelDaoInstance;

  NotesDao _notesDaoInstance;

  LevelLogsDao _levelLogsDaoInstance;

  Future<sqflite.Database> open(String path, List<Migration> migrations,
      [Callback callback]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 5,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Course` (`id` INTEGER, `title` TEXT, `duration` TEXT, `students` TEXT, `retake` TEXT, `enrolled` TEXT, `author` TEXT, `description` TEXT, `userId` INTEGER, `image` TEXT, `subId` INTEGER, `wishList` INTEGER, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `sections` (`sectionName` TEXT, `sectionOrder` INTEGER, `id` INTEGER, `courseId` INTEGER, FOREIGN KEY (`courseId`) REFERENCES `Course` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `lessons` (`itemId` INTEGER, `itemOrder` INTEGER, `postTitle` TEXT, `postId` INTEGER, `sectionId` INTEGER, `courseId` INTEGER, `duration` TEXT, `preview` TEXT, `viewed` INTEGER, `quizCount` INTEGER, `grade` TEXT, PRIMARY KEY (`itemId`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Instructor` (`userId` INTEGER, `email` TEXT, `username` TEXT, `name` TEXT, `description` TEXT, PRIMARY KEY (`userId`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Comments` (`id` INTEGER, `author` TEXT, `email` TEXT, `comment` TEXT, `rating` TEXT, `image` TEXT, `courseId` INTEGER, `title` TEXT, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Testimonial` (`id` INTEGER, `title` TEXT, `content` TEXT, `name` TEXT, `image` TEXT, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `users` (`id` INTEGER, `email` TEXT, `username` TEXT, `name` TEXT, `firstName` TEXT, `lastName` TEXT, `status` TEXT, `startDate` TEXT, `endDate` TEXT, `subscription` TEXT, `image` TEXT, `phoneNo` TEXT, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `userLevel` (`points` TEXT, `award` TEXT, `newPoint` TEXT, `level` TEXT, `deducted` TEXT, `userId` INTEGER, `badge` TEXT, PRIMARY KEY (`userId`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `notes` (`id` INTEGER, `time` TEXT, `course` TEXT, `courseId` INTEGER, `sectionId` INTEGER, `section` TEXT, `lessonId` INTEGER, `lesson` TEXT, `content` TEXT, `createdAt` TEXT, `updatedAt` TEXT, `noteColor` INTEGER, `isArchived` INTEGER, `synced` INTEGER, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `levelLogs` (`userEarningId` INTEGER, `title` TEXT, `userId` INTEGER, `postId` INTEGER, `postType` TEXT, `points` INTEGER, `pointsType` TEXT, `date` TEXT, PRIMARY KEY (`userEarningId`))');

        await database.execute(
            '''CREATE VIEW IF NOT EXISTS `lessonSearch` AS SELECT lessons.postTitle as lesson, lessons.itemId as itemId, sections.sectionName as section, course.title as course FROM lessons INNER JOIN sections ON lessons.sectionId = sections.id INNER JOIN course ON lessons.courseId = course.id''');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  CourseDao get courseDao {
    return _courseDaoInstance ??= _$CourseDao(database, changeListener);
  }

  @override
  SectionsDao get sectionsDao {
    return _sectionsDaoInstance ??= _$SectionsDao(database, changeListener);
  }

  @override
  LessonsDao get lessonsDao {
    return _lessonsDaoInstance ??= _$LessonsDao(database, changeListener);
  }

  @override
  LessonSearchDao get lessonSearchDao {
    return _lessonSearchDaoInstance ??=
        _$LessonSearchDao(database, changeListener);
  }

  @override
  InstructorDao get instructorDao {
    return _instructorDaoInstance ??= _$InstructorDao(database, changeListener);
  }

  @override
  CommentsDao get commentsDao {
    return _commentsDaoInstance ??= _$CommentsDao(database, changeListener);
  }

  @override
  TestimonialDao get testimonialDao {
    return _testimonialDaoInstance ??=
        _$TestimonialDao(database, changeListener);
  }

  @override
  UserDao get userDao {
    return _userDaoInstance ??= _$UserDao(database, changeListener);
  }

  @override
  UserLevelDao get userLevelDao {
    return _userLevelDaoInstance ??= _$UserLevelDao(database, changeListener);
  }

  @override
  NotesDao get notesDao {
    return _notesDaoInstance ??= _$NotesDao(database, changeListener);
  }

  @override
  LevelLogsDao get levelLogsDao {
    return _levelLogsDaoInstance ??= _$LevelLogsDao(database, changeListener);
  }
}

class _$CourseDao extends CourseDao {
  _$CourseDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _courseInsertionAdapter = InsertionAdapter(
            database,
            'Course',
            (Course item) => <String, dynamic>{
                  'id': item.id,
                  'title': item.title,
                  'duration': item.duration,
                  'students': item.students,
                  'retake': item.retake,
                  'enrolled': item.enrolled,
                  'author': item.author,
                  'description': item.description,
                  'userId': item.userId,
                  'image': item.image,
                  'subId': item.subId,
                  'wishList':
                      item.wishList == null ? null : (item.wishList ? 1 : 0)
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Course> _courseInsertionAdapter;

  @override
  Future<List<Course>> findAll() async {
    return _queryAdapter.queryList('SELECT * FROM course',
        mapper: (Map<String, dynamic> row) => Course(
            id: row['id'] as int,
            title: row['title'] as String,
            duration: row['duration'] as String,
            students: row['students'] as String,
            retake: row['retake'] as String,
            enrolled: row['enrolled'] as String,
            author: row['author'] as String,
            description: row['description'] as String,
            userId: row['userId'] as int,
            image: row['image'] as String,
            subId: row['subId'] as int,
            wishList: row['wishList'] == null
                ? null
                : (row['wishList'] as int) != 0));
  }

  @override
  Future<Course> findById(int id) async {
    return _queryAdapter.query('SELECT * FROM course WHERE id = ?',
        arguments: <dynamic>[id],
        mapper: (Map<String, dynamic> row) => Course(
            id: row['id'] as int,
            title: row['title'] as String,
            duration: row['duration'] as String,
            students: row['students'] as String,
            retake: row['retake'] as String,
            enrolled: row['enrolled'] as String,
            author: row['author'] as String,
            description: row['description'] as String,
            userId: row['userId'] as int,
            image: row['image'] as String,
            subId: row['subId'] as int,
            wishList: row['wishList'] == null
                ? null
                : (row['wishList'] as int) != 0));
  }

  @override
  Future<List<Course>> findMyCourses(int id) async {
    return _queryAdapter.queryList('SELECT * FROM course WHERE subId = ?',
        arguments: <dynamic>[id],
        mapper: (Map<String, dynamic> row) => Course(
            id: row['id'] as int,
            title: row['title'] as String,
            duration: row['duration'] as String,
            students: row['students'] as String,
            retake: row['retake'] as String,
            enrolled: row['enrolled'] as String,
            author: row['author'] as String,
            description: row['description'] as String,
            userId: row['userId'] as int,
            image: row['image'] as String,
            subId: row['subId'] as int,
            wishList: row['wishList'] == null
                ? null
                : (row['wishList'] as int) != 0));
  }

  @override
  Future<List<Course>> getWishList(bool id) async {
    return _queryAdapter.queryList('SELECT * FROM course WHERE wishList = ?',
        arguments: <dynamic>[id == null ? null : (id ? 1 : 0)],
        mapper: (Map<String, dynamic> row) => Course(
            id: row['id'] as int,
            title: row['title'] as String,
            duration: row['duration'] as String,
            students: row['students'] as String,
            retake: row['retake'] as String,
            enrolled: row['enrolled'] as String,
            author: row['author'] as String,
            description: row['description'] as String,
            userId: row['userId'] as int,
            image: row['image'] as String,
            subId: row['subId'] as int,
            wishList: row['wishList'] == null
                ? null
                : (row['wishList'] as int) != 0));
  }

  @override
  Future<void> deleteAll() async {
    await _queryAdapter.queryNoReturn('Delete FROM course');
  }

  @override
  Future<void> save(Course course) async {
    await _courseInsertionAdapter.insert(course, OnConflictStrategy.abort);
  }

  @override
  Future<void> update(Course course) async {
    await _courseInsertionAdapter.insert(course, OnConflictStrategy.replace);
  }
}

class _$SectionsDao extends SectionsDao {
  _$SectionsDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database, changeListener),
        _sectionsInsertionAdapter = InsertionAdapter(
            database,
            'sections',
            (Sections item) => <String, dynamic>{
                  'sectionName': item.sectionName,
                  'sectionOrder': item.sectionOrder,
                  'id': item.id,
                  'courseId': item.courseId
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Sections> _sectionsInsertionAdapter;

  @override
  Future<List<Sections>> findAll() async {
    return _queryAdapter.queryList('SELECT * FROM sections',
        mapper: (Map<String, dynamic> row) => Sections(
            sectionName: row['sectionName'] as String,
            sectionOrder: row['sectionOrder'] as int,
            id: row['id'] as int,
            courseId: row['courseId'] as int));
  }

  @override
  Future<List<Sections>> findByCourseId(int courseId) async {
    return _queryAdapter.queryList('SELECT * FROM sections WHERE courseId = ?',
        arguments: <dynamic>[courseId],
        mapper: (Map<String, dynamic> row) => Sections(
            sectionName: row['sectionName'] as String,
            sectionOrder: row['sectionOrder'] as int,
            id: row['id'] as int,
            courseId: row['courseId'] as int));
  }

  @override
  Stream<Sections> findById(int id) {
    return _queryAdapter.queryStream('SELECT * FROM sections WHERE id = ?',
        arguments: <dynamic>[id],
        queryableName: 'sections',
        isView: false,
        mapper: (Map<String, dynamic> row) => Sections(
            sectionName: row['sectionName'] as String,
            sectionOrder: row['sectionOrder'] as int,
            id: row['id'] as int,
            courseId: row['courseId'] as int));
  }

  @override
  Future<void> deleteAll() async {
    await _queryAdapter.queryNoReturn('Delete FROM sections');
  }

  @override
  Future<void> save(Sections sections) async {
    await _sectionsInsertionAdapter.insert(sections, OnConflictStrategy.abort);
  }
}

class _$LessonsDao extends LessonsDao {
  _$LessonsDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database, changeListener),
        _lessonsInsertionAdapter = InsertionAdapter(
            database,
            'lessons',
            (Lessons item) => <String, dynamic>{
                  'itemId': item.itemId,
                  'itemOrder': item.itemOrder,
                  'postTitle': item.postTitle,
                  'postId': item.postId,
                  'sectionId': item.sectionId,
                  'courseId': item.courseId,
                  'duration': item.duration,
                  'preview': item.preview,
                  'viewed': item.viewed == null ? null : (item.viewed ? 1 : 0),
                  'quizCount': item.quizCount,
                  'grade': item.grade
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Lessons> _lessonsInsertionAdapter;

  @override
  Future<List<Lessons>> findAll() async {
    return _queryAdapter.queryList('SELECT * FROM lessons',
        mapper: (Map<String, dynamic> row) => Lessons(
            itemId: row['itemId'] as int,
            itemOrder: row['itemOrder'] as int,
            postTitle: row['postTitle'] as String,
            postId: row['postId'] as int,
            sectionId: row['sectionId'] as int,
            courseId: row['courseId'] as int,
            duration: row['duration'] as String,
            preview: row['preview'] as String,
            viewed: row['viewed'] == null ? null : (row['viewed'] as int) != 0,
            quizCount: row['quizCount'] as int,
            grade: row['grade'] as String));
  }

  @override
  Future<List<Lessons>> findBySectionId(int sectionId) async {
    return _queryAdapter.queryList('SELECT * FROM lessons WHERE sectionId = ?',
        arguments: <dynamic>[sectionId],
        mapper: (Map<String, dynamic> row) => Lessons(
            itemId: row['itemId'] as int,
            itemOrder: row['itemOrder'] as int,
            postTitle: row['postTitle'] as String,
            postId: row['postId'] as int,
            sectionId: row['sectionId'] as int,
            courseId: row['courseId'] as int,
            duration: row['duration'] as String,
            preview: row['preview'] as String,
            viewed: row['viewed'] == null ? null : (row['viewed'] as int) != 0,
            quizCount: row['quizCount'] as int,
            grade: row['grade'] as String));
  }

  @override
  Stream<Lessons> findById(int id) {
    return _queryAdapter.queryStream('SELECT * FROM lessons WHERE id = ?',
        arguments: <dynamic>[id],
        queryableName: 'lessons',
        isView: false,
        mapper: (Map<String, dynamic> row) => Lessons(
            itemId: row['itemId'] as int,
            itemOrder: row['itemOrder'] as int,
            postTitle: row['postTitle'] as String,
            postId: row['postId'] as int,
            sectionId: row['sectionId'] as int,
            courseId: row['courseId'] as int,
            duration: row['duration'] as String,
            preview: row['preview'] as String,
            viewed: row['viewed'] == null ? null : (row['viewed'] as int) != 0,
            quizCount: row['quizCount'] as int,
            grade: row['grade'] as String));
  }

  @override
  Future<void> deleteAll() async {
    await _queryAdapter.queryNoReturn('Delete FROM lessons');
  }

  @override
  Future<void> save(Lessons lessons) async {
    await _lessonsInsertionAdapter.insert(lessons, OnConflictStrategy.abort);
  }

  @override
  Future<void> update(Lessons lessons) async {
    await _lessonsInsertionAdapter.insert(lessons, OnConflictStrategy.replace);
  }
}

class _$LessonSearchDao extends LessonSearchDao {
  _$LessonSearchDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  @override
  Future<List<LessonSearch>> search(String term) async {
    return _queryAdapter.queryList(
        'SELECT * FROM lessonSearch WHERE lesson LIKE ?',
        arguments: <dynamic>[term],
        mapper: (Map<String, dynamic> row) => LessonSearch(
            itemId: row['itemId'] as int,
            lesson: row['lesson'] as String,
            section: row['section'] as String,
            course: row['course'] as String));
  }
}

class _$InstructorDao extends InstructorDao {
  _$InstructorDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _instructorInsertionAdapter = InsertionAdapter(
            database,
            'Instructor',
            (Instructor item) => <String, dynamic>{
                  'userId': item.userId,
                  'email': item.email,
                  'username': item.username,
                  'name': item.name,
                  'description': item.description
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Instructor> _instructorInsertionAdapter;

  @override
  Future<List<Instructor>> findAll() async {
    return _queryAdapter.queryList('SELECT * FROM instructor',
        mapper: (Map<String, dynamic> row) => Instructor(
            userId: row['userId'] as int,
            email: row['email'] as String,
            username: row['username'] as String,
            name: row['name'] as String,
            description: row['description'] as String));
  }

  @override
  Future<Instructor> findById(int id) async {
    return _queryAdapter.query('SELECT * FROM instructor WHERE userId = ?',
        arguments: <dynamic>[id],
        mapper: (Map<String, dynamic> row) => Instructor(
            userId: row['userId'] as int,
            email: row['email'] as String,
            username: row['username'] as String,
            name: row['name'] as String,
            description: row['description'] as String));
  }

  @override
  Future<void> deleteAll() async {
    await _queryAdapter.queryNoReturn('Delete FROM instructor');
  }

  @override
  Future<void> save(Instructor lessons) async {
    await _instructorInsertionAdapter.insert(
        lessons, OnConflictStrategy.replace);
  }
}

class _$CommentsDao extends CommentsDao {
  _$CommentsDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _commentsInsertionAdapter = InsertionAdapter(
            database,
            'Comments',
                (Comments item) => <String, dynamic>{
                  'id': item.id,
                  'author': item.author,
                  'email': item.email,
                  'comment': item.comment,
                  'rating': item.rating,
                  'image': item.image,
                  'courseId': item.courseId,
                  'title': item.title
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Comments> _commentsInsertionAdapter;

  @override
  Future<List<Comments>> findAll() async {
    return _queryAdapter.queryList('SELECT * FROM comments',
        mapper: (Map<String, dynamic> row) =>
            Comments(
                id: row['id'] as int,
                author: row['author'] as String,
                email: row['email'] as String,
                comment: row['comment'] as String,
                rating: row['rating'] as String,
                image: row['image'] as String,
                title: row['title'] as String));
  }

  @override
  Future<void> deleteAll() async {
    await _queryAdapter.queryNoReturn('Delete FROM comments');
  }

  @override
  Future<List<Comments>> findByCourseId(int courseId) async {
    return _queryAdapter.queryList('SELECT * FROM comments WHERE courseId = ?',
        arguments: <dynamic>[courseId],
        mapper: (Map<String, dynamic> row) =>
            Comments(
                id: row['id'] as int,
                author: row['author'] as String,
                email: row['email'] as String,
                comment: row['comment'] as String,
                rating: row['rating'] as String,
                image: row['image'] as String,
                title: row['title'] as String));
  }

  @override
  Future<void> save(Comments lessons) async {
    await _commentsInsertionAdapter.insert(lessons, OnConflictStrategy.abort);
  }
}

class _$TestimonialDao extends TestimonialDao {
  _$TestimonialDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _testimonialInsertionAdapter = InsertionAdapter(
            database,
            'Testimonial',
            (Testimonial item) => <String, dynamic>{
                  'id': item.id,
                  'title': item.title,
                  'content': item.content,
                  'name': item.name,
                  'image': item.image
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Testimonial> _testimonialInsertionAdapter;

  @override
  Future<List<Testimonial>> findAll() async {
    return _queryAdapter.queryList('SELECT * FROM testimonial',
        mapper: (Map<String, dynamic> row) => Testimonial(
            id: row['id'] as int,
            title: row['title'] as String,
            content: row['content'] as String,
            name: row['name'] as String,
            image: row['image'] as String));
  }

  @override
  Future<void> deleteAll() async {
    await _queryAdapter.queryNoReturn('Delete FROM testimonial');
  }

  @override
  Future<void> save(Testimonial lessons) async {
    await _testimonialInsertionAdapter.insert(
        lessons, OnConflictStrategy.abort);
  }
}

class _$UserDao extends UserDao {
  _$UserDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _usersInsertionAdapter = InsertionAdapter(
            database,
            'users',
            (Users item) => <String, dynamic>{
                  'id': item.id,
                  'email': item.email,
                  'username': item.username,
                  'name': item.name,
                  'firstName': item.firstName,
                  'lastName': item.lastName,
                  'status': item.status,
                  'startDate': item.startDate,
                  'endDate': item.endDate,
                  'subscription': item.subscription,
                  'image': item.image,
                  'phoneNo': item.phoneNo
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Users> _usersInsertionAdapter;

  @override
  Future<Users> findAll() async {
    return _queryAdapter.query('SELECT * FROM users LIMIT 1',
        mapper: (Map<String, dynamic> row) => Users(
            id: row['id'] as int,
            email: row['email'] as String,
            username: row['username'] as String,
            name: row['name'] as String,
            firstName: row['firstName'] as String,
            lastName: row['lastName'] as String,
            status: row['status'] as String,
            startDate: row['startDate'] as String,
            endDate: row['endDate'] as String,
            subscription: row['subscription'] as String,
            image: row['image'] as String,
            phoneNo: row['phoneNo'] as String));
  }

  @override
  Future<void> deleteAll() async {
    await _queryAdapter.queryNoReturn('Delete FROM users');
  }

  @override
  Future<void> save(Users user) async {
    await _usersInsertionAdapter.insert(user, OnConflictStrategy.replace);
  }
}

class _$UserLevelDao extends UserLevelDao {
  _$UserLevelDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _userLevelInsertionAdapter = InsertionAdapter(
            database,
            'userLevel',
            (UserLevel item) => <String, dynamic>{
                  'points': item.points,
                  'award': item.award,
                  'newPoint': item.newPoint,
                  'level': item.level,
                  'deducted': item.deducted,
                  'userId': item.userId,
                  'badge': item.badge
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<UserLevel> _userLevelInsertionAdapter;

  @override
  Future<UserLevel> findAll() async {
    return _queryAdapter.query('SELECT * FROM userLevel LIMIT 1',
        mapper: (Map<String, dynamic> row) => UserLevel(
            points: row['points'] as String,
            award: row['award'] as String,
            newPoint: row['newPoint'] as String,
            level: row['level'] as String,
            deducted: row['deducted'] as String,
            userId: row['userId'] as int,
            badge: row['badge'] as String));
  }

  @override
  Future<void> deleteAll() async {
    await _queryAdapter.queryNoReturn('Delete FROM userLevel');
  }

  @override
  Future<void> save(UserLevel level) async {
    await _userLevelInsertionAdapter.insert(level, OnConflictStrategy.replace);
  }
}

class _$NotesDao extends NotesDao {
  _$NotesDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _notesInsertionAdapter = InsertionAdapter(
            database,
            'notes',
            (Notes item) => <String, dynamic>{
                  'id': item.id,
                  'time': item.time,
              'course': item.course,
              'courseId': item.courseId,
              'sectionId': item.sectionId,
              'section': item.section,
              'lessonId': item.lessonId,
              'lesson': item.lesson,
              'content': item.content,
              'createdAt': _dateTimeConverter.encode(item.createdAt),
              'updatedAt': _dateTimeConverter.encode(item.updatedAt),
              'noteColor': _colorConverter.encode(item.noteColor),
              'isArchived': item.isArchived == null
                  ? null
                  : (item.isArchived ? 1 : 0),
              'synced': item.synced == null ? null : (item.synced ? 1 : 0)
            });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Notes> _notesInsertionAdapter;

  @override
  Future<List<Notes>> findAll() async {
    return _queryAdapter.queryList('SELECT * FROM notes',
        mapper: (Map<String, dynamic> row) => Notes(
            id: row['id'] as int,
            time: row['time'] as String,
            course: row['course'] as String,
            courseId: row['courseId'] as int,
            sectionId: row['sectionId'] as int,
            section: row['section'] as String,
            lessonId: row['lessonId'] as int,
            lesson: row['lesson'] as String,
            content: row['content'] as String,
            createdAt: _dateTimeConverter.decode(row['createdAt'] as String),
            updatedAt: _dateTimeConverter.decode(row['updatedAt'] as String),
            noteColor: _colorConverter.decode(row['noteColor'] as int),
            isArchived: row['isArchived'] == null
                ? null
                : (row['isArchived'] as int) != 0,
            synced:
            row['synced'] == null ? null : (row['synced'] as int) != 0));
  }

  @override
  Future<List<Notes>> findBySectionId(int sectionId) async {
    return _queryAdapter.queryList('SELECT * FROM notes WHERE sectionId = ?',
        arguments: <dynamic>[sectionId],
        mapper: (Map<String, dynamic> row) => Notes(
            id: row['id'] as int,
            time: row['time'] as String,
            course: row['course'] as String,
            courseId: row['courseId'] as int,
            sectionId: row['sectionId'] as int,
            section: row['section'] as String,
            lessonId: row['lessonId'] as int,
            lesson: row['lesson'] as String,
            content: row['content'] as String,
            createdAt: _dateTimeConverter.decode(row['createdAt'] as String),
            updatedAt: _dateTimeConverter.decode(row['updatedAt'] as String),
            noteColor: _colorConverter.decode(row['noteColor'] as int),
            isArchived: row['isArchived'] == null
                ? null
                : (row['isArchived'] as int) != 0,
            synced:
            row['synced'] == null ? null : (row['synced'] as int) != 0));
  }

  @override
  Future<List<Notes>> findByCourseId(int courseId) async {
    return _queryAdapter.queryList('SELECT * FROM notes WHERE sectionId = ?',
        arguments: <dynamic>[courseId],
        mapper: (Map<String, dynamic> row) => Notes(
            id: row['id'] as int,
            time: row['time'] as String,
            course: row['course'] as String,
            courseId: row['courseId'] as int,
            sectionId: row['sectionId'] as int,
            section: row['section'] as String,
            lessonId: row['lessonId'] as int,
            lesson: row['lesson'] as String,
            content: row['content'] as String,
            createdAt: _dateTimeConverter.decode(row['createdAt'] as String),
            updatedAt: _dateTimeConverter.decode(row['updatedAt'] as String),
            noteColor: _colorConverter.decode(row['noteColor'] as int),
            isArchived: row['isArchived'] == null
                ? null
                : (row['isArchived'] as int) != 0,
            synced:
            row['synced'] == null ? null : (row['synced'] as int) != 0));
  }

  @override
  Future<List<Notes>> findNotSynced() async {
    return _queryAdapter.queryList('SELECT * FROM notes WHERE synced = 0',
        mapper: (Map<String, dynamic> row) =>
            Notes(
                id: row['id'] as int,
                time: row['time'] as String,
                course: row['course'] as String,
                courseId: row['courseId'] as int,
                sectionId: row['sectionId'] as int,
                section: row['section'] as String,
                lessonId: row['lessonId'] as int,
                lesson: row['lesson'] as String,
                content: row['content'] as String,
                createdAt: _dateTimeConverter.decode(
                    row['createdAt'] as String),
                updatedAt: _dateTimeConverter.decode(
                    row['updatedAt'] as String),
                noteColor: _colorConverter.decode(row['noteColor'] as int),
                isArchived: row['isArchived'] == null
                    ? null
                    : (row['isArchived'] as int) != 0,
                synced:
                row['synced'] == null ? null : (row['synced'] as int) != 0));
  }

  @override
  Future<List<Notes>> findByLessonId(int lessonId) async {
    return _queryAdapter.queryList('SELECT * FROM notes WHERE lesson = ?',
        arguments: <dynamic>[lessonId],
        mapper: (Map<String, dynamic> row) =>
            Notes(
                id: row['id'] as int,
                time: row['time'] as String,
                course: row['course'] as String,
            courseId: row['courseId'] as int,
                sectionId: row['sectionId'] as int,
                section: row['section'] as String,
                lessonId: row['lessonId'] as int,
                lesson: row['lesson'] as String,
                content: row['content'] as String,
                createdAt: _dateTimeConverter.decode(
                    row['createdAt'] as String),
                updatedAt: _dateTimeConverter.decode(
                    row['updatedAt'] as String),
                noteColor: _colorConverter.decode(row['noteColor'] as int),
                isArchived: row['isArchived'] == null
                    ? null
                    : (row['isArchived'] as int) != 0,
                synced:
                row['synced'] == null ? null : (row['synced'] as int) != 0));
  }

  @override
  Future<List<Notes>> search(String lesson) async {
    return _queryAdapter.queryList('SELECT * FROM notes WHERE lesson LIKE ?',
        arguments: <dynamic>[lesson],
        mapper: (Map<String, dynamic> row) => Notes(
            id: row['id'] as int,
            time: row['time'] as String,
            course: row['course'] as String,
            courseId: row['courseId'] as int,
            sectionId: row['sectionId'] as int,
            section: row['section'] as String,
            lessonId: row['lessonId'] as int,
            lesson: row['lesson'] as String,
            content: row['content'] as String,
            createdAt: _dateTimeConverter.decode(row['createdAt'] as String),
            updatedAt: _dateTimeConverter.decode(row['updatedAt'] as String),
            noteColor: _colorConverter.decode(row['noteColor'] as int),
            isArchived: row['isArchived'] == null
                ? null
                : (row['isArchived'] as int) != 0,
            synced:
            row['synced'] == null ? null : (row['synced'] as int) != 0));
  }

  @override
  Future<void> deleteAll() async {
    await _queryAdapter.queryNoReturn('Delete FROM notes');
  }

  @override
  Future<void> delete(int id) async {
    await _queryAdapter.queryNoReturn('DELETE FROM notes WHERE id = ?',
        arguments: <dynamic>[id]);
  }

  @override
  Future<int> save(Notes note) {
    return _notesInsertionAdapter.insertAndReturnId(
        note, OnConflictStrategy.replace);
  }

  @override
  Future<int> update(Notes note) {
    return _notesInsertionAdapter.insertAndReturnId(
        note, OnConflictStrategy.replace);
  }
}

class _$LevelLogsDao extends LevelLogsDao {
  _$LevelLogsDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _levelLogsInsertionAdapter = InsertionAdapter(
            database,
            'levelLogs',
            (LevelLogs item) => <String, dynamic>{
                  'userEarningId': item.userEarningId,
                  'title': item.title,
                  'userId': item.userId,
                  'postId': item.postId,
                  'postType': item.postType,
                  'points': item.points,
                  'pointsType': item.pointsType,
                  'date': item.date
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<LevelLogs> _levelLogsInsertionAdapter;

  @override
  Future<List<LevelLogs>> findAll() async {
    return _queryAdapter.queryList('SELECT * FROM levelLogs',
        mapper: (Map<String, dynamic> row) =>
            LevelLogs(
                userEarningId: row['userEarningId'] as int,
                title: row['title'] as String,
                userId: row['userId'] as int,
                postId: row['postId'] as int,
                postType: row['postType'] as String,
                points: row['points'] as int,
                pointsType: row['pointsType'] as String,
                date: row['date'] as String));
  }

  @override
  Future<void> deleteAll() async {
    await _queryAdapter.queryNoReturn('Delete FROM levelLogs');
  }

  @override
  Future<void> save(LevelLogs level) async {
    await _levelLogsInsertionAdapter.insert(level, OnConflictStrategy.replace);
  }

  @override
  Future<void> saveAll(List<LevelLogs> level) async {
    await _levelLogsInsertionAdapter.insertList(
        level, OnConflictStrategy.replace);
  }
}

// ignore_for_file: unused_element
final _dateTimeConverter = DateTimeConverter();
final _colorConverter = ColorConverter();
