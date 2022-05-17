import 'package:connectsaleorder/Models/AddressModel.dart';
import 'package:connectsaleorder/Models/RetailerModel.dart';

class UserModel {
  String uid = "";
  String name = "";
  String email = "";
  String phone = "";
  String? image;
  int type = 1;
  List<AddressModel> addressList = [];
  String? defaultAddressId;
  bool isRetailer = false;
  RetailerModel? retailerModel;

  UserModel({required this.uid, required this.name, required this.email, required this.phone, required this.type});

  UserModel.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    image = json['image'];
    if(json["type"] != null)
      type = json['type'];

    if(json["addressList"] != null){
      addressList = [];
      json["addressList"].forEach((v){
        addressList.add(AddressModel.fromJson(v));
      });
    }

    retailerModel = json['retailerModel'] != null
        ? new RetailerModel.fromJson(json['retailerModel'])
        : null;

    if(json["defaultAddressId"] != null){
      defaultAddressId = json["defaultAddressId"];
    }
    if(json["isRetailer"] != null){
      isRetailer = json["isRetailer"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uid'] = this.uid;
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['image'] = this.image;
    data['type'] = this.type;
    data['defaultAddressId'] = this.defaultAddressId;
    data['isRetailer'] = this.isRetailer;
    if(this.retailerModel != null) {
      data['retailerModel'] = this.retailerModel!.toJson();
    }
    data['addressList'] = this.addressList.map((v) => v.toJson()).toList();
    return data;
  }

  Map<String, dynamic> toJsonAddresses() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['addressList'] = this.addressList.map((v) => v.toJson()).toList();
    return data;
  }

  Map<String, dynamic> toJsonRetailer() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['retailerModel'] = this.retailerModel!.toJson();
    return data;
  }
}

