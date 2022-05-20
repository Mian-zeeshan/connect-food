class BlogModel {
  String title = "";
  String bid = "";
  String body = "";
  String image = "";
  int timestamp = 0;
  bool active = true;

  BlogModel({required this.title,required this.image, required this.bid, required this.body, required this.timestamp, required this.active});

  BlogModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    bid = json['bid'];
    image = json['image'];
    body = json['body'];
    timestamp = json['timestamp'];
    active = json['active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['bid'] = this.bid;
    data['image'] = this.image;
    data['body'] = this.body;
    data['timestamp'] = this.timestamp;
    data['active'] = this.active;
    return data;
  }
}

