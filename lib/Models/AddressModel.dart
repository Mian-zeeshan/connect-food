class AddressModel {
  String id = "";
  int createdAt = DateTime.now().millisecondsSinceEpoch;
  int updatedAt = DateTime.now().millisecondsSinceEpoch;
  String title = "";
  String fullName = "";
  String mobile = "";
  String province = "";
  String city = "";
  String country = "";
  String address = "";
  String area = "";
  var selected = false;
  double lat = -1;
  double lng = -1;

  AddressModel(
      {required this.id,
        required this.createdAt,
        required this.updatedAt,
        required this.title,
        required this.fullName,
        required this.mobile,
        required this.province,
        required this.city,
        required this.country,
        required this.area,
        required this.address,
        required this.lat,
        required this.lng});

  AddressModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    title = json['title'];
    fullName = json['full_name'];
    mobile = json['mobile'];
    province = json['province'];
    city = json['city'];
    country = json['country'];
    address = json['address'];
    area = json['area'];
    if(json['lat'] != null)
    lat = json['lat'];
    if(json['lng'] != null)
    lng = json['lng'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['title'] = this.title;
    data['full_name'] = this.fullName;
    data['mobile'] = this.mobile;
    data['province'] = this.province;
    data['city'] = this.city;
    data['country'] = this.country;
    data['address'] = this.address;
    data['selected'] = this.selected;
    data['area'] = this.area;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    return data;
  }
}