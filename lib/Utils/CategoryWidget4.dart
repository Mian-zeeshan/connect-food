import 'package:cached_network_image/cached_network_image.dart';
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
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

class CategoryWidget4 extends StatefulWidget {
  CategoryModel categoryModel;

  CategoryWidget4(this.categoryModel);

  @override
  _CategoryWidget4 createState() => _CategoryWidget4(categoryModel);
}

class _CategoryWidget4 extends State<CategoryWidget4> {
  CategoryModel category;

  _CategoryWidget4(this.category);

  var utils = AppUtils();
  UserController userController = Get.find();
  CheckAdminController checkAdminController = Get.find();
  CategoryController categoryController = Get.find();
  SubCategoryController _sCategoryController = Get.find();
  DrawerCustomController drawerCustomController = Get.find();

  @override
  void didUpdateWidget(covariant CategoryWidget4 oldWidget) {
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
        height: 40.w,
        margin: EdgeInsets.symmetric(horizontal: 4),
        padding: EdgeInsets.symmetric(horizontal: 8 , vertical: 5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: checkAdminController.system.mainColor
        ),
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text("${category.name}" , style: utils.smallLabelStyle(whiteColor),textAlign: TextAlign.left,overflow: TextOverflow.ellipsis, maxLines: 1,),
            SizedBox(width: 5,),
            Container(
              width: 30.w,
              height: 30.w,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: whiteColor
              ),
              child: CachedNetworkImage(
                imageUrl: category.image != null ? category.image! : "" ,
                placeholder: (context, url) => SpinKitRotatingCircle(color: checkAdminController.system.mainColor,),
                errorWidget: (context, url, error) => Icon(
                  Icons.image_not_supported_rounded,
                  size: 25.w,
                ), fit: BoxFit.cover,),
            ),
          ],
        ),
      ),
    );
  }

  setData() {
    setState(() {});
  }
}
