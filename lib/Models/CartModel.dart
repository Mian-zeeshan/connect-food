import 'package:connectsaleorder/Models/AddressModel.dart';
import 'package:connectsaleorder/Models/CustomerModel.dart';

import 'ItemModel.dart';

class CartModel {
  String userId = "";
  String cartId = "";
  double totalBill = 0;
  double discountedBill = 0;
  int totalItems = 0;
  int createdAt = 0;
  int discount = 0;
  bool isDraft = false;
  List<ItemModel> products = [];
  CustomerModel? customer;
  int amountPaid = 0;
  String? paymentMethod;
  String? instructions;
  bool isSync = false;
  int status = 0;
  bool? isRetailer = false;
  double deliveryPrice = 0;
  int orderType = 1;
  double couponValue = 0;
  AddressModel? branch;

  CartModel(
      {required this.userId,
        required this.totalBill,
        required this.totalItems,
        required this.createdAt,
        required this.status,
        required this.products});

  CartModel.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    cartId = json['cartId'];
    if(json["isRetailer"] != null)
      isRetailer = json['isRetailer'];
    if(json['customer'] != null)
      customer = CustomerModel.fromJson(json['customer']);
    if(json['branch'] != null)
      branch = AddressModel.fromJson(json['branch']);
    if(json['status'] != null)
      status = json['status'];
    totalBill = json['totalBill'].toDouble();
    discountedBill = json['discountedBill'].toDouble();
    totalItems = json['total_Items'];
    createdAt = json['createdAt'];
    discount = json['discount'];
    amountPaid = json['amountPaid'];
    paymentMethod = json['paymentMethod'];
    isDraft = json['isDraft'];
    instructions = json['instructions'];
    isSync = json['isSync'];
    if(json["orderType"] != null)
    orderType = json['orderType'];

    if(json["couponValue"] != null)
      couponValue = json['couponValue'].toDouble();
    deliveryPrice = (json["deliveryPrice"]??0).toDouble();
    if (json['products'] != null) {
      products = [];
      json['products'].forEach((v) {
        products.add(new ItemModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['cartId'] = this.cartId;
    data['status'] = this.status;
    data['isRetailer'] = this.isRetailer;
    if(this.customer != null)
    data['customer'] = this.customer!.toJson();
    if(this.branch != null)
    data['branch'] = this.branch!.toJson();
    data['totalBill'] = this.totalBill;
    data['discountedBill'] = this.discountedBill;
    data['total_Items'] = this.totalItems;
    data['createdAt'] = this.createdAt;
    data['discount'] = this.discount;
    data['amountPaid'] = this.amountPaid;
    data['paymentMethod'] = this.paymentMethod;
    data['isDraft'] = this.isDraft;
    data["deliveryPrice"] = this.deliveryPrice;
    data["instructions"] = this.instructions;
    data['isSync'] = this.isSync;
    data['orderType'] = this.orderType;
    data['couponValue'] = this.couponValue;
    data['products'] = this.products.map((v) => v.toJson()).toList();
    return data;
  }
}