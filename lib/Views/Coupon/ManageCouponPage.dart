
import 'package:connectsaleorder/GetXController/CheckAdminController.dart';
import 'package:connectsaleorder/GetXController/Couponcontroller.dart';
import 'package:connectsaleorder/GetXController/UserController.dart';
import 'package:connectsaleorder/Models/CartModel.dart';
import 'package:connectsaleorder/Utils/AppUtils.dart';
import 'package:coupon_uikit/coupon_uikit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

import '../../AppConstants/Constants.dart';
import '../../Models/CouponModel.dart';

class ManageCouponPage extends StatefulWidget{
  @override
  _ManageCouponPage createState() => _ManageCouponPage();
}

class _ManageCouponPage extends State<ManageCouponPage>{

  CheckAdminController checkAdminController = Get.find();
  UserController userController = Get.find();
  var utils = AppUtils();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: GestureDetector(
        onTap: (){
          Get.toNamed(addCouponRoute);
        },
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: checkAdminController.system.mainColor
          ),
          child: Center(
            child: Icon(CupertinoIcons.add, color: whiteColor, size: 24,),
          ),
        ),
      ),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0),
        child: AppBar(
          backgroundColor: checkAdminController.system.mainColor,
        ),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
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
                  Expanded(child: Text("Coupons" , style: utils.headingStyle(whiteColor),)),
                ],
              ),
            ),
            SizedBox(height: 12,),
            Expanded(child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: SingleChildScrollView(
                child: GetBuilder<CouponController>(id: "0", builder: (couponController){
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 12,),
                      Text("All Coupons", style: utils.boldLabelStyle(blackColor),),
                      SizedBox(height: 12,),
                      for(var i = 0; i < couponController.coupons.length; i++)
                        SwipeActionCell(
                            key: ObjectKey(couponController.coupons[i].couponId),///this key is necessary
                            trailingActions: <SwipeAction>[
                              SwipeAction(
                                  backgroundRadius: 12,
                                  widthSpace: 80,
                                  title: "Delete",
                                  onTap: (CompletionHandler handler) async {
                                    couponController.removeCoupon(couponController.coupons[i].couponId);
                                  },
                                  color: Colors.red),
                            ],
                            child: couponCard(couponController.coupons[i])
                        ),

                      if(couponController.coupons.length <= 0) Container(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Lottie.asset('Assets/lottie/searchempty.json'),
                              Text(
                                "No Coupon Available",
                                style: utils
                                    .labelStyle(blackColor.withOpacity(0.5)),
                              ),
                            ]),
                      )
                    ],
                  );
                },),
              ),
            ))
          ],
        ),
      ),
    );
  }

  couponCard(CouponModel couponModel) {
    const Color primaryColor = Color(0xffcbf3f0);
    const Color secondaryColor = Color(0xff368f8b);
    CouponController couponController = Get.find();

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      child: CouponCard(
        height: 120.w,
        backgroundColor: primaryColor,
        curveAxis: Axis.vertical,
        firstChild: Container(
          decoration: const BoxDecoration(
            color: secondaryColor,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        couponModel.discountType == "%" ? "${couponModel.value}%" : "${utils.getFormattedPrice(couponModel.value.toDouble())}",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'OFF',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Divider(color: Colors.white54, height: 0),
              Expanded(
                child: Center(
                    child: InkWell(
                      onTap: (){
                        couponController.removeCoupon(couponModel.couponId);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: whiteColor
                        ),
                        child: Text("Delete", style: utils.boldSmallLabelStyle(secondaryColor),),
                      ),
                    )
                ),
              ),
            ],
          ),
        ),
        secondChild: Container(
          child: Stack(
            children: [
              Container(
                width: Get.width,
                child: Image.network(couponModel.image, fit: BoxFit.cover,),
              ),
              Container(
                width: Get.width,
                height: Get.height,
                decoration: BoxDecoration(
                    color: blackColor.withOpacity(0.3)
                ),
              ),
              Container(
                padding: EdgeInsets.all(18),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Coupon Code',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: whiteColor,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '${couponModel.code}',
                      textAlign: TextAlign.center,
                      style: utils.headingStyle(whiteColor),
                    ),
                    Text(
                      'Valid before - ${DateFormat("dd MMM yyyy").format(DateTime.fromMillisecondsSinceEpoch(couponModel.validBefore))}',
                      textAlign: TextAlign.center,
                      style: utils.xSmallLabelStyle(whiteColor.withOpacity(0.7)),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

}