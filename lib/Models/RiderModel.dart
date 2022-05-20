class RiderModel {
  String uid = "";
  String name = "";
  String email = "";
  String phone = "";
  String cnic = "";
  String password = "";
  String address = "";
  String? image;

  RiderModel({required this.uid, required this.name, required this.email, required this.phone,required this.address, required this.password, required this.cnic});

  RiderModel.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    password = json['password'];
    image = json['image'];
    address = json['address']??"";
    cnic = json['cnic']??"";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uid'] = this.uid;
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['password'] = this.password;
    data['image'] = this.image;
    data['cnic'] = this.cnic;
    data['address'] = this.address;
    return data;
  }

}

