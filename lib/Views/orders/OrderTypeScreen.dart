import 'package:connectsaleorder/AppConstants/Constants.dart';
import 'package:connectsaleorder/GetXController/CartController.dart';
import 'package:connectsaleorder/GetXController/CheckAdminController.dart';
import 'package:connectsaleorder/GetXController/OrderController.dart';
import 'package:connectsaleorder/Utils/AppUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderTypeScreen extends StatefulWidget {
  @override
  _OrderTypeScreen createState() => _OrderTypeScreen();
}

class _OrderTypeScreen extends State<OrderTypeScreen> {
  var utils = AppUtils();
  CheckAdminController checkAdminController = Get.find();

  @override
  void initState() {
    super.initState();
  }

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
                  color: whiteColor,
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
                            Text("Select Order Type" , style: utils.headingStyle(blackColor),)
                          ],
                        ),
                      ),
                      SizedBox(height: 20,),
                      InkWell(
                        onTap: (){
                          Get.toNamed(checkoutRoute, arguments: 0);
                        },
                        child: Container(
                          margin: EdgeInsets.all(20),
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: whiteColor,
                            border: Border.all(color: checkAdminController.system.mainColor, width: 2)
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(child: Text("DINE-IN", style: utils.xLHeadingStyle(blackColor),)),
                              Image.asset("Assets/Images/restaurant.png", height: 52,),
                              SizedBox(width: 6,),
                              Icon(CupertinoIcons.chevron_right, color: blackColor,)
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: (){
                          Get.toNamed(checkoutRoute, arguments: 1);
                        },
                        child: Container(
                          margin: EdgeInsets.all(20),
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: whiteColor,
                              border: Border.all(color: checkAdminController.system.mainColor, width: 2)
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(child: Text("Home-Delivery", style: utils.xLHeadingStyle(blackColor),)),
                              Image.asset("Assets/Images/truck.png", height: 52,),
                              SizedBox(width: 6,),
                              Icon(CupertinoIcons.chevron_right, color: blackColor,)
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
        ),
      ),
    );
  }
}
