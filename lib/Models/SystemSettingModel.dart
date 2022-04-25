import 'dart:ui';

import 'package:connectsaleorder/Models/CountriesModel.dart';

import 'AddressModel.dart';

class SystemSettingModel {
  List<Languages> languages = [];
  Languages itemGridStyle = Languages(code: "001" , name: "default");
  Languages itemListStyle = Languages(code: "001" , name: "default");
  List<AddressModel> branches = [];
  CountriesModel? defaultCountry;
  int maxDeliveryPrice = 100;
  BottomNavigationChecks bottomNavigationChecks = BottomNavigationChecks(isCart: false, isCategories: true, isDeals: true, isFavorite: false, isOrders: false, isProducts: true , bottomStyle: 0);
  Color mainColor = Color(0xFF6e9040);
  String companyLogo = "https://connect-sol.com/wp-content/uploads/2019/10/logo-1-1.png";
  String color = "";
  int categoryView = 0;
  bool dineIn = false;

  SystemSettingModel(
      {required this.languages,
        required this.itemGridStyle,
        required this.itemListStyle,
        required this.mainColor,
        required this.companyLogo,
        required this.categoryView,
        required this.maxDeliveryPrice,
        required this.bottomNavigationChecks});

  SystemSettingModel.fromJson(Map<String, dynamic> json) {
    if (json['languages'] != null) {
      languages = [];
      json['languages'].forEach((v) {
        languages.add(new Languages.fromJson(v));
      });
    }
    if(json["categoryView"] != null) {
      categoryView = json["categoryView"];
    }

    if(json["maxDeliveryPrice"] != null) {
      maxDeliveryPrice = json["maxDeliveryPrice"];
    }

    if(json["companyLogo"] != null) {
      companyLogo = json["companyLogo"];
    }
    if(json["color"] != null) {
      color = json["color"];
    }else{
      color = "Color(0xFF6e9040)";
    }

    if(json["dineIn"] != null) {
      dineIn = json["dineIn"];
    }


    if(json["branches"] != null){
      branches = [];
      json["branches"].forEach((v){
        branches.add(AddressModel.fromJson(v));
      });
    }

    String valueString = color.split('(0x')[1].split(')')[0]; // kind of hacky..
    int value = int.parse(valueString, radix: 16);
    mainColor = new Color(value);
    itemGridStyle = json['itemGridStyle'] != null
        ? new Languages.fromJson(json['itemGridStyle'])
        : Languages(code: "001" , name: "default");;
    itemListStyle = json['itemListStyle'] != null
        ? new Languages.fromJson(json['itemListStyle'])
        : Languages(code: "001" , name: "default");;
    bottomNavigationChecks = json['bottomNavigationChecks'] != null
        ? new BottomNavigationChecks.fromJson(json['bottomNavigationChecks'])
        : BottomNavigationChecks(isCart: false, isCategories: true, isDeals: true, isFavorite: false, isOrders: false, isProducts: true, bottomStyle: 0);

    defaultCountry = json['defaultCountry'] != null
        ? new CountriesModel.fromJson(json['defaultCountry'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['languages'] = this.languages.map((v) => v.toJson()).toList();
    data['itemGridStyle'] = this.itemGridStyle.toJson();
    data['itemListStyle'] = this.itemListStyle.toJson();
    data['bottomNavigationChecks'] = this.bottomNavigationChecks.toJson();
    if(defaultCountry != null)
    data['defaultCountry'] = this.defaultCountry!.toJson();
    data["color"] = mainColor.toString();
    data["companyLogo"] = companyLogo;
    data["categoryView"] = categoryView;
    data["maxDeliveryPrice"] = maxDeliveryPrice;
    data["dineIn"] = dineIn;
    data['branches'] = this.branches.map((v) => v.toJson()).toList();
    return data;
  }


  Map<String, dynamic> toJsonBranches() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['branches'] = this.branches.map((v) => v.toJson()).toList();
    return data;
  }

}

class Languages {
  String code = "";
  String name = "";
  bool isSelected = false;

  Languages({required this.code, required this.name});

  Languages.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    name = json['name'];
    if(json["isSelected"] != null)
      isSelected = json['isSelected'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['name'] = this.name;
    data['isSelected'] = this.isSelected;
    return data;
  }
}

class BottomNavigationChecks {
  bool isCategories = true;
  bool isProducts = true;
  bool isDeals = true;
  bool isOrders = false;
  bool isCart = false;
  bool isFavorite = false;
  int bottomStyle = 0;

  BottomNavigationChecks(
      {required this.isCategories,
        required this.isProducts,
        required this.isDeals,
        required this.isOrders,
        required this.isCart,
        required this.bottomStyle,
        required this.isFavorite});

  BottomNavigationChecks.fromJson(Map<String, dynamic> json) {
    isCategories = json['isCategories'];
    isProducts = json['isProducts'];
    isDeals = json['isDeals'];
    isOrders = json['isOrders'];
    isCart = json['isCart'];
    isFavorite = json['isFavorite'];
    if(json['bottomStyle'] != null)
      bottomStyle = json['bottomStyle'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isCategories'] = this.isCategories;
    data['isProducts'] = this.isProducts;
    data['isDeals'] = this.isDeals;
    data['isOrders'] = this.isOrders;
    data['isCart'] = this.isCart;
    data['isFavorite'] = this.isFavorite;
    data['bottomStyle'] = this.bottomStyle;
    return data;
  }
}

