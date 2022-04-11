import 'CartModel.dart';

class CartModelList {
  List<CartModel> cartModelList = [];

  CartModelList({required this.cartModelList});

  CartModelList.fromJson(Map<String, dynamic> json) {
    if (json['cartModelList'] != null) {
      cartModelList = [];
      json['cartModelList'].forEach((v) {
        cartModelList.add(new CartModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cartModelList'] = this.cartModelList.map((v) => v.toJson()).toList();
    return data;
  }
}

