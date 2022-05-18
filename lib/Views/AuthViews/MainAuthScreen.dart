import 'dart:async';

import 'package:animated_widgets/widgets/size_animated.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectsaleorder/AppConstants/Constants.dart';
import 'package:connectsaleorder/GetXController/CheckAdminController.dart';
import 'package:connectsaleorder/GetXController/DrawerCustomController.dart';
import 'package:connectsaleorder/Utils/AppUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

class MainAuthScreen extends StatefulWidget{
  @override
  _MainAuthScreen createState() => _MainAuthScreen();

}

class _MainAuthScreen extends State<MainAuthScreen>{
  var isShow = true;
  var utils = AppUtils();
  DrawerCustomController drawerCustomController = Get.find();
  CheckAdminController checkAdminController = Get.find();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0),
        child: AppBar(
          backgroundColor: whiteColor,
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
              Expanded(
                flex: 2,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CachedNetworkImage(
                        imageUrl: checkAdminController.system.companyLogo,
                        placeholder: (context, url) => Image.asset("Assets/Images/mo_logo.jpg"),
                        errorWidget: (context, url, error) => Icon(
                          Icons.image_not_supported_rounded,
                          size: 25,
                        ), fit: BoxFit.contain,
                      width: 100.h,
                      height:100.h),
                      Container(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Text("You Order we Deliver!" , style: utils.boldLabelStyle(blackColor),))
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      utils.button(checkAdminController.system.mainColor , "LOG IN" , whiteColor , checkAdminController.system.mainColor , 2.0 , (){
                        Get.toNamed(loginRoute);
                      }),
                      SizedBox(height: 20.h,),
                      utils.button(Colors.transparent , "SIGN UP" , blackColor , checkAdminController.system.mainColor , 2.0 , (){
                        Get.toNamed(signUpRoute);
                      }),
                      SizedBox(height: 20.h,),
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
                            Text(" OR " , style: utils.labelStyle(blackColor),),
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
                      SizedBox(height: 20.h,)
                    ],
                  ),
                ),
              ),
            ],
          )
        ),
      ),
    );
  }

}