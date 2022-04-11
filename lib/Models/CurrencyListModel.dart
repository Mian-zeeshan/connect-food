import 'CurrencyModel.dart';

class CurrencyListModel {
  List<CurrencyModel> country = [];

  CurrencyListModel({required this.country});

  CurrencyListModel.fromJson(Map<String, dynamic> json) {
    if (json['country'] != null) {
      country = [];
      json['country'].forEach((v) {
        country.add(new CurrencyModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
      data['country'] = this.country.map((v) => v.toJson()).toList();
    return data;
  }
}

