import 'package:connectsaleorder/AppConstants/Constants.dart';
import 'package:connectsaleorder/GetXController/CheckAdminController.dart';
import 'package:connectsaleorder/Utils/AppUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ContactScreen extends StatefulWidget{
  @override
  _ContactScreen createState() => _ContactScreen();

}

class _ContactScreen extends State<ContactScreen>{
  var utils = AppUtils();
  var emailController = TextEditingController();
  var subjectController = TextEditingController();
  var messageController = TextEditingController();
  CheckAdminController checkAdminController = Get.find();


  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      height: Get.height,
      color: whiteColor,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 30,),
            Container(
              child: utils.textField(whiteColor, CupertinoIcons.mail, checkAdminController.system.mainColor, null, null, blackColor, "Email", blackColor.withOpacity(0.4), checkAdminController.system.mainColor, 1.0, Get.width-40, false, emailController),
            ),
            SizedBox(height: 10,),
            Container(
              child: utils.textField(whiteColor, CupertinoIcons.doc, checkAdminController.system.mainColor, null, null, blackColor, "Subject", blackColor.withOpacity(0.4), checkAdminController.system.mainColor, 1.0, Get.width-40, false, subjectController),
            ),
            SizedBox(height: 10,),
            Container(
              child: utils.textField(whiteColor, null, null, null, null, blackColor, "Message", blackColor.withOpacity(0.4), checkAdminController.system.mainColor, 1.0, Get.width-40, false, messageController, multiline : "yes"),
            ),
            SizedBox(height: 20,),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: utils.button(checkAdminController.system.mainColor, "Submit", whiteColor, checkAdminController.system.mainColor, 1.0, (){
                emailController.clear();
                subjectController.clear();
                messageController.clear();
              }),
            ),
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(width: 20,),
                Container(
                  width: 40,
                  height: 40,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  decoration: BoxDecoration(
                    color: checkAdminController.system.mainColor,
                    borderRadius: BorderRadius.circular(8)
                  ),
                  child: Center(
                    child: Icon(CupertinoIcons.phone_solid, size: 24, color: whiteColor,),
                  ),
                ),
                SizedBox(width: 8,),
                Expanded(
                  child: Text("+92301 23-45-678", style: utils.labelStyle(blackColor),),
                ),
                SizedBox(width: 20,),
              ],
            ),
            SizedBox(height: 12,),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(width: 20,),
                Container(
                  width: 40,
                  height: 40,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  decoration: BoxDecoration(
                    color: checkAdminController.system.mainColor,
                    borderRadius: BorderRadius.circular(8)
                  ),
                  child: Center(
                    child: Image.asset("Assets/Images/worldwide.png", width: 24, height: 24, color: whiteColor,),
                  ),
                ),
                SizedBox(width: 8,),
                Expanded(
                  child: Text("www.al-fatah.com", style: utils.labelStyle(blackColor),),
                ),
                SizedBox(width: 20,),
              ],
            ),
            SizedBox(height: 12,),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(width: 20,),
                Container(
                  width: 40,
                  height: 40,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  decoration: BoxDecoration(
                    color: checkAdminController.system.mainColor,
                    borderRadius: BorderRadius.circular(8)
                  ),
                  child: Center(
                    child: Icon(CupertinoIcons.location, size: 24, color: whiteColor,),
                  ),
                ),
                SizedBox(width: 8,),
                Expanded(
                  child: Text("Abu- Bakar Block 86 new Garden town Lahore,", style: utils.labelStyle(blackColor),),
                ),
                SizedBox(width: 20,),
              ],
            ),
          ],
        ),
      ),
    );
  }

}