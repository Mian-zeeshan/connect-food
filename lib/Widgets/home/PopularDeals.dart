import 'package:connectsaleorder/GetXController/CheckAdminController.dart';
import 'package:connectsaleorder/GetXController/DrawerCustomController.dart';
import 'package:connectsaleorder/Utils/AppUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../AppConstants/Constants.dart';
import '../../GetXController/ItemController.dart';
import '../../Utils/ItemWidget.dart';
import '../../Utils/ItemWidgetStyle2.dart';
import '../../Utils/ItemWidgetStyle3.dart';
import '../../Utils/ItemWidgetStyle4.dart';
import '../../Utils/ItemWidgetStyle5.dart';

class PopularDeals extends StatefulWidget{
  String title;
  String skipCode = "-1";
  PopularDeals(this.title, {this.skipCode = "-1"});
  @override
  _PopularDeals createState() => _PopularDeals();
}

class _PopularDeals extends State<PopularDeals>{
  CheckAdminController checkAdminController = Get.find();
  DrawerCustomController drawerCustomController = Get.find();
  var utils = AppUtils();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("${widget.title}", style: utils.boldLabelStyle(blackColor),),
            GestureDetector(
                onTap: (){
                  if(checkAdminController.system.bottomNavigationChecks.isDeals) {
                    drawerCustomController.setDrawer("categories", 3);
                  }else{
                    Get.toNamed(dealProductsRoute);
                  }
                },
                child: Container(
                    padding: EdgeInsets.only(left: 16),
                    child: Text("VIEW ALL", style: utils.xSmallLabelStyle(checkAdminController.system.mainColor),))
            ),
          ],
        ),
        SizedBox(height: 10.h,),
        Container(
          width: Get.width,
          child: GetBuilder<ItemController>(id: "0" , builder: (itemController){
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for(var item in itemController.itemModelsNewArrival)
                    if(item.code != widget.skipCode) Container(
                      child: checkAdminController.system.itemGridStyle.code == "001" ? ItemWidget(item) : checkAdminController.system.itemGridStyle.code == "002" ? ItemWidgetStyle2(item) : checkAdminController.system.itemGridStyle.code == "003" ? ItemWidgetStyle3(item): checkAdminController.system.itemGridStyle.code == "004" ? ItemWidgetStyle4(item) : checkAdminController.system.itemGridStyle.code == "005" ? ItemWidgetStyle5(item, 140.w) : ItemWidget(item),
                    )
                ],
              ),
            );
          },),
        ),
      ],
    );
  }

}