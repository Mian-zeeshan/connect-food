import 'dart:convert';

import 'package:connectsaleorder/AppConstants/Constants.dart';
import 'package:connectsaleorder/GetXController/ItemController.dart';
import 'package:connectsaleorder/Models/CategoryModel.dart';
import 'package:connectsaleorder/GetXController/SubCategoryController.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';

class CategoryController extends GetxController{
  List<CategoryModel> categories = [];
  List<CategoryModel> filterCategories = [];
  SubCategoryController subCategoryController = Get.put(SubCategoryController());
  int selectedCategory = 0;
  ItemController itemController = Get.find();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getCategories();
  }

  void getCategories() {
    FirebaseDatabase database = FirebaseDatabase(databaseURL: databaseUrl);
    
    if(!GetPlatform.isWeb) {
      database.setPersistenceEnabled(true);
      database.setPersistenceCacheSizeBytes(10000000);
    }
    DatabaseReference reference = database.reference();
    reference
        .child(categoryRef)
        .onValue.listen((event) {
          categories = [];
          filterCategories = [];
      if(event.snapshot.exists){
        event.snapshot.value.forEach((key, value){
          CategoryModel categoryModel = CategoryModel.fromJson(jsonDecode(jsonEncode(value)));
          if(categoryModel.isEnable) {
            categories.add(categoryModel);
            filterCategories.add(categoryModel);
          }
        });
      }
      if(categories.length > 0){
        subCategoryController.getSubCategories(categories[0].code);
      }
      update(["0"]);
      notifyChildrens();
    });
  }

  updateCategory(String code){
    for(var  i = 0; i < categories.length; i++){
      if(categories[i].code == code){
        selectedCategory = i;
        break;
      }
    }
    update(["0"]);
    notifyChildrens();
    itemController.getItems(code, false);
  }

  updateCategoryMain(String code){
    for(var  i = 0; i < categories.length; i++){
      if(categories[i].code == code){
        selectedCategory = i;
        break;
      }
    }
    update(["0"]);
    notifyChildrens();
  }

  filterCategory(String name){
    filterCategories = [];
    for(var  i = 0; i < categories.length; i++){
      if(categories[i].name.toLowerCase().contains(name.toLowerCase())){
        filterCategories.add(categories[i]);
      }
    }
    update(["0"]);
    notifyChildrens();
  }

  CategoryModel? getCategory(String type) {
    return categories.singleWhere((element){
      print(element.toJson());
      return element.code == type;
    });
  }
}