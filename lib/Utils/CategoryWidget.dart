import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectsaleorder/AppConstants/Constants.dart';
import 'package:connectsaleorder/GetXController/CategoryController.dart';
import 'package:connectsaleorder/GetXController/CheckAdminController.dart';
import 'package:connectsaleorder/GetXController/DrawerCustomController.dart';
import 'package:connectsaleorder/GetXController/SubCategoryController.dart';
import 'package:connectsaleorder/GetXController/UserController.dart';
import 'package:connectsaleorder/Models/CategoryModel.dart';
import 'package:connectsaleorder/Utils/AppUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

class CategoryWidget extends StatefulWidget {
  CategoryModel categoryModel;

  CategoryWidget(this.categoryModel);

  @override
  _CategoryWidget createState() => _CategoryWidget(categoryModel);
}

class _CategoryWidget extends State<CategoryWidget> {
  CategoryModel category;

  _CategoryWidget(this.category);

  var utils = AppUtils();
  UserController userController = Get.find();
  CheckAdminController checkAdminController = Get.find();
  CategoryController categoryController = Get.find();
  SubCategoryController _sCategoryController = Get.find();
  DrawerCustomController drawerCustomController = Get.find();

  @override
  void didUpdateWidget(covariant CategoryWidget oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    category = widget.categoryModel;
    setData();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        if(category.code != "0") {
          categoryController.updateCategory(category.code);
          _sCategoryController.getSubCategories(category.code);
          if(checkAdminController.system.bottomNavigationChecks.isProducts) {
            drawerCustomController.setDrawer("categories", 1);
          }else{
            Get.toNamed(homeFragmentRoute);
          }
        }else{
          Get.snackbar("Wow", "You are doing great!");
        }
      },
      child: Container(
        width: 60.w,
        height: 100.h,
        margin: EdgeInsets.symmetric(horizontal: 4.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 60.w,
              height: 60.w,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: whiteColor
              ),
              child: CachedNetworkImage(
                imageUrl: category.image != null ? category.image! : "" ,
                placeholder: (context, url) => SpinKitRotatingCircle(color: checkAdminController.system.mainColor,),
                errorWidget: (context, url, error) => Icon(
                  Icons.image_not_supported_rounded,
                  size: 25.h,
                ), fit: BoxFit.cover,),
            ),
            SizedBox(height: 5.h,),
            Expanded(child: Text("${category.name}" , style: utils.xSmallLabelStyle(blackColor),textAlign: TextAlign.center,overflow: TextOverflow.ellipsis, maxLines: 2,)),
          ],
        ),
      ),
    );
  }

  setData() {
    setState(() {});
  }
}
