import 'dart:ui';

import 'package:floor/floor.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

@Entity(tableName: 'notes')
class Notes {
  @primaryKey
  int id;
  String time;
  String course;
  int courseId;
  int sectionId;
  String section;
  int lessonId;
  String lesson;
  String content;
  DateTime createdAt;
  DateTime updatedAt;
  Color noteColor;
  bool isArchived = false;
  bool synced = false;

  Notes(
      {this.id,
      this.time,
      this.course,
      this.courseId,
      this.sectionId,
      this.section,
      this.lessonId,
      this.lesson,
      this.content,
      this.createdAt,
      this.updatedAt,
      this.noteColor,
      this.isArchived,
      this.synced});

  Notes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    time = json['time'];
    course = json['course'];
    courseId = json['courseId'];
    sectionId = json['sectionId'];
    section = json['section'];
    lessonId = json['lessonId'];
    lesson = json['lesson'];
    content = json['content'];
    createdAt = new DateFormat("yyyy-MM-dd hh:mm:ss").parse(json['createdAt']);
    updatedAt = new DateFormat("yyyy-MM-dd hh:mm:ss").parse(json['updatedAt']);
    noteColor = json['noteColor'] != null ? Color(json['noteColor']) : null;
    isArchived = json['isArchived'];
    synced = json['isArchived'];
  }

  Map<String, dynamic> toJson(bool update) {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (update) {
      data['id'] = this.id;
    }
    data['time'] = this.time;
    data['course'] = this.course;
    data['courseId'] = this.courseId;
    data['sectionId'] = this.sectionId;
    data['section'] = this.section;
    data['lessonId'] = this.lessonId;
    data['lesson'] = this.lesson;
    data['content'] = this.content;
    data['createdAt'] =
        DateFormat("yyyy-MM-dd hh:mm:ss").format(this.createdAt);
    data['updatedAt'] =
        DateFormat("yyyy-MM-dd hh:mm:ss").format(this.updatedAt);
    data['noteColor'] =
    this.noteColor == null ? Colors.white.value : this.noteColor.value;
    data['isArchived'] = this.isArchived;
    data['synced'] = this.synced;
    return data;
  }
}

class DateTimeConverter extends TypeConverter<DateTime, String> {
  @override
  DateTime decode(String databaseValue) {
    return new DateFormat("yyyy-MM-dd hh:mm:ss").parse(databaseValue);
  }

  @override
  String encode(DateTime value) {
    return DateFormat("yyyy-MM-dd hh:mm:ss").format(value);
  }
}

class ColorConverter extends TypeConverter<Color, int> {
  @override
  Color decode(int databaseValue) {
    return new Color(databaseValue);
  }

  @override
  int encode(Color value) {
    return value == null ? Colors.white.value : value.value;
  }
}

class CentralStation {
  static bool _updateNeeded;

  static final fontColor = Color(0xff595959);
  static final borderColor = Color(0xffd3d3d3);

  static init() {
    if (_updateNeeded == null) _updateNeeded = true;
  }

  static bool get updateNeeded {
    init();
    if (_updateNeeded) {
      return true;
    } else {
      return false;
    }
  }

  static set updateNeeded(value) {
    _updateNeeded = value;
  }
}
