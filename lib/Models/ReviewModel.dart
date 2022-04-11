class ReviewModel {
  String name = "";
  String uid = "";
  String image = "";
  String key = "";
  int createdAt = 0;
  double rating = 0;
  String? comment;

  ReviewModel(
      {required this.name,
        required this.uid,
        required this.image,
        required this.key,
        required this.createdAt,
        required this.rating,
        this.comment});

  ReviewModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    uid = json['uid'];
    image = json['image'];
    key = json['key'];
    createdAt = json['createdAt'];
    rating = json['rating'].toDouble();
    comment = json['comment'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['uid'] = this.uid;
    data['image'] = this.image;
    data['key'] = this.key;
    data['createdAt'] = this.createdAt;
    data['rating'] = this.rating;
    data['comment'] = this.comment;
    return data;
  }
}

