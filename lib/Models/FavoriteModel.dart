import 'ItemModel.dart';

class FavoriteModel {
  String userId = "";
  List<ItemModel> products = [];

  FavoriteModel(
      {required this.userId,
        required this.products});

  FavoriteModel.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
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
    data['products'] = this.products.map((v) => v.toJson()).toList();
    return data;
  }
}