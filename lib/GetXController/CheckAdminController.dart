import 'dart:convert';

import 'package:connectsaleorder/AppConstants/Constants.dart';
import 'package:connectsaleorder/Models/CountriesModel.dart';
import 'package:connectsaleorder/Models/SystemSettingModel.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class CheckAdminController extends GetxController{
  String isAdmin = "0";
  var box = GetStorage();
  SystemSettingModel system = SystemSettingModel(maxDeliveryPrice : 100,categoryView: 0 ,companyLogo: "https://connect-sol.com/wp-content/uploads/2019/10/logo-1-1.png",languages: [], itemGridStyle: Languages(code: "001" , name: "default"), itemListStyle: Languages(code: "001" , name: "default"), bottomNavigationChecks: BottomNavigationChecks(isCart: false, bottomStyle: 0, isProducts: true, isCategories: true, isFavorite: false, isDeals: true, isOrders: false) , mainColor: Color(0xFF6e9040));


  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getAdmin();
    getSystem();
  }

  void getAdmin() async {
    String? admin = box.read(isAdminGlobal);
    if(admin == null){
      isAdmin = "0";
      await box.write(isAdminGlobal, "0");
    }else{
      isAdmin = admin;
    }
    update(["0"]);
    notifyChildrens();
  }

  void updateAdmin(isAdmin) async {
    this.isAdmin = isAdmin;
    await box.write(isAdminGlobal, this.isAdmin);
    update(["0"]);
    notifyChildrens();
  }

  void getSystem() {
    FirebaseDatabase database = FirebaseDatabase(databaseURL: databaseUrl);
    
    if(!GetPlatform.isWeb) {
      database.setPersistenceEnabled(true);
      database.setPersistenceCacheSizeBytes(10000000);
    }
    DatabaseReference reference = database.reference();
    reference
        .child(systemRef)
        .onValue.listen((event) {
      if(event.snapshot.exists){
        system = SystemSettingModel.fromJson(jsonDecode(jsonEncode(event.snapshot.value)));
        print("SYSTEM :: ${system.toJson().toString()}");
        update(["0"]);
        notifyChildrens();
      }
    });
  }

  void updateLanguages(List<Languages> languages) {
    system.languages = languages;
    FirebaseDatabase database = FirebaseDatabase(databaseURL: databaseUrl);
    
    if(!GetPlatform.isWeb) {
      database.setPersistenceEnabled(true);
      database.setPersistenceCacheSizeBytes(10000000);
    }
    DatabaseReference reference = database.reference();
    reference
        .child(systemRef)
        .update(system.toJson());
  }

  void updateItemGridStyle(Languages languages) {
    system.itemGridStyle = languages;
    FirebaseDatabase database = FirebaseDatabase(databaseURL: databaseUrl);
    
    if(!GetPlatform.isWeb) {
      database.setPersistenceEnabled(true);
      database.setPersistenceCacheSizeBytes(10000000);
    }
    DatabaseReference reference = database.reference();
    reference
        .child(systemRef)
        .update(system.toJson());
  }

  void updateItemListStyle(Languages languages) {
    system.itemListStyle = languages;
    FirebaseDatabase database = FirebaseDatabase(databaseURL: databaseUrl);
    
    if(!GetPlatform.isWeb) {
      database.setPersistenceEnabled(true);
      database.setPersistenceCacheSizeBytes(10000000);
    }
    DatabaseReference reference = database.reference();
    reference
        .child(systemRef)
        .update(system.toJson());
  }

  void updateBottomNav(BottomNavigationChecks bottomNavigationChecks) {
    system.bottomNavigationChecks = bottomNavigationChecks;
    FirebaseDatabase database = FirebaseDatabase(databaseURL: databaseUrl);
    
    if(!GetPlatform.isWeb) {
      database.setPersistenceEnabled(true);
      database.setPersistenceCacheSizeBytes(10000000);
    }
    DatabaseReference reference = database.reference();
    reference
        .child(systemRef)
        .update(system.toJson());
  }

  void updateColor(Color pickedColor) {
    system.color = pickedColor.toString();
    system.mainColor = pickedColor;
    FirebaseDatabase database = FirebaseDatabase(databaseURL: databaseUrl);
    
    if(!GetPlatform.isWeb) {
      database.setPersistenceEnabled(true);
      database.setPersistenceCacheSizeBytes(10000000);
    }
    DatabaseReference reference = database.reference();
    reference
        .child(systemRef)
        .update(system.toJson());
  }

  void updateLogo(String logo) {
    system.companyLogo = logo;
    FirebaseDatabase database = FirebaseDatabase(databaseURL: databaseUrl);
    
    if(!GetPlatform.isWeb) {
      database.setPersistenceEnabled(true);
      database.setPersistenceCacheSizeBytes(10000000);
    }
    DatabaseReference reference = database.reference();
    reference
        .child(systemRef)
        .update(system.toJson());
  }

  void updateCategory(int categoryView) {
    system.categoryView = categoryView;
    FirebaseDatabase database = FirebaseDatabase(databaseURL: databaseUrl);
    
    if(!GetPlatform.isWeb) {
      database.setPersistenceEnabled(true);
      database.setPersistenceCacheSizeBytes(10000000);
    }
    DatabaseReference reference = database.reference();
    reference
        .child(systemRef)
        .update(system.toJson());
  }

  Future<bool> setSystemCountries(CountriesModel data) async {
    system.defaultCountry = data;
    FirebaseDatabase database = FirebaseDatabase(databaseURL: databaseUrl);
    
    if(!GetPlatform.isWeb) {
      database.setPersistenceEnabled(true);
      database.setPersistenceCacheSizeBytes(10000000);
    }
    DatabaseReference reference = database.reference();
    await reference
        .child(systemRef)
        .update(system.toJson());

    return true;
  }

  Future<bool> setMaxDelivery(int price) async {
    system.maxDeliveryPrice = price;
    FirebaseDatabase database = FirebaseDatabase(databaseURL: databaseUrl);
    
    if(!GetPlatform.isWeb) {
      database.setPersistenceEnabled(true);
      database.setPersistenceCacheSizeBytes(10000000);
    }
    DatabaseReference reference = database.reference();
    await reference
        .child(systemRef)
        .update(system.toJson());

    return true;
  }

  void updateDine(bool dineIn) async {
    system.dineIn = dineIn;
    FirebaseDatabase database = FirebaseDatabase(databaseURL: databaseUrl);

    if(!GetPlatform.isWeb) {
      database.setPersistenceEnabled(true);
      database.setPersistenceCacheSizeBytes(10000000);
    }
    DatabaseReference reference = database.reference();
    await reference
        .child(systemRef)
        .update(system.toJson());
    update(["0"]);
    notifyChildrens();
  }

}