import 'FavoriteModel.dart';

class FavoriteModelList {
  List<FavoriteModel> favoriteModelList = [];

  FavoriteModelList({required this.favoriteModelList});

  FavoriteModelList.fromJson(Map<String, dynamic> json) {
    if (json['favoriteModelList'] != null) {
      favoriteModelList = [];
      json['favoriteModelList'].forEach((v) {
        favoriteModelList.add(new FavoriteModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['favoriteModelList'] = this.favoriteModelList.map((v) => v.toJson()).toList();
    return data;
  }
}

