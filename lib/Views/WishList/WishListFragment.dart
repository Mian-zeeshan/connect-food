import 'package:connectsaleorder/AppConstants/Constants.dart';
import 'package:connectsaleorder/GetXController/CartController.dart';
import 'package:connectsaleorder/GetXController/CheckAdminController.dart';
import 'package:connectsaleorder/GetXController/FavoriteController.dart';
import 'package:connectsaleorder/GetXController/UserController.dart';
import 'package:connectsaleorder/Utils/AppUtils.dart';
import 'package:connectsaleorder/Utils/ItemListWidget.dart';
import 'package:connectsaleorder/Utils/ItemListWidget2.dart';
import 'package:connectsaleorder/Utils/ItemListWidget3.dart';
import 'package:connectsaleorder/Utils/ItemListWidget4.dart';
import 'package:connectsaleorder/Utils/ItemWidget.dart';
import 'package:connectsaleorder/Utils/ItemWidgetStyle2.dart';
import 'package:connectsaleorder/Utils/ItemWidgetStyle3.dart';
import 'package:connectsaleorder/Utils/ItemWidgetStyle4.dart';
import 'package:connectsaleorder/Views/orders/OrderDetailScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class WishListFragment extends StatefulWidget {
  bool fromNav;

  WishListFragment(this.fromNav);

  @override
  _WishListFragment createState() => _WishListFragment();
}

class _WishListFragment extends State<WishListFragment> {
  var utils = AppUtils();
  var isList = true;
  var searchController = TextEditingController();
  CheckAdminController checkAdminController = Get.find();
  CartController _cartController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: grayColor.withOpacity(0.3),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0),
        child: AppBar(
          elevation: 0,
          backgroundColor: checkAdminController.system.mainColor,
        ),
      ),
      body: GetBuilder<UserController>(
        id: "0",
        builder: (userController) {
          return SafeArea(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.only(
                        left: widget.fromNav ? 8 : 0,
                        right: 8,
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
                                size: 24,
                              )),
                        Expanded(
                            child: Text(
                          "Wishlist".tr,
                          style: utils.headingStyle(whiteColor),
                        )),
                        if (userController.user != null)
                          GestureDetector(
                            onTap: () {
                              Get.toNamed(chatRoute, arguments: 0);
                            },
                            child: Container(
                              width: 32,
                              height: 32,
                              child: Stack(
                                alignment: Alignment.bottomCenter,
                                children: [
                                  Icon(
                                    CupertinoIcons.conversation_bubble,
                                    color: whiteColor,
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
                              width: 32,
                              height: 32,
                              child: Stack(
                                alignment: Alignment.bottomCenter,
                                children: [
                                  Icon(
                                    CupertinoIcons.shopping_cart,
                                    color: whiteColor,
                                  ),
                                  Positioned(
                                      top: 0,
                                      right: 0,
                                      child: Container(
                                        width: 18,
                                        height: 18,
                                        padding: EdgeInsets.all(2),
                                        decoration: BoxDecoration(
                                            color: redColor,
                                            shape: BoxShape.circle),
                                        child: Center(
                                          child: GetBuilder<CartController>(
                                            id: "0",
                                            builder: (cartController) {
                                              return Text(
                                                "${cartController.myCart.totalItems}",
                                                style: utils.xSmallLabelStyle(
                                                    whiteColor),
                                              );
                                            },
                                          ),
                                        ),
                                      ))
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
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                          child: Text(
                        "",
                        style: utils.boldLabelStyle(blackColor),
                      )),
                      GestureDetector(
                          onTap: () {
                            isList = !isList;
                            setState(() {});
                          },
                          child: Icon(
                            isList
                                ? CupertinoIcons.rectangle_grid_2x2
                                : CupertinoIcons.list_bullet,
                            color: blackColor.withOpacity(0.7),
                            size: 24,
                          )),
                      SizedBox(
                        width: 12,
                      ),
                    ],
                  ),
                  Expanded(
                      child: SingleChildScrollView(
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 12,
                          ),
                          GetBuilder<FavoriteController>(
                              id: "0",
                              builder: (favController) {
                                return favController.myFav.products.length > 0
                                    ? Wrap(
                                        alignment: WrapAlignment.spaceEvenly,
                                        children: [
                                          for (var i = 0;
                                              i <
                                                  favController
                                                      .myFav.products.length;
                                              i++)
                                            isList
                                                ? favController.myFav.products[i].name
                                                        .toLowerCase()
                                                        .contains(searchController.text
                                                            .toLowerCase())
                                                    ? checkAdminController
                                                                .system
                                                                .itemGridStyle
                                                                .code ==
                                                            "001"
                                                        ? ItemListWidget(favController
                                                            .myFav.products[i])
                                                        : checkAdminController
                                                                    .system
                                                                    .itemGridStyle
                                                                    .code ==
                                                                "002"
                                                            ? ItemListWidget2(favController
                                                                .myFav
                                                                .products[i])
                                                            : checkAdminController
                                                                        .system
                                                                        .itemGridStyle
                                                                        .code ==
                                                                    "003"
                                                                ? ItemListWidget3(favController.myFav.products[i])
                                                                : checkAdminController.system.itemGridStyle.code == "004"
                                                                    ? ItemListWidget4(favController.myFav.products[i])
                                                                    : ItemListWidget(favController.myFav.products[i])
                                                    : Container()
                                                : favController.myFav.products[i].name.toLowerCase().contains(searchController.text.toLowerCase())
                                                    ? Container(
                                                        width: checkAdminController
                                                                    .system
                                                                    .itemGridStyle
                                                                    .code ==
                                                                "001"
                                                            ? Get.width * 0.45
                                                            : Get.width * 0.4,
                                                        child: AspectRatio(
                                                          aspectRatio:
                                                              checkAdminController
                                                                          .system
                                                                          .itemGridStyle
                                                                          .code ==
                                                                      "001"
                                                                  ? 0.9
                                                                  : 0.46,
                                                          child: Container(
                                                            child: checkAdminController
                                                                        .system
                                                                        .itemGridStyle
                                                                        .code ==
                                                                    "001"
                                                                ? ItemWidget(
                                                                    favController
                                                                            .myFav
                                                                            .products[
                                                                        i])
                                                                : checkAdminController
                                                                            .system
                                                                            .itemGridStyle
                                                                            .code ==
                                                                        "002"
                                                                    ? ItemWidgetStyle2(
                                                                        favController.myFav.products[
                                                                            i])
                                                                    : checkAdminController.system.itemGridStyle.code ==
                                                                            "003"
                                                                        ? ItemWidgetStyle3(favController
                                                                            .myFav
                                                                            .products[i])
                                                                        : checkAdminController.system.itemGridStyle.code == "004"
                                                                            ? ItemWidgetStyle4(favController.myFav.products[i])
                                                                            : ItemWidget(favController.myFav.products[i]),
                                                          ),
                                                        ),
                                                      )
                                                    : Container(),
                                        ],
                                      )
                                    : Container(
                                        child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Lottie.asset(
                                                  'Assets/lottie/searchempty.json'),
                                              Text(
                                                "No Wishlist Available",
                                                style: utils.labelStyle(
                                                    blackColor
                                                        .withOpacity(0.5)),
                                              ),
                                            ]),
                                      );
                              })
                        ],
                      ),
                    ),
                  ))
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
