import 'dart:convert';

import 'package:connectsaleorder/AppConstants/Constants.dart';
import 'package:connectsaleorder/Models/BrandModel.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';

import 'ItemController.dart';

class BrandController extends GetxController{
  List<BrandModel> brands = [];
  List<BrandModel> filterBrands = [];
  int selectedBrand = -1;
  ItemController itemController = Get.find();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getBrands();
  }

  void getBrands() {
    FirebaseDatabase database = FirebaseDatabase(databaseURL: databaseUrl);
    
    if(!GetPlatform.isWeb) {
      database.setPersistenceEnabled(true);
      database.setPersistenceCacheSizeBytes(10000000);
    }
    DatabaseReference reference = database.reference();
    reference
        .child(brandRef)
        .onValue.listen((event) {
      brands = [];
      filterBrands = [];
      if(event.snapshot.exists){
        event.snapshot.value.forEach((key,value){
          BrandModel brandModel = BrandModel.fromJson(jsonDecode(jsonEncode(value)));
          brands.add(brandModel);
          filterBrands.add(brandModel);
        });
      }
      update(["0"]);
      notifyChildrens();
    });
  }

  updateBrand(String code){
    for(var i = 0; i < brands.length; i++){
      if(brands[i].code == code){
        selectedBrand = i;
        break;
      }
    }
    if(selectedBrand != -1)
     itemController.updateProducts(brands[selectedBrand]);
    update(["0"]);
    notifyChildrens();
  }

  filterBrand(String name){
    filterBrands = [];
    for(var i = 0; i < brands.length; i++){
      if(brands[i].name.toLowerCase().contains(name.toLowerCase())){
        filterBrands.add(brands[i]);
      }
    }
    update(["0"]);
    notifyChildrens();
  }
}