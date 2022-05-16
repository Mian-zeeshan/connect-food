import 'dart:async';

import 'package:bubble/bubble.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:connectsaleorder/AppConstants/Constants.dart';
import 'package:connectsaleorder/GetXController/ChatController.dart';
import 'package:connectsaleorder/GetXController/CheckAdminController.dart';
import 'package:connectsaleorder/GetXController/UserController.dart';
import 'package:connectsaleorder/Utils/AppUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../Product/ProductDetailScreen.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreen createState() => _ChatScreen();
}

class _ChatScreen extends State<ChatScreen> {
  var utils = AppUtils();
  UserController userController = Get.find();
  var messageController = TextEditingController();
  int type = Get.arguments;
  ScrollController _scrollControllerUser = ScrollController();
  ScrollController _scrollControllerAdmin = ScrollController();

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
              ),
            ),
            body: SafeArea(
              child: Container(
                width: Get.width,
                height: Get.height,
                child: GetBuilder<ChatController>(id: "0", builder: (chatController){
                  chatController.chatModel.chat.sort((a,b)=> a.timeStamp.compareTo(b.timeStamp));
                  Timer.periodic(Duration(milliseconds: 500), (timer) {
                    timer.cancel();
                    if(type == 0) {
                      if(_scrollControllerUser.hasClients) {
                        _scrollControllerUser.animateTo(
                          _scrollControllerUser.position.maxScrollExtent,
                          duration: Duration(seconds: 2),
                          curve: Curves.fastOutSlowIn,
                        );
                      }
                    }else {
                      if(_scrollControllerAdmin.hasClients) {
                        _scrollControllerAdmin.animateTo(
                          _scrollControllerAdmin.position.maxScrollExtent,
                          duration: Duration(seconds: 2),
                          curve: Curves.fastOutSlowIn,
                        );
                      }
                    }
                  });
                  return type == 0 ? Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
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
                          child: Container(
                            color: grayColor.withOpacity(0.3),
                            child: ListView.separated(
                              controller: _scrollControllerUser,
                              itemBuilder: (context, i) => Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Visibility(
                                    visible: i > 0 ? DateTime.fromMillisecondsSinceEpoch(chatController.chatModel.chat[i-1].timeStamp).day != DateTime.fromMillisecondsSinceEpoch(chatController.chatModel.chat[i].timeStamp).day:true,
                                    child: Bubble(
                                      color: grayColor,
                                      child: Text(DateFormat("dd MMM, yyyy").format(DateTime.fromMillisecondsSinceEpoch(chatController.chatModel.chat[i].timeStamp)),
                                          textAlign: TextAlign.center,
                                          style: utils.xSmallLabelStyle(blackColor)),
                                      nip: BubbleNip.no,
                                      margin: BubbleEdges.symmetric(horizontal: 12),
                                      padding: BubbleEdges.symmetric(
                                          horizontal: 6, vertical: 2),
                                      alignment: Alignment.center,
                                    ),
                                  ),
                                  if(chatController.chatModel.chat[i].enquiryProduct != null) Bubble(
                                    color: whiteColor,
                                    child: InkWell(
                                      onTap: (){
                                        Get.to(()=> ProductDetailScreen(), routeName: "${chatController.chatModel.chat[i].enquiryProduct!.code}", arguments: chatController.chatModel.chat[i].enquiryProduct);
                                      },
                                      child: Container(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text("Hello, I want to enquire about your below product" , style: utils.xSmallLabelStyle(blackColor),),
                                            Text("${chatController.chatModel.chat[i].enquiryProduct!.name}" , style: utils.xSmallLabelStyle(checkAdminController.system.mainColor),),
                                            Text("${utils.getFormattedPrice(chatController.chatModel.chat[i].enquiryProduct!.salesRate)}" , style: utils.xSmallLabelStyle(blackColor),),
                                            CachedNetworkImage(
                                                imageUrl: chatController.chatModel.chat[i].enquiryProduct!.images.length > 0 ? chatController.chatModel.chat[i].enquiryProduct!.images[0] : "",
                                              errorWidget: (context, url , _) => Icon(CupertinoIcons.info , color: redColor, size: 32,),
                                              placeholder: (context, url)=> SpinKitRotatingCircle(color: checkAdminController.system.mainColor,),
                                              width: Get.width * 0.5,
                                            ),
                                            SizedBox(height: 4,),
                                          ],
                                        ),
                                      ),
                                    ),
                                    nip: BubbleNip.no,
                                    margin: BubbleEdges.symmetric(horizontal: 12, vertical: 12),
                                    padding: BubbleEdges.symmetric(
                                        horizontal: 6, vertical: 12),
                                    alignment: Alignment.centerRight,
                                  ),
                                  if(chatController.chatModel.chat[i].message != null) BubbleSpecialOne(
                                    text: '${chatController.chatModel.chat[i].message??""}',
                                    isSender: chatController.chatModel.chat[i].senderId == userController.user!.uid,
                                    color:  chatController.chatModel.chat[i].senderId == userController.user!.uid ? whiteColor : checkAdminController.system.mainColor,
                                    textStyle: utils.smallLabelStyle(chatController.chatModel.chat[i].senderId == userController.user!.uid ? blackColor : whiteColor),
                                  ),
                                ],
                              ),
                              separatorBuilder: (context, i) => SizedBox(
                                height: 12,
                              ),
                              itemCount: chatController.chatModel.chat.length,
                              reverse: false,),
                          )),
                      SizedBox(height: 4,),
                      Container(
                        width: Get.width,
                        decoration: BoxDecoration(color: whiteColor),
                        padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: TextField(
                                controller: messageController,
                                style: utils.labelStyle(blackColor),
                                decoration: InputDecoration.collapsed(
                                    hintText: "Enter text here...",
                                    hintStyle: utils.smallLabelStyle(grayColor)),
                              ),
                            ),
                            SizedBox(
                              width: 12,
                            ),
                            IconButton(
                                onPressed: () {
                                  if(messageController.text.isNotEmpty){
                                    chatController.sendMessage(messageController.text.toString(), null, null, null,userController.user!.uid , "admin");
                                    messageController.text = "";
                                    messageController.clear();
                                  }
                                },
                                icon: Icon(
                                  CupertinoIcons.arrow_right_circle_fill,
                                  color: checkAdminController.system.mainColor,
                                  size: 26,
                                ))
                          ],
                        ),
                      )
                    ],
                  ) : Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding:
                        EdgeInsets.symmetric(horizontal: 15, vertical: 16),
                        decoration: BoxDecoration(
                            color: checkAdminController.system.mainColor),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {
                                  Get.back();
                              },
                              child: Container(
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100)
                                ),
                                child: Wrap(
                                  alignment: WrapAlignment.start,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    Icon(
                                      CupertinoIcons.arrow_left,
                                      size: 24,
                                      color: whiteColor,
                                    ),
                                    SizedBox(
                                      width: 6,
                                    ),
                                    Container(
                                      width: 30,
                                      height: 30,
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: checkAdminController.system.mainColor,
                                      ),
                                      child: CachedNetworkImage(
                                        imageUrl: chatController.selectedChatModel.image??"",
                                        errorWidget: (context, url , _) => Icon(CupertinoIcons.info , color: redColor, size: 32,),
                                        placeholder: (context, url)=> SpinKitRotatingCircle(color: checkAdminController.system.mainColor,),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                                child: Text(
                                  "${chatController.selectedChatModel.name}",
                                  style: utils.boldLabelStyle(whiteColor),
                                )),
                          ],
                        ),
                      ),
                      Expanded(
                          child: Container(
                            color: grayColor.withOpacity(0.3),
                            child: ListView.separated(
                              controller: _scrollControllerAdmin,
                              itemBuilder: (context, i) => Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Visibility(
                                    visible: i > 0 ? DateTime.fromMillisecondsSinceEpoch(chatController.currentChat[i-1].timeStamp).day != DateTime.fromMillisecondsSinceEpoch(chatController.currentChat[i].timeStamp).day:true,
                                    child: Bubble(
                                      color: grayColor,
                                      child: Text(DateFormat("dd MMM, yyyy").format(DateTime.fromMillisecondsSinceEpoch(chatController.currentChat[i].timeStamp)),
                                          textAlign: TextAlign.center,
                                          style: utils.xSmallLabelStyle(blackColor)),
                                      nip: BubbleNip.no,
                                      margin: BubbleEdges.symmetric(horizontal: 12),
                                      padding: BubbleEdges.symmetric(
                                          horizontal: 6, vertical: 2),
                                      alignment: Alignment.center,
                                    ),
                                  ),
                                  if(chatController.currentChat[i].enquiryProduct != null) Bubble(
                                    color: whiteColor,
                                    child: InkWell(
                                      onTap: (){
                                        Get.to(()=> ProductDetailScreen(), arguments: chatController.chatModel.chat[i].enquiryProduct);
                                      },
                                      child: Container(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text("Hello, I want to enquire about your below product" , style: utils.xSmallLabelStyle(blackColor),),
                                            Text("${chatController.currentChat[i].enquiryProduct!.name}" , style: utils.xSmallLabelStyle(checkAdminController.system.mainColor),),
                                            Text("${utils.getFormattedPrice(chatController.currentChat[i].enquiryProduct!.salesRate)}" , style: utils.xSmallLabelStyle(blackColor),),
                                            CachedNetworkImage(
                                                imageUrl: chatController.currentChat[i].enquiryProduct!.images.length > 0 ? chatController.currentChat[i].enquiryProduct!.images[0] : "",
                                              errorWidget: (context, url , _) => Icon(CupertinoIcons.info , color: redColor, size: 32,),
                                              placeholder: (context, url)=> SpinKitRotatingCircle(color: checkAdminController.system.mainColor,),
                                              width: Get.width * 0.5,
                                            ),
                                            SizedBox(height: 4,),
                                          ],
                                        ),
                                      ),
                                    ),
                                    nip: BubbleNip.no,
                                    margin: BubbleEdges.symmetric(horizontal: 12, vertical: 12),
                                    padding: BubbleEdges.symmetric(
                                        horizontal: 6, vertical: 12),
                                    alignment: Alignment.centerLeft,
                                  ),
                                  if(chatController.currentChat[i].message != null) BubbleSpecialOne(
                                    text: '${chatController.currentChat[i].message??""}',
                                    isSender: chatController.currentChat[i].senderId == "admin",
                                    color:  chatController.currentChat[i].senderId == "admin" ? whiteColor : checkAdminController.system.mainColor,
                                    textStyle: utils.smallLabelStyle(chatController.currentChat[i].senderId == "admin" ? blackColor : whiteColor),
                                  ),
                                ],
                              ),
                              separatorBuilder: (context, i) => SizedBox(
                                height: 12,
                              ),
                              itemCount: chatController.currentChat.length,
                              reverse: false,),
                          )),
                      SizedBox(height: 4,),
                      Container(
                        width: Get.width,
                        decoration: BoxDecoration(color: whiteColor),
                        padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: TextField(
                                controller: messageController,
                                style: utils.labelStyle(blackColor),
                                decoration: InputDecoration.collapsed(
                                    hintText: "Enter text here...",
                                    hintStyle: utils.smallLabelStyle(grayColor)),
                              ),
                            ),
                            SizedBox(
                              width: 12,
                            ),
                            IconButton(
                                onPressed: () {
                                  if(messageController.text.isNotEmpty){
                                    chatController.sendMessageAdmin(messageController.text.toString(), null, null, null,"admin" , chatController.selectedChatModel.uid, chatController.selectedChatModel);
                                    messageController.text = "";
                                    messageController.clear();
                                  }
                                },
                                icon: Icon(
                                  CupertinoIcons.arrow_right_circle_fill,
                                  color: checkAdminController.system.mainColor,
                                  size: 26,
                                ))
                          ],
                        ),
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
