import 'package:floor/floor.dart';

@entity
class Course {
  @primaryKey
  int id;
  String title;
  String duration;
  String students;
  String retake;
  String enrolled;
  String author;
  String description;
  int userId;
  @ignore
  List<Sections> sections;
  String image;
  @ignore
  Instructor instructor;
  @ignore
  List<Comments> comments;
  int subId;
  bool wishList = false;

  Course(
      {this.id,
      this.title,
      this.duration,
      this.students,
      this.retake,
      this.enrolled,
      this.author,
      this.description,
      this.userId,
      this.sections,
      this.image,
      this.instructor,
      this.comments,
      this.subId,
      this.wishList});

  Course.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    duration = json['duration'];
    students = json['students'];
    retake = json['retake'];
    enrolled = json['enrolled'];
    author = json['author'];
    description = json['description'];
    userId = json['userId'];
    if (json['sections'] != null) {
      sections = [];
      json['sections'].forEach((v) {
        sections.add(new Sections.fromJson(v));
      });
    }
    image = json['image'];
    instructor = json['instructor'] != null
        ? new Instructor.fromJson(json['instructor'])
        : null;
    if (json['comments'] != null) {
      comments = [];
      json['comments'].forEach((v) {
        comments.add(new Comments.fromJson(v));
      });
    }
    subId = json['subId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['duration'] = this.duration;
    data['students'] = this.students;
    data['retake'] = this.retake;
    data['enrolled'] = this.enrolled;
    data['author'] = this.author;
    data['description'] = this.description;
    data['userId'] = this.userId;
    if (this.sections != null) {
      data['sections'] = this.sections.map((v) => v.toJson()).toList();
    }
    data['image'] = this.image;
    if (this.instructor != null) {
      data['instructor'] = this.instructor.toJson();
    }
    if (this.comments != null) {
      data['comments'] = this.comments.map((v) => v.toJson()).toList();
    }
    data['subId'] = this.subId;
    data['wishList'] = this.wishList ?? false;
    return data;
  }
}

@Entity(
  tableName: 'sections',
  foreignKeys: [
    ForeignKey(
      childColumns: ['courseId'],
      parentColumns: ['id'],
      entity: Course,
    )
  ],
)
class Sections {
  String sectionName;
  int sectionOrder;
  @primaryKey
  int id;
  int courseId;
  @ignore
  List<Lessons> lessons;

  Sections(
      {this.sectionName, this.sectionOrder, this.id, this.courseId, this.lessons});

  Sections.fromJson(Map<String, dynamic> json) {
    sectionName = json['sectionName'];
    sectionOrder = json['sectionOrder'];
    id = json['id'];
    courseId = json['courseId'];
    if (json['lessons'] != null) {
      lessons = [];
      json['lessons'].forEach((v) {
        lessons.add(new Lessons.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sectionName'] = this.sectionName;
    data['sectionOrder'] = this.sectionOrder;
    data['id'] = this.id;
    data['courseId'] = this.courseId;
    if (this.lessons != null) {
      data['lessons'] = this.lessons.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

@Entity(
  tableName: 'lessons',
  // foreignKeys: [
  //   ForeignKey(
  //     childColumns: ['sectionId'],
  //     parentColumns: ['id'],
  //     entity: Sections,
  //   )
  // ],
)
class Lessons {
  @primaryKey
  int itemId;
  int itemOrder;
  String postTitle;
  int postId;
  int sectionId;
  int courseId;
  String duration;
  String preview;
  bool viewed;
  int quizCount;
  String grade;

  Lessons({this.itemId,
    this.itemOrder,
    this.postTitle,
    this.postId,
    this.sectionId,
    this.courseId,
    this.duration,
    this.preview,
    this.viewed,
    this.quizCount,
    this.grade});

  Lessons.fromJson(Map<String, dynamic> json) {
    itemId = json['itemId'];
    itemOrder = json['itemOrder'];
    postTitle = json['postTitle'];
    postId = json['postId'];
    sectionId = json['sectionId'];
    courseId = json['courseId'];
    duration = json['duration'];
    preview = json['preview'];
    viewed = json['viewed'];
    quizCount = json['quizCount'];
    grade = json['grade'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['itemId'] = this.itemId;
    data['itemOrder'] = this.itemOrder;
    data['postTitle'] = this.postTitle;
    data['postId'] = this.postId;
    data['sectionId'] = this.sectionId;
    data['courseId'] = this.courseId;
    data['duration'] = this.duration;
    data['preview'] = this.preview;
    data['viewed'] = this.viewed;
    data['quizCount'] = this.quizCount;
    data['grade'] = this.grade;
    return data;
  }
}

@DatabaseView(
    'SELECT lessons.postTitle as lesson, lessons.itemId as itemId, sections.sectionName as section, course.title as course FROM lessons INNER JOIN sections ON lessons.sectionId = sections.id INNER JOIN course ON lessons.courseId = course.id',
    viewName: 'lessonSearch')
class LessonSearch {
  int itemId;
  String lesson;
  String section;
  String course;

  LessonSearch({this.itemId,
    this.lesson,
    this.section,
    this.course});

  LessonSearch.fromJson(Map<String, dynamic> json) {
    itemId = json['itemId'];
    lesson = json['lesson'];
    section = json['section'];
    course = json['course'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['itemId'] = this.itemId;
    data['lesson'] = this.lesson;
    data['section'] = this.section;
    data['course'] = this.course;
    return data;
  }
}

@entity
class Instructor {
  @primaryKey
  int userId;
  String email;
  String username;
  String name;
  String description;

  Instructor(
      {this.userId, this.email, this.username, this.name, this.description});

  Instructor.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    email = json['email'];
    username = json['username'];
    name = json['name'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['email'] = this.email;
    data['username'] = this.username;
    data['name'] = this.name;
    data['description'] = this.description;
    return data;
  }
}

@entity
class Comments {
  @primaryKey
  int id;
  String author;
  String email;
  String comment;
  String rating;
  String image;
  int courseId;
  String title;

  Comments(
      {this.id,
      this.author,
      this.email,
      this.comment,
      this.rating,
      this.image,
      this.title});

  Comments.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    author = json['author'];
    email = json['email'];
    comment = json['comment'];
    rating = json['rating'];
    image = json['image'];
    courseId = json['courseId'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['author'] = this.author;
    data['email'] = this.email;
    data['comment'] = this.comment;
    data['rating'] = this.rating;
    data['image'] = this.image;
    data['courseId'] = this.courseId;
    data['title'] = this.title;
    return data;
  }
}

@entity
class Testimonial {
  @primaryKey
  int id;
  String title;
  String content;
  String name;
  String image;

  Testimonial({this.id, this.title, this.content, this.name, this.image});

  Testimonial.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    content = json['content'];
    name = json['name'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['content'] = this.content;
    data['name'] = this.name;
    data['image'] = this.image;
    return data;
  }
}

class Questions {
  String postTitle;
  @primaryKey
  int postId;
  String mark;
  String type;
  int questionId;
  int order;
  String itemId;
  List<QuizOptions> options;

  Questions({this.postTitle,
    this.postId,
    this.mark,
    this.type,
    this.questionId,
    this.order,
    this.itemId,
    this.options});

  Questions.fromJson(Map<String, dynamic> json) {
    postTitle = json['postTitle'];
    postId = json['postId'];
    mark = json['mark'];
    type = json['type'];
    questionId = json['questionId'];
    order = json['order'];
    itemId = json['itemId'];
    if (json['options'] != null) {
      options = [];
      json['options'].forEach((v) {
        options.add(new QuizOptions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['postTitle'] = this.postTitle;
    data['postId'] = this.postId;
    data['mark'] = this.mark;
    data['type'] = this.type;
    data['questionId'] = this.questionId;
    data['order'] = this.order;
    data['itemId'] = this.itemId;
    if (this.options != null) {
      data['options'] = this.options.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class QuizOptions {
  @primaryKey
  int id;
  int order;
  OptionsData data;

  QuizOptions({this.order, this.data});

  QuizOptions.fromJson(Map<String, dynamic> json) {
    order = json['order'];
    data = json['data'] != null ? new OptionsData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order'] = this.order;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class OptionsData {
  @primaryKey
  int id;
  String text;
  String value;
  String isTrue;

  OptionsData({this.text, this.value, this.isTrue});

  OptionsData.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    value = json['value'];
    isTrue = json['is_true'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['text'] = this.text;
    data['value'] = this.value;
    data['is_true'] = this.isTrue;
    return data;
  }
}

class ViewedCourses {
  @primaryKey
  int userItemId;
  int userId;
  int itemId;
  String startTime;
  String startTimeGmt;
  String endTime;
  String endTimeGmt;
  String itemType;
  String status;
  int refId;
  String refType;
  int parentId;
  int sectionId;
  String grade;

  ViewedCourses({
    this.userItemId,
    this.userId,
    this.itemId,
    this.startTime,
    this.startTimeGmt,
    this.endTime,
    this.endTimeGmt,
    this.itemType,
    this.status,
    this.refId,
    this.refType,
    this.parentId,
    this.sectionId,
    this.grade,
  });

  ViewedCourses.fromJson(Map<String, dynamic> json) {
    userItemId = json['user_item_id'];
    userId = json['user_id'];
    itemId = json['item_id'];
    startTime = json['start_time'];
    startTimeGmt = json['start_time_gmt'];
    endTime = json['end_time'];
    endTimeGmt = json['end_time_gmt'];
    itemType = json['item_type'];
    status = json['status'];
    refId = json['ref_id'];
    refType = json['ref_type'];
    parentId = json['parent_id'];
    parentId = json['sectionId'];
    parentId = json['grade'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_item_id'] = this.userItemId;
    data['user_id'] = this.userId;
    data['item_id'] = this.itemId;
    data['start_time'] = this.startTime;
    data['start_time_gmt'] = this.startTimeGmt;
    data['end_time'] = this.endTime;
    data['end_time_gmt'] = this.endTimeGmt;
    data['item_type'] = this.itemType;
    data['status'] = this.status;
    data['ref_id'] = this.refId;
    data['ref_type'] = this.refType;
    data['parent_id'] = this.parentId;
    data['sectionId'] = this.parentId;
    data['grade'] = this.parentId;
    return data;
  }
}
