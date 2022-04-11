import 'package:connectsaleorder/AppConstants/Constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LocaleController extends GetxController{
  String locale = english;
  String isAdmin = "0";
  var box = GetStorage();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getLocale();
    getAdmin();
  }

  void getLocale() async {
    String? lang = box.read(language);
    if(lang == null){
      locale = english;
      await box.write(language, english);
      Locale l = Locale(english);
      Get.updateLocale(l);
    }else{
      locale = lang;
      Locale l = Locale(lang);
      Get.updateLocale(l);
    }
    update(["0"]);
    notifyChildrens();
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

  void updateLocale(lang) async {
    locale = lang;
    await box.write(language, lang);
    Locale l = Locale(lang);
    Get.updateLocale(l);
    update(["0"]);
    notifyChildrens();
  }

  void updateLoc() async {
    Locale l = Locale(locale);
    Get.updateLocale(l);
    update(["0"]);
    notifyChildrens();
  }

}