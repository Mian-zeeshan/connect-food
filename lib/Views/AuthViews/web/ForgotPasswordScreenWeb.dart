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

class ForgotPasswordScreenWeb extends StatefulWidget{
  @override
  _ForgotPasswordScreenWeb createState() => _ForgotPasswordScreenWeb();
}

class _ForgotPasswordScreenWeb extends State<ForgotPasswordScreenWeb>{
  var utils = AppUtils();
  var isEmailValid = true;
  var emailError = "Email is required";
  var emailController = TextEditingController();
  CheckAdminController checkAdminController = Get.find();

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
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        decoration: BoxDecoration(
                          color: whiteColor,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: double.infinity,
                              child: Stack(
                                alignment: Alignment.centerLeft,
                                children: [
                                  Container(
                                    alignment: Alignment.center,
                                    child: RichText(text: TextSpan(
                                        children: [
                                          TextSpan(
                                              text: "Forgot ",
                                              style: utils.headingStyle(blackColor)
                                          ),
                                          TextSpan(
                                              text: "Password",
                                              style: utils.headingStyle(blackColor)
                                          ),
                                        ]
                                    )),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 12.w),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: Get.size.width/3,
                                    child: CachedNetworkImage(
                                      imageUrl: checkAdminController.system.companyLogo,
                                      placeholder: (context, url) => SpinKitRotatingCircle(color: checkAdminController.system.mainColor,),
                                      errorWidget: (context, url, error) => Icon(
                                        Icons.image_not_supported_rounded,
                                        size: 25.h,
                                      ), fit: BoxFit.contain,
                                      width: 140.h,
                                      height:140.h,
                                    ),
                                  ),

                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                                    margin: EdgeInsets.symmetric(horizontal: 30),
                                    child: Text(
                                      "Enter your email we'll send link to your email to reset your password.",
                                      style: utils.smallLabelStyle(blackColor),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  SizedBox(height: 40.h,),
                                  Container(
                                    margin: EdgeInsets.symmetric(horizontal: 10.w),
                                    child: utils.textField(whiteColor, CupertinoIcons.mail, blackColor, null, null, blackColor, "Email", blackColor.withOpacity(0.4), blackColor, 1.0, GetPlatform.isWeb ? 400 : Get.size.width - 30, false, emailController),
                                  ),
                                  SizedBox(height: 40,),
                                  Container(
                                    margin: EdgeInsets.symmetric(horizontal: 10.w),
                                    child: utils.button(checkAdminController.system.mainColor, "Submit", whiteColor, checkAdminController.system.mainColor, 2.0, (){
                                      if(emailController.text.isEmpty){
                                        Get.snackbar("Error", "Empty Email");
                                        return;
                                      }else if(!GetUtils.isEmail(emailController.text.toString())){
                                        Get.snackbar("Error", "Invalid Email");
                                        return;
                                      }
                                      sendEmailToUser(emailController.text.toString());
                                    }),
                                  ),
                                  SizedBox(height: 20.h,),
                                ],
                              ),
                            )
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

  void sendEmailToUser(String email) {
    EasyLoading.show(status: "Sending Email...");
    FirebaseAuth.instance.sendPasswordResetEmail(email: email)
        .then((value){
      EasyLoading.dismiss();
      Get.snackbar("Success", "Email to reset password is sent to your mail $email");
    }).onError((FirebaseException error, stackTrace){
      EasyLoading.dismiss();
      Get.snackbar("Error", error.message!);
    });
    emailController.clear();
  }
}