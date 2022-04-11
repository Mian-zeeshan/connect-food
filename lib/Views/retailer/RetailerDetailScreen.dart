import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectsaleorder/AppConstants/Constants.dart';
import 'package:connectsaleorder/GetXController/ChatController.dart';
import 'package:connectsaleorder/GetXController/CheckAdminController.dart';
import 'package:connectsaleorder/GetXController/UserController.dart';
import 'package:connectsaleorder/Models/ChatModel.dart';
import 'package:connectsaleorder/Utils/AppUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class RetailerDetailScreen extends StatefulWidget{
  RetailerDetailScreen();
  @override
  _RetailerDetailScreen createState() => _RetailerDetailScreen();

}

class _RetailerDetailScreen extends State<RetailerDetailScreen>{
  var utils = AppUtils();
  CheckAdminController adminController = Get.find();
  ChatController chatController = Get.find();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CheckAdminController>(id: "0",builder: (checkAController){
      adminController = checkAController;
      return Scaffold(
        backgroundColor: whiteColor,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(0),
          child: AppBar(
            backgroundColor: checkAController.system.mainColor,
            elevation: 0,
          ),
        ),
        body: SafeArea(
          child: GetBuilder<UserController>(id: "0",builder: (userController){
            return userController.currentSeller != null ? Container(
            width: Get.width,
            height: Get.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: Get.width,
                  padding: EdgeInsets.symmetric(horizontal: 2, vertical: 4),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
                      color: checkAController.system.mainColor
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(onPressed: (){
                        Get.back();
                      }, icon: Icon(CupertinoIcons.arrow_left , color: whiteColor,)),
                      Expanded(child: Text("${userController.currentSeller!.retailerModel!.shopName}", style: utils.headingStyle(whiteColor),))
                    ],
                  ),
                ),
                Expanded(child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 12.h,),
                      Container(
                        width: 120.w,
                        height: 120.w,
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: checkAController.system.mainColor
                        ),
                        child: CachedNetworkImage(
                            imageUrl: userController.currentSeller!.image??"",
                            placeholder: (context, url) => SpinKitRotatingCircle(color: whiteColor,),
                            errorWidget: (context, url, error) => Icon(
                              Icons.image_not_supported_rounded,
                              color: whiteColor,
                              size: 25.h,
                            ), fit: BoxFit.cover),
                      ),
                      SizedBox(height: 6.h,),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: userController.currentSeller!.retailerModel!.approved ? greenColor.withOpacity(0.3) : redColor.withOpacity(0.3)
                        ),
                        child: Text("${userController.currentSeller!.retailerModel!.approved ? "Approved" : "Not Approved"}", style: utils.xSmallLabelStyle(userController.currentSeller!.retailerModel!.approved ? greenColor : redColor),),
                      ),
                      SizedBox(height: 12.h,),
                      Container(
                        width: Get.width,
                        height: 0.5,
                        color: grayColor,
                      ),
                      SizedBox(height: 6.h,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap : (){
                              if(!userController.currentSeller!.retailerModel!.approved) {
                                Get.snackbar("Opps", "Already rejected!");
                              }else{
                                userController.changeApproval(
                                    false, userController.currentSeller!.uid);
                              }
                            },
                            child: Container(
                              width: 100.w,
                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              margin: EdgeInsets.only(right: 6.w),
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.w),
                                color: whiteColor,
                                border: Border.all(color: redColor, width: 2)
                              ),
                              child: Center(
                                child: Text("Reject" , style: utils.smallLabelStyle(redColor),),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap : (){
                              if(userController.currentSeller!.retailerModel!.approved) {
                                Get.snackbar("Opps", "Already approved!");
                              }else{
                                userController.changeApproval(
                                    true, userController.currentSeller!.uid);
                              }
                            },
                            child: Container(
                              width: 100.w,
                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              margin: EdgeInsets.only(left: 6.w),
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.w),
                                color: greenColor,
                                border: Border.all(color: greenColor, width: 2)
                              ),
                              child: Center(
                                child: Text("Accept" , style: utils.smallLabelStyle(whiteColor),),
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 6.h,),
                      Container(
                        width: Get.width,
                        height: 0.5,
                        color: grayColor,
                      ),
                      Container(
                        width: Get.width,
                        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Retailer Detail" , style: utils.boldSmallLabelStyle(blackColor.withOpacity(0.8)),),
                            SizedBox(height: 12.h,),
                            tableForm("Shop Name" , userController.currentSeller!.retailerModel!.shopName),
                            tableForm("Phone" , userController.currentSeller!.retailerModel!.phone),
                            tableForm("Contact Person" , userController.currentSeller!.retailerModel!.contactPerson),
                            tableForm("Mobile" , userController.currentSeller!.retailerModel!.contactPersonPhone),
                            tableForm("City" , "${userController.currentSeller!.retailerModel!.area} ${userController.currentSeller!.retailerModel!.city}, ${userController.currentSeller!.retailerModel!.country}"),
                            tableForm("Address" , "${userController.currentSeller!.retailerModel!.address}"),
                            SizedBox(height: 12.h,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: InkWell(
                                    onTap : (){
                                      launch("tel://${userController.currentSeller!.retailerModel!.contactPersonPhone}");
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                      margin: EdgeInsets.only(right: 6.w),
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8.w),
                                          color: whiteColor,
                                          border: Border.all(color: checkAController.system.mainColor, width: 2)
                                      ),
                                      child: Center(
                                        child: Text("Call" , style: utils.smallLabelStyle(checkAController.system.mainColor),),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: InkWell(
                                    onTap: () async {
                                      EasyLoading.show(status: "Loading...");
                                      ChatModel? chatModel = await chatController.getSupportChatById(userController.currentSeller!.uid);
                                      EasyLoading.dismiss();
                                      if(chatModel != null){
                                        chatController.getSupportChatCurrent(chatModel);
                                        Get.toNamed(chatRoute , arguments: 1);
                                      }else{
                                        Get.snackbar("Opps!", "User is not available or deleted!");
                                      }
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                      margin: EdgeInsets.only(left: 6.w),
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8.w),
                                          color: checkAController.system.mainColor,
                                          border: Border.all(color: checkAController.system.mainColor, width: 2)
                                      ),
                                      child: Center(
                                        child: Text("Chat" , style: utils.smallLabelStyle(whiteColor),),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ))
              ],
            )) : Container(
              width: Get.width,
              height: Get.height,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          })
        ),
      );
    });
  }

  tableForm(title, value) {
    return Container(
      width: Get.width,
      padding: EdgeInsets.symmetric(horizontal: 2, vertical: 6),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: Text("$title", style: utils.boldSmallLabelStyle(blackColor),)),
              SizedBox(width: 6.w,),
              Text(":", style: utils.boldSmallLabelStyle(blackColor),),
              SizedBox(width: 6.w,),
              Expanded(child: Text("$value", style: utils.smallLabelStyle(blackColor),)),
            ],
          ),
          SizedBox(height: 6.h,),
          Container(
            width: Get.width,
            height: 0.5,
            color: grayColor,
          ),
        ],
      ),
    );
  }
}