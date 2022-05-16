import 'package:connectsaleorder/AppConstants/Constants.dart';
import 'package:connectsaleorder/GetXController/CartController.dart';
import 'package:connectsaleorder/GetXController/CheckAdminController.dart';
import 'package:connectsaleorder/GetXController/ItemController.dart';
import 'package:connectsaleorder/GetXController/UserController.dart';
import 'package:connectsaleorder/Models/ItemModel.dart';
import 'package:connectsaleorder/Utils/AppUtils.dart';
import 'package:connectsaleorder/Utils/ItemWidget.dart';
import 'package:connectsaleorder/Utils/ItemWidgetStyle2.dart';
import 'package:connectsaleorder/Utils/ItemWidgetStyle3.dart';
import 'package:connectsaleorder/Utils/ItemWidgetStyle4.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../Utils/ItemWidgetStyle5.dart';

class DealProductsScreen extends StatefulWidget{
  bool fromNav;
  DealProductsScreen(this.fromNav);
  @override
  _DealProductsScreen createState() => _DealProductsScreen();

}

class _DealProductsScreen extends State<DealProductsScreen>{
  var utils = AppUtils();
  var deals = ["Top Deals" , "Popular" , "Today Deals"];
  var selected = 0;
  UserController userController = Get.find();
  CheckAdminController checkAdminController = Get.find();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.only(left: widget.fromNav ? 8 : 0 , right: 8, top: widget.fromNav ? 12 : 6, bottom: widget.fromNav ? 12 :6),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12),),
                    color: checkAdminController.system.mainColor
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if(!widget.fromNav) IconButton(
                        onPressed: (){
                          Get.back();
                        },
                        icon: Icon(CupertinoIcons.arrow_left, color: whiteColor, size: 24,)
                    ),
                    Expanded(child: Text("Products".tr, style: utils.headingStyle(whiteColor),)),
                    if(userController.user != null) GestureDetector(
                      onTap : (){
                        Get.toNamed(favoriteRoute);
                      },
                      child: Container(
                        width: 32,
                        height: 32,
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            Icon(CupertinoIcons.heart , color: whiteColor,),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 8,),
                    if(userController.user != null) GestureDetector(
                      onTap : (){
                        if(userController.user != null) {
                          setState(() {
                            Get.toNamed(cartRoute);
                          });
                        }else{
                          utils.loginBottomSheet(context);
                        }
                      },
                      child: Container(
                        width: 32,
                        height: 32,
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            Icon(CupertinoIcons.shopping_cart , color: whiteColor,),
                            Positioned(
                                top: 0,
                                right: 0,
                                child: Container(
                                  width: 18,
                                  height: 18,
                                  padding: EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                      color: redColor,
                                      shape: BoxShape.circle
                                  ),
                                  child: Center(
                                    child: GetBuilder<CartController>(id: "0", builder: (cartController){
                                      return Text("${cartController.myCart.totalItems}" , style: utils.xSmallLabelStyle(whiteColor),);
                                    },),
                                  ),
                                )
                            )
                          ],
                        ),
                      ),
                    ),
                    if(userController.user == null) GestureDetector(
                      onTap : (){
                        utils.loginBottomSheet(context);
                      },
                      child: Container(
                        width: 32,
                        height: 32,
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            Image.asset("Assets/Images/account.png" , color: whiteColor,),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Wrap(
                  alignment: WrapAlignment.start,
                  children: [
                    for(var i = 0 ; i < deals.length; i++)
                      GestureDetector(
                        onTap: (){
                          selected = i;
                          setState(() {
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          margin: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: i == selected ? checkAdminController.system.mainColor : grayColor
                          ),
                          child: Text("${deals[i]}" , style: utils.smallLabelStyle(i == selected ? whiteColor : blackColor),),
                        ),
                      )
                  ],
                ),
              ),
              Expanded(child: SingleChildScrollView(
                child: GetBuilder<ItemController>(id: "0",builder: (itemController){
                  if(itemController.isLoading) {
                    EasyLoading.show(status: "Loading...");
                  }else{
                    EasyLoading.dismiss();
                  }

                  List<ItemModel> items = [];
                    items = selected == 0
                        ? itemController.itemModelsTopDeals
                        : itemController.itemModelsNewArrival;

                    return itemController.itemModels.length > 0 ? Container(
                    width: Get.width,
                    child: Wrap(
                      alignment: WrapAlignment.spaceEvenly,
                      children: [
                        for(var i = 0; i < items.length; i++)
                          Container(
                            width: checkAdminController.system.itemGridStyle.code == "001" ? Get.width * 0.45 : Get.width * 0.4,
                            child: Container(
                              child: checkAdminController.system.itemGridStyle.code == "001" ? ItemWidget(items[i]) : checkAdminController.system.itemGridStyle.code == "002" ? ItemWidgetStyle2(items[i]) : checkAdminController.system.itemGridStyle.code == "003" ? ItemWidgetStyle3(items[i]): checkAdminController.system.itemGridStyle.code == "004" ? ItemWidgetStyle4(items[i]) : checkAdminController.system.itemGridStyle.code == "005" ? ItemWidgetStyle5(items[i], 140.w) : ItemWidget(items[i]),
                            ),
                          )
                      ],
                    ),
                  ) : Container(
                    child: Center(
                      child: Lottie.asset('Assets/lottie/searchempty.json'),
                    ),
                  );
                }),
              )),
              SizedBox(height: 12,)
            ],
          ),
        ),
      ),
    );
  }

}