
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
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../AppConstants/Constants.dart';
import '../../Models/CouponModel.dart';

class CouponListPage extends StatefulWidget{
  @override
  _CouponListPage createState() => _CouponListPage();
}

class _CouponListPage extends State<CouponListPage>{

  CheckAdminController checkAdminController = Get.find();
  UserController userController = Get.find();
  var utils = AppUtils();
  var searchController = TextEditingController();
  CartModel cartModel = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            GetBuilder<CouponController>(id: "0",builder: (couponController){
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(child: utils.textField(Colors.transparent, null, null, null, blackColor, blackColor, "Coupon Code", blackColor.withOpacity(0.5), blackColor.withOpacity(0.7), 2.0, Get.width, false, searchController),),
                    SizedBox(width: 12,),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: checkAdminController.system.mainColor
                      ),
                      child: TextButton(
                        onPressed: (){
                          CouponModel coupon = couponController.getCoupon(searchController.text.toString());
                          if(coupon.validFrom <= DateTime.now().millisecondsSinceEpoch){
                            if(coupon.validBefore >= DateTime.now().millisecondsSinceEpoch){
                              if(cartModel.discountedBill >= double.parse(coupon.maxOrderPrice.toString())){
                                couponController.setSelectedCoupon(coupon, true);
                                Get.back();
                              }else{
                                Get.snackbar("Error", "Order value should be greater than ${coupon.maxOrderPrice}");
                              }
                            }else{
                              Get.snackbar("Error", "Coupon is expired.");
                            }
                          }else{
                            Get.snackbar("Error", "Coupon is not available yet.");
                          }
                          couponController.stopLoading();
                        },
                        child: couponController.loadingCoupon ? CircularProgressIndicator(color: whiteColor,) :Text("Apply", style: utils.smallLabelStyle(whiteColor),),
                      ),
                    )
                  ],
                ),
              );
            }),
            SizedBox(height: 8,),
            Container(
              width: Get.width,
              height: 0.9,
              color: grayColor,
              margin: EdgeInsets.symmetric(horizontal: 12),
            ),
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
                        couponCard(couponController.coupons[i])
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
                      Clipboard.setData(ClipboardData(text: "${couponModel.code}")).then((value){
                        utils.snackBar(context, message: "Copied");
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: whiteColor
                      ),
                      child: Text("Copy", style: utils.boldSmallLabelStyle(secondaryColor),),
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