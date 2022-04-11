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

class SignUpScreen extends StatefulWidget{
  @override
  _SignUpScreen createState() => _SignUpScreen();

}

class _SignUpScreen extends State<SignUpScreen>{
  var utils = AppUtils();
  var emailController = TextEditingController();
  var nameController = TextEditingController();
  var phoneController = TextEditingController();
  var passwordController = TextEditingController();
  var cPasswordController = TextEditingController();
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
                        child: RichText(text: TextSpan(
                            children: [
                              TextSpan(
                                  text: "Sign ",
                                  style: utils.headingStyle(blackColor)
                              ),
                              TextSpan(
                                  text: "up",
                                  style: utils.headingStyle(blackColor)
                              ),
                            ]
                        )),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  child: CachedNetworkImage(
                    imageUrl: checkAdminController.system.companyLogo,
                    placeholder: (context, url) => SpinKitRotatingCircle(color: checkAdminController.system.mainColor,),
                    errorWidget: (context, url, error) => Icon(
                      Icons.image_not_supported_rounded,
                      size: 25,
                    ), fit: BoxFit.contain,
                    width: 120.h,
                    height:120.h,),
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
                              margin: EdgeInsets.symmetric(horizontal: 10),
                              child: utils.textField(whiteColor, CupertinoIcons.person, blackColor, null, null, checkAdminController.system.mainColor, "Name", blackColor.withOpacity(0.4), blackColor, 1.0, Get.size.width - 30, false, nameController),
                            ),
                            SizedBox(height: 10.h,),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 10),
                              child: utils.textField(whiteColor, CupertinoIcons.mail, blackColor, null, null, checkAdminController.system.mainColor, "Email", blackColor.withOpacity(0.4), blackColor, 1.0, Get.size.width - 30, false, emailController),
                            ),
                            SizedBox(height: 10.h,),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 10),
                              child: utils.textField(whiteColor, CupertinoIcons.phone, blackColor, null, null, checkAdminController.system.mainColor, "Phone", blackColor.withOpacity(0.4), blackColor, 1.0, Get.size.width - 30, false, phoneController , isPhone : "yes"),
                            ),
                            SizedBox(height: 10.h,),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 10),
                              child: utils.textField(whiteColor, CupertinoIcons.lock, blackColor, null, null, blackColor, "Password", blackColor.withOpacity(0.4), blackColor, 1.0,  Get.size.width - 30, true, passwordController),
                            ),
                            SizedBox(height: 10.h,),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 10),
                              child: utils.textField(whiteColor, CupertinoIcons.lock, blackColor, null, null, blackColor, "Confirm Password", blackColor.withOpacity(0.4), blackColor, 1.0, Get.size.width - 30, true, cPasswordController),
                            ),
                            SizedBox(height: 20.h,),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 10),
                              child: utils.button(checkAdminController.system.mainColor, "SIGN UP", whiteColor, checkAdminController.system.mainColor, 2.0, (){
                                if(nameController.text.isEmpty){
                                  Get.snackbar("Error", "Empty Name!");
                                  return;
                                }else if(emailController.text.isEmpty){
                                  Get.snackbar("Error", "Empty Email!");
                                  return;
                                }else if(!GetUtils.isEmail(emailController.text.toString())){
                                  Get.snackbar("Error", "Invalid Email!");
                                  return;
                                }else if(phoneController.text.isEmpty){
                                  Get.snackbar("Error", "Empty phone!");
                                  return;
                                }else if(passwordController.text.isEmpty){
                                  Get.snackbar("Error", "Empty password");
                                  return;
                                }else if(cPasswordController.text.isEmpty){
                                  Get.snackbar("Error", "Empty Confirm password");
                                  return;
                                }else if(cPasswordController.text != passwordController.text){
                                  Get.snackbar("Error", "Password not match");
                                  return;
                                }else if(passwordController.text.length < 6 ){
                                  Get.snackbar("Error", "Weak Password!");
                                  return;
                                }
                                EasyLoading.show(status: "Signing up...");
                                createUserWithEmail();
                                // Get.toNamed(homeRoute);
                              }),
                            ),
                            SizedBox(height: 10.h,),
                            Container(
                                alignment: Alignment.center,
                                margin: EdgeInsets.symmetric(horizontal: 10),
                                child: GestureDetector(
                                  onTap: (){
                                    Get.toNamed(loginRoute);
                                  },
                                  child: GestureDetector(
                                    onTap: (){
                                      Get.toNamed(loginRoute);
                                    },
                                    child: RichText(
                                      text: TextSpan(
                                          children:[
                                            TextSpan(
                                                text: "Already have an account? ",
                                                style: utils.labelStyle(blackColor.withOpacity(0.4))
                                            ),
                                            TextSpan(
                                                text: "Log In",
                                                style: utils.boldLabelStyle(blackColor)
                                            ),
                                          ]
                                      ),
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


  void createUserWithEmail() async {
    await auth!
        .createUserWithEmailAndPassword(
        email: emailController.text.trim(), password: passwordController.text.toString())
        .then((value) {
      addUserToFirebase(value);
    }).onError((FirebaseException error, stackTrace) {
      EasyLoading.dismiss();
      Get.snackbar("Error", error.message!);
    });
  }


  void addUserToFirebase(UserCredential value) {
    FirebaseDatabase database = FirebaseDatabase(databaseURL: databaseUrl);
    var userModel = UserModel(uid: value.user!.uid, name: nameController.text.toString(), email: emailController.text.toString(), phone: phoneController.text.toString(), type: 1);
    
    if(!GetPlatform.isWeb) {
      database.setPersistenceEnabled(true);
      database.setPersistenceCacheSizeBytes(10000000);
    }
    DatabaseReference reference = database.reference();
    reference
        .child(usersRef)
        .child(value.user!.uid)
        .set(userModel.toJson())
        .then((value) async {
          await box.write(currentUser, userModel.toJson());
          Get.offAllNamed(homeCRoute);
          EasyLoading.dismiss();
    }).onError((FirebaseException error, stackTrace) {
      EasyLoading.dismiss();
      Get.snackbar("Error", error.message!);
    });
  }

}