import 'dart:convert';

import 'package:connectsaleorder/AppConstants/Constants.dart';
import 'package:connectsaleorder/GetXController/ChatController.dart';
import 'package:connectsaleorder/GetXController/CheckAdminController.dart';
import 'package:connectsaleorder/Models/AddressModel.dart';
import 'package:connectsaleorder/Models/RetailerModel.dart';
import 'package:connectsaleorder/Models/UserModel.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class UserController extends GetxController{
  UserModel? user;
  UserModel? currentSeller;
  List<UserModel> retailers = [];
  List<UserModel> allRetailers = [];
  CheckAdminController checkAdminController = Get.find();
  var box = GetStorage();
  int type = 0;
  String? area;
  AddressModel? selectedAddress;

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
      if(user!.type == 0){
        getRetailers();
      }
      loadUerFromFirebase();
      Get.put(ChatController());
    }
  }

  setType(type){
    this.type = type;
    filterRetailers();
  }


  void setArea(area) {
    this.area = area;
    filterRetailers();
  }

  void removeUser(){
    user = null;
    update(["0"]);
    notifyChildrens();
  }

  void loadUerFromFirebase() {
    FirebaseDatabase database = FirebaseDatabase(databaseURL: databaseUrl);
    
    if(!GetPlatform.isWeb) {
      database.setPersistenceEnabled(true);
      database.setPersistenceCacheSizeBytes(10000000);
    }
    DatabaseReference reference = database.reference();
    reference
        .child(usersRef)
        .child(user!.uid)
    .onValue.listen((event) async {
      if(event.snapshot.exists){
        user = UserModel.fromJson(jsonDecode(jsonEncode(event.snapshot.value)));
        print("USERMODEL ${user!.toJson().toString()}");
        box.write(currentUser, user!.toJson());
        if(user!.type == 0){
          checkAdminController.updateAdmin("1");
        }
        for(var i = 0 ; i < user!.addressList.length; i++){
          if(user!.addressList[i].id == user!.defaultAddressId){
            user!.addressList[i].selected = true;
            break;
          }
        }
        update(["0"]);
        notifyChildrens();
      }
    });
  }
  
  
  void getRetailers() {
    FirebaseDatabase database = FirebaseDatabase(databaseURL: databaseUrl);
    
    if(!GetPlatform.isWeb) {
      database.setPersistenceEnabled(true);
      database.setPersistenceCacheSizeBytes(10000000);
    }
    DatabaseReference reference = database.reference();
    reference
        .child(usersRef)
        .orderByChild("isRetailer")
    .equalTo(true)
    .onValue.listen((event) {
      allRetailers = [];
      if(event.snapshot.exists){
        event.snapshot.value.forEach((key,value){
          allRetailers.add(UserModel.fromJson(jsonDecode(jsonEncode(value))));
          filterRetailers();
        });
      }
    });
  }

  void getCurrentRetailer(uid){
    currentSeller = null;
    FirebaseDatabase database = FirebaseDatabase(databaseURL: databaseUrl);
    
    if(!GetPlatform.isWeb) {
      database.setPersistenceEnabled(true);
      database.setPersistenceCacheSizeBytes(10000000);
    }
    DatabaseReference reference = database.reference();
    reference
        .child(usersRef)
    .child(uid)
    .onValue.listen((event) {
      currentSeller = UserModel.fromJson(jsonDecode(jsonEncode(event.snapshot.value)));
      update(["0"]);
      notifyChildrens();
    });
  }

  void updateSelectedAddress(AddressModel address) {
    selectedAddress = address;
    update(["0"]);
    notifyChildrens();
  }

  void setSelected(int pos) {
    for(var i = 0 ; i < user!.addressList.length; i++){
      if(i == pos){
        user!.addressList[i].selected = true;
      }else{
        user!.addressList[i].selected = false;
      }
    }
    update(["0"]);
    notifyChildrens();
  }

  void changeApproval( isApproved, uid) async {
    FirebaseDatabase database = FirebaseDatabase(databaseURL: databaseUrl);
    
    if(!GetPlatform.isWeb) {
      database.setPersistenceEnabled(true);
      database.setPersistenceCacheSizeBytes(10000000);
    }
    DatabaseReference reference = database.reference();
    reference
        .child(usersRef)
        .child(uid)
        .child("retailerModel")
        .update({"approved" : isApproved});
  }

  void filterRetailers() {
    retailers = [];
    for(var r in allRetailers){
      if(type == 0){
        if(area != null){
          if(r.retailerModel!.area == area){
            retailers.add(r);
          }
        }else {
          retailers.add(r);
        }
      }else if(type == 1){
        if(r.retailerModel!.approved) {
          if(area != null) {
            if (r.retailerModel!.area == area) {
              retailers.add(r);
            }
          }else {
            retailers.add(r);
          }
        }
      }else if(type == 2){
        if(!(r.retailerModel!.approved)) {
          if(area != null) {
            if (r.retailerModel!.area == area) {
              retailers.add(r);
            }
          }else {
            retailers.add(r);
          }
        }
      }
    }
    update(["0"]);
    notifyChildrens();
  }
}