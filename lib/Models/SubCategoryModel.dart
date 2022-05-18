class SubCategoryModel {
  String code = "";
  String name = "";
  String? secondName = "";
  String type = "";
  String? image;
  bool isSync = false;
  bool isEnable = true;

  SubCategoryModel({required this.code, required this.name,required this.secondName,required this.image, required this.type, required this.isEnable});

  SubCategoryModel.fromJson(Map<String, dynamic> json) {
    code = json['Code'];
    name = json['name'];
    secondName = json['secondName'];
    image = json['image'];
    type = json['Type'];
    isEnable = json['isEnable']??true;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Code'] = this.code;
    data['name'] = this.name;
    data['secondName'] = this.secondName;
    data['image'] = this.image;
    data['Type'] = this.type;
    data['isSync'] = this.isSync;
    data['isEnable'] = this.isEnable;
    return data;
  }
}

