import 'dart:io';

import 'package:animated_widgets/widgets/translation_animated.dart';
import 'package:connectsaleorder/AppConstants/Constants.dart';
import 'package:connectsaleorder/GetXController/CheckAdminController.dart';
import 'package:connectsaleorder/GetXController/UserController.dart';
import 'package:connectsaleorder/Utils/AppUtils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';


class ProfileScreen extends StatefulWidget{
  @override
  _ProfileScreen createState() => _ProfileScreen();

}

class _ProfileScreen extends State<ProfileScreen>{
  var utils = AppUtils();


  final ImagePicker _picker = ImagePicker();
  File? _image;
  FirebaseStorage _storage = FirebaseStorage.instance;
  CheckAdminController checkAdminController = Get.find();

  Future _getImage() async {
    var image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 50);

    setState(() {
      _image = File(image!.path);
      uploadPic(_image);
    });
  }
  uploadPic(file) async {
    EasyLoading.show(status: "Uploading...");
    var random = DateTime.now();
    //Create a reference to the location you want to upload to in firebase
    firebase_storage.Reference reference =
    _storage.ref().child("images/$random.JPG");
    //Upload the file to firebase
    firebase_storage.UploadTask uploadTask = reference.putFile(file);
    var dowurl = await (await uploadTask).ref.getDownloadURL();
    addToFirebase(dowurl);
    EasyLoading.dismiss();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserController>(id : "0",builder: (userController){
      return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: checkAdminController.system.mainColor,
          leading: GestureDetector(
              onTap: (){
                Get.back();
              },
              child: Icon(CupertinoIcons.arrow_left , color: whiteColor,)
          ),
          title: RichText(
            text: TextSpan(
                children: [
                  TextSpan(
                    text: "Profile",
                    style: utils.xLHeadingStyle(whiteColor),
                  ),
                ]
            ),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Container(
            width: Get.width,
            height: Get.height,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: Get.width,
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: checkAdminController.system.mainColor,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () async {
                                await Get.toNamed(editProfileRoute);
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 16 , vertical: 8),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    color: whiteColor
                                ),
                                child: Text("Edit" , style: utils.boldLabelStyle(checkAdminController.system.mainColor),),
                              ),
                            )
                          ],
                        ),
                        Container(
                          width: 160,
                          height: 150,
                          child: Stack(
                            alignment: Alignment.topCenter,
                            children: [
                              TranslationAnimatedWidget.tween(
                                enabled: true,
                                translationDisabled: Offset(0, -300),
                                translationEnabled: Offset(0, 0),
                                child: Container(
                                  width: 140,
                                  height: 140,
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: whiteColor
                                  ),
                                  child: Center(
                                    child: Container(
                                      width: 130,
                                      height: 130,
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Image.network(userController.user!.image != null? userController.user!.image!:"https://www.nj.com/resizer/zovGSasCaR41h_yUGYHXbVTQW2A=/1280x0/smart/cloudfront-us-east-1.images.arcpublishing.com/advancelocal/SJGKVE5UNVESVCW7BBOHKQCZVE.jpg", fit: BoxFit.cover,),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                  right: 0,
                                  bottom: 0,
                                  child: TranslationAnimatedWidget.tween(
                                    enabled: true,
                                    translationDisabled: Offset(-300, 0),
                                    translationEnabled: Offset(0, 0),
                                    child: GestureDetector(
                                      onTap: (){
                                        _getImage();
                                      },
                                      child: Container(
                                        width: 40,
                                        height: 40,
                                        clipBehavior: Clip.antiAliasWithSaveLayer,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: whiteColor
                                        ),
                                        child: Center(child: Icon(CupertinoIcons.camera_fill , color: checkAdminController.system.mainColor, size: 20,)),
                                      ),
                                    ),
                                  )
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10,),
                        Text("${userController.user!.name}" , style: utils.headingStyle(whiteColor),),
                        Text(userController.user!.phone , style: utils.boldLabelStyle(whiteColor.withOpacity(0.7)),),

                      ],
                    ),
                  ),
                  SizedBox(height: 20,),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 10,),
                        Container(
                            padding: EdgeInsets.symmetric(horizontal: 10 , vertical: 6),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                      color: checkAdminController.system.mainColor,
                                      borderRadius: BorderRadius.circular(12)
                                  ),
                                  child: Center(
                                    child: Icon(CupertinoIcons.mail_solid , color: whiteColor, size: 20,),
                                  ),
                                ),
                                SizedBox(width: 10,),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("Email" , style: utils.labelStyle(blackColor),),
                                      SizedBox(height: 5,),
                                      Text("${userController.user!.email}" , style: utils.labelStyle(blackColor.withOpacity(0.6)),),
                                    ],
                                  ),
                                )
                              ],
                            )
                        ),
                        SizedBox(height: 10,),
                        Container(
                            padding: EdgeInsets.symmetric(horizontal: 10 , vertical: 6),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                      color: checkAdminController.system.mainColor,
                                      borderRadius: BorderRadius.circular(12)
                                  ),
                                  child: Center(
                                    child: Icon(CupertinoIcons.phone_fill , color: whiteColor, size: 20,),
                                  ),
                                ),
                                SizedBox(width: 10,),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("Phone" , style: utils.labelStyle(blackColor),),
                                      SizedBox(height: 5,),
                                      Text("${userController.user!.phone}" , style: utils.labelStyle(blackColor.withOpacity(0.6)),),
                                    ],
                                  ),
                                )
                              ],
                            )
                        ),
                        SizedBox(height: 30,),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  void addToFirebase(String avatar) async {
    FirebaseDatabase database = FirebaseDatabase(databaseURL: databaseUrl);
    
    database.setPersistenceEnabled(true);
    database.setPersistenceCacheSizeBytes(10000000);
    DatabaseReference reference = database.reference();
    await reference
        .child(usersRef)
        .child(FirebaseAuth.instance.currentUser!.uid)
        .update({"image" : avatar});
  }
}