class BannerModel {
  String image = "";
  String key = "";
  String categoryId = "";

  BannerModel({required this.image, required this.key, required this.categoryId});

  BannerModel.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    key = json['key'];
    categoryId = json['categoryId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = this.image;
    data['key'] = this.key;
    data['categoryId'] = this.categoryId;
    return data;
  }
}

