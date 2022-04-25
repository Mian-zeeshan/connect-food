import 'package:connectsaleorder/AppConstants/Constants.dart';
import 'package:connectsaleorder/GetXController/CheckAdminController.dart';
import 'package:connectsaleorder/GetXController/DrawerCustomController.dart';
import 'package:connectsaleorder/GetXController/UserController.dart';
import 'package:connectsaleorder/GetXController/locale_controller.dart';
import 'package:connectsaleorder/Models/SystemSettingModel.dart';
import 'package:connectsaleorder/Utils/AppUtils.dart';
import 'package:connectsaleorder/Views/Coupon/ManageCouponPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:timelines/timelines.dart';

import '../Address/BranchList.dart';

class SettingScreen extends StatefulWidget {
  @override
  _SettingScreen createState() => _SettingScreen();
}

class _SettingScreen extends State<SettingScreen> {
  var utils = AppUtils();
  var isArabic = false;
  var box = GetStorage();
  var selectedIndex = 0;
  DrawerCustomController drawerCustomController = Get.find();
  CheckAdminController checkAdminController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0),
        child: AppBar(
          elevation: 0,
          backgroundColor: checkAdminController.system.mainColor,
        ),
      ),
      body: SafeArea(
        child: GetBuilder<UserController>(
            id: "0",
            builder: (userController) {
              return GetBuilder<CheckAdminController>(
                id: "0",
                builder: (checkAdminController) {
                  return DefaultTabController(
                    length: checkAdminController.isAdmin == "1" ? 2 : 1,
                    child: Container(
                      width: Get.width,
                      height: Get.height,
                      color: whiteColor,
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: Get.width,
                              padding:
                                  EdgeInsets.only(left: 16, right: 16, top: 8),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(16),
                                    bottomRight: Radius.circular(16),
                                  ),
                                  color: checkAdminController.system.mainColor),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          if (userController.user != null)
                                            Get.toNamed(profileRoute);
                                          else
                                            utils.loginBottomSheet(context);
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 8),
                                          decoration: BoxDecoration(
                                              color: whiteColor,
                                              borderRadius:
                                                  BorderRadius.circular(8)),
                                          child: Text(
                                            "View",
                                            style: utils.labelStyle(blackColor),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  Container(
                                      width: 120,
                                      height: 120,
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Container(
                                            width: 100,
                                            height: 100,
                                            clipBehavior:
                                                Clip.antiAliasWithSaveLayer,
                                            decoration: BoxDecoration(
                                                color: whiteColor,
                                                borderRadius:
                                                    BorderRadius.circular(12)),
                                            child: Image.network(
                                              userController.user != null &&
                                                      userController
                                                              .user!.image !=
                                                          null
                                                  ? userController.user!.image!
                                                  : "https://www.nj.com/resizer/zovGSasCaR41h_yUGYHXbVTQW2A=/1280x0/smart/cloudfront-us-east-1.images.arcpublishing.com/advancelocal/SJGKVE5UNVESVCW7BBOHKQCZVE.jpg",
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          if (userController.user!.isRetailer)
                                            Positioned(
                                                bottom: 0,
                                                right: 0,
                                                child: Container(
                                                  width: 50,
                                                  height: 50,
                                                  clipBehavior: Clip
                                                      .antiAliasWithSaveLayer,
                                                  decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: userController
                                                                      .user!
                                                                      .retailerModel !=
                                                                  null &&
                                                              userController
                                                                  .user!
                                                                  .retailerModel!
                                                                  .approved
                                                          ? greenColor
                                                          : redColor),
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      Text("Retailer" , style: utils.xSmallLabelStyle(whiteColor),)
                                                    ],
                                                  )
                                                ))
                                        ],
                                      )),
                                  Text(
                                    userController.user == null
                                        ? "Guest"
                                        : "${userController.user!.name}",
                                    style: utils.headingStyle(whiteColor),
                                  ),
                                  Text(
                                    userController.user == null
                                        ? "guest login"
                                        : "${userController.user!.email}",
                                    style: utils.labelStyle(whiteColor),
                                  ),
                                  if(userController.user!.isRetailer) Text(
                                    userController.user!.retailerModel == null
                                        ? "Not Approved"
                                        :userController.user!.retailerModel!.approved ? "Approved": "Not Approved",
                                    style: utils.boldSmallLabelStyle(userController.user!.retailerModel == null ? redColor : userController.user!.retailerModel!.approved ? greenColor : redColor),
                                  ),
                                  TabBar(
                                    indicatorColor:
                                        checkAdminController.isAdmin == "1"
                                            ? whiteColor
                                            : checkAdminController
                                                .system.mainColor,
                                    labelStyle: utils.boldSmallLabelStyle(
                                        checkAdminController.isAdmin == "1"
                                            ? whiteColor
                                            : checkAdminController
                                                .system.mainColor),
                                    unselectedLabelStyle:
                                        utils.boldSmallLabelStyle(
                                            checkAdminController.isAdmin == "1"
                                                ? whiteColor
                                                : checkAdminController
                                                    .system.mainColor),
                                    labelColor: checkAdminController.isAdmin ==
                                            "1"
                                        ? whiteColor
                                        : checkAdminController.system.mainColor,
                                    unselectedLabelColor:
                                        checkAdminController.isAdmin == "1"
                                            ? whiteColor.withOpacity(0.6)
                                            : checkAdminController
                                                .system.mainColor,
                                    onTap: (index) {
                                      selectedIndex = index;
                                      setData();
                                    },
                                    tabs: [
                                      Tab(
                                        text: "General",
                                      ),
                                      if (checkAdminController.isAdmin == "1")
                                        Tab(
                                          text: "Admin",
                                        )
                                    ],
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            if (selectedIndex == 0)
                              Column(
                                children: [
                                  if (userController.user!.type == 0)
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 8),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Icon(
                                            CupertinoIcons
                                                .person_alt_circle_fill,
                                            color: blackColor,
                                            size: 24,
                                          ),
                                          SizedBox(
                                            width: 12,
                                          ),
                                          Expanded(
                                              child: Text(
                                            "Switch to Admin",
                                            style: utils.labelStyle(blackColor),
                                          )),
                                          Transform.scale(
                                            scale: 0.8,
                                            child: CupertinoSwitch(
                                                activeColor:
                                                    checkAdminController
                                                        .system.mainColor,
                                                value: checkAdminController
                                                        .isAdmin ==
                                                    "1",
                                                onChanged: (value) async {
                                                  if (value) {
                                                    checkAdminController
                                                        .updateAdmin("1");
                                                    selectedIndex = 0;
                                                  } else {
                                                    checkAdminController
                                                        .updateAdmin("0");
                                                    selectedIndex = 0;
                                                  }
                                                }),
                                          )
                                        ],
                                      ),
                                    ),
                                  if (userController.user!.type == 0)
                                    Container(
                                      width: Get.width,
                                      height: 1,
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 6),
                                      color: checkAdminController
                                          .system.mainColor
                                          .withOpacity(0.3),
                                    ),
                                  GetBuilder<LocaleController>(
                                      id: "0",
                                      builder: (localeController) {
                                        isArabic =
                                            localeController.locale == arabic;
                                        return Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 8),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Icon(
                                                CupertinoIcons
                                                    .arrow_2_squarepath,
                                                color: blackColor,
                                                size: 24,
                                              ),
                                              SizedBox(
                                                width: 12,
                                              ),
                                              Expanded(
                                                  child: Text(
                                                "Language",
                                                style: utils
                                                    .labelStyle(blackColor),
                                              )),
                                              Container(
                                                width: Get.width * 0.3,
                                                child: DropdownButtonFormField(
                                                  isExpanded: false,
                                                  decoration:
                                                      InputDecoration.collapsed(
                                                          hintText: ''),
                                                  style: utils
                                                      .labelStyle(blackColor),
                                                  onChanged: (newValue) {
                                                    if (newValue == "Arabic") {
                                                      localeController
                                                          .updateLocale(arabic);
                                                    } else {
                                                      localeController
                                                          .updateLocale(
                                                              english);
                                                    }
                                                  },
                                                  value:
                                                      localeController.locale ==
                                                              "ar_AR"
                                                          ? "Arabic"
                                                          : "English",
                                                  items: checkAdminController
                                                      .system.languages
                                                      .where((element) =>
                                                          element.isSelected)
                                                      .map((selectedType) {
                                                    return DropdownMenuItem(
                                                      child: new Text(
                                                        selectedType.name,
                                                      ),
                                                      value: selectedType.name,
                                                    );
                                                  }).toList(),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }),
                                  Container(
                                    width: Get.width,
                                    height: 1,
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 6),
                                    color: checkAdminController.system.mainColor
                                        .withOpacity(0.3),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Get.toNamed(registerRetailerRoute);
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 8),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Icon(
                                            CupertinoIcons.bookmark,
                                            color: blackColor,
                                            size: 24,
                                          ),
                                          SizedBox(
                                            width: 12,
                                          ),
                                          Expanded(
                                              child: Text(
                                            "Become a Retailer",
                                            style: utils.labelStyle(blackColor),
                                          )),
                                          Icon(
                                            CupertinoIcons.forward,
                                            color: blackColor,
                                            size: 24,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: Get.width,
                                    height: 1,
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 6),
                                    color: checkAdminController.system.mainColor
                                        .withOpacity(0.3),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Get.toNamed(changePasswordRoute);
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 8),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Icon(
                                            CupertinoIcons.lock_rotation,
                                            color: blackColor,
                                            size: 24,
                                          ),
                                          SizedBox(
                                            width: 12,
                                          ),
                                          Expanded(
                                              child: Text(
                                            "Change Password",
                                            style: utils.labelStyle(blackColor),
                                          )),
                                          Icon(
                                            CupertinoIcons.forward,
                                            color: blackColor,
                                            size: 24,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: Get.width,
                                    height: 1,
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 6),
                                    color: checkAdminController.system.mainColor
                                        .withOpacity(0.3),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Get.toNamed(changeEmailRoute);
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 8),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Icon(
                                            CupertinoIcons.envelope,
                                            color: blackColor,
                                            size: 24,
                                          ),
                                          SizedBox(
                                            width: 12,
                                          ),
                                          Expanded(
                                              child: Text(
                                            "Change Email",
                                            style: utils.labelStyle(blackColor),
                                          )),
                                          Icon(
                                            CupertinoIcons.forward,
                                            color: blackColor,
                                            size: 24,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: Get.width,
                                    height: 1,
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 6),
                                    color: checkAdminController.system.mainColor
                                        .withOpacity(0.3),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Get.toNamed(addressesRoute, arguments: 1);
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 8),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Icon(
                                            CupertinoIcons.location,
                                            color: blackColor,
                                            size: 24,
                                          ),
                                          SizedBox(
                                            width: 12,
                                          ),
                                          Expanded(
                                              child: Text(
                                            "Addresses",
                                            style: utils.labelStyle(blackColor),
                                          )),
                                          Icon(
                                            CupertinoIcons.forward,
                                            color: blackColor,
                                            size: 24,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: Get.width,
                                    height: 1,
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 6),
                                    color: checkAdminController.system.mainColor
                                        .withOpacity(0.3),
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      await box.remove(currentUser);
                                      checkAdminController.updateAdmin("0");
                                      await FirebaseAuth.instance.signOut();
                                      await Get.delete<UserController>();
                                      await Get.offAllNamed(mainAuth);
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 8),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Icon(
                                            CupertinoIcons.square_arrow_left,
                                            color: blackColor,
                                            size: 24,
                                          ),
                                          SizedBox(
                                            width: 12,
                                          ),
                                          Expanded(
                                              child: Text(
                                            "Logout",
                                            style: utils.labelStyle(blackColor),
                                          )),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: Get.width,
                                    height: 1,
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 6),
                                    color: checkAdminController.system.mainColor
                                        .withOpacity(0.3),
                                  ),
                                ],
                              ),
                            if (selectedIndex == 1)
                              Column(
                                children: [
                                  if (userController.user!.type == 0)
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 8),
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                        children: [
                                          Icon(
                                            CupertinoIcons.table,
                                            color: blackColor,
                                            size: 24,
                                          ),
                                          SizedBox(
                                            width: 12,
                                          ),
                                          Expanded(
                                              child: Text(
                                                "Dine-In",
                                                style: utils.labelStyle(blackColor),
                                              )),
                                          Transform.scale(
                                            scale: 0.8,
                                            child: CupertinoSwitch(
                                                activeColor:
                                                checkAdminController
                                                    .system.mainColor,
                                                value: checkAdminController
                                                    .system.dineIn,
                                                onChanged: (value) async {
                                                  checkAdminController.updateDine(value);
                                                }),
                                          )
                                        ],
                                      ),
                                    ),
                                  if (userController.user!.type == 0)
                                    Container(
                                      width: Get.width,
                                      height: 1,
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 6),
                                      color: checkAdminController
                                          .system.mainColor
                                          .withOpacity(0.3),
                                    ),
                                  if (userController.user!.type == 0 &&
                                      checkAdminController.isAdmin == "1")
                                    GestureDetector(
                                      onTap: () {
                                        Get.toNamed(manageOrderRoute);
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 8),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.start,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          children: [
                                            Icon(
                                              CupertinoIcons.bag,
                                              color: blackColor,
                                              size: 24,
                                            ),
                                            SizedBox(
                                              width: 12,
                                            ),
                                            Expanded(
                                                child: Text(
                                                  "Manage Orders",
                                                  style:
                                                  utils.labelStyle(blackColor),
                                                )),
                                            Icon(
                                              CupertinoIcons.forward,
                                              color: blackColor,
                                              size: 24,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  if (userController.user!.type == 0 &&
                                      checkAdminController.isAdmin == "1")
                                    Container(
                                      width: Get.width,
                                      height: 1,
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 6),
                                      color: checkAdminController
                                          .system.mainColor
                                          .withOpacity(0.3),
                                    ),
                                  if (userController.user!.type == 0 &&
                                      checkAdminController.isAdmin == "1")
                                    GestureDetector(
                                      onTap: () {
                                        Get.toNamed(adminSupportRoute);
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 8),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.start,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          children: [
                                            Icon(
                                              CupertinoIcons
                                                  .bubble_left_bubble_right,
                                              color: blackColor,
                                              size: 24,
                                            ),
                                            SizedBox(
                                              width: 12,
                                            ),
                                            Expanded(
                                                child: Text(
                                                  "Support Chat",
                                                  style:
                                                  utils.labelStyle(blackColor),
                                                )),
                                            Icon(
                                              CupertinoIcons.forward,
                                              color: blackColor,
                                              size: 24,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  if (userController.user!.type == 0 &&
                                      checkAdminController.isAdmin == "1")
                                    Container(
                                      width: Get.width,
                                      height: 1,
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 6),
                                      color: checkAdminController
                                          .system.mainColor
                                          .withOpacity(0.3),
                                    ),
                                  if (userController.user!.type == 0 &&
                                      checkAdminController.isAdmin == "1")
                                    GestureDetector(
                                      onTap: () {
                                        Get.toNamed(systemConfigRoute);
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 8),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Icon(
                                              CupertinoIcons.settings,
                                              color: blackColor,
                                              size: 24,
                                            ),
                                            SizedBox(
                                              width: 12,
                                            ),
                                            Expanded(
                                                child: Text(
                                              "System Configuration",
                                              style:
                                                  utils.labelStyle(blackColor),
                                            )),
                                            Icon(
                                              CupertinoIcons.forward,
                                              color: blackColor,
                                              size: 24,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  if (userController.user!.type == 0 &&
                                      checkAdminController.isAdmin == "1")
                                    Container(
                                      width: Get.width,
                                      height: 1,
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 6),
                                      color: checkAdminController
                                          .system.mainColor
                                          .withOpacity(0.3),
                                    ),
                                  if (userController.user!.type == 0 &&
                                      checkAdminController.isAdmin == "1")
                                    GestureDetector(
                                      onTap: () {
                                        Get.to(()=> BranchList());
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 8),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Icon(
                                              CupertinoIcons.pin,
                                              color: blackColor,
                                              size: 24,
                                            ),
                                            SizedBox(
                                              width: 12,
                                            ),
                                            Expanded(
                                                child: Text(
                                              "Branches",
                                              style:
                                                  utils.labelStyle(blackColor),
                                            )),
                                            Icon(
                                              CupertinoIcons.forward,
                                              color: blackColor,
                                              size: 24,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  if (userController.user!.type == 0 &&
                                      checkAdminController.isAdmin == "1")
                                    Container(
                                      width: Get.width,
                                      height: 1,
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 6),
                                      color: checkAdminController
                                          .system.mainColor
                                          .withOpacity(0.3),
                                    ),
                                  if (userController.user!.type == 0 &&
                                      checkAdminController.isAdmin == "1")
                                    GestureDetector(
                                      onTap: () {
                                        Get.toNamed(retailersRoute);
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 8),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Icon(
                                              CupertinoIcons.person,
                                              color: blackColor,
                                              size: 24,
                                            ),
                                            SizedBox(
                                              width: 12,
                                            ),
                                            Expanded(
                                                child: Text(
                                              "Retailers",
                                              style:
                                                  utils.labelStyle(blackColor),
                                            )),
                                            Icon(
                                              CupertinoIcons.forward,
                                              color: blackColor,
                                              size: 24,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  if (userController.user!.type == 0 &&
                                      checkAdminController.isAdmin == "1")
                                    Container(
                                      width: Get.width,
                                      height: 1,
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 6),
                                      color: checkAdminController
                                          .system.mainColor
                                          .withOpacity(0.3),
                                    ),
                                  if (userController.user!.type == 0 &&
                                      checkAdminController.isAdmin == "1")
                                    GestureDetector(
                                      onTap: () {
                                        Get.toNamed(configureCountryRoute);
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 8),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Icon(
                                              CupertinoIcons.location,
                                              color: blackColor,
                                              size: 24,
                                            ),
                                            SizedBox(
                                              width: 12,
                                            ),
                                            Expanded(
                                                child: Text(
                                              "Manage Address",
                                              style:
                                                  utils.labelStyle(blackColor),
                                            )),
                                            Icon(
                                              CupertinoIcons.forward,
                                              color: blackColor,
                                              size: 24,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  if (userController.user!.type == 0 &&
                                      checkAdminController.isAdmin == "1")
                                    Container(
                                      width: Get.width,
                                      height: 1,
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 6),
                                      color: checkAdminController
                                          .system.mainColor
                                          .withOpacity(0.3),
                                    ),
                                  if (userController.user!.type == 0 &&
                                      checkAdminController.isAdmin == "1")
                                    GestureDetector(
                                      onTap: () {
                                        Get.toNamed(manageBannerRoute);
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 8),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Icon(
                                              CupertinoIcons.tv,
                                              color: blackColor,
                                              size: 24,
                                            ),
                                            SizedBox(
                                              width: 12,
                                            ),
                                            Expanded(
                                                child: Text(
                                              "Manage Banners",
                                              style:
                                                  utils.labelStyle(blackColor),
                                            )),
                                            Icon(
                                              CupertinoIcons.forward,
                                              color: blackColor,
                                              size: 24,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  if (userController.user!.type == 0 &&
                                      checkAdminController.isAdmin == "1")
                                    Container(
                                      width: Get.width,
                                      height: 1,
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 6),
                                      color: checkAdminController
                                          .system.mainColor
                                          .withOpacity(0.3),
                                    ),
                                  if (userController.user!.type == 0 &&
                                      checkAdminController.isAdmin == "1")
                                    GestureDetector(
                                      onTap: () {
                                        Get.toNamed(manageCurrencyRoute);
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 8),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Icon(
                                              CupertinoIcons.money_pound_circle,
                                              color: blackColor,
                                              size: 24,
                                            ),
                                            SizedBox(
                                              width: 12,
                                            ),
                                            Expanded(
                                                child: Text(
                                              "Manage Currency",
                                              style:
                                                  utils.labelStyle(blackColor),
                                            )),
                                            Icon(
                                              CupertinoIcons.forward,
                                              color: blackColor,
                                              size: 24,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  if (userController.user!.type == 0 &&
                                      checkAdminController.isAdmin == "1")
                                    Container(
                                      width: Get.width,
                                      height: 1,
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 6),
                                      color: checkAdminController
                                          .system.mainColor
                                          .withOpacity(0.3),
                                    ),
                                  if (userController.user!.type == 0 &&
                                      checkAdminController.isAdmin == "1")
                                    GestureDetector(
                                      onTap: () {
                                        Get.toNamed(manageCategoriesRoute);
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 8),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Icon(
                                              CupertinoIcons
                                                  .rectangle_3_offgrid,
                                              color: blackColor,
                                              size: 24,
                                            ),
                                            SizedBox(
                                              width: 12,
                                            ),
                                            Expanded(
                                                child: Text(
                                              "Manage Category",
                                              style:
                                                  utils.labelStyle(blackColor),
                                            )),
                                            Icon(
                                              CupertinoIcons.forward,
                                              color: blackColor,
                                              size: 24,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  if (userController.user!.type == 0 &&
                                      checkAdminController.isAdmin == "1")
                                    Container(
                                      width: Get.width,
                                      height: 1,
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 6),
                                      color: checkAdminController
                                          .system.mainColor
                                          .withOpacity(0.3),
                                    ),
                                  if (userController.user!.type == 0 &&
                                      checkAdminController.isAdmin == "1")
                                    GestureDetector(
                                      onTap: () {
                                        Get.toNamed(manageBrandRoute);
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 8),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Icon(
                                              CupertinoIcons.tornado,
                                              color: blackColor,
                                              size: 24,
                                            ),
                                            SizedBox(
                                              width: 12,
                                            ),
                                            Expanded(
                                                child: Text(
                                              "Manage Brand",
                                              style:
                                                  utils.labelStyle(blackColor),
                                            )),
                                            Icon(
                                              CupertinoIcons.forward,
                                              color: blackColor,
                                              size: 24,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  if (userController.user!.type == 0 &&
                                      checkAdminController.isAdmin == "1")
                                    Container(
                                      width: Get.width,
                                      height: 1,
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 6),
                                      color: checkAdminController
                                          .system.mainColor
                                          .withOpacity(0.3),
                                    ),
                                  if (userController.user!.type == 0 &&
                                      checkAdminController.isAdmin == "1")
                                    GestureDetector(
                                      onTap: () {
                                        Get.toNamed(addProductRoute);
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 8),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Icon(
                                              CupertinoIcons.plus_circled,
                                              color: blackColor,
                                              size: 24,
                                            ),
                                            SizedBox(
                                              width: 12,
                                            ),
                                            Expanded(
                                                child: Text(
                                              "Add Product",
                                              style:
                                                  utils.labelStyle(blackColor),
                                            )),
                                            Icon(
                                              CupertinoIcons.forward,
                                              color: blackColor,
                                              size: 24,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  if (userController.user!.type == 0 &&
                                      checkAdminController.isAdmin == "1")
                                    Container(
                                      width: Get.width,
                                      height: 1,
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 6),
                                      color: checkAdminController
                                          .system.mainColor
                                          .withOpacity(0.3),
                                    ),
                                  if (userController.user!.type == 0 &&
                                      checkAdminController.isAdmin == "1")
                                    GestureDetector(
                                      onTap: () {
                                        Get.to(ManageCouponPage());
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 8),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Icon(
                                              CupertinoIcons.tag,
                                              color: blackColor,
                                              size: 24,
                                            ),
                                            SizedBox(
                                              width: 12,
                                            ),
                                            Expanded(
                                                child: Text(
                                              "Coupons",
                                              style:
                                                  utils.labelStyle(blackColor),
                                            )),
                                            Icon(
                                              CupertinoIcons.forward,
                                              color: blackColor,
                                              size: 24,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  if (userController.user!.type == 0 &&
                                      checkAdminController.isAdmin == "1")
                                    Container(
                                      width: Get.width,
                                      height: 1,
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 6),
                                      color: checkAdminController
                                          .system.mainColor
                                          .withOpacity(0.3),
                                    ),
                                ],
                              )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
      ),
    );
  }

  void setData() {
    setState(() {});
  }
}
