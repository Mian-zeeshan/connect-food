import 'dart:convert';

import 'package:connectsaleorder/AppConstants/Constants.dart';
import 'package:connectsaleorder/Models/CouponModel.dart';
import 'package:connectsaleorder/Models/UserModel.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class CouponController extends GetxController{
  UserModel? user;
  CouponModel? selectedCoupon;
  var box = GetStorage();
  List<CouponModel> coupons = [];
  var loadingCoupon = false;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getUser();
  }

  void getUser() async {
    var value = await box.read(currentUser);
    if(value != null) {
      user = UserModel.fromJson(value);
      getCoupons();
    }
  }

  void getCoupons() {
    FirebaseDatabase database = FirebaseDatabase(databaseURL: databaseUrl);
    if(!GetPlatform.isWeb) {
      database.setPersistenceEnabled(true);
      database.setPersistenceCacheSizeBytes(10000000);
    }
    DatabaseReference reference = database.reference();
    reference
        .child(couponRef)
        .onValue.listen((event) {
      coupons = [];
      if(event.snapshot.exists){
        event.snapshot.value.forEach((key,value){
          coupons.add(CouponModel.fromJson(jsonDecode(jsonEncode(value))));
        });
      }
      update(["0"]);
      notifyChildrens();
    });
  }

  Future<void> addCoupons(CouponModel couponModel) async {
    FirebaseDatabase database = FirebaseDatabase(databaseURL: databaseUrl);
    if(!GetPlatform.isWeb) {
      database.setPersistenceEnabled(true);
      database.setPersistenceCacheSizeBytes(10000000);
    }
    DatabaseReference reference = database.reference();
    reference = reference
        .child(couponRef)
        .push();
    couponModel.couponId = reference.key;
    await reference.set(couponModel.toJson());
    return;
  }

  CouponModel getCoupon(String code) {
    loadingCoupon = true;
    update(["0"]);
    notifyChildrens();
    return coupons.firstWhere((element) => element.code == code);
  }

  void setSelectedCoupon(CouponModel? co) {
    selectedCoupon = co;
    update(["0"]);
    notifyChildrens();
  }

  void stopLoading() {
    loadingCoupon = false;
    update(["0"]);
    notifyChildrens();
  }

  void removeCoupon(String couponId) async {
    FirebaseDatabase database = FirebaseDatabase(databaseURL: databaseUrl);
    if(!GetPlatform.isWeb) {
      database.setPersistenceEnabled(true);
      database.setPersistenceCacheSizeBytes(10000000);
    }
    DatabaseReference reference = database.reference();
    await reference
        .child(couponRef)
        .child(couponId)
        .remove();
    update(["0"]);
    notifyChildrens();
  }
}