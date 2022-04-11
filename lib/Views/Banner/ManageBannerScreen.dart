import 'dart:io';

import 'package:connectsaleorder/AppConstants/Constants.dart';
import 'package:connectsaleorder/GetXController/BannerController.dart';
import 'package:connectsaleorder/GetXController/CheckAdminController.dart';
import 'package:connectsaleorder/Models/BannerModel.dart';
import 'package:connectsaleorder/Utils/AppUtils.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_swipe_action_cell/flutter_swipe_action_cell.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;


class ManageBannerScreen extends StatefulWidget{
  bool fromWeb;
  ManageBannerScreen({this.fromWeb = false});
  @override
  _ManageBannerScreen createState() => _ManageBannerScreen();

}

class _ManageBannerScreen extends State<ManageBannerScreen>{
  var utils = AppUtils();

  BannerController __bannerController = Get.find();
  CheckAdminController checkAdminController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0),
        child: AppBar(
          backgroundColor: checkAdminController.system.mainColor,
          elevation: 0,
        ),
      ),
      body: SafeArea(
        child: Container(
          width: Get.width,
          height: Get.height,
          color: whiteColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if(!widget.fromWeb) Container(
                padding: EdgeInsets.symmetric(horizontal: 15 , vertical: 16),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12),),
                    color: checkAdminController.system.mainColor
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap : (){
                        setState(() {
                          Get.back();
                        });
                      },
                      child: Icon(CupertinoIcons.arrow_left, size: 24, color: whiteColor,),
                    ),
                    SizedBox(width: 20,),
                    Expanded(child: Text("Manage Banners" , style: utils.headingStyle(whiteColor),)),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12 , vertical: 12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 8,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(child: Text("Banners", style: utils.boldLabelStyle(blackColor),)),
                            GestureDetector(
                                onTap: (){
                                  Get.toNamed(addBannerRoute);
                                },
                                child: Icon(CupertinoIcons.add , color: checkAdminController.system.mainColor, size: 18,)
                            ),
                            SizedBox(width: 6,),
                            GestureDetector(
                                onTap: (){
                                  Get.toNamed(addBannerRoute);
                                },
                                child: Text("Add Banners", style: utils.smallLabelStyle(checkAdminController.system.mainColor),)),
                          ],
                        ),
                        SizedBox(height: 16,),
                        Container(
                          width: Get.width,
                          child: GetBuilder<BannerController>(id: "0" , builder: (bannerController){
                            return Wrap(
                              alignment: WrapAlignment.spaceBetween,
                              children: [
                                for(var i = 0; i < bannerController.banners.length; i++)
                                  SwipeActionCell(
                                    key: ObjectKey(bannerController.banners[i].key),///this key is necessary
                                    trailingActions: <SwipeAction>[
                                      SwipeAction(
                                          backgroundRadius: 12,
                                          widthSpace: 80,
                                          title: "Delete",
                                          onTap: (CompletionHandler handler) async {
                                            removeBanner(bannerController.banners[i]);
                                          },
                                          color: Colors.red),
                                    ],
                                    child: Container(
                                      width: Get.width * 0.9,
                                      height: Get.height/5,
                                      margin: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8),
                                          color: whiteColor
                                      ),
                                      child: Image.network(bannerController.banners[i].image, fit: BoxFit.cover,),
                                    ),
                                  ),
                              ],
                            );
                          },),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void removeBanner(BannerModel banner) async {
    EasyLoading.show(status: "Loading...");

    FirebaseDatabase database = FirebaseDatabase(databaseURL: databaseUrl);
    
    database.setPersistenceEnabled(true);
    database.setPersistenceCacheSizeBytes(10000000);
    DatabaseReference reference = database.reference();
    await reference.child(bannerRef).child(banner.key).remove();
    EasyLoading.dismiss();
    Get.snackbar("Success", "Banner Deleted!");
  }

}