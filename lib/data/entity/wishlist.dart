class WishList {
  int id;
  String course;
  int courseId;
  int sectionId;
  String section;
  int lessonId;
  String lesson;
  String image;
  bool synced = false;

  WishList(
      {this.id,
      this.course,
      this.courseId,
      this.sectionId,
      this.section,
      this.lessonId,
      this.lesson,
       this.image,
      this.synced});

  WishList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    course = json['course'];
    courseId = json['courseId'];
    sectionId = json['sectionId'];
    section = json['section'];
    lessonId = json['lessonId'];
    lesson = json['lesson'];
    image = json['image'];
    synced = json['isArchived'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['course'] = this.course;
    data['courseId'] = this.courseId;
    data['sectionId'] = this.sectionId;
    data['section'] = this.section;
    data['lessonId'] = this.lessonId;
    data['lesson'] = this.lesson;
    data['image'] = this.image;
    data['synced'] = this.synced;

    return data;
  }
}
