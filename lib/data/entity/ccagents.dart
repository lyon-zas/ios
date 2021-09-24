class Agents {
  String name;
  String title;
  String available;
  String image;
  String number;

  Agents({this.name, this.title, this.available, this.image, this.number});

  Agents.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    title = json['title'];
    available = json['available'];
    image = json['image'];
    number = json['number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['title'] = this.title;
    data['available'] = this.available;
    data['image'] = this.image;
    data['number'] = this.number;
    return data;
  }
}