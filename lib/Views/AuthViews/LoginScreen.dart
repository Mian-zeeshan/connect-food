import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectsaleorder/AppConstants/Constants.dart';
import 'package:connectsaleorder/GetXController/CheckAdminController.dart';
import 'package:connectsaleorder/GetXController/DrawerCustomController.dart';
import 'package:connectsaleorder/Models/UserModel.dart';
import 'package:connectsaleorder/Utils/AppUtils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/platform/platform.dart';
import 'package:get_storage/get_storage.dart';

class LoginScreen extends StatefulWidget{
  @override
  _LoginScreen createState() => _LoginScreen();

}

class _LoginScreen extends State<LoginScreen>{
  var utils = AppUtils();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  DrawerCustomController drawerCustomController = Get.find();
  CheckAdminController checkAdminController = Get.find();

  var box = GetStorage();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0),
        child: AppBar(
          backgroundColor: whiteColor,
          elevation: 0,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              color: whiteColor,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: double.infinity,
                  child: Stack(
                    alignment: Alignment.centerLeft,
                    children: [
                      IconButton(onPressed: (){Get.back();}, icon: Icon(CupertinoIcons.arrow_left , color: blackColor,)),
                      Container(
                        alignment: Alignment.center,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  child: CachedNetworkImage(
                    imageUrl: checkAdminController.system.companyLogo,
                    placeholder: (context, url) => Image.asset("Assets/Images/mi_logo.jpeg"),
                    errorWidget: (context, url, error) => Icon(
                      Icons.image_not_supported_rounded,
                      size: 25,
                    ), fit: BoxFit.contain,
                    width: 140.h,
                    height: 140.h),
                ),
                Expanded(
                    child: SingleChildScrollView(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 12.w),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 10.w),
                              child: utils.textField(whiteColor, CupertinoIcons.mail, blackColor, null, null, blackColor, "Email", blackColor.withOpacity(0.4), blackColor, 1.0, Get.size.width - 30, false, emailController),
                            ),
                            SizedBox(height: 20,),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 10.w),
                              child: utils.textField(whiteColor, CupertinoIcons.lock, blackColor, null, null, blackColor, "Password", blackColor.withOpacity(0.4), blackColor, 1.0, Get.size.width - 30, true, passwordController),
                            ),
                            SizedBox(height: 10,),
                            Container(
                              alignment: Alignment.centerRight,
                              margin: EdgeInsets.symmetric(horizontal: 20.w),
                              child: GestureDetector(
                                onTap: (){
                                  Get.toNamed(forgotRoute);
                                },
                                  child: Text("Forgot Password?" , style: utils.labelStyle(blackColor),)),
                            ),
                            SizedBox(height: 40,),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 10.w),
                              child: utils.button(checkAdminController.system.mainColor, "LOG IN", whiteColor, checkAdminController.system.mainColor, 2.0, (){
                                if(emailController.text.isEmpty){
                                  Get.snackbar("Error", "Empty Email");
                                  return;
                                }else if(!GetUtils.isEmail(emailController.text.toString())){
                                  Get.snackbar("Error", "Invalid Email");
                                  return;
                                }else if(passwordController.text.isEmpty){
                                  Get.snackbar("Error", "Invalid password");
                                  return;
                                }
                                EasyLoading.show(status: "Logging in...");
                                loginUser();
                               // Get.toNamed(homeRoute);
                              }),
                            ),
                            SizedBox(height: 10.h,),
                            Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.symmetric(horizontal: 10.w),
                              child: GestureDetector(
                                onTap: (){
                                  Get.toNamed(signUpRoute);
                                },
                                child: RichText(
                                  text: TextSpan(
                                    children:[
                                      TextSpan(
                                        text: "Don't have an account? ",
                                        style: utils.labelStyle(blackColor.withOpacity(0.4))
                                      ),
                                      TextSpan(
                                        text: "Sign up",
                                        style: utils.boldLabelStyle(blackColor)
                                      ),
                                    ]
                                  ),
                                ),
                              )
                            ),
                            SizedBox(height: 40.h,),
                            Container(
                              width: Get.width,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(child: Container(
                                    height: 1,
                                    color: grayColor,
                                  )),
                                  Text(" OR " , style: utils.labelStyle(blackColor.withOpacity(0.9)),),
                                  Expanded(child: Container(
                                    height: 1,
                                    color: grayColor,
                                  )),
                                ],
                              ),
                            ),
                            SizedBox(height: 20.h,),
                           Container(
                              width: Get.width,
                              child: Center(
                                child:GestureDetector(
                                  onTap: (){
                                    drawerCustomController.setDrawer("home", 0);
                                    Get.toNamed(homeCRoute);
                                  },
                                    child: Text("SKIP" , style: utils.labelStyleUnderline(Colors.blue),)),
                              ),
                            ),
                            SizedBox(height: 20.h,),
                          ],
                        ),
                      ),
                    )
                )
              ],
            ),
          ),
        ),
      ),
    );
  }


  void loginUser() async {
    auth.signInWithEmailAndPassword(email: emailController.text.toString(), password: passwordController.text.toString())
        .then((value){
      box.write("password", passwordController.text);
      loadUserFromFirebase(value.user!.uid);
    }).onError((FirebaseException error, stackTrace){
      EasyLoading.dismiss();
      Get.snackbar("Error", error.message!);
    });
  }

  void loadUserFromFirebase(String uid) async {
    FirebaseDatabase database = FirebaseDatabase(databaseURL: databaseUrl);
    
    if(!GetPlatform.isWeb) {
      database.setPersistenceEnabled(true);
      database.setPersistenceCacheSizeBytes(10000000);
    }
    DatabaseReference reference = database.reference();
    reference
        .child(usersRef)
        .child(uid)
        .once()
        .then((value) async {
      UserModel userModel = UserModel.fromJson(jsonDecode(jsonEncode(value.value)));
      box.write(currentUser, userModel.toJson());
      drawerCustomController.setDrawer("home", 0);
      Get.offAllNamed(homeCRoute);
      EasyLoading.dismiss();
    }).onError((FirebaseException error, stackTrace){
      print("USER MODEL");
      EasyLoading.dismiss();
      Get.snackbar("Error", error.message!);
    });
  }
}