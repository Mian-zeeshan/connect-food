import 'package:connectsaleorder/AppConstants/Constants.dart';
import 'package:connectsaleorder/GetXController/CheckAdminController.dart';
import 'package:connectsaleorder/Models/BlogModel.dart';
import 'package:connectsaleorder/Utils/AppUtils.dart';
import 'package:connectsaleorder/Widgets/Blogs/BlogWidget.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class BlogDetailScreen extends StatefulWidget {
  BlogModel blogModel;
  BlogDetailScreen(this.blogModel);
  @override
  _BlogDetailScreen createState() => _BlogDetailScreen();
}

class _BlogDetailScreen extends State<BlogDetailScreen> {
  var utils = AppUtils();
  final GlobalKey _menuKey = GlobalKey();

  @override
  Widget build(BuildContext context) {

    final button = PopupMenuButton(
        key: _menuKey,
        icon: Icon(CupertinoIcons.ellipsis_vertical, color: whiteColor,),
        itemBuilder: (_) => const<PopupMenuItem<String>>[
          PopupMenuItem<String>(
              child: Text('Inactive'), value: '0'),
        ],
        onSelected: (value) async {
          inActiveBlog(widget.blogModel.bid);
        });

    return GetBuilder<CheckAdminController>(
        id: "0", builder: (checkAdminController) {
      return Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(0),
            child: AppBar(
              backgroundColor: checkAdminController.system.mainColor,
              elevation: 0,
            ),
          ),
          backgroundColor: whiteColor,
          body: SafeArea(
            child: Container(
              width: Get.width,
              height: Get.height,
              child: Column(
                children: [
                  Container(
                    width: Get.width,
                    padding: EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20),),
                      color: checkAdminController.system.mainColor
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(onPressed: (){
                          Get.back();
                        }, icon: Icon(CupertinoIcons.arrow_left, color: whiteColor,)),
                        SizedBox(width: 4,),
                        Expanded(child: Text("Blogs", style: utils.boldLabelStyle(whiteColor),)),
                        button
                      ],
                    ),
                  ),
                  Expanded(child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    child: SingleChildScrollView(
                      child: BlogWidget(widget.blogModel,true),
                    ),
                  ))
                ],
              ),
            ),
          ),
      );
    });
  }

  void inActiveBlog(String bid) async {
    EasyLoading.show(status: "Loading...");
    FirebaseDatabase database = FirebaseDatabase(databaseURL: databaseUrl);

    if(!GetPlatform.isWeb) {
      database.setPersistenceEnabled(true);
      database.setPersistenceCacheSizeBytes(10000000);
    }

    DatabaseReference reference = database.reference();
    await reference
        .child(blogRef)
        .child(bid).update({"active" : false});
    EasyLoading.dismiss();
    Get.back();
  }

}