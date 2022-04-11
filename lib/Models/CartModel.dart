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
  bool isSync = false;
  int status = 0;
  bool? isRetailer = false;
  double deliveryPrice = 0;

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
    isSync = json['isSync'];
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
    data['totalBill'] = this.totalBill;
    data['discountedBill'] = this.discountedBill;
    data['total_Items'] = this.totalItems;
    data['createdAt'] = this.createdAt;
    data['discount'] = this.discount;
    data['amountPaid'] = this.amountPaid;
    data['paymentMethod'] = this.paymentMethod;
    data['isDraft'] = this.isDraft;
    data["deliveryPrice"] = this.deliveryPrice;
    data['isSync'] = this.isSync;
    data['products'] = this.products.map((v) => v.toJson()).toList();
    return data;
  }
}