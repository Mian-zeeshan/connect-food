class BrandModel {
  String code = "";
  String name = "";
  String? secondName = "";
  String? image;

  BrandModel({required this.code, required this.name, required this.image, required this.secondName});

  BrandModel.fromJson(Map<String, dynamic> json) {
    code = json['Code'];
    name = json['name'];
    secondName = json['secondName'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Code'] = this.code;
    data['name'] = this.name;
    data['secondName'] = this.secondName;
    data['image'] = this.image;
    return data;
  }
}

