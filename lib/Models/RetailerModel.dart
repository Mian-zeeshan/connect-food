class RetailerModel {
  String shopName = "";
  String phone = "";
  String city = "";
  String country = "";
  String area = "";
  String province = "";
  String address = "";
  int createdAt = 0;
  int updatedAt = 0;
  String contactPerson = "";
  String contactPersonPhone = "";
  bool approved = false;

  RetailerModel(
      {required this.shopName,
        required this.phone,
        required this.city,
        required this.country,
        required this.area,
        required this.province,
        required this.address,
        required this.updatedAt,
        required this.createdAt,
        required this.contactPerson,
        required this.contactPersonPhone,
        required this.approved});

  RetailerModel.fromJson(Map<String, dynamic> json) {
    shopName = json['shop_name'];
    phone = json['phone'];
    city = json['city'];
    country = json['country'];
    area = json['area'];
    province = json['province'];
    address = json['address'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    contactPerson = json['contact_person'];
    contactPersonPhone = json['contact_person_phone'];
    approved = json['approved'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['shop_name'] = this.shopName;
    data['phone'] = this.phone;
    data['city'] = this.city;
    data['country'] = this.country;
    data['area'] = this.area;
    data['province'] = this.province;
    data['address'] = this.address;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['contact_person'] = this.contactPerson;
    data['contact_person_phone'] = this.contactPersonPhone;
    data['approved'] = this.approved;
    return data;
  }
}

