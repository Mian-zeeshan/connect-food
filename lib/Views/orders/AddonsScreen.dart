import 'package:connectsaleorder/AppConstants/Constants.dart';
import 'package:connectsaleorder/GetXController/BrandController.dart';
import 'package:connectsaleorder/GetXController/CheckAdminController.dart';
import 'package:connectsaleorder/GetXController/ItemController.dart';
import 'package:connectsaleorder/Utils/AppUtils.dart';
import 'package:connectsaleorder/Views/Product/AddAddonScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddonsScreen extends StatefulWidget{
  @override
  _AddonsScreen createState() => _AddonsScreen();

}

class _AddonsScreen extends State<AddonsScreen>{
  var utils = AppUtils();
  var searchController = TextEditingController();
  CheckAdminController checkAdminController = Get.find();


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
          color: whiteColor,
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
                    Expanded(child: Text("Manage Addons" , style: utils.headingStyle(whiteColor),)),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12 , vertical: 12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 8,),
                        utils.textField(whiteColor, null, null,  CupertinoIcons.search, blackColor.withOpacity(0.6), blackColor, "Search...", blackColor.withOpacity(0.5), blackColor.withOpacity(0.6), 2.0, Get.width-12, false, searchController , onTextChange: (val){
                          setData();
                        }),
                        SizedBox(height: 8,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(child: Text("All Addons", style: utils.boldLabelStyle(blackColor),)),
                            GestureDetector(
                                onTap: (){
                                  Get.toNamed(addBrandRoute);
                                },
                                child: Icon(CupertinoIcons.add , color: checkAdminController.system.mainColor, size: 18,)
                            ),
                            SizedBox(width: 6,),
                            GestureDetector(
                                onTap: (){
                                  Get.to(()=> AddAddonScreen());
                                },
                                child: Text("Add Addons", style: utils.smallLabelStyle(checkAdminController.system.mainColor),)),
                          ],
                        ),
                        SizedBox(height: 16,),
                        Container(
                          width: Get.width,
                          child: GetBuilder<ItemController>(id: "0" , builder: (itemController){
                            return Wrap(
                              alignment: WrapAlignment.spaceBetween,
                              children: [
                                for(var i = 0; i < itemController.addons.length; i++)
                                  GestureDetector(
                                    onTap: (){
                                    },
                                    child: Container(
                                      width: Get.width * 0.4,
                                      height: 160,
                                      margin: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8),
                                          color: whiteColor
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: Get.width * 0.4,
                                            height: 140,
                                            clipBehavior: Clip.antiAliasWithSaveLayer,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(8),
                                                color: checkAdminController.system.mainColor
                                            ),
                                            child: Stack(
                                              children: [
                                                Container(
                                                  width: Get.width * 0.4,
                                                  height: 140,
                                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(8),
                                                      color: checkAdminController.system.mainColor
                                                  ),
                                                  child: Image.network(itemController.addons[i].image != null ? itemController.addons[i].image! :"https://s7d2.scene7.com/is/image/Caterpillar/CM20200212-04866-33d60", fit: BoxFit.cover,),
                                                ),
                                                GestureDetector(
                                                  onTap: (){
                                                    Get.to(()=> AddAddonScreen() , arguments: itemController.addons[i]);
                                                  },
                                                  child: Container(
                                                    padding: EdgeInsets.symmetric(horizontal: 6 , vertical: 12),
                                                    margin: EdgeInsets.symmetric(horizontal: 10),
                                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                                    decoration: BoxDecoration(
                                                        color: checkAdminController.system.mainColor,
                                                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30))
                                                    ),
                                                    child: Icon(CupertinoIcons.pen, color: whiteColor, size: 24,),
                                                  ),
                                                ),

                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 5,),
                                          Expanded(child: Text("${itemController.addons[i].adonDescription}" , style: utils.xSmallLabelStyle(blackColor),textAlign: TextAlign.center,overflow: TextOverflow.ellipsis, maxLines: 2,)),
                                        ],
                                      ),
                                    ),
                                  )
                              ],
                            );
                          },),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void setData() {
    setState(() {
    });
  }

}