import 'package:floor/floor.dart';

@Entity(tableName: 'users')
class Users {
  @primaryKey
  int id;
  String email;
  String username;
  @ignore
  String password;
  String name;
  String firstName;
  String lastName;
  String status;
  String startDate;
  String endDate;
  String subscription;
  String image;
  String phoneNo;

  Users(
      {this.id,
      this.email,
      this.username,
      this.password,
      this.name,
      this.firstName,
      this.lastName,
      this.status,
      this.startDate,
      this.endDate,
      this.subscription,
      this.image,
      this.phoneNo});

  Users.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    username = json['username'];
    password = json['password'];
    name = json['name'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    status = json['status'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    subscription = json['subscription'];
    image = json['image'];
    phoneNo = json['phoneNo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['email'] = this.email;
    data['username'] = this.username;
    data['password'] = this.username;
    data['name'] = this.name;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['status'] = this.status;
    data['startDate'] = this.startDate;
    data['endDate'] = this.endDate;
    data['subscription'] = this.subscription;
    data['image'] = this.image;
    data['phoneNo'] = this.phoneNo;
    return data;
  }
}

@Entity(tableName: 'userLevel')
class UserLevel {
  String points;
  String award;
  String newPoint;
  String level;
  String deducted;
  @primaryKey
  int userId;
  String badge;
  @ignore
  List<LevelLogs> logs;

  UserLevel(
      {this.points,
      this.award,
      this.newPoint,
      this.level,
      this.deducted,
      this.userId,
      this.badge,
      this.logs});

  UserLevel.fromJson(Map<String, dynamic> json) {
    points = json['points'].toString();
    award = json['award'].toString();
    newPoint = json['newPoint'].toString();
    level = json['level'].toString();
    deducted = json['deducted'].toString();
    userId = json['userId'];
    badge = json['badge'];
    if (json['logs'] != null) {
      logs = [];
      json['logs'].forEach((v) {
        logs.add(new LevelLogs.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['points'] = this.points;
    data['award'] = this.award;
    data['newPoint'] = this.newPoint;
    data['level'] = this.level;
    data['deducted'] = this.deducted;
    data['userId'] = this.userId;
    data['badge'] = this.badge;
    if (this.logs != null) {
      data['logs'] = this.logs.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

@Entity(tableName: 'levelLogs')
class LevelLogs {
  @primaryKey
  int userEarningId;
  String title;
  int userId;
  int postId;
  String postType;
  int points;
  String pointsType;
  String date;

  LevelLogs({this.userEarningId,
    this.title,
    this.userId,
    this.postId,
    this.postType,
    this.points,
    this.pointsType,
    this.date});

  LevelLogs.fromJson(Map<String, dynamic> json) {
    userEarningId = json['user_earning_id'];
    title = json['title'];
    userId = json['user_id'];
    postId = json['post_id'];
    postType = json['post_type'];
    points = json['points'];
    pointsType = json['points_type'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_earning_id'] = this.userEarningId;
    data['title'] = this.title;
    data['user_id'] = this.userId;
    data['post_id'] = this.postId;
    data['post_type'] = this.postType;
    data['points'] = this.points;
    data['points_type'] = this.pointsType;
    data['date'] = this.date;
    return data;
  }
}
