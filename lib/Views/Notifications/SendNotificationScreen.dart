import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../AppConstants/Constants.dart';
import '../../GetXController/CheckAdminController.dart';
import '../../GetXController/UserController.dart';
import '../../Models/NotificationModel.dart';
import '../../Models/UserModel.dart';
import '../../Utils/AppUtils.dart';
import '../../services/NotificationApis.dart';

class SendNotificationScreen extends StatefulWidget{
  @override
  _SendNotificationScreen createState() => _SendNotificationScreen();

}

class _SendNotificationScreen extends State<SendNotificationScreen>{
  var utils = AppUtils();
  UserController userController = Get.find();
  var titleController = TextEditingController();
  var bodyController = TextEditingController();
  UserModel? selectedUser;
  CheckAdminController checkAdminController = Get.find();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CheckAdminController>(id: "0", builder: (checkAdminController){
      checkAdminController = checkAdminController;
      return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(0),
          child: AppBar(
            backgroundColor: checkAdminController.system.mainColor,
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
                  width: Get.width,
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12),),
                      color: checkAdminController.system.mainColor
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(onPressed: (){
                        Get.back();
                      }, icon: Icon(CupertinoIcons.arrow_left, color: whiteColor,)),
                      Text("Notifications", style: utils.headingStyle(whiteColor),)
                    ],
                  ),
                ),
                Expanded(child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 12,),
                      InkWell(
                        onTap: (){
                          FocusScope.of(context).unfocus();
                          showSearchDialog(context);
                        },
                        child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: blackColor , width: 0.5)
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(child: Text(
                                  selectedUser == null ? "Select User" : selectedUser!.name,
                                  style: utils.smallLabelStyle(blackColor),
                                ),),
                                SizedBox(width: 8,),
                                Icon(CupertinoIcons.chevron_down, color: blackColor, size: 16,)
                              ],
                            )
                        ),
                      ),
                      SizedBox(height: 12,),
                      utils.textField(whiteColor, null, null, null, null, blackColor, "Title", blackColor.withOpacity(0.5), blackColor.withOpacity(0.5), 1.0, Get.width, false, titleController),
                      SizedBox(height: 12,),
                      utils.textField(whiteColor, null, null, null, null, blackColor, "Description", blackColor.withOpacity(0.5), blackColor.withOpacity(0.5), 1.0, Get.width, false, bodyController, multiline: true),
                      SizedBox(height: 12,),
                      utils.button(checkAdminController.system.mainColor, "Send", whiteColor, checkAdminController.system.mainColor, 1.0, (){
                        if(selectedUser ==null){
                          Get.snackbar("Error", "Please select user first");
                          return;
                        }else if(titleController.text.isEmpty){
                          Get.snackbar("Error", "Please add title first");
                          return;
                        }else if(titleController.text.length < 4){
                          Get.snackbar("Error", "Title is too short");
                          return;
                        }else if(bodyController.text.isEmpty){
                          Get.snackbar("Error", "Please add description first");
                          return;
                        }else if(bodyController.text.length < 10){
                          Get.snackbar("Error", "Description is too short must be at least 10 characters.");
                          return;
                        }

                        sendNotification(selectedUser!.uid, "${titleController.text.toString()}", "${bodyController.text.toString()}");
                        titleController.clear();
                        bodyController.clear();
                        selectedUser = null;
                        setData();
                        Get.snackbar("Notification sent", "Notification sent successfully.");
                      })
                    ],
                  ),
                ))
              ],
            ),
          ),
        ),
      );
    });
  }

  showSearchDialog(BuildContext context){
    var searchText = "";
    var searchController = TextEditingController();
    showCupertinoModalBottomSheet(
      enableDrag: true,
      expand: false,
      context: context,
      closeProgressThreshold: 100,
      backgroundColor: whiteColor,
      elevation: 0,
      builder: (context) => StatefulBuilder(builder: (BuildContext context , StateSetter setState){
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 5 , vertical: 12),
          width: double.infinity,
          decoration: BoxDecoration(
              color: whiteColor,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20))
          ),
          constraints: BoxConstraints(
              minWidth: Get.width,
              maxWidth: Get.width,
              minHeight: 0,
              maxHeight: Get.height * 0.5
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 12 , vertical: 5),
                      child: Icon(CupertinoIcons.arrow_left  ,color: blackColor, size: 24,),
                    ),
                  ),
                  SizedBox(width: 12,),
                  Text("Choose User", style: utils.headingStyle(blackColor),)
                ],
              ),
              SizedBox(height: 10,),
              form("Search", searchController , onChange: (val){
                searchText = val;
                setState((){});
              }),
              SizedBox(height: 10,),
              Expanded(child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 12,),
                    for(var i = 0 ; i < userController.users.length; i++)
                      userController.users[i].name.toLowerCase().contains(searchText.toLowerCase()) ?
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16 , vertical: 5),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap :(){
                                selectedUser = userController.users[i];
                                setState((){});
                                setData();
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(color: checkAdminController.system.mainColor , width: 2)
                                    ),
                                    child: Center(
                                      child: Container(
                                        width: 8,
                                        height: 8,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: selectedUser != null && selectedUser!.uid == userController.users[i].uid ? checkAdminController.system.mainColor : Colors.transparent
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 12,),
                                  Expanded(child: Text("${userController.users[i].name}(${userController.users[i].email})" , style: utils.boldLabelStyle(blackColor),))
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                              width: Get.width,
                              height: 1,
                              color: blackColor.withOpacity(0.3),
                            ),
                          ],
                        ),
                      ) : Container()
                  ],
                )
              ))
            ],
          ),
        );
      }),
    );
  }

  Widget form(String hints, TextEditingController controller,{onChange,isMultiline,isNumber, enable}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: blackColor , width: 0.5)
      ),
      child: TextField(
        enabled: enable,
        controller: controller,
        maxLines: isMultiline != null ? 8 : 1,
        keyboardType: isNumber != null ? TextInputType.number : TextInputType.text,
        onChanged: onChange,
        style: utils.smallLabelStyle(blackColor),
        decoration: InputDecoration.collapsed(hintStyle: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 12,
            color: blackColor
        ),
            hintText: hints),
      ),
    );
  }

  setData(){
    if(mounted){
      setState(() {
      });
    }
  }


  sendNotification(uid, title, message) async {
    FirebaseDatabase database = FirebaseDatabase(databaseURL: databaseUrl);

    if(!GetPlatform.isWeb) {
      database.setPersistenceEnabled(true);
      database.setPersistenceCacheSizeBytes(10000000);
    }
    DatabaseReference reference = database.reference();
    reference
        .child(tokenRef)
        .child(uid)
        .onValue
        .listen((event) {
      if (event.snapshot.exists) {
        var token = jsonDecode(jsonEncode(event.snapshot.value))["token"];

        NotificationApis notificationApis = NotificationApis();

        notificationApis.sendNotification(token, title, message);
        sendNotificationAll(title, message);
        addNotification(uid,title,message);
      }
    });
  }

  sendNotificationAll(title, message) async {
    NotificationApis notificationApis = NotificationApis();

    notificationApis.sendNotification("$socialNotifications", title, message);

  }

  void addNotification(uid, title, message) async {
    FirebaseDatabase database = FirebaseDatabase(databaseURL: databaseUrl);
    NotificationModel notificationModel = NotificationModel(title: title, nid: "", body: message, timestamp: DateTime.now().millisecondsSinceEpoch, isRead: true, uid: uid);

    if(!GetPlatform.isWeb) {
      database.setPersistenceEnabled(true);
      database.setPersistenceCacheSizeBytes(10000000);
    }
    DatabaseReference reference = database.reference();
    reference = reference
        .child(notificationRef)
        .child(uid)
        .push();
    notificationModel.nid = reference.key;
    reference.set(notificationModel.toJson());
  }
}