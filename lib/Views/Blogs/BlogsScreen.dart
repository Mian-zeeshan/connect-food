import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectsaleorder/AppConstants/Constants.dart';
import 'package:connectsaleorder/GetXController/CheckAdminController.dart';
import 'package:connectsaleorder/Utils/AppUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

import '../../GetXController/ItemController.dart';
import '../../Utils/ItemWidgetStyle5.dart';
import '../../Widgets/Blogs/BlogWidget.dart';

class BlogsScreen extends StatefulWidget{
  @override
  _BlogsScreen createState() => _BlogsScreen();
}

class _BlogsScreen extends State<BlogsScreen>{
  var utils = AppUtils();
  ScrollController _scrollController = ScrollController();
  var page = 1;
  ItemController _itemController = Get.find();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        print("Extended");
        page++;
        _itemController.getAllProducts(page);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CheckAdminController>(id: "0", builder: (checkAdminController){
      return Container(
        width: Get.width,
        padding: EdgeInsets.all(12),
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BlogWidget(false),
              SizedBox(height: 12,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Just for you", style: utils.boldLabelStyle(blackColor),),
                ],
              ),
              SizedBox(height: 16,),
              Container(
                width: Get.width,
                child: GetBuilder<ItemController>(id: "0" , builder: (itemController){
                  return itemController.itemModelsAll.isNotEmpty ? GridView.builder(
                    primary: false,
                    shrinkWrap: true,
                    itemCount: itemController.itemModelsAll.length,
                    gridDelegate:
                    SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        crossAxisCount: 2,
                        childAspectRatio: 2 / 3.1),
                    itemBuilder: (context, i) {
                      return /*checkAdminController.system.itemGridStyle.code == "001" ? ItemWidget(itemController.itemModelsAll[i]) : checkAdminController.system.itemGridStyle.code == "002" ? ItemWidgetStyle2(itemController.itemModelsAll[i]) : checkAdminController.system.itemGridStyle.code == "003" ? ItemWidgetStyle3(itemController.itemModelsAll[i]): checkAdminController.system.itemGridStyle.code == "004" ? ItemWidgetStyle4(itemController.itemModelsAll[i]) : checkAdminController.system.itemGridStyle.code == "005" ?*/ ItemWidgetStyle5(itemController.itemModelsAll[i],null) /*: ItemWidget(itemController.itemModelsAll[i])*/;
                    },
                  ) : Center(
                    child: Text("You haven't review any Item Explore now."),
                  );
                },),
              ),
              SizedBox(height: 12,),
            ],
          ),
        ),
      );
    });
  }

}