import 'dart:convert';

import 'package:connectsaleorder/AppConstants/Constants.dart';
import 'package:connectsaleorder/GetXController/CheckAdminController.dart';
import 'package:connectsaleorder/GetXController/UserController.dart';
import 'package:connectsaleorder/Utils/AppUtils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ChangePasswordScreen extends StatefulWidget{
  @override
  _ChangePasswordScreen createState() => _ChangePasswordScreen();

}

class _ChangePasswordScreen extends State<ChangePasswordScreen>{
  var utils = AppUtils();
  var box = GetStorage();
  var oldPasswordController = TextEditingController();
  var newPasswordController = TextEditingController();
  var repeatPasswordController = TextEditingController();
  UserController userController = Get.find();
  CheckAdminController checkAdminController = Get.find();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0),
        child: AppBar(
          elevation: 0,
          backgroundColor: checkAdminController.system.mainColor,
          brightness: Brightness.light,
        ),
      ),
      body: SafeArea(
        child: Container(
          color: whiteColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: (){
                      Get.back();
                    },
                    icon: Icon(CupertinoIcons.arrow_left , color: blackColor, size: 24,),
                  ),
                ],
              ),
              Container(
                width: Get.width < 550 ? Get.size.width/2 : Get.width/3 ,
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Image.network(checkAdminController.system.companyLogo),
              ),
              const SizedBox(height: 20,),
              Text("change_password".tr , style: utils.boldLabelStyle(checkAdminController.system.mainColor)),
              Expanded(
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        child: utils.textField(whiteColor, CupertinoIcons.lock, blackColor, null, null, blackColor, "old_password".tr, blackColor.withOpacity(0.4), blackColor, 1.0, GetPlatform.isWeb ? 400 : Get.size.width - 30, true, oldPasswordController),
                      ),
                      const SizedBox(height: 12,),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        child: utils.textField(whiteColor, CupertinoIcons.lock, blackColor, null, null, blackColor, "new_password".tr, blackColor.withOpacity(0.4), blackColor, 1.0, GetPlatform.isWeb ? 400 : Get.size.width - 30, true, newPasswordController),
                      ),
                      const SizedBox(height: 12,),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        child: utils.textField(whiteColor, CupertinoIcons.lock, blackColor, null, null, blackColor, "r_password".tr, blackColor.withOpacity(0.4), blackColor, 1.0, GetPlatform.isWeb ? 400 : Get.size.width - 30, true, repeatPasswordController),
                      ),
                      const SizedBox(height: 20,),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: utils.button(checkAdminController.system.mainColor, "change_password".tr , whiteColor, checkAdminController.system.mainColor, 2.0,() async {
                          if(oldPasswordController.text.isEmpty){
                            EasyLoading.showToast("old_p_error".tr , toastPosition: EasyLoadingToastPosition.bottom);
                          }else if(newPasswordController.text.isEmpty || newPasswordController.text.length < 6){
                            EasyLoading.showToast("password_error".tr , toastPosition: EasyLoadingToastPosition.bottom);
                          }else if(repeatPasswordController.text.isEmpty){
                            EasyLoading.showToast("r_p_error".tr , toastPosition: EasyLoadingToastPosition.bottom);
                          }else if(repeatPasswordController.text != newPasswordController.text){
                            EasyLoading.showToast("not_match_p_error".tr , toastPosition: EasyLoadingToastPosition.bottom);
                          }else{
                            changePassword();
                          }
                        }),
                      ),
                      const  SizedBox(height: 20,),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void changePassword() async {
    EasyLoading.show(status: "Loading...");
    final user = FirebaseAuth.instance.currentUser;
    final cred = EmailAuthProvider.credential(
        email: userController.user!.email, password: oldPasswordController.text.toString());

    user!.reauthenticateWithCredential(cred).then((value) {
      user.updatePassword(newPasswordController.text.toString()).then((_) {
        Get.back();
        Get.snackbar("Success", "Password Change Successfully!" , duration: Duration(seconds: 2));
        EasyLoading.dismiss();
      }).onError((FirebaseAuthException error, stackTrace){
        EasyLoading.dismiss();
        Get.snackbar("Error", error.message!);
      });
    }).onError((FirebaseAuthException error, stackTrace){
      EasyLoading.dismiss();
      Get.snackbar("Error", error.message!);
    });
  }
}