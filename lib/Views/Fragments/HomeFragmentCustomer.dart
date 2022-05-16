import 'package:connectsaleorder/AppConstants/Constants.dart';
import 'package:connectsaleorder/GetXController/BrandController.dart';
import 'package:connectsaleorder/GetXController/CartController.dart';
import 'package:connectsaleorder/GetXController/CategoryController.dart';
import 'package:connectsaleorder/GetXController/CheckAdminController.dart';
import 'package:connectsaleorder/GetXController/FavoriteController.dart';
import 'package:connectsaleorder/GetXController/ItemController.dart';
import 'package:connectsaleorder/GetXController/SubCategoryController.dart';
import 'package:connectsaleorder/GetXController/UserController.dart';
import 'package:connectsaleorder/Models/CustomerModel.dart';
import 'package:connectsaleorder/Utils/AppUtils.dart';
import 'package:connectsaleorder/Utils/CategoryWidget.dart';
import 'package:connectsaleorder/Utils/CategoryWidget2.dart';
import 'package:connectsaleorder/Utils/CategoryWidget3.dart';
import 'package:connectsaleorder/Utils/CategoryWidget4.dart';
import 'package:connectsaleorder/Utils/CategoryWidget5.dart';
import 'package:connectsaleorder/Utils/ItemListWidget.dart';
import 'package:connectsaleorder/Utils/ItemListWidget2.dart';
import 'package:connectsaleorder/Utils/ItemListWidget3.dart';
import 'package:connectsaleorder/Utils/ItemListWidget4.dart';
import 'package:connectsaleorder/Utils/ItemWidget.dart';
import 'package:connectsaleorder/Utils/ItemWidgetStyle2.dart';
import 'package:connectsaleorder/Utils/ItemWidgetStyle3.dart';
import 'package:connectsaleorder/Utils/ItemWidgetStyle4.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../Utils/ItemWidgetStyle5.dart';

class HomeFragmentCustomer extends StatefulWidget {
  bool fromNav;

  HomeFragmentCustomer(this.fromNav);

  @override
  _HomeFragmentCustomer createState() => _HomeFragmentCustomer();
}

class _HomeFragmentCustomer extends State<HomeFragmentCustomer> {
  var utils = AppUtils();
  var searchController = TextEditingController();
  SubCategoryController _subCController = Get.find();
  CategoryController _cController = Get.find();
  BrandController _bController = Get.find();
  ScrollController _scrollController = ScrollController();
  List<TextEditingController> controllers = [];
  ItemController iController = Get.find();
  var selectedStyle = "";
  CartController _cartController = Get.find();
  FavoriteController _favoriteController = Get.find();
  UserController userController = Get.find();
  CustomerModel? selectedCModel;
  CheckAdminController checkAdminController = Get.find();

  @override
  void initState() {
    if(iController.itemModels.length <= 0){
      print("INSIDE MODEL 2");
      if(_cController.filterCategories.length > 0) {
        print("INSIDE MODEL 3");
        iController.getItems(_cController.filterCategories[0].code, false, mounted: false);
      }
    }
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        iController.getItems(selectedStyle, true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          color: grayColor.withOpacity(0.3),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.only(
                    right: widget.fromNav ? 8 : 0,
                    left: 8,
                    top: widget.fromNav ? 12 : 6,
                    bottom: widget.fromNav ? 12 : 6),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
                    color: checkAdminController.system.mainColor),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (!widget.fromNav)
                      IconButton(
                          onPressed: () {
                            Get.back();
                          },
                          icon: Icon(
                            CupertinoIcons.arrow_left,
                            color: whiteColor,
                            size: 20.w,
                          )),
                    Expanded(child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: whiteColor
                      ),
                      child: TextField(
                        onTap: () async {
                          await Get.toNamed(searchRoute);
                          FocusManager.instance.primaryFocus?.unfocus();
                        },
                        decoration: InputDecoration.collapsed(hintText: "Search"),
                        obscureText: false,
                        maxLines: 1,
                      ),
                    )),
                    if (userController.user != null)
                      GestureDetector(
                        onTap: () {
                          Get.toNamed(favoriteRoute);
                        },
                        child: Container(
                          width: 32,
                          height: 32,
                          child: Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              Icon(
                                CupertinoIcons.heart,
                                color: whiteColor,
                                size: 20.w,
                              ),
                            ],
                          ),
                        ),
                      ),
                    SizedBox(
                      width: 8,
                    ),
                    if (userController.user != null)
                      GestureDetector(
                        onTap: () {
                          if (userController.user != null) {
                            setState(() {
                              Get.toNamed(cartRoute);
                            });
                          } else {
                            utils.loginBottomSheet(context);
                          }
                        },
                        child: Container(
                          width: 26.w,
                          height: 26.w,
                          child: Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              Icon(
                                CupertinoIcons.shopping_cart,
                                color: whiteColor,
                                size: 20.w,
                              ),
                              GetBuilder<CartController>(id: "0", builder: (cartController){
                                return cartController.myCart.totalItems > 0 ? Positioned(
                                    top: 0,
                                    right: 0,
                                    child: Container(
                                      width: 18,
                                      height: 18,
                                      padding: EdgeInsets.all(2),
                                      decoration: BoxDecoration(
                                          color: redColor,
                                          shape: BoxShape.circle
                                      ),
                                      child: Center(
                                          child: Text("${cartController.myCart.totalItems}" , style: utils.xSmallLabelStyle(whiteColor),)
                                      ),
                                    )
                                ) : Container();}),
                            ],
                          ),
                        ),
                      ),
                    if (userController.user == null)
                      GestureDetector(
                        onTap: () {
                          utils.loginBottomSheet(context);
                        },
                        child: Container(
                          width: 32,
                          height: 32,
                          child: Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              Image.asset(
                                "Assets/Images/account.png",
                                color: whiteColor,
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Container(
                width: Get.width,
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                color: grayColor.withOpacity(0.3),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /*Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(width: 8,),
                        GetBuilder<ItemController>(
                            id: "0",
                            builder: (itemController) {
                              return GestureDetector(
                                  onTap: () {
                                    itemController.changeView();
                                  },
                                  child: Icon(
                                    itemController.isList
                                        ? CupertinoIcons.rectangle_grid_2x2
                                        : CupertinoIcons.list_bullet,
                                    color: blackColor.withOpacity(0.7),
                                    size: 20,
                                  ));
                            }),
                        SizedBox(
                          width: 10,
                        ),
                        GetBuilder<ItemController>(
                            id: "0",
                            builder: (itemController) {
                              return GestureDetector(
                                  onTap: () {
                                    itemController.changeView();
                                  },
                                  child: Text(
                                    "VIEW",
                                    style: utils.labelStyle(blackColor),
                                  ));
                            }),
                        SizedBox(
                          width: 16,
                        ),
                        *//*GetBuilder<ItemController>(
                            id: "0",
                            builder: (itemController) {
                              return GestureDetector(
                                  onTap: () {
                                    showBottomSheetFilter(context);
                                  },
                                  child: Icon(
                                    CupertinoIcons.slider_horizontal_3,
                                    color: blackColor,
                                    size: 20,
                                  ));
                            }),
                        SizedBox(
                          width: 8,
                        ),
                        GetBuilder<ItemController>(
                            id: "0",
                            builder: (itemController) {
                              return GestureDetector(
                                onTap: () {
                                  showBottomSheetFilter(context);
                                },
                                child: Text(
                                  "FILTER",
                                  style: utils.labelStyle(blackColor),
                                ),
                              );
                            }),*//*
                        SizedBox(
                          width: 12,
                        ),
                      ],
                    ),*/
                    SizedBox(
                      height: 8,
                    ),
                    GetBuilder<CategoryController>(
                        id: "0",
                        builder: (categoryController) {
                          return Container(
                            width: Get.width,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  GetBuilder<ItemController>(
                                      id: "0",
                                      builder: (itemController) {
                                        return GestureDetector(
                                            onTap: () {
                                              itemController.changeView();
                                            },
                                            child: Container(
                                              padding: EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(8),
                                                color: checkAdminController.system.mainColor
                                              ),
                                              child: Icon(
                                                itemController.isList
                                                    ? CupertinoIcons.rectangle_grid_2x2
                                                    : CupertinoIcons.list_bullet,
                                                color: Colors.white,
                                                size: 20.w,
                                              ),
                                            ));
                                      }),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  for (var i = 0;
                                      i < categoryController.categories.length;
                                      i++)
                                    checkAdminController.system.categoryView ==
                                            0
                                        ? CategoryWidget(
                                            categoryController.categories[i],null)
                                        : checkAdminController.system.categoryView ==
                                                1
                                            ? CategoryWidget2(categoryController
                                                .categories[i],null)
                                            : checkAdminController
                                                        .system.categoryView ==
                                                    2
                                                ? CategoryWidget3(
                                                    categoryController
                                                        .categories[i],null)
                                                : checkAdminController.system
                                                            .categoryView ==
                                                        3
                                                    ? CategoryWidget4(
                                                        categoryController
                                                            .categories[i],null)
                                                    : checkAdminController
                                                                .system
                                                                .categoryView ==
                                                            4
                                                        ? CategoryWidget5(
                                                            categoryController
                                                                .categories[i],null)
                                                        : CategoryWidget(categoryController.categories[i],null)
                                ],
                              ),
                            ),
                          );
                        }),
                  ],
                ),
              ),
              Expanded(
                  child: Container(
                width: Get.width,
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                color: grayColor.withOpacity(0.3),
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GetBuilder<ItemController>(
                          id: "0",
                          builder: (itemController) {
                            if (itemController.isLoading) {
                              EasyLoading.show(status: "Loading...");
                            } else {
                              EasyLoading.dismiss();
                            }
                            return itemController.itemModels.length > 0
                                ? Container(
                                    width: Get.width,
                                    child: itemController.isList
                                        ? Wrap(
                                            alignment:
                                                WrapAlignment.spaceEvenly,
                                            children: [
                                              for (var i = 0;
                                                  i <
                                                      itemController
                                                          .itemsLength;
                                                  i++)
                                                itemController.itemModels[i].name
                                                        .toLowerCase()
                                                        .contains(searchController.text
                                                            .toLowerCase())
                                                    ? checkAdminController
                                                                .system
                                                                .itemListStyle
                                                                .code ==
                                                            "001"
                                                        ? ItemListWidget(
                                                            itemController
                                                                .itemModels[i])
                                                        : checkAdminController
                                                                    .system
                                                                    .itemListStyle
                                                                    .code ==
                                                                "002"
                                                            ? ItemListWidget2(itemController
                                                                .itemModels[i])
                                                            : checkAdminController
                                                                        .system
                                                                        .itemListStyle
                                                                        .code ==
                                                                    "003"
                                                                ? ItemListWidget3(
                                                                    itemController.itemModels[i])
                                                                : checkAdminController.system.itemListStyle.code == "004"
                                                                    ? ItemListWidget4(itemController.itemModels[i])
                                                                    : ItemListWidget(itemController.itemModels[i])
                                                    : Container()
                                            ],
                                          )
                                        : GridView.builder(
                                      primary: false,
                                      shrinkWrap: true,
                                      itemCount: itemController
                                          .itemsLength,
                                      gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisSpacing: 10,
                                          mainAxisSpacing: 10,
                                          crossAxisCount: 2,
                                          childAspectRatio: 2 / 3.5),
                                      itemBuilder: (context, i) {
                                        return checkAdminController.system.itemGridStyle.code == "001" ? ItemWidget(itemController.itemModels[i]) : checkAdminController.system.itemGridStyle.code == "002" ? ItemWidgetStyle2(itemController.itemModels[i]) : checkAdminController.system.itemGridStyle.code == "003" ? ItemWidgetStyle3(itemController.itemModels[i]): checkAdminController.system.itemGridStyle.code == "004" ? ItemWidgetStyle4(itemController.itemModels[i]) : checkAdminController.system.itemGridStyle.code == "005" ? ItemWidgetStyle5(itemController.itemModels[i],null) : ItemWidget(itemController.itemModels[i]);
                                      },
                                    )/*Wrap(
                                            alignment:
                                                WrapAlignment.spaceEvenly,
                                            children: [
                                              for (var i = 0;
                                                  i <
                                                      itemController
                                                          .itemsLength;
                                                  i++)
                                                itemController
                                                        .itemModels[i].name
                                                        .toLowerCase()
                                                        .contains(
                                                            searchController
                                                                .text
                                                                .toLowerCase())
                                                    ? Container(
                                                        width: checkAdminController
                                                                    .system
                                                                    .itemGridStyle
                                                                    .code ==
                                                                "001"
                                                            ? Get.width * 0.45
                                                            : Get.width * 0.4,
                                                        child: Container(
                                                          child: checkAdminController
                                                                      .system
                                                                      .itemGridStyle
                                                                      .code ==
                                                                  "001"
                                                              ? ItemWidget(
                                                                  itemController
                                                                          .itemModels[
                                                                      i])
                                                              : checkAdminController
                                                                          .system
                                                                          .itemGridStyle
                                                                          .code ==
                                                                      "002"
                                                                  ? ItemWidgetStyle2(
                                                                      itemController
                                                                              .itemModels[
                                                                          i])
                                                                  : checkAdminController
                                                                              .system
                                                                              .itemGridStyle
                                                                              .code ==
                                                                          "003"
                                                                      ? ItemWidgetStyle3(
                                                                          itemController.itemModels[
                                                                              i])
                                                                      : checkAdminController.system.itemGridStyle.code ==
                                                                              "004"
                                                                          ? ItemWidgetStyle4(itemController.itemModels[i])
                                                                          : checkAdminController.system.itemGridStyle.code == "005" ? ItemWidgetStyle5(itemController.itemModels[i], Get.width * 0.4)
                                                              : ItemWidget(itemController.itemModels[i]),
                                                        ),
                                                      )
                                                    : Container(),
                                            ],
                                          ),*/
                                  )
                                : Container(
                                    child: Center(
                                      child: Lottie.asset(
                                          'Assets/lottie/searchempty.json'),
                                    ),
                                  );
                          })
                    ],
                  ),
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }

  void setData() {
    setState(() {});
  }

  showBottomSheetFilter(BuildContext context) {
    var showCategory = false;
    var showSubCategory = false;
    var showBrand = false;
    var selectedCategory = _cController.selectedCategory;
    var selectedSubCategory = _subCController.selectedSubCategory;
    var selectedBrand = _bController.selectedBrand;
    showCupertinoModalBottomSheet(
      context: context,
      backgroundColor: whiteColor,
      topRadius: Radius.circular(30),
      builder: (context) => StatefulBuilder(
          builder: (BuildContext contextBuild, StateSetter setState) {
        return Container(
          height: Get.height * 0.8,
          padding: EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: whiteColor,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(child: Container()),
                  Expanded(
                      child: Container(
                    height: 3,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: blackColor.withOpacity(0.8),
                    ),
                  )),
                  Expanded(child: Container()),
                ],
              ),
              Expanded(
                  child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Filter By",
                            style: utils.boldLabelStyle(blackColor),
                          )
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        showCategory = !showCategory;
                        setState(() {});
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                                child: Text(
                              "Category",
                              style: utils
                                  .boldLabelStyle(blackColor.withOpacity(0.8)),
                            )),
                            Icon(
                              showCategory
                                  ? CupertinoIcons.chevron_up
                                  : CupertinoIcons.chevron_down,
                              size: 20,
                              color: blackColor.withOpacity(0.8),
                            )
                          ],
                        ),
                      ),
                    ),
                    if (showCategory)
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 0, vertical: 4),
                        child: GetBuilder<CategoryController>(
                          id: "0",
                          builder: (categoryController) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                for (var i = 0;
                                    i < categoryController.categories.length;
                                    i++)
                                  Container(
                                    width: Get.width,
                                    padding: EdgeInsets.symmetric(vertical: 4),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: 12,
                                        ),
                                        Expanded(
                                            child: Text(
                                          "${categoryController.categories[i].name}",
                                          style: utils.boldSmallLabelStyle(
                                              blackColor.withOpacity(0.6)),
                                        )),
                                        Radio(
                                          value: true,
                                          groupValue: selectedCategory == i,
                                          onChanged: (val) {
                                            selectedCategory = i;
                                            setState(() {});
                                            categoryController.updateCategory(
                                                categoryController
                                                    .categories[i].code);
                                            _subCController.getSubCategories(
                                                categoryController
                                                    .categories[i].code);
                                          },
                                          toggleable: true,
                                          activeColor: checkAdminController
                                              .system.mainColor,
                                        )
                                      ],
                                    ),
                                  )
                              ],
                            );
                          },
                        ),
                      ),
                    Container(
                      width: Get.width,
                      height: 1,
                      color: blackColor.withOpacity(0.3),
                    ),
                    GestureDetector(
                      onTap: () {
                        showSubCategory = !showSubCategory;
                        setState(() {});
                      },
                      child: GestureDetector(
                        onTap: () {
                          showSubCategory = !showSubCategory;
                          setState(() {});
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 12, vertical: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                  child: Text(
                                "Sub Category",
                                style: utils.boldLabelStyle(
                                    blackColor.withOpacity(0.8)),
                              )),
                              Icon(
                                showSubCategory
                                    ? CupertinoIcons.chevron_up
                                    : CupertinoIcons.chevron_down,
                                size: 20,
                                color: blackColor.withOpacity(0.8),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    if (showSubCategory)
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 0, vertical: 4),
                        child: GetBuilder<SubCategoryController>(
                          id: "0",
                          builder: (subCategoryController) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                for (var i = 0;
                                    i <
                                        subCategoryController
                                            .subCategories.length;
                                    i++)
                                  Container(
                                    width: Get.width,
                                    padding: EdgeInsets.symmetric(vertical: 4),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: 12,
                                        ),
                                        Expanded(
                                            child: Text(
                                          "${subCategoryController.subCategories[i].name}",
                                          style: utils.boldSmallLabelStyle(
                                              blackColor.withOpacity(0.6)),
                                        )),
                                        Radio(
                                          value: true,
                                          groupValue: selectedSubCategory == i,
                                          onChanged: (val) {
                                            selectedSubCategory = i;
                                            subCategoryController
                                                .updateSubCategory(i, false);
                                            setState(() {});
                                          },
                                          toggleable: true,
                                          activeColor: checkAdminController
                                              .system.mainColor,
                                        )
                                      ],
                                    ),
                                  )
                              ],
                            );
                          },
                        ),
                      ),
                    Container(
                      width: Get.width,
                      height: 1,
                      color: blackColor.withOpacity(0.3),
                    ),
                    GestureDetector(
                      onTap: () {
                        showBrand = !showBrand;
                        setState(() {});
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                                child: Text(
                              "Brand",
                              style: utils
                                  .boldLabelStyle(blackColor.withOpacity(0.8)),
                            )),
                            Icon(
                              showBrand
                                  ? CupertinoIcons.chevron_up
                                  : CupertinoIcons.chevron_down,
                              size: 20,
                              color: blackColor.withOpacity(0.8),
                            )
                          ],
                        ),
                      ),
                    ),
                    if (showBrand)
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 0, vertical: 4),
                        child: GetBuilder<BrandController>(
                          id: "0",
                          builder: (brandController) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                for (var i = 0;
                                    i < brandController.brands.length;
                                    i++)
                                  Container(
                                    width: Get.width,
                                    padding: EdgeInsets.symmetric(vertical: 4),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: 12,
                                        ),
                                        Expanded(
                                            child: Text(
                                          "${brandController.brands[i].name}",
                                          style: utils.boldSmallLabelStyle(
                                              blackColor.withOpacity(0.6)),
                                        )),
                                        Radio(
                                          value: true,
                                          groupValue: selectedBrand == i,
                                          onChanged: (val) {
                                            selectedBrand = i;
                                            brandController.updateBrand(
                                                brandController.brands[i].code);
                                            setState(() {});
                                          },
                                          toggleable: true,
                                          activeColor: checkAdminController
                                              .system.mainColor,
                                        )
                                      ],
                                    ),
                                  )
                              ],
                            );
                          },
                        ),
                      ),
                    Container(
                      width: Get.width,
                      height: 1,
                      color: blackColor.withOpacity(0.3),
                    )
                  ],
                ),
              )),
            ],
          ),
        );
      }),
    );
  }
}
