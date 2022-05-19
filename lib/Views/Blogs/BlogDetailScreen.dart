import 'package:connectsaleorder/AppConstants/Constants.dart';
import 'package:connectsaleorder/GetXController/CheckAdminController.dart';
import 'package:connectsaleorder/Utils/AppUtils.dart';
import 'package:connectsaleorder/Widgets/Blogs/BlogWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BlogDetailScreen extends StatefulWidget {
  @override
  _BlogDetailScreen createState() => _BlogDetailScreen();
}

class _BlogDetailScreen extends State<BlogDetailScreen> {
  var utils = AppUtils();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CheckAdminController>(
        id: "0", builder: (checkAdminController) {
      return Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(0),
            child: AppBar(
              backgroundColor: checkAdminController.system.mainColor,
              elevation: 0,
            ),
          ),
          backgroundColor: whiteColor,
          body: SafeArea(
            child: Container(
              width: Get.width,
              height: Get.height,
              child: Column(
                children: [
                  Container(
                    width: Get.width,
                    padding: EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20),),
                      color: checkAdminController.system.mainColor
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(onPressed: (){
                          Get.back();
                        }, icon: Icon(CupertinoIcons.arrow_left, color: whiteColor,)),
                        SizedBox(width: 4,),
                        Text("Blogs", style: utils.boldLabelStyle(whiteColor),),
                      ],
                    ),
                  ),
                  Expanded(child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    child: SingleChildScrollView(
                      child: BlogWidget(true),
                    ),
                  ))
                ],
              ),
            ),
          ),
      );
    });
  }

}