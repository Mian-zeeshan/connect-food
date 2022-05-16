import 'package:connectsaleorder/AppConstants/Constants.dart';
import 'package:connectsaleorder/GetXController/CartController.dart';
import 'package:connectsaleorder/GetXController/CategoryController.dart';
import 'package:connectsaleorder/GetXController/CheckAdminController.dart';
import 'package:connectsaleorder/GetXController/DrawerCustomController.dart';
import 'package:connectsaleorder/GetXController/FavoriteController.dart';
import 'package:connectsaleorder/GetXController/SubCategoryController.dart';
import 'package:connectsaleorder/GetXController/UserController.dart';
import 'package:connectsaleorder/Models/CategoryModel.dart';
import 'package:connectsaleorder/Models/ItemModel.dart';
import 'package:connectsaleorder/Models/SubCategoryModel.dart';
import 'package:connectsaleorder/Utils/AppUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CategoryWidget5 extends StatefulWidget {
  CategoryModel categoryModel;

  var onPress;
  CategoryWidget5(this.categoryModel, this.onPress);

  @override
  _CategoryWidget5 createState() => _CategoryWidget5(categoryModel);
}

class _CategoryWidget5 extends State<CategoryWidget5> {
  CategoryModel category;

  _CategoryWidget5(this.category);

  var utils = AppUtils();
  UserController userController = Get.find();
  CheckAdminController checkAdminController = Get.find();
  CategoryController categoryController = Get.find();
  SubCategoryController _sCategoryController = Get.find();
  DrawerCustomController drawerCustomController = Get.find();

  @override
  void didUpdateWidget(covariant CategoryWidget5 oldWidget) {
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
      onTap: category.code == "-1" ? widget.onPress : (){
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
        margin: EdgeInsets.symmetric(horizontal: 4.w),
        padding: EdgeInsets.symmetric(horizontal: 12.w , vertical: 8.h),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: checkAdminController.system.mainColor
        ),
        child: Text("${category.name}" , style: utils.smallLabelStyle(whiteColor),textAlign: TextAlign.left,overflow: TextOverflow.ellipsis, maxLines: 1,),
      ),
    );
  }

  setData() {
    setState(() {});
  }
}
