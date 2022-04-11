import 'dart:convert';

import 'package:connectsaleorder/AppConstants/Constants.dart';
import 'package:connectsaleorder/Models/BannerModel.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';

class BannerController extends GetxController{
  List<BannerModel> banners = [];
  var isLoading = true;

  @override
  void onInit() {
    super.onInit();
    getBanner(true);
  }

  void getBanner(mounted) async {
    isLoading = true;
    if(mounted){
      update(["0"]);
      notifyChildrens();
    }
    await Future.delayed(Duration(milliseconds: 1000));
    FirebaseDatabase database = FirebaseDatabase(databaseURL: databaseUrl);
    
    if(!GetPlatform.isWeb) {
      database.setPersistenceEnabled(true);
      database.setPersistenceCacheSizeBytes(10000000);
    }
    DatabaseReference reference = database.reference();
    reference
        .child(bannerRef)
        .onValue.listen((event) {
      banners = [];
      if(event.snapshot.exists){
        event.snapshot.value.forEach((key,value){
          BannerModel bannerModel = BannerModel.fromJson(jsonDecode(jsonEncode(value)));
          banners.add(bannerModel);
        });
      }
      isLoading = false;
      update(["0"]);
      notifyChildrens();
    });
  }

}