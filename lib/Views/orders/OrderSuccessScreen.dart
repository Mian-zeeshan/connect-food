import 'package:connectsaleorder/AppConstants/Constants.dart';
import 'package:connectsaleorder/GetXController/CartController.dart';
import 'package:connectsaleorder/GetXController/CheckAdminController.dart';
import 'package:connectsaleorder/GetXController/OrderController.dart';
import 'package:connectsaleorder/Models/CartModel.dart';
import 'package:connectsaleorder/Utils/AppUtils.dart';
import 'package:connectsaleorder/Views/orders/OrderDetailScreen.dart';
import 'package:cr_calendar/cr_calendar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class OrderSuccessScreen extends StatefulWidget {
  @override
  _OrderSuccessScreen createState() => _OrderSuccessScreen();
}

class _OrderSuccessScreen extends State<OrderSuccessScreen> {
  var utils = AppUtils();
  CheckAdminController checkAdminController = Get.find();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(0),
          child: AppBar(
            elevation: 0,
            backgroundColor: checkAdminController.system.mainColor,
          ),
        ),
        body: SafeArea(
          child: GetBuilder<OrderController>(
              id: "0",
              builder: (orderController) {
                return Container(
                  width: Get.width,
                  height: Get.height,
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  color: whiteColor,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(CupertinoIcons.check_mark_circled_solid , color: greenColor, size: 56,),
                      SizedBox(height: 12,),
                      Text("Order placed successfully" , style: utils.boldLabelStyle(blackColor),),
                      SizedBox(height: 12,),
                      utils.button(checkAdminController.system.mainColor, "Go to Orders", whiteColor, checkAdminController.system.mainColor, 1.0, (){
                        Get.offAllNamed(homeCRoute , arguments: 1);
                      }),
                      SizedBox(height: 12,),
                      utils.button(whiteColor, "Go to Home", checkAdminController.system.mainColor, checkAdminController.system.mainColor, 2.0, (){
                        Get.offAllNamed(homeCRoute);
                      })
                    ],
                  ),
                );
              }),
        ),
      ),
    );
  }
}
