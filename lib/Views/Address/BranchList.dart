import 'package:connectsaleorder/AppConstants/Constants.dart';
import 'package:connectsaleorder/GetXController/CheckAdminController.dart';
import 'package:connectsaleorder/GetXController/UserController.dart';
import 'package:connectsaleorder/Utils/AppUtils.dart';
import 'package:connectsaleorder/Views/Address/AddAddressPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'BranchItem.dart';

class BranchList extends StatefulWidget{
  @override
  _BranchList createState() => _BranchList();
}

class _BranchList extends State<BranchList>{
  var utils = AppUtils();
  CheckAdminController adminController = Get.find();
  UserController _userController = Get.find();

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return GetBuilder<CheckAdminController>(id: "0",builder: (aController){
      adminController = aController;
      return GetBuilder<UserController>(id:"0", builder: (userController){
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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: Get.width,
                    padding: EdgeInsets.only(right: 12, top: 6, bottom: 6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(onPressed: ()=> Get.back(), icon: Icon(CupertinoIcons.arrow_left , color: blackColor, size: 24,)),
                        SizedBox(width: 12,),
                        Expanded(child: Text("Branches" , style: utils.headingStyle(blackColor),)),
                        //if(!widget.fromSettings) Text("Save" , style: utils.smallLabelStyle(adminController.system.mainColor),)
                      ],
                    ),
                  ),
                  Container(
                    width: Get.width,
                    height: 1,
                    color: grayColor,
                  ),
                  Expanded(child: SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 12,),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: 12,),
                          InkWell(
                            onTap: (){
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) => AddAddressPage(2,null)));
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 24),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: whiteColor,
                                  border: Border.all(color: adminController.system.mainColor),
                                  boxShadow: [
                                    BoxShadow(
                                        spreadRadius: 2,
                                        blurRadius: 12,
                                        offset: Offset(0,2),
                                        color: grayColor.withOpacity(0.3)
                                    )
                                  ]
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(CupertinoIcons.add , size: 24, color: adminController.system.mainColor,),
                                  SizedBox(width: 8,),
                                  Text("Add Branch", style: utils.labelStyle(adminController.system.mainColor),)
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 12,),
                          Container(
                            width: Get.width,
                            height: 1,
                            color: grayColor,
                          ),
                          SizedBox(height: 12,),
                          Container(
                            child: ListView.separated(
                              shrinkWrap: true,
                              physics: ScrollPhysics(),
                              itemBuilder: (context, i) {
                                return BranchItem(adminController.system.branches[i],i);
                              },
                              separatorBuilder: (BuildContext context, int index) {
                                return Container(
                                  margin: EdgeInsets.symmetric(vertical: 10),
                                  width: double.infinity,
                                  height: 1,
                                  color: grayColor,
                                );
                              },
                              itemCount: adminController.system.branches.length,
                            ),
                          )
                        ],
                      ),
                    ),
                  ))
                ],
              ),
            ),
          ),
        );
      });
    });
  }
}