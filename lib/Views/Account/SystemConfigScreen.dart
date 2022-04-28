import 'dart:io';

import 'package:connectsaleorder/AppConstants/Constants.dart';
import 'package:connectsaleorder/GetXController/CheckAdminController.dart';
import 'package:connectsaleorder/GetXController/UserController.dart';
import 'package:connectsaleorder/Models/CategoryModel.dart';
import 'package:connectsaleorder/Models/ItemModel.dart';
import 'package:connectsaleorder/Models/SystemSettingModel.dart';
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
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';


class SystemConfigScreen extends StatefulWidget{
  bool fromWeb;
  SystemConfigScreen({this.fromWeb = false});
  @override
  _SystemConfigScreen createState() => _SystemConfigScreen();
}

class _SystemConfigScreen extends State<SystemConfigScreen>{
  var utils = AppUtils();
  List<Languages> itemGridStyles = [];
  List<Languages> itemListStyle = [];
  List<String> bottomStyles = ["Assets/Images/style-9.gif" , "Assets/Images/style-1.gif" ,"Assets/Images/style-3.gif" ,"Assets/Images/style-6.gif" ,"Assets/Images/style-7.gif" ,"Assets/Images/style-10.gif" , "Assets/Images/style-12.gif" ,"Assets/Images/style-13.gif" ,"Assets/Images/style-15.gif" ,"Assets/Images/style-16.gif"];
  var selectedGrid = 0;
  var selectedCategory = 0;
  var selectedList = 0;
  var selectedBottomStyle = 0;
  late ItemModel itemModel;
  late ItemModel itemModel4;
  CheckAdminController checkAdminController = Get.find();
  late Color pickedColor;
  late Color selectedColor;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedBottomStyle = checkAdminController.system.bottomNavigationChecks.bottomStyle;
    selectedColor = checkAdminController.system.mainColor;
    pickedColor = checkAdminController.system.mainColor;
    itemGridStyles.add(Languages(code: "001", name: "default"));
    itemGridStyles.add(Languages(code: "002", name: "Style 1"));
    itemGridStyles.add(Languages(code: "003", name: "Style 2"));
    itemGridStyles.add(Languages(code: "004", name: "Style 3"));
    itemListStyle.add(Languages(code: "001", name: "default"));
    itemListStyle.add(Languages(code: "002", name: "Style 1"));
    itemListStyle.add(Languages(code: "003", name: "Style 2"));
    itemListStyle.add(Languages(code: "004", name: "Style 3"));
    itemModel = ItemModel(status: 0,code: "0", name: "Samsung Galaxy S21", type: "0", salesRate: 99999, style: "0", mUnit: "1Kg", images: ["https://www.apple.com/newsroom/images/product/iphone/standard/Apple_new-iphone-se-white_04152020_big.jpg"], purchaseRate: 129999, stock: [], deliveryApplyItem: 2, deliveryPrice: 50, freeDeliveryItems: -1, maxDeliveryTime: 0, minDeliveryTime: 0, parentId: null);
    itemModel.totalStock = 99;
    itemModel.disCont = true;
    itemModel.discountType = "%";
    itemModel.discountVal = 30;
    itemModel.discountedPrice = 89999;
    itemModel.rating = 3.3;
    itemModel.images = [];
    itemModel.images.add("https://i.gadgets360cdn.com/large/samsung_galaxy_s21_plus_image_voice_evan_blass_1609136733026.jpg");
    itemModel4 = itemModel;
    itemModel4.images = [];
    itemModel4.images.add("https://files.gsmchoice.com/phones/huawei-nova-9/huawei-nova-9-22.jpg");

    setState(() {
    });
  }

  final ImagePicker _picker = ImagePicker();
  File? _image;
  FirebaseStorage _storage = FirebaseStorage.instance;

  Future _getImage() async {
    var image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 50);

    setState(() {
      _image = File(image!.path);
    });
  }
  uploadPic(file) async {
    EasyLoading.show(status: "Uploading...");
    var random = DateTime.now();
    //Create a reference to the location you want to upload to in firebase
    firebase_storage.Reference reference =
    _storage.ref().child("images/$random.JPG");
    //Upload the file to firebase
    firebase_storage.UploadTask uploadTask = reference.putFile(file);
    var dowurl = await (await uploadTask).ref.getDownloadURL();
    checkAdminController.updateLogo(dowurl);
    EasyLoading.dismiss();
  }


  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserController>(id : "0",builder: (userController){
      return GetBuilder<CheckAdminController>(id : "0",builder: (checkController){
        SystemSettingModel settingModel = checkController.system;

        for(var a = 0; a < itemGridStyles.length; a++){
            if(itemGridStyles[a].code == settingModel.itemGridStyle.code){
              selectedGrid = a;
              break;
            }
        }
        for(var a = 0; a < itemListStyle.length; a++){
            if(itemListStyle[a].code == settingModel.itemListStyle.code){
              selectedList = a;
              break;
            }
        }

        selectedCategory = settingModel.categoryView;

        return Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(0),
            child: AppBar(
              elevation: 0,
              backgroundColor: checkAdminController.system.mainColor,
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
                            Get.back();
                          },
                          child: Icon(CupertinoIcons.arrow_left , color: whiteColor, size: 24,)
                        ),
                        SizedBox(width: 12,),
                        Expanded(child: Text("System Configuration".tr, style: utils.headingStyle(whiteColor),)),
                      ],
                    ),
                  ),
                  Expanded(child: SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 12 , vertical: 12),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Company Logo" , style: utils.boldLabelStyle(blackColor),),
                          SizedBox(height: 10,),
                          GestureDetector(
                            onTap: (){
                              _getImage();
                            },
                            child: Container(
                              width: Get.width,
                              child: Center(
                                child: Container(
                                  width: 100,
                                  height: 100,
                                  alignment: Alignment.center,
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: whiteColor
                                  ),
                                  child: Center(
                                      child: _image == null ? Image.network(checkAdminController.system.companyLogo , fit: BoxFit.contain,) : Image.file(_image!)
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 10,),
                          Container(
                            width: Get.width,
                            child: Center(
                              child: utils.button(checkAdminController.system.mainColor, "Update Logo", whiteColor, checkAdminController.system.mainColor, 1.0, (){
                               if(_image == null){
                                 Get.snackbar("Error", "Upload Logo First!");
                               }else{
                                 uploadPic(_image);
                               }
                              }),
                            ),
                          ),
                          SizedBox(height: 10,),
                          Container(
                            width: Get.width,
                            height: 1,
                            margin: EdgeInsets.symmetric(horizontal: 12,vertical: 6),
                            color: checkAdminController.system.mainColor.withOpacity(0.3),
                          ),
                          SizedBox(height: 20,),
                          Text("Languages" , style: utils.boldLabelStyle(blackColor),),
                          SizedBox(height: 10,),
                          Wrap(
                            alignment: WrapAlignment.start,
                            children: [
                              for(var i = 0; i < settingModel.languages.length; i++)
                                Container(
                                  child: Row(
                                    children: [
                                      Checkbox(value: settingModel.languages[i].isSelected, onChanged: (val){
                                        settingModel.languages[i].isSelected = val!;
                                        settingModel.languages[i].isSelected = val;
                                        setState(() {
                                        });
                                      }, activeColor: checkAdminController.system.mainColor,),
                                      Text(settingModel.languages[i].name , style: utils.smallLabelStyle(blackColor),)
                                    ],
                                  ),
                                )
                            ],
                          ),
                          SizedBox(height: 10,),
                          Container(
                            width: Get.width,
                            child: Center(
                              child: utils.button(checkAdminController.system.mainColor, "Update Language", whiteColor, checkAdminController.system.mainColor, 1.0, (){
                                var exist = false;
                                for(var l in settingModel.languages){
                                  if(l.isSelected){
                                    exist = true;
                                  }
                                }
                                if(exist){
                                  checkController.updateLanguages(settingModel.languages);
                                  Get.snackbar("Success", "Languages updated");
                                }else{
                                  Get.snackbar("Error", "Select at least one language");
                                }
                              }),
                            ),
                          ),
                          SizedBox(height: 10,),
                          Container(
                            width: Get.width,
                            height: 1,
                            margin: EdgeInsets.symmetric(horizontal: 12,vertical: 6),
                            color: checkAdminController.system.mainColor.withOpacity(0.3),
                          ),
                          SizedBox(height: 10,),
                          Text("Color" , style: utils.boldLabelStyle(blackColor),),
                          SizedBox(height: 20,),
                          GestureDetector(
                            onTap: (){
                              showColorDialog();
                            },
                            child: Container(
                              width: Get.width,
                              margin: EdgeInsets.symmetric(horizontal: Get.width * 0.2),
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: pickedColor
                              ),
                            ),
                          ),
                          SizedBox(height: 10,),
                          Container(
                            width: Get.width,
                            child: Center(
                              child: utils.button(checkAdminController.system.mainColor, "Update Color", whiteColor, checkAdminController.system.mainColor, 1.0, (){
                                  checkController.updateColor(pickedColor);
                                  Get.snackbar("Success", "Color Changed");
                              }),
                            ),
                          ),
                          SizedBox(height: 10,),
                          Container(
                            width: Get.width,
                            height: 1,
                            margin: EdgeInsets.symmetric(horizontal: 12,vertical: 6),
                            color: checkAdminController.system.mainColor.withOpacity(0.3),
                          ),
                          SizedBox(height: 20,),
                          Text("Bottom Navigation" , style: utils.boldLabelStyle(blackColor),),
                          SizedBox(height: 10,),
                          Wrap(
                            alignment: WrapAlignment.start,
                            children: [
                                Container(
                                  child: Row(
                                    children: [
                                      Checkbox(value: settingModel.bottomNavigationChecks.isCart, onChanged: (val){
                                        settingModel.bottomNavigationChecks.isCart = val!;
                                        setState(() {
                                        });
                                      }, activeColor: checkAdminController.system.mainColor,),
                                      Text("Cart" , style: utils.smallLabelStyle(blackColor),)
                                    ],
                                  ),
                                ),
                              Container(
                                  child: Row(
                                    children: [
                                      Checkbox(value: settingModel.bottomNavigationChecks.isCategories, onChanged: (val){
                                        settingModel.bottomNavigationChecks.isCategories = val!;
                                        setState(() {
                                        });
                                      }, activeColor: checkAdminController.system.mainColor,),
                                      Text("Categories" , style: utils.smallLabelStyle(blackColor),)
                                    ],
                                  ),
                                ),
                              Container(
                                  child: Row(
                                    children: [
                                      Checkbox(value: settingModel.bottomNavigationChecks.isDeals, onChanged: (val){
                                        settingModel.bottomNavigationChecks.isDeals = val!;
                                        setState(() {
                                        });
                                      }, activeColor: checkAdminController.system.mainColor,),
                                      Text("Deals" , style: utils.smallLabelStyle(blackColor),)
                                    ],
                                  ),
                                ),
                              Container(
                                  child: Row(
                                    children: [
                                      Checkbox(value: settingModel.bottomNavigationChecks.isFavorite, onChanged: (val){
                                        settingModel.bottomNavigationChecks.isFavorite = val!;
                                        setState(() {
                                        });
                                      }, activeColor: checkAdminController.system.mainColor,),
                                      Text("Favorite" , style: utils.smallLabelStyle(blackColor),)
                                    ],
                                  ),
                                ),
                              Container(
                                  child: Row(
                                    children: [
                                      Checkbox(value: settingModel.bottomNavigationChecks.isOrders, onChanged: (val){
                                        settingModel.bottomNavigationChecks.isOrders = val!;
                                        setState(() {
                                        });
                                      }, activeColor: checkAdminController.system.mainColor,),
                                      Text("Orders" , style: utils.smallLabelStyle(blackColor),)
                                    ],
                                  ),
                                ),
                              Container(
                                  child: Row(
                                    children: [
                                      Checkbox(value: settingModel.bottomNavigationChecks.isProducts, onChanged: (val){
                                        settingModel.bottomNavigationChecks.isProducts = val!;
                                        setState(() {
                                        });
                                      }, activeColor: checkAdminController.system.mainColor,),
                                      Text("Products" , style: utils.smallLabelStyle(blackColor),)
                                    ],
                                  ),
                                ),
                            ],
                          ),
                          SizedBox(height: 10,),
                          Container(
                            width: Get.width,
                            child: Center(
                              child: utils.button(checkAdminController.system.mainColor, "Update Bottom Nav", whiteColor, checkAdminController.system.mainColor, 1.0, (){
                                var checks = 0;
                                if(settingModel.bottomNavigationChecks.isCart){
                                  checks++;
                                }

                                if(settingModel.bottomNavigationChecks.isCategories){
                                  checks++;
                                }

                                if(settingModel.bottomNavigationChecks.isDeals){
                                  checks++;
                                }

                                if(settingModel.bottomNavigationChecks.isFavorite){
                                  checks++;
                                }

                                if(settingModel.bottomNavigationChecks.isOrders){
                                  checks++;
                                }

                                if(settingModel.bottomNavigationChecks.isProducts){
                                  checks++;
                                }


                                if(checks == 3){
                                  checkController.updateBottomNav(settingModel.bottomNavigationChecks);
                                  Get.snackbar("Success", "Bottom Navigation updated");
                                }else{
                                  Get.snackbar("Error", "Select 3 options!");
                                }
                              }),
                            ),
                          ),
                          SizedBox(height: 10,),
                          Container(
                            width: Get.width,
                            height: 1,
                            margin: EdgeInsets.symmetric(horizontal: 12,vertical: 6),
                            color: checkAdminController.system.mainColor.withOpacity(0.3),
                          ),
                          SizedBox(height: 10,),
                          Text("Bottom Navigation Style" , style: utils.boldLabelStyle(blackColor),),
                          SizedBox(height: 10,),
                          Wrap(
                            alignment: WrapAlignment.start,
                            children: [
                                for(var i = 0 ; i < bottomStyles.length; i++)
                                  Container(
                                    width: GetPlatform.isWeb ? Get.width * 0.3 : Get.width,
                                    padding: EdgeInsets.symmetric(horizontal: 10),
                                    margin: EdgeInsets.symmetric(vertical: 5),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          child: Image.asset(bottomStyles[i]),
                                        ),
                                        SizedBox(height: 10,),
                                        GestureDetector(
                                          onTap : (){
                                            selectedBottomStyle = i;
                                            setState(() {
                                            });
                                          },
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Container(
                                                width: 18,
                                                height: 18,
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: selectedBottomStyle == i ? checkAdminController.system.mainColor : whiteColor,
                                                    border: Border.all(color: checkAdminController.system.mainColor)
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                            ],
                          ),
                          SizedBox(height: 10,),
                          Container(
                            width: Get.width,
                            child: Center(
                              child: utils.button(checkAdminController.system.mainColor, "Update Bottom Style", whiteColor, checkAdminController.system.mainColor, 1.0, (){
                                settingModel.bottomNavigationChecks.bottomStyle = selectedBottomStyle;
                                checkController.updateBottomNav(settingModel.bottomNavigationChecks);
                                  Get.snackbar("Success", "Bottom Navigation updated");
                              }),
                            ),
                          ),
                          SizedBox(height: 10,),
                          Container(
                            width: Get.width,
                            height: 1,
                            margin: EdgeInsets.symmetric(horizontal: 12,vertical: 6),
                            color: checkAdminController.system.mainColor.withOpacity(0.3),
                          ),
                          SizedBox(height: 10,),
                          Text("Item Grid View" , style: utils.boldLabelStyle(blackColor),),
                          SizedBox(height: 10,),
                          Container(
                            width: Get.width,
                            child: Wrap(
                              alignment: WrapAlignment.spaceEvenly,
                              children: [
                                GestureDetector(
                                  onTap : (){
                                    selectedGrid = 0;
                                    checkController.system.itemGridStyle = Languages(code: "001", name: "Default");
                                    setState(() {
                                    });
                                  },
                                  child: Container(
                                      width: GetPlatform.isWeb ? 220.w :Get.width * 0.44,
                                      margin: EdgeInsets.symmetric(horizontal: 2, vertical: 10),
                                      child: Container(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            ItemWidget(itemModel),
                                            SizedBox(height: 10,),
                                            GestureDetector(
                                              onTap : (){
                                                selectedGrid = 0;
                                                checkController.system.itemGridStyle = Languages(code: "001", name: "Default");
                                                setState(() {
                                                });
                                              },
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    width: 18,
                                                    height: 18,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: selectedGrid == 0 ? checkAdminController.system.mainColor : whiteColor,
                                                      border: Border.all(color: checkAdminController.system.mainColor)
                                                    ),
                                                  )
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                  ),
                                ) ,
                                GestureDetector(
                                  onTap : (){
                                    selectedGrid = 1;
                                    checkController.system.itemGridStyle = Languages(code: "002", name: "Style 2");
                                    setState(() {
                                    });
                                  },
                                  child: Container(
                                      width: GetPlatform.isWeb ? 220.w :Get.width * 0.44,
                                      margin: EdgeInsets.symmetric(horizontal: 2, vertical: 10),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            ItemWidgetStyle2(itemModel),
                                            GestureDetector(
                                              onTap : (){
                                                selectedGrid = 1;
                                                checkController.system.itemGridStyle = Languages(code: "002", name: "Style 2");
                                                setState(() {
                                                });
                                              },
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    width: 18,
                                                    height: 18,
                                                    decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: selectedGrid == 1 ? checkAdminController.system.mainColor : whiteColor,
                                                        border: Border.all(color: checkAdminController.system.mainColor)
                                                    ),
                                                  )
                                                ],
                                              ),
                                            )
                                          ],
                                        )
                                      ),
                                ),
                                GestureDetector(
                                  onTap : (){
                                    selectedGrid = 2;
                                    checkController.system.itemGridStyle = Languages(code: "003", name: "Style 3");
                                    setState(() {
                                    });
                                  },
                                  child: Container(
                                      width: GetPlatform.isWeb ? 220.w :Get.width * 0.44,
                                      margin: EdgeInsets.symmetric(horizontal: 2, vertical: 10),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            ItemWidgetStyle3(itemModel),
                                            GestureDetector(
                                              onTap : (){
                                                selectedGrid = 2;
                                                checkController.system.itemGridStyle = Languages(code: "003", name: "Style 3");
                                                setState(() {
                                                });
                                              },
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    width: 18,
                                                    height: 18,
                                                    decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: selectedGrid == 2 ? checkAdminController.system.mainColor : whiteColor,
                                                        border: Border.all(color: checkAdminController.system.mainColor)
                                                    ),
                                                  )
                                                ],
                                              ),
                                            )
                                          ],
                                        )
                                      ),
                                ),
                                GestureDetector(
                                  onTap : (){
                                    selectedGrid = 3;
                                    checkController.system.itemGridStyle = Languages(code: "004", name: "Style 4");
                                    setState(() {
                                    });
                                  },
                                  child: Container(
                                      width: GetPlatform.isWeb ? 220.w :Get.width * 0.44,
                                      margin: EdgeInsets.symmetric(horizontal: 2, vertical: 10),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            ItemWidgetStyle4(itemModel),
                                            GestureDetector(
                                              onTap : (){
                                                selectedGrid = 3;
                                                checkController.system.itemGridStyle = Languages(code: "004", name: "Style 4");
                                                setState(() {
                                                });
                                              },
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    width: 18,
                                                    height: 18,
                                                    decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: selectedGrid == 3 ? checkAdminController.system.mainColor : whiteColor,
                                                        border: Border.all(color: checkAdminController.system.mainColor)
                                                    ),
                                                  )
                                                ],
                                              ),
                                            )
                                          ],
                                        )
                                      ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(height: 10,),
                          Container(
                            width: Get.width,
                            child: Center(
                              child: utils.button(checkAdminController.system.mainColor, "Update Grid View", whiteColor, checkAdminController.system.mainColor, 1.0, (){
                                  checkController.updateItemGridStyle(settingModel.itemGridStyle);
                                  Get.snackbar("Success", "Grid Item Updated");
                              }),
                            ),
                          ),
                          SizedBox(height: 10,),
                          Container(
                            width: Get.width,
                            height: 1,
                            margin: EdgeInsets.symmetric(horizontal: 12,vertical: 6),
                            color: checkAdminController.system.mainColor.withOpacity(0.3),
                          ),
                          SizedBox(height: 10,),
                          Text("Item List View" , style: utils.boldLabelStyle(blackColor),),
                          SizedBox(height: 10,),
                          Container(
                            width: Get.width,
                            child: Wrap(
                              alignment: WrapAlignment.spaceEvenly,
                              children: [
                                GestureDetector(
                                  onTap : (){
                                    selectedList = 0;
                                    checkController.system.itemGridStyle = Languages(code: "001", name: "Default");
                                    setState(() {
                                    });
                                  },
                                  child: Container(
                                      width: Get.width,
                                      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          ItemListWidget(itemModel),
                                          SizedBox(height: 10,),
                                          GestureDetector(
                                            onTap : (){
                                              selectedList = 0;
                                              checkController.system.itemListStyle = Languages(code: "001", name: "Default");
                                              setState(() {
                                              });
                                            },
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  width: 18,
                                                  height: 18,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: selectedList == 0 ? checkAdminController.system.mainColor : whiteColor,
                                                    border: Border.all(color: checkAdminController.system.mainColor)
                                                  ),
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      )
                                  ),
                                ) ,
                                GestureDetector(
                                  onTap : (){
                                    selectedList = 1;
                                    checkController.system.itemGridStyle = Languages(code: "002", name: "Style 2");
                                    setState(() {
                                    });
                                  },
                                  child: Container(
                                      width: Get.width,
                                      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          ItemListWidget2(itemModel),
                                          SizedBox(height: 10,),
                                          GestureDetector(
                                            onTap : (){
                                              selectedList = 1;
                                              checkController.system.itemListStyle = Languages(code: "002", name: "Style 2");
                                              setState(() {
                                              });
                                            },
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  width: 18,
                                                  height: 18,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: selectedList == 1 ? checkAdminController.system.mainColor : whiteColor,
                                                    border: Border.all(color: checkAdminController.system.mainColor)
                                                  ),
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      )
                                  ),
                                ) ,
                                GestureDetector(
                                  onTap : (){
                                    selectedList = 2;
                                    checkController.system.itemGridStyle = Languages(code: "003", name: "Style 3");
                                    setState(() {
                                    });
                                  },
                                  child: Container(
                                      width: Get.width,
                                      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          ItemListWidget3(itemModel),
                                          SizedBox(height: 10,),
                                          GestureDetector(
                                            onTap : (){
                                              selectedList = 2;
                                              checkController.system.itemListStyle = Languages(code: "003", name: "Style 3");
                                              setState(() {
                                              });
                                            },
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  width: 18,
                                                  height: 18,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: selectedList == 2 ? checkAdminController.system.mainColor : whiteColor,
                                                    border: Border.all(color: checkAdminController.system.mainColor)
                                                  ),
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      )
                                  ),
                                ) ,
                                GestureDetector(
                                  onTap : (){
                                    selectedList = 3;
                                    checkController.system.itemGridStyle = Languages(code: "004", name: "Style 4");
                                    setState(() {
                                    });
                                  },
                                  child: Container(
                                      width: Get.width,
                                      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          ItemListWidget4(itemModel4),
                                          SizedBox(height: 10,),
                                          GestureDetector(
                                            onTap : (){
                                              selectedList = 3;
                                              checkController.system.itemListStyle = Languages(code: "004", name: "Style 4");
                                              setState(() {
                                              });
                                            },
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  width: 18,
                                                  height: 18,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: selectedList == 3 ? checkAdminController.system.mainColor : whiteColor,
                                                    border: Border.all(color: checkAdminController.system.mainColor)
                                                  ),
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      )
                                  ),
                                ) ,
                              ],
                            ),
                          ),
                          SizedBox(height: 10,),
                          Container(
                            width: Get.width,
                            child: Center(
                              child: utils.button(checkAdminController.system.mainColor, "Update List View", whiteColor, checkAdminController.system.mainColor, 1.0, (){
                                  checkController.updateItemGridStyle(settingModel.itemListStyle);
                                  Get.snackbar("Success", "List Item Updated");
                              }),
                            ),
                          ),
                          SizedBox(height: 10,),
                          Container(
                            width: Get.width,
                            height: 1,
                            margin: EdgeInsets.symmetric(horizontal: 12,vertical: 6),
                            color: checkAdminController.system.mainColor.withOpacity(0.3),
                          ),
                          SizedBox(height: 10,),
                          Text("Category View" , style: utils.boldLabelStyle(blackColor),),
                          SizedBox(height: 10,),
                          Container(
                            width: Get.width,
                            child: Wrap(
                              alignment: WrapAlignment.spaceEvenly,
                              children: [
                                GestureDetector(
                                  onTap : (){
                                    selectedCategory = 0;
                                    checkController.system.categoryView = selectedCategory;
                                    setState(() {
                                    });
                                  },
                                  child: Container(
                                      width: GetPlatform.isWeb ? 220.w :Get.width * 0.44,
                                      margin: EdgeInsets.symmetric(horizontal: 2, vertical: 10),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          CategoryWidget(CategoryModel(code: "0" , name: "Mobiles" , secondName: "", image: 'https://hamariweb.com/images/articles/articles/110218_01.png')),
                                          SizedBox(height: 10,),
                                          GestureDetector(
                                            onTap : (){
                                              selectedCategory = 0;
                                              checkController.system.categoryView = selectedCategory;
                                              setState(() {
                                              });
                                            },
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  width: 18,
                                                  height: 18,
                                                  decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: selectedCategory == 0 ? checkAdminController.system.mainColor : whiteColor,
                                                      border: Border.all(color: checkAdminController.system.mainColor)
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      )
                                  ),
                                ),
                                GestureDetector(
                                  onTap : (){
                                    selectedCategory = 1;
                                    checkController.system.categoryView = selectedCategory;
                                    setState(() {
                                    });
                                  },
                                  child: Container(
                                      width: GetPlatform.isWeb ? 220.w :Get.width * 0.44,
                                      margin: EdgeInsets.symmetric(horizontal: 2, vertical: 10),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          CategoryWidget2(CategoryModel(code: "0" , name: "Mobiles" , secondName: "", image: 'https://hamariweb.com/images/articles/articles/110218_01.png')),
                                          SizedBox(height: 10,),
                                          GestureDetector(
                                            onTap : (){
                                              selectedCategory = 1;
                                              checkController.system.categoryView = selectedCategory;
                                              setState(() {
                                              });
                                            },
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  width: 18,
                                                  height: 18,
                                                  decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: selectedCategory == 1 ? checkAdminController.system.mainColor : whiteColor,
                                                      border: Border.all(color: checkAdminController.system.mainColor)
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      )
                                  ),
                                ),
                                GestureDetector(
                                  onTap : (){
                                    selectedCategory = 2;
                                    checkController.system.categoryView = selectedCategory;
                                    setState(() {
                                    });
                                  },
                                  child: Container(
                                      width: GetPlatform.isWeb ? 220.w :Get.width * 0.44,
                                      margin: EdgeInsets.symmetric(horizontal: 2, vertical: 10),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          CategoryWidget3(CategoryModel(code: "0" , name: "Mobiles" , secondName: "", image: 'https://hamariweb.com/images/articles/articles/110218_01.png')),
                                          SizedBox(height: 10,),
                                          GestureDetector(
                                            onTap : (){
                                              selectedCategory = 2;
                                              checkController.system.categoryView = selectedCategory;
                                              setState(() {
                                              });
                                            },
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  width: 18,
                                                  height: 18,
                                                  decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: selectedCategory == 2 ? checkAdminController.system.mainColor : whiteColor,
                                                      border: Border.all(color: checkAdminController.system.mainColor)
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      )
                                  ),
                                ),
                                GestureDetector(
                                  onTap : (){
                                    selectedCategory = 3;
                                    checkController.system.categoryView = selectedCategory;
                                    setState(() {
                                    });
                                  },
                                  child: Container(
                                      width: GetPlatform.isWeb ? 220.w :Get.width * 0.44,
                                      margin: EdgeInsets.symmetric(horizontal: 2, vertical: 10),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          CategoryWidget4(CategoryModel(code: "0" , name: "Mobiles" , secondName: "", image: 'https://hamariweb.com/images/articles/articles/110218_01.png')),
                                          SizedBox(height: 10,),
                                          GestureDetector(
                                            onTap : (){
                                              selectedCategory = 3;
                                              checkController.system.categoryView = selectedCategory;
                                              setState(() {
                                              });
                                            },
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  width: 18,
                                                  height: 18,
                                                  decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: selectedCategory == 3 ? checkAdminController.system.mainColor : whiteColor,
                                                      border: Border.all(color: checkAdminController.system.mainColor)
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      )
                                  ),
                                ),
                                GestureDetector(
                                  onTap : (){
                                    selectedCategory = 4;
                                    checkController.system.categoryView = selectedCategory;
                                    setState(() {
                                    });
                                  },
                                  child: Container(
                                      width: GetPlatform.isWeb ? 220.w :Get.width * 0.44,
                                      margin: EdgeInsets.symmetric(horizontal: 2, vertical: 10),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          CategoryWidget5(CategoryModel(code: "0" , name: "Mobiles" , secondName: "", image: 'https://hamariweb.com/images/articles/articles/110218_01.png')),
                                          SizedBox(height: 10,),
                                          GestureDetector(
                                            onTap : (){
                                              selectedCategory = 4;
                                              checkController.system.categoryView = selectedCategory;
                                              setState(() {
                                              });
                                            },
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  width: 18,
                                                  height: 18,
                                                  decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: selectedCategory == 4 ? checkAdminController.system.mainColor : whiteColor,
                                                      border: Border.all(color: checkAdminController.system.mainColor)
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      )
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10,),
                          Container(
                            width: Get.width,
                            child: Center(
                              child: utils.button(checkAdminController.system.mainColor, "Update Category View", whiteColor, checkAdminController.system.mainColor, 1.0, (){
                                checkController.updateCategory(settingModel.categoryView);
                                Get.snackbar("Success", "Category View Updated");
                              }),
                            ),
                          ),
                          SizedBox(height: 10,),
                          Container(
                            width: Get.width,
                            height: 1,
                            margin: EdgeInsets.symmetric(horizontal: 12,vertical: 6),
                            color: checkAdminController.system.mainColor.withOpacity(0.3),
                          ),
                          SizedBox(height: 10,),
                        ],
                      ),
                    ),
                  ))
                ],
              ),
            ),
          ),
        );
      });
    });
  }

  void showColorDialog() {
    late BuildContext dialogContext;
    var hexController = TextEditingController();
    Dialog errorDialog = Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      backgroundColor: Colors.transparent,
      //this right here
      child: StatefulBuilder(
        builder: (context, setState) {
          return SingleChildScrollView(
            child: Container(
              width: Get.width,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: whiteColor,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      child: Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          Container(
                            width: Get.width,
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            alignment: Alignment.centerLeft,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pop(dialogContext);
                              },
                              child: Icon(
                                CupertinoIcons.xmark_octagon_fill,
                                color: checkAdminController.system.mainColor,
                                size: 24,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 40),
                            child: Text(
                              "Pick Color",
                              style: utils.xLHeadingStyle(blackColor),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding:
                      EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      width: Get.width,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ColorPicker(
                            pickerColor: selectedColor,
                            onColorChanged: (color) {
                              selectedColor = color;
                              setState(() {});
                            },
                            showLabel: true,
                            pickerAreaHeightPercent: 0.8,
                            hexInputController: hexController,
                          ),
                          SizedBox(height: 10,),
                          utils.textField(whiteColor, null, null, null, null, blackColor, "Color Code", blackColor.withOpacity(0.4), checkAdminController.system.mainColor, 1.0, Get.width, false, hexController)
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 12),
                      child: utils.button(checkAdminController.system.mainColor, "Pick", whiteColor, checkAdminController.system.mainColor, 1.0, (){
                        pickedColor = selectedColor;
                        Navigator.pop(dialogContext);
                        setData();
                      }),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
    showDialog(
        context: context,
        builder: (BuildContext context) {
          dialogContext = context;
          return errorDialog;
        });
  }

  setData(){
    setState(() {
    });
  }

}