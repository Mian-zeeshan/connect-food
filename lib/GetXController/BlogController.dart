import 'dart:convert';

import 'package:connectsaleorder/AppConstants/Constants.dart';
import 'package:connectsaleorder/Models/BlogModel.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';


class BlogController extends GetxController{
  List<BlogModel> blogs = [];

  @override
  void onInit() {
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
        .child(blogRef)
        .onValue.listen((event) {
      blogs = [];
      if(event.snapshot.exists){
        event.snapshot.value.forEach((key,value){
          BlogModel brandModel = BlogModel.fromJson(jsonDecode(jsonEncode(value)));
          if(brandModel.active) {
            blogs.add(brandModel);
          }
        });
      }
      update(["0"]);
      notifyChildrens();
    });
  }
}