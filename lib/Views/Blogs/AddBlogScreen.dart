import 'package:connectsaleorder/Views/Product/EditorPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../AppConstants/Constants.dart';
import '../../GetXController/CheckAdminController.dart';
import '../../Utils/AppUtils.dart';
import 'package:html/parser.dart';

class AddBlogScreen extends StatefulWidget{
  @override
  _AddBlogScreen createState() => _AddBlogScreen();

}

class _AddBlogScreen extends State<AddBlogScreen>{
  var utils = AppUtils();
  var titleController = TextEditingController();
  var bodyController = TextEditingController();
  CheckAdminController checkAdminController = Get.find();
  @override
  void initState() {
    htmlString = "";
    super.initState();
  }

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
                      Text("Add Blog", style: utils.headingStyle(whiteColor),)
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
                      SizedBox(height: 12,),
                      utils.textField(whiteColor, null, null, null, null, blackColor, "Title", blackColor.withOpacity(0.5), blackColor.withOpacity(0.5), 1.0, Get.width, false, titleController),
                      SizedBox(height: 12,),
                      utils.textField(whiteColor, null, null, null, null, blackColor, "Description", blackColor.withOpacity(0.5), blackColor.withOpacity(0.5), 1.0, Get.width, false, bodyController, multiline: true, onClick: () async {
                        await Get.to(()=> EditorPage());
                        bodyController.text = _parseHtmlString(htmlString);
                      }),
                      SizedBox(height: 12,),
                      utils.button(checkAdminController.system.mainColor, "Add", whiteColor, checkAdminController.system.mainColor, 1.0, (){
                        if(titleController.text.isEmpty){
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

                        titleController.clear();
                        bodyController.clear();
                        setData();
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

  setData(){
    if(mounted){
      setState(() {
      });
    }
  }

  String _parseHtmlString(String htmlS) {
    final document = parse(htmlS);
    final String parsedString = parse(document.body!.text).documentElement!.text;
    return parsedString;
  }
}