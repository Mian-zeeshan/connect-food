import 'dart:async';

import 'package:connectsaleorder/AppConstants/Constants.dart';
import 'package:connectsaleorder/GetXController/CheckAdminController.dart';
import 'package:connectsaleorder/GetXController/ItemController.dart';
import 'package:connectsaleorder/GetXController/UserController.dart';
import 'package:connectsaleorder/Models/CustomerModel.dart';
import 'package:connectsaleorder/Utils/AppUtils.dart';
import 'package:connectsaleorder/Utils/ItemListWidget.dart';
import 'package:connectsaleorder/Utils/ItemListWidget2.dart';
import 'package:connectsaleorder/Utils/ItemListWidget3.dart';
import 'package:connectsaleorder/Utils/ItemListWidget4.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class SearchScreen extends StatefulWidget {
  bool fromWeb;
  SearchScreen({this.fromWeb = false});
  @override
  _SearchScreen createState() => _SearchScreen();
}

class _SearchScreen extends State<SearchScreen> {
  var utils = AppUtils();
  var searchController = TextEditingController();
  ScrollController _scrollController = ScrollController();
  ItemController iController = Get.find();
  var selectedStyle = " ";
  UserController userController = Get.find();
  CustomerModel? selectedCModel;
  CheckAdminController checkAdminController = Get.find();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    iController.getSearchProducts(false);
    if(GetPlatform.isWeb){
      searchController.text = " ";
    }
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        iController.searchProducts(selectedStyle);
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
              SizedBox(height: 12,),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if(!widget.fromWeb) IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: Icon(
                        CupertinoIcons.arrow_left,
                        color: blackColor,
                        size: 20,
                      )),
                  SizedBox(
                    width: 2,
                  ),
                  Expanded(
                    child: utils.textField(
                        grayColor.withOpacity(0.3),
                        null,
                        null,
                        CupertinoIcons.search,
                        blackColor.withOpacity(0.6),
                        blackColor,
                        "Search...",
                        blackColor.withOpacity(0.5),
                        blackColor.withOpacity(0.6),
                        2.0,
                        Get.width - 12,
                        false,
                        searchController, onTextChange: (val) {
                          Timer.periodic(Duration(milliseconds: 600), (timer) {
                            timer.cancel();
                            if(searchController.text.isNotEmpty) {
                              iController.searchProducts(searchController.text.toString());
                            }else{
                              iController.emptyProductsSearch();
                            }
                          });
                    }),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  if (searchController.text.length > 0)
                    IconButton(
                        onPressed: () {
                          searchController.clear();
                          iController.emptyProductsSearch();
                        },
                        icon: Icon(
                          CupertinoIcons.xmark_circle,
                          color: checkAdminController.system.mainColor,
                        ))
                ],
              ),
              Expanded(child: SingleChildScrollView(
                controller: _scrollController,
                child: GetBuilder<ItemController>(
                    id: "0",
                    builder: (itemController) {
                      return itemController.isLoadingSearch ? Container(
                        width: Get.width,
                        height: Get.height-100,
                        child: Center(
                          child: SpinKitRotatingCircle(color: checkAdminController.system.mainColor,),
                        ),
                      ) :(itemController.itemModelsSearchFilter.length > 0
                          ? Container(
                        width: Get.width,
                        child: Wrap(
                          alignment: WrapAlignment.spaceEvenly,
                          children: [
                            for (var i = 0;
                            i < itemController.itemModelsSearchFilter.length;
                            i++)
                              checkAdminController.system
                                  .itemListStyle.code ==
                                  "001"
                                  ? ItemListWidget(
                                  itemController
                                      .itemModelsSearchFilter[i])
                                  : checkAdminController
                                  .system
                                  .itemListStyle
                                  .code ==
                                  "002"
                                  ? ItemListWidget2(
                                  itemController
                                      .itemModelsSearchFilter[i])
                                  : checkAdminController
                                  .system
                                  .itemListStyle
                                  .code ==
                                  "003"
                                  ? ItemListWidget3(
                                  itemController.itemModelsSearchFilter[i])
                                  : checkAdminController.system.itemListStyle.code == "004"
                                  ? ItemListWidget4(itemController.itemModelsSearchFilter[i])
                                  : ItemListWidget(itemController.itemModelsSearchFilter[i])
                          ],
                        ),
                      )
                          : Container(
                        child: Center(
                          child: Lottie.asset(
                              'Assets/lottie/searchempty.json'),
                        ),
                      )
                      );
                    }),
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
}
