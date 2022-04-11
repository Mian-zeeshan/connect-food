import 'package:connectsaleorder/AppConstants/Constants.dart';
import 'package:connectsaleorder/GetXController/ChatController.dart';
import 'package:connectsaleorder/GetXController/CheckAdminController.dart';
import 'package:connectsaleorder/GetXController/UserController.dart';
import 'package:connectsaleorder/Utils/AppUtils.dart';
import 'package:connectsaleorder/Widgets/chat/ChatMemberItem.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminSupportScreen extends StatefulWidget {
  bool fromWeb;
  AdminSupportScreen({this.fromWeb = false});
  @override
  _AdminSupportScreen createState() => _AdminSupportScreen();
}

class _AdminSupportScreen extends State<AdminSupportScreen> {
  var utils = AppUtils();
  UserController userController = Get.find();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CheckAdminController>(
        id: "0",
        builder: (checkAdminController) {
          return Scaffold(
            backgroundColor: whiteColor,
            resizeToAvoidBottomInset: true,
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
                child: GetBuilder<ChatController>(id: "0", builder: (chatController){
                  chatController.chatModel.chat.sort((a,b)=> a.timeStamp.compareTo(b.timeStamp));
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if(!widget.fromWeb) Container(
                        padding:
                        EdgeInsets.symmetric(horizontal: 15, vertical: 16),
                        decoration: BoxDecoration(
                            color: checkAdminController.system.mainColor),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  Get.back();
                                });
                              },
                              child: Icon(
                                CupertinoIcons.arrow_left,
                                size: 24,
                                color: whiteColor,
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Expanded(
                                child: Text(
                                  "Support",
                                  style: utils.headingStyle(whiteColor),
                                )),
                          ],
                        ),
                      ),
                      Expanded(
                          child: GetBuilder<ChatController>(id: "0",builder: (chatController){
                            chatController.chatModelList.sort((a,b) => b.timestamp.compareTo(a.timestamp));
                            return ListView.builder(
                              scrollDirection: Axis.vertical,
                              itemCount: chatController.chatModelList.length,
                              itemBuilder: (context,i)=> ChatMemberItem(chatController.chatModelList[i],i,chatController.chatModelList.length-1),
                            );
                          })
                      )
                    ],
                  );
                },),
              ),
            ),
          );
        });
  }
}
