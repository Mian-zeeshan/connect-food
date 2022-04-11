import 'dart:convert';

import 'package:connectsaleorder/AppConstants/Constants.dart';
import 'package:connectsaleorder/GetXController/CheckAdminController.dart';
import 'package:connectsaleorder/GetXController/ItemController.dart';
import 'package:connectsaleorder/Models/CurrencyListModel.dart';
import 'package:connectsaleorder/Models/CurrencyModel.dart';

import 'package:connectsaleorder/Utils/AppUtils.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class CurrencyScreen extends StatefulWidget{
  bool fromWeb;
  CurrencyScreen({this.fromWeb = false});
  @override
  _CurrencyScreen createState() => _CurrencyScreen();

}

class _CurrencyScreen extends State<CurrencyScreen>{
  var utils = AppUtils();
  var nameController = TextEditingController();
  CurrencyListModel currencyListModel = CurrencyListModel(country: []);
  CurrencyModel? selectedCurrency;
  ItemController itemController = Get.find();
  CheckAdminController checkAdminController = Get.find();
  var deliveryMaxController = TextEditingController();
  @override
  void initState() {
    super.initState();
    deliveryMaxController.text = checkAdminController.system.maxDeliveryPrice.toString();
    readJson();
  }

  readJson() async {
    final String responseH = await rootBundle.loadString('Assets/lottie/currencylist.json');
    currencyListModel = CurrencyListModel.fromJson(jsonDecode(responseH));
    selectedCurrency = itemController.currencyModel;
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return selectedCurrency == null ? CircularProgressIndicator() : Scaffold(
      backgroundColor: whiteColor,
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if(!widget.fromWeb) Container(
                padding: EdgeInsets.symmetric(horizontal: 15 , vertical: 16),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12),),
                    color: checkAdminController.system.mainColor
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap : (){
                        setState(() {
                          Get.back();
                        });
                      },
                      child: Icon(CupertinoIcons.arrow_left, size: 24, color: whiteColor,),
                    ),
                    SizedBox(width: 20,),
                    Expanded(child: Text("Manage Currency" , style: utils.headingStyle(whiteColor),)),
                  ],
                ),
              ),
              Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      width: Get.width,
                      padding: EdgeInsets.symmetric(horizontal: 12 , vertical: 16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: 12,),
                          GestureDetector(
                            onTap: () {
                              _presentBottomSheet();
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 10),
                              child: Container(
                                width:
                                GetPlatform.isWeb ? 400 : Get.size.width - 30,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 12),
                                decoration: BoxDecoration(
                                    color: whiteColor,
                                    borderRadius: BorderRadius.circular(50),
                                    border: Border.all(
                                        color: checkAdminController.system.mainColor, width: 1)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(CupertinoIcons.tag, color: checkAdminController.system.mainColor,),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                        child: Text(
                                          selectedCurrency!.currencyCode,
                                          style: utils.boldLabelStyle(blackColor),
                                        )),
                                    Icon(
                                      CupertinoIcons.chevron_down,
                                      color: checkAdminController.system.mainColor,
                                      size: 20,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 8,),
                          Container(
                            width: Get.width-40,
                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                            decoration: BoxDecoration(
                                color: whiteColor,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: checkAdminController.system.mainColor , width: 1.0)
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(CupertinoIcons.doc_text_search, color: checkAdminController.system.mainColor,size: 20,),
                                SizedBox(width: 10,),
                                Expanded(child: Text(
                                  "${selectedCurrency!.countryName} (${selectedCurrency!.countryCode})",
                                  style: utils.labelStyle(blackColor),
                                )),
                              ],
                            ),
                          ),
                          SizedBox(height: 20,),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 20),
                            child: utils.button(checkAdminController.system.mainColor, "Update Currency", whiteColor, checkAdminController.system.mainColor, 1.0, (){
                              addCurrency();
                            }),
                          ),
                          SizedBox(height: 30,),
                          Container(
                            width: Get.width-40,
                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                            decoration: BoxDecoration(
                                color: whiteColor,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: checkAdminController.system.mainColor , width: 1.0)
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(CupertinoIcons.money_dollar_circle, color: checkAdminController.system.mainColor,size: 20,),
                                SizedBox(width: 10,),
                                Expanded(child: TextFormField(
                                  controller: deliveryMaxController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration.collapsed(hintText: "Max Delivery Price"),
                                  style: utils.labelStyle(blackColor),
                                )),
                              ],
                            ),
                          ),
                          SizedBox(height: 20,),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 20),
                            child: utils.button(checkAdminController.system.mainColor, "Update max delivery", whiteColor, checkAdminController.system.mainColor, 1.0, () async {
                              if(deliveryMaxController.text.isNotEmpty) {
                                EasyLoading.show(status: "Updating...");
                                await checkAdminController.setMaxDelivery(int.parse(deliveryMaxController.text.toLowerCase()));
                                EasyLoading.dismiss();
                                Get.snackbar("Success", "Updated maximum price to place order.");
                              }
                            }),
                          ),
                        ],
                      ),
                    ),
                  )
              )
            ],
          ),
        ),
      ),
    );
  }


  void addCurrency() async {
    EasyLoading.show(status: "Loading...");
    FirebaseDatabase database = FirebaseDatabase(databaseURL: databaseUrl);
    
    database.setPersistenceEnabled(true);
    database.setPersistenceCacheSizeBytes(10000000);
    DatabaseReference reference = database.reference();
    reference.child(currencyRef).set(
        selectedCurrency!.toJson());
    EasyLoading.dismiss();
    Get.back();
    Get.snackbar("Success", "Currency Updated!");
  }
  void setData() {
    setState(() {
    });
  }

  void _presentBottomSheet() {
    var searchController = TextEditingController();
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0), topRight: Radius.circular(20)),
      ),
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (BuildContext context1, StateSetter setState) {
          return Container(
            height: Get.size.height - 30,
            color: Colors.transparent,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: whiteColor),
                    child: Center(
                      child: Icon(
                        CupertinoIcons.xmark,
                        color: checkAdminController.system.mainColor,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(20),
                          topLeft: Radius.circular(20)),
                      color: whiteColor),
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    "Select Currency",
                    style: utils.boldLabelStyle(checkAdminController.system.mainColor),
                  ),
                ),
                Container(
                  color: whiteColor,
                  width: Get.width,
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: utils.textField(whiteColor, null, checkAdminController.system.mainColor, CupertinoIcons.search, checkAdminController.system.mainColor, blackColor, "Search...", checkAdminController.system.mainColor.withOpacity(0.3), checkAdminController.system.mainColor, 1.0,  GetPlatform.isWeb ? 400 : Get.size.width, false, searchController ,onTextChange:  (text){
                    setState((){
                    });
                  }),
                ),
                Expanded(
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                      decoration: BoxDecoration(color: whiteColor),
                      child: SingleChildScrollView(
                        child: Wrap(
                          children: <Widget>[
                            Wrap(
                              children: [
                                for (var i = 0; i < currencyListModel.country.length; i++)
                                  if(currencyListModel.country[i].countryName.toLowerCase().contains(searchController.text.toLowerCase()))
                                  utils.selectionList(currencyListModel.country[i],currencyListModel.country[i].currencyCode == selectedCurrency!.currencyCode, () {
                                    setState(() {
                                        selectedCurrency = currencyListModel.country[i];
                                        setData();
                                        Navigator.pop(context);
                                    });
                                  })
                              ],
                            )
                          ],
                        ),
                      ),
                    )),
              ],
            ),
          );
        },
      ),
    );
  }

}