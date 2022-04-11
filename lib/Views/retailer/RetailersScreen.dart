import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectsaleorder/AppConstants/Constants.dart';
import 'package:connectsaleorder/GetXController/CheckAdminController.dart';
import 'package:connectsaleorder/GetXController/UserController.dart';
import 'package:connectsaleorder/Models/CountriesModel.dart';
import 'package:connectsaleorder/Utils/AppUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

class RetailersScreen extends StatefulWidget {
  RetailersScreen();

  @override
  _RetailersScreen createState() => _RetailersScreen();
}

class _RetailersScreen extends State<RetailersScreen> {
  var utils = AppUtils();
  CheckAdminController adminController = Get.find();
  var currentIndex = 0;
  AreaModel? selectedArea;
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
                              "Retailers",
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
                                  Container(
                                    margin: EdgeInsets.symmetric(vertical: 15),
                                    child: TabBar(
                                      labelPadding:
                                          EdgeInsets.symmetric(horizontal: 5),
                                      onTap: (i) async {
                                        setState(() {
                                          currentIndex = i;
                                        });
                                        EasyLoading.show(status: "Loading...");
                                        await Future.delayed(Duration(milliseconds: 500));
                                        userController.setType(i);
                                        EasyLoading.dismiss();
                                      },
                                      isScrollable: true,
                                      indicatorSize: TabBarIndicatorSize.label,
                                      indicator: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color:
                                            checkAController.system.mainColor,
                                      ),
                                      tabs: [
                                        tabStyle(0, 'All'.tr),
                                        tabStyle(1, 'Approved'.tr),
                                        tabStyle(2, 'Rejected'.tr),
                                      ],
                                    ),
                                  ),
                                  if(adminController.system.defaultCountry != null && adminController.system.defaultCountry!.states.length > 0 && adminController.system.defaultCountry!.states[0].cities.length > 0 && adminController.system.defaultCountry!.states[0].cities[0].areas.length > 0)Container(
                                    width: Get.width,
                                    margin: EdgeInsets.symmetric(vertical: 4),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: (){
                                              _presentBottomSheetArea(context, userController);
                                            },
                                            child: Container(
                                              margin: EdgeInsets.symmetric(horizontal: 8),
                                              padding: EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                                              decoration: BoxDecoration(
                                                  color: whiteColor,
                                                  borderRadius: BorderRadius.circular(8),
                                                  border: Border.all(color: blackColor.withOpacity(0.4) , width: 1)
                                              ),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  SizedBox(width: 10,),
                                                  Expanded(child: Text(
                                                    selectedArea != null ? "${selectedArea!.name}"  :"All Areas",
                                                    style: utils.smallLabelStyle(blackColor),
                                                  )),
                                                  Icon(CupertinoIcons.chevron_down , color: blackColor, size: 16,)
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  userController.retailers.length > 0
                                      ? Wrap(
                                          children: [
                                            for (var i = 0;
                                                i <
                                                    userController
                                                        .retailers.length;
                                                i++)
                                              InkWell(
                                                onTap: () {
                                                  userController
                                                      .getCurrentRetailer(
                                                          userController
                                                              .retailers[i]
                                                              .uid);
                                                  Get.toNamed(
                                                      retailerDetailRoute);
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
                                                                          userController.retailers[i].image ??
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
                                                                  "${userController.retailers[i].retailerModel!.shopName} (${userController.retailers[i].retailerModel!.contactPerson})",
                                                                  style: utils
                                                                      .boldLabelStyle(
                                                                          blackColor),
                                                                ),
                                                                SizedBox(
                                                                  height: 4,
                                                                ),
                                                                Text(
                                                                  "${userController.retailers[i].retailerModel!.phone}",
                                                                  style: utils.smallLabelStyle(
                                                                      blackColor
                                                                          .withOpacity(
                                                                              0.6)),
                                                                ),
                                                                SizedBox(
                                                                  height: 4,
                                                                ),
                                                                Text(
                                                                  "From: ${userController.retailers[i].retailerModel!.area}, ${userController.retailers[i].retailerModel!.city}",
                                                                  style: utils.xSmallLabelStyle(
                                                                      blackColor
                                                                          .withOpacity(
                                                                              0.6)),
                                                                ),
                                                              ],
                                                            )),
                                                            Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .end,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Container(
                                                                  padding: EdgeInsets
                                                                      .symmetric(
                                                                          horizontal:
                                                                              12,
                                                                          vertical:
                                                                              6),
                                                                  decoration: BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              8),
                                                                      color: userController
                                                                              .retailers[
                                                                                  i]
                                                                              .retailerModel!
                                                                              .approved
                                                                          ? greenColor.withOpacity(
                                                                              0.3)
                                                                          : redColor
                                                                              .withOpacity(0.3)),
                                                                  child: Text(
                                                                    "${userController.retailers[i].retailerModel!.approved ? "Approved" : "Not Approved"}",
                                                                    style: utils.xSmallLabelStyle(userController
                                                                            .retailers[i]
                                                                            .retailerModel!
                                                                            .approved
                                                                        ? greenColor
                                                                        : redColor),
                                                                  ),
                                                                )
                                                              ],
                                                            )
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
                                                "No retailer exist",
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

  Widget tabStyle(int index, String title) {
    return Container(
      decoration: BoxDecoration(
          color: currentIndex == index ? Colors.transparent : Colors.white,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
              color: currentIndex == index
                  ? Colors.transparent
                  : Color(0xffc4c4c4))),
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title,
              style: utils.smallLabelStyle(
                  currentIndex == index ? Colors.white : Color(0xffc4c4c4)))
        ],
      ),
    );
  }

  void _presentBottomSheetArea(BuildContext context, UserController userController) {
    var searchController = TextEditingController();
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0) , topRight: Radius.circular(20)),
      ),
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (BuildContext context1,StateSetter setState){
          return Container(
            height: Get.size.height - 30,
            color: Colors.transparent,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: whiteColor
                    ),
                    child: Center(
                      child: Icon(CupertinoIcons.xmark , color: adminController.system.mainColor,),
                    ),
                  ),
                ),
                SizedBox(height: 10,),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(topRight: Radius.circular(20) , topLeft: Radius.circular(20)),
                      color: whiteColor
                  ),
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 12),
                    width: double.infinity,
                    child: form("Search", "Search", searchController,onChange: (val){
                      setState((){});
                    }),
                  ),
                ),
                Expanded(child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 10,vertical: 12),
                  decoration: BoxDecoration(
                      color: whiteColor
                  ),
                  child: SingleChildScrollView(
                    child: Wrap(
                      children: <Widget>[
                        Wrap(
                          children: [
                            for(var i = 0 ; i < adminController.system.defaultCountry!.states[0].cities[0].areas.length ; i++)
                              if(adminController.system.defaultCountry!.states[0].cities[0].areas[i].name.toLowerCase().contains(searchController.text.toLowerCase()))
                                utils.areaList(adminController.system.defaultCountry!.states[0].cities[0].areas[i] , (){
                                  selectedArea = adminController.system.defaultCountry!.states[0].cities[0].areas[i];
                                  userController.setArea(selectedArea!.name);
                                  setState((){
                                    Navigator.pop(context);
                                  });
                                }),

                            utils.areaList(AreaModel(id: "0", name: "All Areas") , (){
                                  selectedArea = null;
                                  userController.setArea(null);
                                  setState((){
                                    Navigator.pop(context);
                                  });
                                })
                          ],
                        )
                      ],
                    ),
                  ),
                ))
              ],
            ),
          );
        },
      ),
    );
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
