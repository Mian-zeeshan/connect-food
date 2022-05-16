import 'package:connectsaleorder/AppConstants/Constants.dart';
import 'package:connectsaleorder/GetXController/CartController.dart';
import 'package:connectsaleorder/GetXController/CheckAdminController.dart';
import 'package:connectsaleorder/GetXController/Couponcontroller.dart';
import 'package:connectsaleorder/GetXController/OrderController.dart';
import 'package:connectsaleorder/GetXController/UserController.dart';
import 'package:connectsaleorder/Models/CartModel.dart';
import 'package:connectsaleorder/Models/CouponModel.dart';
import 'package:connectsaleorder/Utils/AppUtils.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class PaymentScreen extends StatefulWidget{
  CartModel postOrderModel;
  PaymentScreen(this.postOrderModel);
  @override
  _PaymentScreen createState() => _PaymentScreen();
}

class _PaymentScreen extends State<PaymentScreen>{
  UserController userController = Get.find();
  var utils = AppUtils();
  var isUsePoints = false;
  CheckAdminController checkAdminController = Get.find();
  CartController cartController = Get.find();
  var insController = TextEditingController();
  
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: Get.width,
                padding: EdgeInsets.symmetric(horizontal: 2, vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(onPressed: (){
                      Get.back();
                    }, icon: Icon(CupertinoIcons.arrow_left , size: 20, color: blackColor,)),
                    Text("Payment Method" , style: utils.labelStyle(blackColor),)
                  ],
                ),
              ),
              Expanded(child: SingleChildScrollView(
                child: Container(
                  width: Get.width,
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: checkAdminController.system.mainColor.withOpacity(0.2)
                          ),
                          child: Text("Choose the payment method you want to proceed with." , style: utils.xSmallLabelStyle(checkAdminController.system.mainColor),)
                      ),
                      SizedBox(height: 12,),
                      utils.textField(whiteColor, null, null, null, null, blackColor, "Instructions", blackColor.withOpacity(0.5), blackColor.withOpacity(0.5), 1.0, Get.width-20, false, insController, multiline: true),
                      SizedBox(height: 12,),
                      Text("Recommended method(s)" , style: utils.smallLabelStyle(blackColor.withOpacity(0.5)),),
                      SizedBox(height: 8,),
                      InkWell(
                        onTap: (){
                          //placeOrder(0);
                        },
                        child: Container(
                            width: Get.width,
                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: whiteColor,
                                boxShadow: [
                                  BoxShadow(
                                      spreadRadius: 2,
                                      blurRadius: 2,
                                      offset: Offset(0,2),
                                      color: blackColor.withOpacity(0.2)
                                  )
                                ]
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(CupertinoIcons.creditcard , size: 32, color: blackColor.withOpacity(0.4),),
                                SizedBox(width: 12,),
                                Expanded(child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("EasyPaisa" , style: utils.boldLabelStyle(blackColor.withOpacity(0.4)),),
                                    SizedBox(height: 2,),
                                    Text("Comming soon..." , style: utils.xSmallLabelStyle(checkAdminController.system.mainColor),),
                                  ],
                                )),
                                Icon(CupertinoIcons.chevron_forward , size: 20, color: blackColor.withOpacity(0.7),),
                              ],
                            )
                        ),
                      ),
                      SizedBox(height: 12,),
                      Text("Payment methods" , style: utils.smallLabelStyle(blackColor.withOpacity(0.5)),),
                      SizedBox(height: 8,),
                      InkWell(
                        onTap: (){
                          placeOrder(1);
                        },
                        child: Container(
                            width: Get.width,
                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: whiteColor,
                                boxShadow: [
                                  BoxShadow(
                                      spreadRadius: 2,
                                      blurRadius: 2,
                                      offset: Offset(0,2),
                                      color: blackColor.withOpacity(0.2)
                                  )
                                ]
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(CupertinoIcons.money_dollar_circle , size: 32, color: blackColor,),
                                SizedBox(width: 12,),
                                Expanded(child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Cash on delivery" , style: utils.boldLabelStyle(blackColor),),
                                    SizedBox(height: 2,),
                                    Text("Cash will be collection while delivering order" , style: utils.xSmallLabelStyle(blackColor.withOpacity(0.6)),),
                                  ],
                                )),
                                Icon(CupertinoIcons.chevron_forward , size: 20, color: blackColor.withOpacity(0.7),),
                              ],
                            )
                        ),
                      ),
                    ],
                  ),
                ),
              )),
              Container(
                width: Get.width,
                height: 0.9,
                color: grayColor,
                margin: EdgeInsets.symmetric(horizontal: 12),
              ),
              SizedBox(height: 6,),
              GetBuilder<CouponController>(id: "0",builder: (couponController){
                if(couponController.selectedCoupon != null){
                  if(couponController.selectedCoupon!.discountType == "%"){
                    widget.postOrderModel.couponValue = (widget.postOrderModel.discountedBill * (couponController.selectedCoupon!.value/100)).toPrecision(2);
                  }else{
                    widget.postOrderModel.couponValue = couponController.selectedCoupon!.value > widget.postOrderModel.discountedBill ? widget.postOrderModel.discountedBill : couponController.selectedCoupon!.value.toDouble();
                  }
                }
                return Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(child: Text(couponController.selectedCoupon == null ? "" : couponController.selectedCoupon!.discountType == "%" ? "Congratulation You got ${couponController.selectedCoupon!.value}% OFF" : "Congratulation You got ${utils.getFormattedPrice(couponController.selectedCoupon!.value.toDouble())} OFF")),
                      InkWell(
                        onTap: (){
                          if(couponController.selectedCoupon == null){
                            Get.toNamed(couponListRoute, arguments: widget.postOrderModel);
                          }else{
                            couponController.setSelectedCoupon(null, true);
                          }
                        },
                        child: Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(couponController.selectedCoupon == null ? "Apply Coupon" : "Remove Coupon", style: utils.xSmallLabelStyle(couponController.selectedCoupon == null ? checkAdminController.system.mainColor : redColor),),
                              SizedBox(width: 6,),
                              Icon(couponController.selectedCoupon == null ? CupertinoIcons.bandage_fill : CupertinoIcons.xmark_octagon_fill, color: couponController.selectedCoupon == null ? checkAdminController.system.mainColor : redColor, size: 16,),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 6,)
                    ],
                  ),
                );
              }),
              Container(
                  width: Get.width,
                  color: whiteColor,
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: Get.width,
                        height: 0.9,
                        color: grayColor,
                      ),
                      SizedBox(height: 4,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("Sub Total" , style: utils.smallLabelStyle(blackColor.withOpacity(0.6)),),
                          Text("${utils.getFormattedPrice(widget.postOrderModel.discountedBill.toDouble())}" , style: utils.smallLabelStyle(blackColor.withOpacity(0.6)),),
                        ],
                      ),
                      SizedBox(height: 4,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("Delivery Charges" , style: utils.smallLabelStyle(blackColor.withOpacity(0.6)),),
                          Text("${utils.getFormattedPrice(widget.postOrderModel.deliveryPrice.toDouble())}" , style: utils.smallLabelStyle(blackColor.withOpacity(0.6)),),
                        ],
                      ),
                      GetBuilder<CouponController>(id: "0", builder: (couponController){
                        if(couponController.selectedCoupon != null){
                          if(couponController.selectedCoupon!.discountType == "%"){
                            widget.postOrderModel.couponValue = (widget.postOrderModel.discountedBill * (couponController.selectedCoupon!.value/100)).toPrecision(2);
                          }else{
                            widget.postOrderModel.couponValue = couponController.selectedCoupon!.value > widget.postOrderModel.discountedBill ? widget.postOrderModel.discountedBill : couponController.selectedCoupon!.value.toDouble();
                          }
                        }
                        return Column(
                          children: [
                            if(widget.postOrderModel.couponValue > 0) SizedBox(height: 4,),
                            if(widget.postOrderModel.couponValue > 0) Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text("Coupon Saved" , style: utils.smallLabelStyle(blackColor.withOpacity(0.6)),),
                                Text("${utils.getFormattedPrice(widget.postOrderModel.couponValue)}" , style: utils.smallLabelStyle(blackColor.withOpacity(0.6)),),
                              ],
                            ),
                            SizedBox(height: 4,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text("Total" , style: utils.boldLabelStyle(checkAdminController.system.mainColor),),
                                Text("${utils.getFormattedPrice((widget.postOrderModel.discountedBill+widget.postOrderModel.deliveryPrice).toDouble() - widget.postOrderModel.couponValue)}" , style: utils.boldLabelStyle(checkAdminController.system.mainColor),),
                              ],
                            )
                          ],
                        );
                      }),
                    ],
                  )
              )
            ],
          ),
        ),
      ),
    );
  }

  void placeOrder(type) async {
    EasyLoading.show(status: "Placing Order...");
    widget.postOrderModel.status = 0;
    OrderController orderController = Get.find();
    FirebaseDatabase database = FirebaseDatabase(databaseURL: databaseUrl);
    if(insController.text.isNotEmpty)
      widget.postOrderModel.instructions = insController.text.toString();
    
    database.setPersistenceEnabled(true);
    database.setPersistenceCacheSizeBytes(10000000);
    DatabaseReference reference = database.reference();
    orderController.sendNotificationAdmin("New Order Received", "Congratulation! you got new order from ${widget.postOrderModel.customer != null ? widget.postOrderModel.customer!.name : ""}(${widget.postOrderModel.customer != null ? widget.postOrderModel.customer!.area : ""})");
    await reference.child(orderCRef)
        .child(widget.postOrderModel.cartId)
        .set(widget.postOrderModel.toJson());
    EasyLoading.dismiss();
    Get.toNamed(orderSuccessRoute, arguments: widget.postOrderModel);
  }
}