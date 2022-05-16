import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:connectsaleorder/AppConstants/Constants.dart';
import 'package:connectsaleorder/GetXController/BannerController.dart';
import 'package:connectsaleorder/GetXController/CartController.dart';
import 'package:connectsaleorder/GetXController/CategoryController.dart';
import 'package:connectsaleorder/GetXController/CheckAdminController.dart';
import 'package:connectsaleorder/GetXController/Couponcontroller.dart';
import 'package:connectsaleorder/GetXController/DrawerCustomController.dart';
import 'package:connectsaleorder/GetXController/FavoriteController.dart';
import 'package:connectsaleorder/GetXController/ItemController.dart';
import 'package:connectsaleorder/GetXController/OrderController.dart';
import 'package:connectsaleorder/GetXController/SubCategoryController.dart';
import 'package:connectsaleorder/GetXController/UserController.dart';
import 'package:connectsaleorder/Models/CartModel.dart';
import 'package:connectsaleorder/Models/CouponModel.dart';
import 'package:connectsaleorder/Utils/AppUtils.dart';
import 'package:connectsaleorder/Utils/CategoryWidget.dart';
import 'package:connectsaleorder/Utils/CategoryWidget2.dart';
import 'package:connectsaleorder/Utils/CategoryWidget3.dart';
import 'package:connectsaleorder/Utils/CategoryWidget4.dart';
import 'package:connectsaleorder/Utils/CategoryWidget5.dart';
import 'package:connectsaleorder/Utils/ItemWidget.dart';
import 'package:connectsaleorder/Utils/ItemWidgetStyle2.dart';
import 'package:connectsaleorder/Utils/ItemWidgetStyle3.dart';
import 'package:connectsaleorder/Utils/ItemWidgetStyle4.dart';
import 'package:connectsaleorder/Views/AuthViews/MainAuthScreen.dart';
import 'package:connectsaleorder/Views/orders/OrderDetailScreen.dart';
import 'package:connectsaleorder/Views/orders/OrdersFragment.dart';
import 'package:coupon_uikit/coupon_uikit.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shimmer/shimmer.dart';

import '../../Utils/ItemWidgetStyle5.dart';

class HomeFragment extends StatefulWidget{
  @override
  _HomeFragment createState() => _HomeFragment();
}

class _HomeFragment extends State<HomeFragment>{
  var utils = AppUtils();
  ScrollController _scrollController = ScrollController();
  CartController cartController = Get.find();
  UserController userController = Get.find();
  CategoryController __categoryController = Get.find();
  BannerController _bannerController = Get.find();
  SubCategoryController _sCategoryController = Get.find();
  DrawerCustomController drawerCustomController = Get.find();
  FavoriteController favoriteController = Get.find();
  CheckAdminController checkAdminController = Get.find();
  ItemController _itemController = Get.find();
  
  var index = 0;
  var length = 0;
  var page = 1;

  @override
  void initState() {
    _itemController.getAllProducts(page);
    // TODO: implement initState
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        print("Extended");
        if(_itemController.itemModelsAll.length % 10 == 0){
          page++;
          _itemController.getAllProducts(page);
        }
      }
    });
  }

  RefreshController _refreshController =
  RefreshController(initialRefresh: false);

  void _onRefresh() async{
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    page = 1;
    _bannerController.getBanner(true);
    _refreshController.refreshCompleted();
    _itemController.getAllProducts(page);
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
        controller: _refreshController,
      scrollController: _scrollController,
      onRefresh: _onRefresh,
      child: Container(
        width: Get.width,
        padding: EdgeInsets.symmetric(horizontal: 12.w , vertical: 12.h),
        color: grayColor.withOpacity(0.3),
        child: SingleChildScrollView(
          //controller: _scrollController,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GetBuilder<BannerController>(id: "0", builder: (bannerController){
                return bannerController.isLoading ? Container(
                  width: Get.width,
                  height: 140.h,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                  ),
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey[500]!,
                    highlightColor: Colors.grey[300]!,
                    child: Container(
                        width: Get.width,
                        height: 140.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: whiteColor,
                      ),
                    ),
                  ),
                ) :bannerController.banners.isNotEmpty ? Container(
                  width: Get.width,
                  height: 140.h,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: checkAdminController.system.mainColor
                  ),
                  child: Stack(
                    children: [
                      Container(
                        width: Get.width,
                        height: 140.h,
                        child: CarouselSlider(
                          items: [
                            for(var b in bannerController.banners)
                              GestureDetector(
                                onTap: (){
                                  __categoryController.updateCategory(b.categoryId);
                                  _sCategoryController.getSubCategories(b.categoryId);
                                  Get.toNamed(homeFragmentRoute);
                                },
                                child: Container(
                                    width: Get.width,
                                    height: 140.h,
                                    child: CachedNetworkImage(
                                        imageUrl: b.image,
                                        placeholder: (context, url) => SpinKitRotatingCircle(color: whiteColor,),
                                        errorWidget: (context, url, error) => Icon(
                                          Icons.image_not_supported_rounded,
                                          size: 25.h,
                                        ), fit: BoxFit.cover)
                                ),
                              ),
                          ],
                          options: CarouselOptions(
                              autoPlay: true,
                              enlargeCenterPage: false,
                              viewportFraction: 1,
                              aspectRatio: 2.0,
                              initialPage: 0,
                              onPageChanged: (position,reason){
                                index = position;
                                setState(() {
                                });
                              }
                          ),
                        ),
                      ),
                      Container(
                        width: Get.width,
                        height: 140.h,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            DotsIndicator(
                              dotsCount: bannerController.banners.length,
                              position: index.toDouble(),
                              decorator: DotsDecorator(
                                  size: const Size.square(9.0),
                                  activeSize: const Size(18.0, 9.0),
                                  activeShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                                  activeColor: checkAdminController.system.mainColor,
                                  color: grayColor
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ) : Container();
              }),
              SizedBox(height: 16.h,),
              GetBuilder<CouponController>(id: "0", builder: (couponController){
                return couponController.coupons.length > 0 ? Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Coupons", style: utils.boldLabelStyle(blackColor),),
                    SizedBox(height: 16.h,),
                    Container(
                      width: Get.width,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            for(var i = 0 ; i  < couponController.coupons.length; i++)
                              couponCard(couponController.coupons[i])
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h,)
                  ],
                ) : Container();
              }),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Top Categories", style: utils.boldLabelStyle(blackColor),),
                  GestureDetector(
                      onTap: (){
                        if(checkAdminController.system.bottomNavigationChecks.isProducts) {
                          drawerCustomController.setDrawer("categories", 1);
                        }else{
                          Get.toNamed(homeFragmentRoute);
                        }
                      },
                      child: Container(
                          padding: EdgeInsets.only(left: 16.w),
                          child: Text("VIEW ALL", style: utils.xSmallLabelStyle(checkAdminController.system.mainColor),))
                  ),
                ],
              ),
              SizedBox(height: 16.h,),
              GetBuilder<CategoryController>(id: "0",builder: (categoryController){
                return Container(
                  width: Get.width,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        for(var i = 0 ; i < categoryController.categories.length; i++)
                          checkAdminController.system.categoryView == 0 ?
                          CategoryWidget(categoryController.categories[i]) :
                          checkAdminController.system.categoryView == 1 ?
                          CategoryWidget2(categoryController.categories[i]) :
                          checkAdminController.system.categoryView == 2 ?
                          CategoryWidget3(categoryController.categories[i]) :
                          checkAdminController.system.categoryView == 3 ?
                          CategoryWidget4(categoryController.categories[i]) :
                          checkAdminController.system.categoryView == 4 ?
                          CategoryWidget5(categoryController.categories[i]) :
                          CategoryWidget(categoryController.categories[i])
                      ],
                    ),
                  ),
                );
              }),
              SizedBox(height: 10.h,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Popular", style: utils.boldLabelStyle(blackColor),),
                  GestureDetector(
                      onTap: (){
                        if(checkAdminController.system.bottomNavigationChecks.isDeals) {
                          drawerCustomController.setDrawer("categories", 3);
                        }else{
                          Get.toNamed(dealProductsRoute);
                        }
                      },
                      child: Container(
                          padding: EdgeInsets.only(left: 16),
                          child: Text("VIEW ALL", style: utils.xSmallLabelStyle(checkAdminController.system.mainColor),))
                  ),
                ],
              ),
              SizedBox(height: 10.h,),
              Container(
                width: Get.width,
                child: GetBuilder<ItemController>(id: "0" , builder: (itemController){
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for(var item in itemController.itemModelsNewArrival)
                          Container(
                            child: checkAdminController.system.itemGridStyle.code == "001" ? ItemWidget(item) : checkAdminController.system.itemGridStyle.code == "002" ? ItemWidgetStyle2(item) : checkAdminController.system.itemGridStyle.code == "003" ? ItemWidgetStyle3(item): checkAdminController.system.itemGridStyle.code == "004" ? ItemWidgetStyle4(item) : checkAdminController.system.itemGridStyle.code == "005" ? ItemWidgetStyle5(item, 140.w) : ItemWidget(item),
                          )
                      ],
                    ),
                  );
                },),
              ),
              SizedBox(height: 12.h,),
              GetBuilder<ItemController>(id: "0", builder: (itemController){
                return itemController.itemModelsTopDeals.length > 0 ? Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("Top Deals", style: utils.boldLabelStyle(blackColor),),
                        GestureDetector(
                            onTap: (){
                              if(checkAdminController.system.bottomNavigationChecks.isDeals) {
                                drawerCustomController.setDrawer("categories", 3);
                              }else{
                                Get.toNamed(dealProductsRoute);
                              }
                            },
                            child: Container(
                                padding: EdgeInsets.only(left: 16),
                                child: Text("VIEW ALL", style: utils.xSmallLabelStyle(checkAdminController.system.mainColor),))
                        )
                      ],
                    ),
                    SizedBox(height: 16.h,),
                    Container(
                      width: Get.width,
                      child:SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            for(var item in itemController.itemModelsTopDeals)
                              Container(
                                child: checkAdminController.system.itemGridStyle.code == "001" ? ItemWidget(item) : checkAdminController.system.itemGridStyle.code == "002" ? ItemWidgetStyle2(item) : checkAdminController.system.itemGridStyle.code == "003" ? ItemWidgetStyle3(item): checkAdminController.system.itemGridStyle.code == "004" ? ItemWidgetStyle4(item) : checkAdminController.system.itemGridStyle.code == "005" ? ItemWidgetStyle5(item, 140.w) : ItemWidget(item),
                              )
                          ],
                        ),
                      )
                    )
                  ],
                ) : Container();
              },),
              SizedBox(height: 12,),
              GetBuilder<ItemController>(id: "0", builder: (itemController){
                return itemController.itemModelsTopDeals.length > 0 ? Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("Best Offers", style: utils.boldLabelStyle(blackColor),),
                      ],
                    ),
                    SizedBox(height: 16,),
                    StaggeredGrid.count(
                      crossAxisCount: 4,
                      mainAxisSpacing: 4,
                      crossAxisSpacing: 4,
                      children: [
                        if(itemController.itemModelsTopDeals.length > 0) StaggeredGridTile.count(
                          crossAxisCellCount: 2,
                          mainAxisCellCount: 2,
                          child: InkWell(
                            onTap: () async {
                              await Get.toNamed(productDetailRoute , arguments: itemController.itemModelsTopDeals[0]);
                              setState(() {
                              });
                            },
                            child: Container(
                              width: Get.width,
                              clipBehavior: Clip
                                  .antiAliasWithSaveLayer,
                              margin: EdgeInsets
                                  .symmetric(
                                  horizontal: 5,
                                  vertical: 5),
                              decoration: BoxDecoration(
                                  borderRadius:
                                  BorderRadius
                                      .circular(
                                      8),
                                  color: whiteColor),
                              child:
                              CachedNetworkImage(
                                imageUrl: itemController.itemModelsTopDeals[0].images.length > 0 ? itemController.itemModelsTopDeals[0].images[0] : "",
                                progressIndicatorBuilder:
                                    (context, url,
                                    downloadProgress) => SpinKitFadingCircle(color: checkAdminController.system.mainColor,),
                                errorWidget: (context,
                                    url, error) => Icon(CupertinoIcons.info_circle_fill, color: blackColor,),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        if(itemController.itemModelsTopDeals.length > 1) StaggeredGridTile.count(
                          crossAxisCellCount: 2,
                          mainAxisCellCount: 1,
                          child: InkWell(
                            onTap: () async {
                              await Get.toNamed(productDetailRoute , arguments: itemController.itemModelsTopDeals[1]);
                              setState(() {
                              });
                            },
                            child: Container(
                              width: Get.width,
                              clipBehavior: Clip
                                  .antiAliasWithSaveLayer,
                              margin: EdgeInsets
                                  .symmetric(
                                  horizontal: 5,
                                  vertical: 5),
                              decoration: BoxDecoration(
                                  borderRadius:
                                  BorderRadius
                                      .circular(
                                      8),
                                  color: checkAdminController.system.mainColor),
                              child:
                              CachedNetworkImage(
                                imageUrl: itemController.itemModelsTopDeals[1].images.length > 0 ? itemController.itemModelsTopDeals[1].images[0] : "",
                                progressIndicatorBuilder:
                                    (context, url,
                                    downloadProgress) => SpinKitFadingCircle(color: checkAdminController.system.mainColor,),
                                errorWidget:
                                    (context, url,
                                    error) => Icon(CupertinoIcons.info_circle_fill, color: blackColor,),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        if(itemController.itemModelsTopDeals.length > 2) StaggeredGridTile.count(
                          crossAxisCellCount: 1,
                          mainAxisCellCount: 1,
                          child: InkWell(
                            onTap: () async {
                              await Get.toNamed(productDetailRoute , arguments: itemController.itemModelsTopDeals[2]);
                              setState(() {
                              });
                            },
                            child: Container(
                              width: Get.width,
                              clipBehavior: Clip
                                  .antiAliasWithSaveLayer,
                              margin: EdgeInsets
                                  .symmetric(
                                  horizontal: 5,
                                  vertical: 5),
                              decoration: BoxDecoration(
                                  borderRadius:
                                  BorderRadius
                                      .circular(
                                      8),
                                  color: checkAdminController.system.mainColor
                              ),
                              child:
                              CachedNetworkImage(
                                imageUrl: itemController.itemModelsTopDeals[2].images.length > 0 ? itemController.itemModelsTopDeals[2].images[0] : "",
                                progressIndicatorBuilder:
                                    (context, url,
                                    downloadProgress) => SpinKitFadingCircle(color: checkAdminController.system.mainColor,),
                                errorWidget:
                                    (context, url,
                                    error) => Icon(CupertinoIcons.info_circle_fill, color: blackColor,),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        if(itemController.itemModelsTopDeals.length > 3) StaggeredGridTile.count(
                          crossAxisCellCount: 1,
                          mainAxisCellCount: 1,
                          child: InkWell(
                            onTap: () async {
                              await Get.toNamed(productDetailRoute , arguments: itemController.itemModelsTopDeals[3]);
                              setState(() {
                              });
                            },
                            child: Container(
                              width: Get.width,
                              clipBehavior: Clip
                                  .antiAliasWithSaveLayer,
                              margin: EdgeInsets
                                  .symmetric(
                                  horizontal: 5,
                                  vertical: 5),
                              decoration: BoxDecoration(
                                  borderRadius:
                                  BorderRadius
                                      .circular(
                                      8),
                                  color: checkAdminController.system.mainColor),
                              child:
                              CachedNetworkImage(
                                imageUrl: itemController.itemModelsTopDeals[3].images.length > 0 ? itemController.itemModelsTopDeals[3].images[0] : "",
                                progressIndicatorBuilder:
                                    (context, url,
                                    downloadProgress) => SpinKitFadingCircle(color: checkAdminController.system.mainColor,),
                                errorWidget:
                                    (context, url,
                                    error) => Icon(CupertinoIcons.info_circle_fill, color: blackColor,),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ) : Container();
              }),
              SizedBox(height: 12,),
              GetBuilder<ItemController>(id: "0", builder: (itemController){
                return itemController.itemModelsRecentView.length > 0 ? Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("Trending", style: utils.boldLabelStyle(blackColor),),
                      ],
                    ),
                    SizedBox(height: 16,),
                    StaggeredGrid.count(
                      crossAxisCount: 4,
                      mainAxisSpacing: 4,
                      crossAxisSpacing: 4,
                      children: [
                        if(itemController.itemModelsRecentView.length > 0) StaggeredGridTile.count(
                          crossAxisCellCount: 4,
                          mainAxisCellCount: 2,
                          child: InkWell(
                            onTap: () async {
                              await Get.toNamed(productDetailRoute , arguments: itemController.itemModelsRecentView[0]);
                              setState(() {
                              });
                            },
                            child: Container(
                              width: Get.width,
                              clipBehavior: Clip
                                  .antiAliasWithSaveLayer,
                              margin: EdgeInsets
                                  .symmetric(
                                  horizontal: 5,
                                  vertical: 5),
                              decoration: BoxDecoration(
                                  borderRadius:
                                  BorderRadius
                                      .circular(
                                      8),
                                  color: whiteColor),
                              child:
                              CachedNetworkImage(
                                imageUrl: itemController.itemModelsRecentView[0].images.length > 0 ? itemController.itemModelsRecentView[0].images[0] : "",
                                progressIndicatorBuilder:
                                    (context, url,
                                    downloadProgress) => SpinKitFadingCircle(color: checkAdminController.system.mainColor,),
                                errorWidget: (context,
                                    url, error) => Icon(CupertinoIcons.info_circle_fill, color: blackColor,),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        if(itemController.itemModelsRecentView.length > 1) StaggeredGridTile.count(
                          crossAxisCellCount: 1,
                          mainAxisCellCount: 1,
                          child: InkWell(
                            onTap: () async {
                              await Get.toNamed(productDetailRoute , arguments: itemController.itemModelsRecentView[1]);
                              setState(() {
                              });
                            },
                            child: Container(
                              width: Get.width,
                              clipBehavior: Clip
                                  .antiAliasWithSaveLayer,
                              margin: EdgeInsets
                                  .symmetric(
                                  horizontal: 5,
                                  vertical: 5),
                              decoration: BoxDecoration(
                                  borderRadius:
                                  BorderRadius
                                      .circular(
                                      8),
                                  color: checkAdminController.system.mainColor),
                              child:
                              CachedNetworkImage(
                                imageUrl: itemController.itemModelsRecentView[1].images.length > 0 ? itemController.itemModelsRecentView[1].images[0] : "",
                                progressIndicatorBuilder:
                                    (context, url,
                                    downloadProgress) => SpinKitFadingCircle(color: checkAdminController.system.mainColor,),
                                errorWidget:
                                    (context, url,
                                    error) => Icon(CupertinoIcons.info_circle_fill, color: blackColor,),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        if(itemController.itemModelsRecentView.length > 2) StaggeredGridTile.count(
                          crossAxisCellCount: 1,
                          mainAxisCellCount: 1,
                          child: InkWell(
                            onTap: () async {
                              await Get.toNamed(productDetailRoute , arguments: itemController.itemModelsRecentView[2]);
                              setState(() {
                              });
                            },
                            child: Container(
                              width: Get.width,
                              clipBehavior: Clip
                                  .antiAliasWithSaveLayer,
                              margin: EdgeInsets
                                  .symmetric(
                                  horizontal: 5,
                                  vertical: 5),
                              decoration: BoxDecoration(
                                  borderRadius:
                                  BorderRadius
                                      .circular(
                                      8),
                                  color: checkAdminController.system.mainColor
                              ),
                              child:
                              CachedNetworkImage(
                                imageUrl: itemController.itemModelsRecentView[2].images.length > 0 ? itemController.itemModelsRecentView[2].images[0] : "",
                                progressIndicatorBuilder:
                                    (context, url,
                                    downloadProgress) => SpinKitFadingCircle(color: checkAdminController.system.mainColor,),
                                errorWidget:
                                    (context, url,
                                    error) => Icon(CupertinoIcons.info_circle_fill, color: blackColor,),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        if(itemController.itemModelsRecentView.length > 3) StaggeredGridTile.count(
                          crossAxisCellCount: 1,
                          mainAxisCellCount: 1,
                          child: InkWell(
                            onTap: () async {
                              await Get.toNamed(productDetailRoute , arguments: itemController.itemModelsRecentView[3]);
                              setState(() {
                              });
                            },
                            child: Container(
                              width: Get.width,
                              clipBehavior: Clip
                                  .antiAliasWithSaveLayer,
                              margin: EdgeInsets
                                  .symmetric(
                                  horizontal: 5,
                                  vertical: 5),
                              decoration: BoxDecoration(
                                  borderRadius:
                                  BorderRadius
                                      .circular(
                                      8),
                                  color: checkAdminController.system.mainColor),
                              child:
                              CachedNetworkImage(
                                imageUrl: itemController.itemModelsRecentView[3].images.length > 0 ? itemController.itemModelsRecentView[3].images[0] : "",
                                progressIndicatorBuilder:
                                    (context, url,
                                    downloadProgress) => SpinKitFadingCircle(color: checkAdminController.system.mainColor,),
                                errorWidget:
                                    (context, url,
                                    error) => Icon(CupertinoIcons.info_circle_fill, color: blackColor,),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        if(itemController.itemModelsRecentView.length > 4) StaggeredGridTile.count(
                          crossAxisCellCount: 1,
                          mainAxisCellCount: 1,
                          child: InkWell(
                            onTap: () async {
                              await Get.toNamed(productDetailRoute , arguments: itemController.itemModelsRecentView[4]);
                              setState(() {
                              });
                            },
                            child: Container(
                              width: Get.width,
                              clipBehavior: Clip
                                  .antiAliasWithSaveLayer,
                              margin: EdgeInsets
                                  .symmetric(
                                  horizontal: 5,
                                  vertical: 5),
                              decoration: BoxDecoration(
                                  borderRadius:
                                  BorderRadius
                                      .circular(
                                      8),
                                  color: checkAdminController.system.mainColor),
                              child:
                              CachedNetworkImage(
                                imageUrl: itemController.itemModelsRecentView[4].images.length > 0 ? itemController.itemModelsRecentView[4].images[0] : "",
                                progressIndicatorBuilder:
                                    (context, url,
                                    downloadProgress) => SpinKitFadingCircle(color: checkAdminController.system.mainColor,),
                                errorWidget:
                                    (context, url,
                                    error) => Icon(CupertinoIcons.info_circle_fill, color: blackColor,),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ) : Container();
              }),
              SizedBox(height: 12,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Recently Viewed", style: utils.boldLabelStyle(blackColor),),
                ],
              ),
              SizedBox(height: 16,),
              Container(
                width: Get.width,
                child: GetBuilder<ItemController>(id: "0" , builder: (itemController){
                  return itemController.itemModelsRecentView.isNotEmpty ? SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for(var item in itemController.itemModelsRecentView)
                          Container(
                            child: checkAdminController.system.itemGridStyle.code == "001" ? ItemWidget(item) : checkAdminController.system.itemGridStyle.code == "002" ? ItemWidgetStyle2(item) : checkAdminController.system.itemGridStyle.code == "003" ? ItemWidgetStyle3(item): checkAdminController.system.itemGridStyle.code == "004" ? ItemWidgetStyle4(item) : checkAdminController.system.itemGridStyle.code == "005" ? ItemWidgetStyle5(item, 140.w) :ItemWidget(item),
                          )
                      ],
                    ),
                  ) : Center(
                    child: Text("You haven't review any Item Explore now."),
                  );
                },),
              ),
              SizedBox(height: 12,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(child: Text("Recent Orders", style: utils.boldLabelStyle(blackColor),)),
                  InkWell(
                    onTap: (){
                        Get.to(()=>OrderFragment(false,hideBack: false));
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                          child: Text("View All", style: utils.xSmallLabelStyle(checkAdminController.system.mainColor),)
                      )
                  ),
                ],
              ),
              SizedBox(height: 8,),
              Container(
                width: Get.width,
                child: GetBuilder<OrderController>(id: "0" , builder: (orderController){
                  return orderController.ordersRecent.length > 0 ? SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        for (var i = 0;
                        i < orderController.ordersRecent.length;
                        i++)
                          GestureDetector(
                            onTap: (){
                              if(orderController.ordersRecent[i].status != -1) {
                                orderController.listenOrdersTrack(orderController.ordersRecent[i]);
                                Get.toNamed(trackOrderRoute);
                              }else{
                                Get.snackbar("Opps!", "Your order is cancelled and can not track.");
                              }
                            },
                            child: Container(
                              width: 300.w,
                              margin: EdgeInsets.symmetric(
                                  vertical: 6, horizontal: 4),
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.w),
                                  color: whiteColor,
                                  boxShadow: [
                                    BoxShadow(
                                        blurRadius: 2,
                                        spreadRadius: 2,
                                        offset: Offset(0, 2),
                                        color: grayColor.withOpacity(0.7))
                                  ]),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(8.w),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.start,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                            width: 60.w,
                                            height: 60.w,
                                            clipBehavior:
                                            Clip.antiAliasWithSaveLayer,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                BorderRadius.circular(
                                                    8.w)),
                                            child: Stack(
                                              children: [
                                                Image.network(
                                                  orderController
                                                      .ordersRecent[i]
                                                      .products[0]
                                                      .images.length > 0
                                                      ? orderController
                                                      .ordersRecent[i]
                                                      .products[0]
                                                      .images[0]
                                                      : "https://5.imimg.com/data5/SELLER/Default/2020/9/XP/HK/UQ/113167197/grocery-items-500x500.jpg",
                                                  fit: BoxFit.cover,
                                                ),
                                                Container(
                                                  width: 60.w,
                                                  height: 60.w,
                                                  clipBehavior: Clip
                                                      .antiAliasWithSaveLayer,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                      BorderRadius
                                                          .circular(12),
                                                      color: blackColor
                                                          .withOpacity(0.5)),
                                                  child: Center(
                                                    child: Text(
                                                      "+${orderController.ordersRecent[i].products.length} more",
                                                      style: utils
                                                          .boldLabelStyle(
                                                          whiteColor),
                                                      textAlign:
                                                      TextAlign.center,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                            child: Column(
                                              mainAxisAlignment:
                                              MainAxisAlignment.start,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Order ID : ${orderController.ordersRecent[i].cartId}",
                                                  style: utils.boldLabelStyle(
                                                      blackColor
                                                          .withOpacity(0.7)),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  "${DateFormat("dd MMM, yyyy hh:mm aa").format(DateTime.fromMillisecondsSinceEpoch(orderController.ordersRecent[i].createdAt))}",
                                                  style: utils.smallLabelStyle(
                                                      blackColor
                                                          .withOpacity(0.5)),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  "Total Amount: ${utils.getFormattedPrice(orderController.ordersRecent[i].discountedBill.round())}",
                                                  style: utils.smallLabelStyle(
                                                      blackColor
                                                          .withOpacity(0.5)),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    Expanded(child: Text(
                                                      "Total Items: ${orderController.ordersRecent[i].products.length}",
                                                      style: utils.smallLabelStyle(
                                                          blackColor
                                                              .withOpacity(0.5)),
                                                    ),),
                                                    SizedBox(width: 8,),
                                                    Container(
                                                      padding: EdgeInsets.symmetric(horizontal: 12,vertical: 6),
                                                      decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(8),
                                                          color: orderController.ordersRecent[i].status == -1 ? Colors.red.withOpacity(0.3) : orderController.ordersRecent[i].status == 0 ? Colors.blue.withOpacity(0.3) : orderController.ordersRecent[i].status == 1 ? Colors.greenAccent.withOpacity(0.3) : orderController.ordersRecent[i].status == 2 ? Colors.amber.withOpacity(0.3) : Colors.green.withOpacity(0.3)
                                                      ),
                                                      child: Text(utils.getOrderStatus(orderController.ordersRecent[i].status), style: utils.xSmallLabelStyle(orderController.ordersRecent[i].status == -1 ? Colors.red : orderController.ordersRecent[i].status == 0 ? Colors.blue : orderController.ordersRecent[i].status == 1 ? Colors.greenAccent : orderController.ordersRecent[i].status == 2 ? Colors.amber : Colors.green),),
                                                    )
                                                  ],
                                                )
                                              ],
                                            )),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: Get.width,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 8.w, vertical: 4.h),
                                    decoration:
                                    BoxDecoration(color: checkAdminController.system.mainColor),
                                    child: IntrinsicHeight(
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                        children: [
                                          Icon(
                                            CupertinoIcons.bag_badge_plus,
                                            color: whiteColor,
                                            size: 16.w,
                                          ),
                                          SizedBox(
                                            width: 8.w,
                                          ),
                                          GestureDetector(
                                              onTap: () {
                                                cartController.retriveOrder(
                                                    orderController
                                                        .ordersRecent[i]);
                                                Get.offAllNamed(homeCRoute);
                                              },
                                              child: Text(
                                                "Reorder",
                                                style: utils.boldLabelStyle(
                                                    whiteColor),
                                              )),
                                          SizedBox(
                                            width: 12,
                                          ),
                                          Container(
                                            width: 1,
                                            color: whiteColor,
                                          ),
                                          SizedBox(
                                            width: 8.w,
                                          ),
                                          Icon(
                                            CupertinoIcons.eye,
                                            color: whiteColor,
                                            size: 16.w,
                                          ),
                                          SizedBox(
                                            width: 8.w,
                                          ),
                                          GestureDetector(
                                              onTap: () {
                                                Get.to(()=> OrderDetailScreen(orderController.ordersRecent[i], fromBottom: false,));
                                                /*showOrderDetailBottom(
                                                    context,
                                                    orderController
                                                        .ordersRecent[i]);*/
                                              },
                                              child: Text(
                                                "View Order",
                                                style: utils.boldLabelStyle(
                                                    whiteColor),
                                              )),
                                          SizedBox(
                                            width: 8.w,
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                      ],
                    ),
                  ) :
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("Opps! No recent orders.\nPlace your First Order Now" , style: utils.labelStyle(blackColor.withOpacity(0.7)),textAlign: TextAlign.center,),
                        SizedBox(height: 10,),
                        GestureDetector(
                          onTap: (){
                            if(userController.user != null)
                              Get.toNamed(cartRoute);
                            else
                              utils.loginBottomSheet(context);
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: checkAdminController.system.mainColor
                            ),
                            child: Text("Go to Cart" , style: utils.boldLabelStyle(whiteColor),),
                          ),
                        )
                      ],
                    ),
                  );
                },),
              ),
              SizedBox(height: 12,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Recommendation", style: utils.boldLabelStyle(blackColor),),
                ],
              ),
              SizedBox(height: 16,),
              /*Container(
                width: Get.width,
                child: GetBuilder<ItemController>(id: "0" , builder: (itemController){
                  return itemController.itemModelsAll.isNotEmpty ? Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    alignment: WrapAlignment.spaceBetween,
                    children: [
                      for(var item in itemController.itemModelsAll)
                        Container(
                          child: checkAdminController.system.itemGridStyle.code == "001" ? ItemWidget(item) : checkAdminController.system.itemGridStyle.code == "002" ? ItemWidgetStyle2(item) : checkAdminController.system.itemGridStyle.code == "003" ? ItemWidgetStyle3(item): checkAdminController.system.itemGridStyle.code == "004" ? ItemWidgetStyle4(item) : checkAdminController.system.itemGridStyle.code == "005" ? ItemWidgetStyle5(item,null) : ItemWidget(item),
                        )
                    ],
                  ) : Center(
                    child: Text("You haven't review any Item Explore now."),
                  );
                },),
              ),*/
              Container(
                width: Get.width,
                child: GetBuilder<ItemController>(id: "0" , builder: (itemController){
                  return itemController.itemModelsAll.isNotEmpty ? GridView.builder(
                    primary: false,
                    shrinkWrap: true,
                    itemCount: itemController.itemModelsAll.length,
                    gridDelegate:
                    SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        crossAxisCount: 2,
                        childAspectRatio: 2 / 3.1),
                    itemBuilder: (context, i) {
                      return checkAdminController.system.itemGridStyle.code == "001" ? ItemWidget(itemController.itemModelsAll[i]) : checkAdminController.system.itemGridStyle.code == "002" ? ItemWidgetStyle2(itemController.itemModelsAll[i]) : checkAdminController.system.itemGridStyle.code == "003" ? ItemWidgetStyle3(itemController.itemModelsAll[i]): checkAdminController.system.itemGridStyle.code == "004" ? ItemWidgetStyle4(itemController.itemModelsAll[i]) : checkAdminController.system.itemGridStyle.code == "005" ? ItemWidgetStyle5(itemController.itemModelsAll[i],null) : ItemWidget(itemController.itemModelsAll[i]);
                    },
                  ) : Center(
                    child: Text("You haven't review any Item Explore now."),
                  );
                },),
              ),
              SizedBox(height: 12,),
            ],
          ),
        ),
      ),
    );
  }

  showOrderDetailBottom(BuildContext context, CartModel order) {
    showCupertinoModalBottomSheet(
      context: context,
      backgroundColor: whiteColor,
      topRadius: Radius.circular(30),
      builder: (context) => Container(
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
            Expanded(child: OrderDetailScreen(order))
          ],
        ),
      ),
    );
  }


  void setData() {
    setState(() {
    });
  }

  couponCard(CouponModel couponModel) {
    const Color primaryColor = Color(0xffcbf3f0);
    const Color secondaryColor = Color(0xff368f8b);

    return Container(
      margin: EdgeInsets.only(right: 12),
      child: CouponCard(
        height: 80.w,
        width: 250.w,
        backgroundColor: primaryColor,
        curveAxis: Axis.vertical,
        firstChild: Container(
          decoration: const BoxDecoration(
            color: secondaryColor,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        couponModel.discountType == "%" ? "${couponModel.value}%" : "${utils.getFormattedPrice(couponModel.value.toDouble())}",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'OFF',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Divider(color: Colors.white54, height: 0),
              Expanded(
                child: Center(
                  child: Text(
                    '${couponModel.name}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        secondChild: Container(
          child: Stack(
            children: [
              Container(
                width: Get.width,
                child: Image.network(couponModel.image, fit: BoxFit.cover,),
              ),
              Container(
                width: Get.width,
                height: Get.height,
                decoration: BoxDecoration(
                  color: blackColor.withOpacity(0.3)
                ),
              ),
              Container(
                padding: EdgeInsets.all(18),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Coupon Code',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: whiteColor,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '${couponModel.code}',
                      textAlign: TextAlign.center,
                      style: utils.headingStyle(whiteColor),
                    ),
                    Text(
                      'Valid before - ${DateFormat("dd MMM yyyy").format(DateTime.fromMillisecondsSinceEpoch(couponModel.validBefore))}',
                      textAlign: TextAlign.center,
                      style: utils.xSmallLabelStyle(whiteColor.withOpacity(0.7)),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
