import 'dart:convert';
import 'package:connectsaleorder/AppConstants/Constants.dart';
import 'package:connectsaleorder/GetXController/ItemController.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import '../Models/SubCategoryModel.dart';

class SubCategoryController extends GetxController{
  List<SubCategoryModel> subCategories = [];
  List<SubCategoryModel> subCategoriesAll = [];
  var isLoadingSubCategories = false;
  int selectedSubCategory = 0;
  ItemController itemController = Get.find();
  var categoryId = "";

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getAllSubCategories();
  }

  void getAllSubCategories() {
    FirebaseDatabase database = FirebaseDatabase(databaseURL: databaseUrl);
    
    if(!GetPlatform.isWeb) {
      database.setPersistenceEnabled(true);
      database.setPersistenceCacheSizeBytes(10000000);
    }
    DatabaseReference reference = database.reference();
    reference
        .child(subCategoryRef)
        .onValue.listen((event) {
      subCategoriesAll = [];
      if(event.snapshot.exists){
        if(event.snapshot.value != null) {
          event.snapshot.value.forEach((key,value) {
            SubCategoryModel subCategoryModel = SubCategoryModel.fromJson(
                jsonDecode(jsonEncode(value)));
            subCategoriesAll.add(subCategoryModel);
          });
          getSubCategories(categoryId);
        }
      }
      update(["0"]);
      notifyChildrens();
    });
  }

  getSubCategories(categoryId){
    isLoadingSubCategories = true;
    this.categoryId = categoryId;
    subCategories = [];
    for(var sCategory in subCategoriesAll){
      if(sCategory.type == categoryId){
        subCategories.add(sCategory);
      }
    }
    isLoadingSubCategories = false;
    update(["0"]);
    notifyChildrens();
    updateSubCategory(0);
  }

  updateSubCategory(int selected){
    selectedSubCategory = selected;
    update(["0"]);
    notifyChildrens();/*
    if(subCategories.length > 0)
      itemController.getItems(subCategories[selected].code, false);*/
  }
}