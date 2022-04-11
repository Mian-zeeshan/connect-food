
import 'package:connectsaleorder/AppConstants/Constants.dart';
import 'package:connectsaleorder/GetXController/CheckAdminController.dart';
import 'package:connectsaleorder/GetXController/UserController.dart';
import 'package:connectsaleorder/Models/AddressModel.dart';
import 'package:connectsaleorder/Utils/AppUtils.dart';
import 'package:connectsaleorder/Views/Address/AddressesScreen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:get/get.dart';

import 'AddAddressPage.dart';

class AddressItem extends StatelessWidget{
  var utils = AppUtils();
  CheckAdminController adminController = Get.find();
  AddressModel addressModel;
  UserController _userController = Get.find();
  int type;
  int pos;
  var onPress;
  AddressItem(this.addressModel, this.pos, this.type, this.onPress);

  @override
  Widget build(BuildContext context) {
    return SwipeActionCell(
      isDraggable: type == 0,
      key: ObjectKey(addressModel.id),///this key is necessary
      trailingActions: <SwipeAction>[
        SwipeAction(
            title: " Delete",
            onTap: (CompletionHandler handler) async {
              deleteAddress(pos);
            },
            color: adminController.system.mainColor),
      ],
      child: GetBuilder<UserController>(id: "0", builder: (userController){
        print(userController.user!.defaultAddressId);
        return InkWell(
          onTap: onPress,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 12),
            width: Get.width,
            color: whiteColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(CupertinoIcons.location , size: 20, color: adminController.system.mainColor,),
                SizedBox(width: 8,),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(child: Text("${addressModel.fullName}" , style: utils.smallLabelStyle(blackColor),)),
                          InkWell(
                              onTap: (){
                                if(type == 0) {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) =>
                                          AddAddressPage(1, addressModel)));
                                }else{
                                  Get.toNamed(addressesRoute);
                                }
                              },
                              child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                  child: Text("Edit" , style: utils.labelStyle(adminController.system.mainColor),))),
                        ],
                      ),
                      SizedBox(height: 8,),
                      Text("${addressModel.mobile}" , style: utils.smallLabelStyle(blackColor),),
                      SizedBox(height: 8,),
                      Wrap(
                        alignment: WrapAlignment.start,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: adminController.system.mainColor
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                            child: Text("${addressModel.title}" , style: utils.xSmallLabelStyle(whiteColor),),
                          ),
                          SizedBox(width: 4,),
                          Text("${addressModel.address.length > 34 ? addressModel.address.substring(0,34) : addressModel.address}", style: utils.xSmallLabelStyle(blackColor.withOpacity(0.7)),),
                          if(addressModel.address.length > 34) Text("${addressModel.address.substring(34)}", style: utils.xSmallLabelStyle(blackColor.withOpacity(0.7)),),
                        ],
                      ),
                      SizedBox(height: 4,),
                      Text("${addressModel.area} ${addressModel.city} ${addressModel.province}, ${addressModel.country}", style: utils.xSmallLabelStyle(blackColor.withOpacity(0.7)),),
                      SizedBox(height: 4,),
                      if(addressModel.id == userController.user!.defaultAddressId)Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                            border: Border.all(color: adminController.system.mainColor),
                            borderRadius: BorderRadius.circular(12)
                        ),
                        child: Text("Default Shipping Address", style: utils.xSmallLabelStyle(adminController.system.mainColor),),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },),
    );
  }

  void deleteAddress(int pos) async {
      EasyLoading.show(status: "Loading...");
      var isDefault = false;
      if(_userController.user!.addressList[pos].id == _userController.user!.defaultAddressId){
        isDefault = true;
      }
      _userController.user!.addressList.removeAt(pos);

      FirebaseDatabase database = FirebaseDatabase(databaseURL: databaseUrl);
      
      database.setPersistenceEnabled(true);
      database.setPersistenceCacheSizeBytes(10000000);
      DatabaseReference reference = database.reference();
      await reference
          .child(usersRef)
          .child(_userController.user!.uid)
          .update(_userController.user!.toJsonAddresses());
      if(isDefault){
        await reference
            .child(usersRef)
            .child(_userController.user!.uid)
            .update({"defaultAddressId" : null});
      }
      EasyLoading.dismiss();
  }
}