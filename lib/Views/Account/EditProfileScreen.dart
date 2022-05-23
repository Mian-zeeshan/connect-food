import 'package:connectsaleorder/AppConstants/Constants.dart';
import 'package:connectsaleorder/GetXController/CheckAdminController.dart';
import 'package:connectsaleorder/GetXController/UserController.dart';
import 'package:connectsaleorder/Models/UserModel.dart';
import 'package:connectsaleorder/Utils/AppUtils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class EditProfileScreen extends StatefulWidget{
  @override
  _EditProfileScreen createState() => _EditProfileScreen();

}

class _EditProfileScreen extends State<EditProfileScreen>{
  var utils = AppUtils();
  var nameController = TextEditingController();
  var phoneController = TextEditingController();
  var box = GetStorage();
  UserController userController = Get.find();
  CheckAdminController checkAdminController = Get.find();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameController.text = userController.user!.name;
    phoneController.text = userController.user!.phone;
  }
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
                  width: Get.width < 550 ? Get.size.width/2 : Get.width/3 ,
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Image.asset("Assets/Images/mi_logo.jpeg"),
                ),
                SizedBox(height: 20,),
                Expanded(
                    child: SingleChildScrollView(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: Get.width < 550 ? 12 : Get.width/4),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 10),
                              child: utils.textField(whiteColor, CupertinoIcons.person, blackColor, null, null, blackColor, "Name", blackColor.withOpacity(0.4), blackColor, 1.0, GetPlatform.isWeb ? 400 : Get.size.width - 30, false, nameController),
                            ),
                            SizedBox(height: 10,),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 10),
                              child: utils.textField(whiteColor, CupertinoIcons.phone, blackColor, null, null, blackColor, "Phone", blackColor.withOpacity(0.4), blackColor, 1.0, GetPlatform.isWeb ? 400 : Get.size.width - 30, false, phoneController , isPhone : "yes"),
                            ),
                            SizedBox(height: 10,),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 10),
                              child: utils.button(checkAdminController.system.mainColor, "UPDATE", whiteColor, checkAdminController.system.mainColor, 2.0, (){
                                if(nameController.text.isEmpty){
                                  Get.snackbar("Error", "Empty Name!");
                                  return;
                                }else if(phoneController.text.isEmpty){
                                  Get.snackbar("Error", "Empty phone!");
                                  return;
                                }
                                EasyLoading.show(status: "Updating...");
                                addUserToFirebase();
                                // Get.toNamed(homeRoute);
                              }),
                            ),
                            SizedBox(height: 10,),
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


  void addUserToFirebase() {
    userController.user!.name = nameController.text.toString();
    userController.user!.phone = phoneController.text.toString();

    FirebaseDatabase database = FirebaseDatabase(databaseURL: databaseUrl);
    
    database.setPersistenceEnabled(true);
    database.setPersistenceCacheSizeBytes(10000000);
    DatabaseReference reference = database.reference();
    reference
        .child(usersRef)
        .child(userController.user!.uid)
        .set(userController.user!.toJson())
        .then((value) async {
      await box.write(currentUser, userController.user!.toJson());
      Get.snackbar("Success", "Updated Profile!");
      EasyLoading.dismiss();
    }).onError((FirebaseException error, stackTrace) {
      EasyLoading.dismiss();
      Get.snackbar("Error", error.message!);
    });
  }

}