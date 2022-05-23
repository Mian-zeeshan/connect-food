import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectsaleorder/AppConstants/Constants.dart';
import 'package:connectsaleorder/GetXController/CheckAdminController.dart';
import 'package:connectsaleorder/GetXController/UserController.dart';
import 'package:connectsaleorder/Utils/AppUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

class RiderScreen extends StatefulWidget {
  RiderScreen();

  @override
  _RiderScreen createState() => _RiderScreen();
}

class _RiderScreen extends State<RiderScreen> {
  var utils = AppUtils();
  CheckAdminController adminController = Get.find();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CheckAdminController>(
        id: "0",
        builder: (checkAController) {
          adminController = checkAController;
          return Scaffold(
            backgroundColor: whiteColor,
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(0),
              child: AppBar(
                backgroundColor: checkAController.system.mainColor,
                elevation: 0,
              ),
            ),
            body: SafeArea(
              child: DefaultTabController(
                length: 3,
                child: Container(
                  width: Get.width,
                  height: Get.height,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: Get.width,
                        padding:
                        EdgeInsets.symmetric(horizontal: 2, vertical: 4),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20)),
                            color: checkAController.system.mainColor),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            IconButton(
                                onPressed: () {
                                  Get.back();
                                },
                                icon: Icon(
                                  CupertinoIcons.arrow_left,
                                  color: whiteColor,
                                )),
                            Expanded(
                                child: Text(
                                  "Riders",
                                  style: utils.headingStyle(whiteColor),
                                ))
                          ],
                        ),
                      ),
                      Expanded(
                          child: SingleChildScrollView(
                            child: GetBuilder<UserController>(
                                id: "0",
                                builder: (userController) {
                                  return Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      userController.riders.length > 0
                                          ? Wrap(
                                        children: [
                                          for (var i = 0;
                                          i <
                                              userController
                                                  .riders.length;
                                          i++)
                                            InkWell(
                                              onTap: () {
                                              },
                                              child: Container(
                                                width: Get.width,
                                                child: Column(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment
                                                      .start,
                                                  children: [
                                                    Container(
                                                      width: Get.width,
                                                      padding: EdgeInsets
                                                          .symmetric(
                                                          horizontal: 12,
                                                          vertical: 8),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .start,
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                        children: [
                                                          Container(
                                                            width: 60,
                                                            height: 60,
                                                            clipBehavior: Clip
                                                                .antiAliasWithSaveLayer,
                                                            decoration: BoxDecoration(
                                                                shape: BoxShape
                                                                    .circle,
                                                                color: checkAController
                                                                    .system
                                                                    .mainColor),
                                                            child:
                                                            CachedNetworkImage(
                                                                imageUrl:
                                                                userController.riders[i].image ??
                                                                    "",
                                                                placeholder:
                                                                    (context, url) =>
                                                                    SpinKitRotatingCircle(
                                                                      color: whiteColor,
                                                                    ),
                                                                errorWidget: (context,
                                                                    url,
                                                                    error) =>
                                                                    Icon(
                                                                      Icons.image_not_supported_rounded,
                                                                      color:
                                                                      whiteColor,
                                                                      size:
                                                                      25.h,
                                                                    ),
                                                                fit: BoxFit
                                                                    .cover),
                                                          ),
                                                          SizedBox(
                                                            width: 12,
                                                          ),
                                                          Expanded(
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                                crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                                children: [
                                                                  Text(
                                                                    "${userController.riders[i].name}",
                                                                    style: utils
                                                                        .boldLabelStyle(
                                                                        blackColor),
                                                                  ),
                                                                  SizedBox(
                                                                    height: 4,
                                                                  ),
                                                                  Text(
                                                                    "${userController.riders[i].phone}",
                                                                    style: utils.smallLabelStyle(
                                                                        blackColor
                                                                            .withOpacity(
                                                                            0.6)),
                                                                  ),
                                                                  SizedBox(
                                                                    height: 4,
                                                                  ),
                                                                  Text(
                                                                    "From: ${userController.riders[i].address}",
                                                                    style: utils.xSmallLabelStyle(
                                                                        blackColor
                                                                            .withOpacity(
                                                                            0.6)),
                                                                  ),
                                                                ],
                                                              )),
                                                        ],
                                                      ),
                                                    ),
                                                    Container(
                                                      width: Get.width,
                                                      height: 0.8,
                                                      color: grayColor
                                                          .withOpacity(0.5),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            )
                                        ],
                                      )
                                          : Container(
                                        width: Get.width,
                                        height: Get.height * 0.6,
                                        child: Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          children: [
                                            Icon(
                                              CupertinoIcons.info,
                                              size: 42,
                                              color: redColor,
                                            ),
                                            SizedBox(
                                              height: 12.h,
                                            ),
                                            Text(
                                              "No rider exist",
                                              style: utils
                                                  .smallLabelStyle(grayColor),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  );
                                }),
                          ))
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  Widget form(String hints, String label, TextEditingController controller,{onChange}) {
    return Container(
      height: MediaQuery.of(context).size.height / 12,
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.text,
        onChanged: onChange,
        style: utils.smallLabelStyle(blackColor),
        decoration: InputDecoration(
            labelStyle: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 10,
                color: blackColor
            ),
            hintStyle: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 10,
                color: blackColor
            ),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            labelText: label,
            hintText: hints),
      ),
    );
  }

  void setData() {
    setState(() {
    });
  }

}
