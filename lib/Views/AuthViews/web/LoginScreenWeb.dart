import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectsaleorder/AppConstants/Constants.dart';
import 'package:connectsaleorder/GetXController/CheckAdminController.dart';
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

class LoginScreenWeb extends StatefulWidget{
  @override
  _LoginScreenWeb createState() => _LoginScreenWeb();
}

class _LoginScreenWeb extends State<LoginScreenWeb>{
  var utils = AppUtils();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                    child: Container()),
                Expanded(
                  flex: 2,
                    child: Container(
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    color: whiteColor,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: CachedNetworkImage(
                            imageUrl: checkAdminController.system.companyLogo,
                            placeholder: (context, url) => SpinKitRotatingCircle(color: checkAdminController.system.mainColor,),
                            errorWidget: (context, url, error) => Icon(
                              Icons.image_not_supported_rounded,
                              size: 25,
                            ), fit: BoxFit.contain,
                            width: 140.h,
                            height: 140.h),
                      ),
                      SizedBox(height: 40,),
                      Text("Sign in" , style: utils.xLHeadingStyle(blackColor),),
                      SizedBox(height: 10,),
                      Container(
                        child: utils.textField(whiteColor, CupertinoIcons.mail, blackColor, null, null, blackColor, "Email", blackColor.withOpacity(0.4), blackColor, 1.0, Get.size.width - 30, false, emailController),
                      ),
                      SizedBox(height: 20,),
                      Container(
                        child: utils.textField(whiteColor, CupertinoIcons.lock, blackColor, null, null, blackColor, "Password", blackColor.withOpacity(0.4), blackColor, 1.0, Get.size.width - 30, true, passwordController),
                      ),
                      SizedBox(height: 10,),
                      Container(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                            onTap: (){
                              Get.toNamed(forgotRoute);
                            },
                            child: Text("Forgot Password?" , style: utils.labelStyle(blackColor),)),
                      ),
                      SizedBox(height: 40,),
                      Container(
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
                    ],
                  ),
                )
                ),
                Expanded(
                  flex: 5,
                    child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    color: whiteColor,
                  ),
                  child: Stack(
                    children: [
                      Container(
                      width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          decoration: BoxDecoration(
                            color: whiteColor,
                          ),
                        child: Image.network("https://firebasestorage.googleapis.com/v0/b/sales-orders-374ef.appspot.com/o/web-development-programmer-engineering-coding-website-augmented-reality-interface-screens-developer-project-engineer-programming-software-application-design-cartoon-illustration_107791-3863.jpg?alt=media&token=78c96d34-6ff9-459b-9440-65669540feba" , fit: BoxFit.contain,),
                      ),
                    ],
                  ),
                )
                )
              ],
            )
          ),
        ),
      ),
    );
  }


  void loginUser() async {
    FirebaseAuth.instance.signInWithEmailAndPassword(email: emailController.text.toString(), password: passwordController.text.toString())
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
    database = FirebaseDatabase.instance;
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
      Get.offAllNamed(homeCRoute);
      EasyLoading.dismiss();
    }).onError((FirebaseException error, stackTrace){
      print("USER MODEL");
      EasyLoading.dismiss();
      Get.snackbar("Error", error.message!);
    });
  }
}