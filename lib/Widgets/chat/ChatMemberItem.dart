import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectsaleorder/AppConstants/Constants.dart';
import 'package:connectsaleorder/AppConstants/TimeAgo.dart';
import 'package:connectsaleorder/GetXController/ChatController.dart';
import 'package:connectsaleorder/GetXController/CheckAdminController.dart';
import 'package:connectsaleorder/Models/ChatModel.dart';
import 'package:connectsaleorder/Utils/AppUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ChatMemberItem extends StatelessWidget{
  CheckAdminController checkAdminController = Get.find();
  ChatController chatController = Get.find();
  var utils = AppUtils();
  ChatModel chatModel;
  int index;
  int length;
  ChatMemberItem(this.chatModel,this.index, this.length);
  @override
  Widget build(BuildContext context) {
    chatModel.chat.sort((a,b) => b.timeStamp.compareTo(a.timeStamp));
    return InkWell(
      onTap: (){
        chatController.getSupportChatCurrent(chatModel);
        Get.toNamed(chatRoute , arguments: 1);
      },
      child: Container(
        width: Get.width,
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: checkAdminController.system.mainColor,
                  ),
                  child: CachedNetworkImage(
                    imageUrl: chatModel.image??"",
                    errorWidget: (context, url , _) => Icon(CupertinoIcons.info , color: redColor, size: 32,),
                    placeholder: (context, url)=> SpinKitRotatingCircle(color: checkAdminController.system.mainColor,),
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 8,),
                Expanded(child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("${chatModel.name}" , style: utils.boldSmallLabelStyle(blackColor),),
                    SizedBox(height: 4,),
                    Text(chatModel.chat.length > 0 ? "${chatModel.chat[0].message != null ? (chatModel.chat[0].message!.length > 100 ? chatModel.chat[0].message!.substring(0,100) +"..." : chatModel.chat[0].message) : "Start chat"}" : "Start Chat", style: utils.xSmallLabelStyle(blackColor.withOpacity(0.5)),),
                    SizedBox(height: 4,),
                    Text("${TimeAgo.timeAgoSinceDate(DateFormat("yyyy-MM-ddTHH:mm:ss").format(DateTime.fromMillisecondsSinceEpoch(chatModel.timestamp)))}", style: utils.xSmallLabelStyle(checkAdminController.system.mainColor.withOpacity(0.5)),),
                  ],
                ))
              ],
            ),
            SizedBox(height: 8,),
            if(index < length) Container(
              width: Get.width,
              height: 0.5,
              color: checkAdminController.system.mainColor,
            )
          ],
        ),
      ),
    );
  }

}