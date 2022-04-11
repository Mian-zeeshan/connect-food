import 'dart:io';

import 'package:connectsaleorder/GetXController/CheckAdminController.dart';
import 'package:connectsaleorder/GetXController/Couponcontroller.dart';
import 'package:connectsaleorder/Models/CouponModel.dart';
import 'package:connectsaleorder/Utils/AppUtils.dart';
import 'package:cr_calendar/cr_calendar.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../AppConstants/Constants.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class AddCoupons extends StatefulWidget{
  @override
  _AddCoupons createState() => _AddCoupons();

}

class _AddCoupons extends State<AddCoupons>{

  CheckAdminController checkAdminController = Get.find();
  var utils = AppUtils();
  var controllerCode = TextEditingController();
  var controllerName = TextEditingController();
  var controllerDescription = TextEditingController();
  var controllerTerms = TextEditingController();
  var controllerMaxOrderPrice = TextEditingController();
  var controllerMaxPrice = TextEditingController();
  var controllerCouponValue = TextEditingController();
  var validFrom;
  var validBefore;
  var validFromUser;
  var validBeforeUser;
  var selectedType = 0;

  final ImagePicker _picker = ImagePicker();
  File? _image;
  FirebaseStorage _storage = FirebaseStorage.instance;

  Future _getImage() async {
    var image =
    await _picker.pickImage(source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      _image = File(image!.path);
    });
  }


  Future<String> uploadPic(File file) async {
    var random = DateTime.now();
    firebase_storage.Reference reference =
    _storage.ref().child("images/$random.JPG");
    var downUrl = "";
    if (GetPlatform.isWeb) {
      var rawBytes = file.readAsBytesSync();
      firebase_storage.UploadTask uploadTask = reference.putData(rawBytes);
      downUrl = await (await uploadTask).ref.getDownloadURL();
    }else {
      firebase_storage.UploadTask uploadTask = reference.putFile(file);
      downUrl = await (await uploadTask).ref.getDownloadURL();
    }
    return downUrl;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0),
        child: AppBar(
          backgroundColor: checkAdminController.system.mainColor,
        ),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
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
                  Expanded(child: Text("Add Coupon" , style: utils.headingStyle(whiteColor),)),
                ],
              ),
            ),
            Expanded(child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 12,),
                    AspectRatio(
                      aspectRatio: 16/9,
                      child: InkWell(
                        onTap: (){
                          _getImage();
                        },
                        child: Container(
                          width: Get.width,
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: checkAdminController.system.mainColor, width: 1)
                          ),
                          child: _image == null ? Center(
                            child: Icon(CupertinoIcons.add, color: checkAdminController.system.mainColor, size: 42,),
                          ) : Image.file(_image!, fit: BoxFit.cover,),
                        ),
                      ),
                    ),
                    SizedBox(height: 12,),
                    utils.textField(Colors.transparent, null, blackColor, null, null, blackColor, "Coupon Name", blackColor.withOpacity(0.5), blackColor.withOpacity(0.5), 2.0, Get.width, false, controllerName),
                    SizedBox(height: 12,),
                    utils.textField(Colors.transparent, null, blackColor, null, null, blackColor, "Coupon Code", blackColor.withOpacity(0.5), blackColor.withOpacity(0.5), 2.0, Get.width, false, controllerCode),
                    SizedBox(height: 12,),
                    utils.textField(Colors.transparent, null, blackColor, null, null, blackColor, "Coupon Description", blackColor.withOpacity(0.5), blackColor.withOpacity(0.5), 2.0, Get.width, false, controllerDescription, multiline: true),
                    SizedBox(height: 12,),
                    utils.textField(Colors.transparent, null, blackColor, null, null, blackColor, "Terms", blackColor.withOpacity(0.5), blackColor.withOpacity(0.5), 2.0, Get.width, false, controllerTerms, multiline: true),
                    SizedBox(height: 12,),
                    Container(
                      width: Get.width,
                      child: Text("Ruling", style: utils.headingStyle(blackColor),),
                    ),
                    SizedBox(height: 12,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Valid From", style: utils.labelStyle(blackColor),),
                            InkWell(
                              onTap: (){
                                showCalendarDialog(0);
                              },
                              child: Container(
                                width: Get.width,
                                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: blackColor.withOpacity(0.5) , width: 2.0)
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(child: Text("${validFrom??"--/--/----"}", style: utils.labelStyle(blackColor),)),
                                    SizedBox(width: 10,),
                                    Icon(CupertinoIcons.timer, color: blackColor.withOpacity(0.6),size: 20,),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )),
                        SizedBox(width: 12,),
                        Expanded(child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Valid Before", style: utils.labelStyle(blackColor),),
                            InkWell(
                              onTap: (){
                                showCalendarDialog(1);
                              },
                              child: Container(
                                width: Get.width,
                                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: blackColor.withOpacity(0.5) , width: 2.0)
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(child: Text("${validBefore??"--/--/----"}", style: utils.labelStyle(blackColor),)),
                                    SizedBox(width: 10,),
                                    Icon(CupertinoIcons.timer, color: blackColor.withOpacity(0.6),size: 20,),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ))
                      ],
                    ),
                    SizedBox(height: 12,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Users register from", style: utils.labelStyle(blackColor),),
                            InkWell(
                              onTap: (){
                                showCalendarDialog(2);
                              },
                              child: Container(
                                width: Get.width,
                                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: blackColor.withOpacity(0.5) , width: 2.0)
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(child: Text("${validFromUser??"-/--/----"}", style: utils.labelStyle(blackColor),)),
                                    SizedBox(width: 10,),
                                    Icon(CupertinoIcons.timer, color: blackColor.withOpacity(0.6),size: 20,),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )),
                        SizedBox(width: 12,),
                        Expanded(child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Users register before", style: utils.labelStyle(blackColor),),
                            InkWell(
                              onTap: (){
                                showCalendarDialog(3);
                              },
                              child: Container(
                                width: Get.width,
                                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: blackColor.withOpacity(0.5) , width: 2.0)
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(child: Text("${validBeforeUser??"--/--/----"}", style: utils.labelStyle(blackColor),)),
                                    SizedBox(width: 10,),
                                    Icon(CupertinoIcons.timer, color: blackColor.withOpacity(0.6),size: 20,),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ))
                      ],
                    ),
                    SizedBox(height: 12,),
                    utils.textField(Colors.transparent, null, blackColor, null, null, blackColor, "Max Order Price", blackColor.withOpacity(0.5), blackColor.withOpacity(0.5), 2.0, Get.width, false, controllerMaxOrderPrice, isNumber: true),
                    SizedBox(height: 12,),
                    utils.textField(Colors.transparent, null, blackColor, null, null, blackColor, "Max Discount Price", blackColor.withOpacity(0.5), blackColor.withOpacity(0.5), 2.0, Get.width, false, controllerMaxPrice, isNumber: true),
                    SizedBox(height: 12,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: (){
                            setState(() {
                              selectedType = 0;
                            });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: checkAdminController.system.mainColor, width: 2),
                                ),
                                child: Center(
                                  child: Container(
                                    width: 18,
                                    height: 18,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: selectedType == 0 ? checkAdminController.system.mainColor : Colors.transparent
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 12,),
                              Expanded(child: Text("Percentage", style: utils.labelStyle(blackColor),))
                            ],
                          ),
                        )),
                        SizedBox(width: 12,),
                        Expanded(child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: (){
                            setState(() {
                              selectedType = 1;
                            });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(color: checkAdminController.system.mainColor, width: 2)
                                ),
                                child: Center(
                                  child: Container(
                                    width: 18,
                                    height: 18,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: selectedType == 1 ? checkAdminController.system.mainColor : Colors.transparent
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 12,),
                              Expanded(child: Text("Flat", style: utils.labelStyle(blackColor),))
                            ],
                          ),
                        )),
                      ],
                    ),
                    SizedBox(height: 12,),
                    utils.textField(Colors.transparent, null, blackColor, null, null, blackColor, "Coupon Value", blackColor.withOpacity(0.5), blackColor.withOpacity(0.5), 2.0, Get.width, false, controllerCouponValue, isNumber: true),
                    SizedBox(height: 20,),
                    utils.button(checkAdminController.system.mainColor, "Add", whiteColor, checkAdminController.system.mainColor, 2.0, () async {
                      if(_image == null){
                        Get.snackbar("Opps", "Please select the image first.");
                        return;
                      } else if(controllerName.text.isEmpty){
                        Get.snackbar("Opps", "Please enter the name first.");
                        return;
                      } else if(controllerCode.text.isEmpty){
                        Get.snackbar("Opps", "Please enter the code first.");
                        return;
                      } else if(controllerDescription.text.isEmpty){
                        Get.snackbar("Opps", "Please enter the description first.");
                        return;
                      } else if(controllerTerms.text.isEmpty){
                        Get.snackbar("Opps", "Please enter the terms first.");
                        return;
                      } else if(controllerMaxOrderPrice.text.isEmpty){
                        Get.snackbar("Opps", "Please enter the maximum order price first.");
                        return;
                      } else if(controllerMaxPrice.text.isEmpty){
                        Get.snackbar("Opps", "Please enter the maximum discount price first.");
                        return;
                      } else if(controllerCouponValue.text.isEmpty){
                        Get.snackbar("Opps", "Please enter the coupon value first.");
                        return;
                      } else if(validFrom == null){
                        Get.snackbar("Opps", "Please enter the Validation.");
                        return;
                      } else if(validBefore == null){
                        Get.snackbar("Opps", "Please enter the Validation.");
                        return;
                      }

                      if(validFromUser == null){
                        validFromUser = DateFormat("dd-MM-yyyy").format(DateTime(2021,1,1));
                      }

                      if(validBeforeUser == null){
                        validBeforeUser = DateFormat("dd-MM-yyyy").format(DateTime(2050,12,31));
                      }
                      CouponController couponController = Get.find();
                      EasyLoading.show(status: "Loading...");
                      String url = await uploadPic(_image!);
                      CouponModel coupon = CouponModel(image: url, name: controllerName.text.toString(), code: controllerCode.text.toString(), description: controllerDescription.text.toString(), terms: controllerTerms.text.toString(), validFrom: DateFormat("dd-MM-yyyy").parse(validFrom).millisecondsSinceEpoch, validBefore: DateFormat("dd-MM-yyyy").parse(validBefore).millisecondsSinceEpoch, registerFrom: DateFormat("dd-MM-yyyy").parse(validFromUser).millisecondsSinceEpoch, registerBefore: DateFormat("dd-MM-yyyy").parse(validBeforeUser).millisecondsSinceEpoch, maxOrderPrice: int.parse(controllerMaxPrice.text.toString()), discountType: selectedType == 0 ? "%" : "@", value: int.parse(controllerCouponValue.text.toString()), couponId: "", createdAt: DateTime.now().millisecondsSinceEpoch, updatedAt: DateTime.now().millisecondsSinceEpoch);
                      await couponController.addCoupons(coupon);
                      EasyLoading.dismiss();
                      Get.back();
                      utils.snackBar(context, message: "Coupon Added");
                    }),
                    SizedBox(height: 20,),
                  ],
                ),
              ),
            ))
          ],
        ),
      ),
    );
  }

  void showCalendarDialog(type) {
    showCrDatePicker(
      context,
      properties: DatePickerProperties(
        pickerMode: TouchMode.singleTap,
        backButton: Icon(CupertinoIcons.back , color: whiteColor,),
        forwardButton: Icon(CupertinoIcons.forward , color: blackColor,),
        pickerTitleBuilder: (DateTime dateTime) => Text(DateFormat("MMMM yyyy").format(dateTime), style: utils.smallLabelStyle(blackColor),),
        controlBarTitleBuilder: (DateTime dateTime) => Text(DateFormat("EEE, dd MMM yyyy").format(dateTime), style: utils.smallLabelStyle(blackColor),),
        weekDaysBuilder: (WeekDay weekDay) => Text(getWeekDay(weekDay.index), style: utils.smallLabelStyle(blackColor),),
        backgroundColor: whiteColor,
        dayItemBuilder: (DayItemProperties dayProperties) => Container(
          padding: EdgeInsets.all(4),
          decoration: BoxDecoration(
              color: dayProperties.isFirstInRange || dayProperties.isLastInRange ? checkAdminController.system.mainColor : dayProperties.isInRange ? checkAdminController.system.mainColor.withOpacity(0.5) : dayProperties.isSelected ? checkAdminController.system.mainColor :dayProperties.isCurrentDay ? greenColor : Colors.transparent,
              borderRadius: dayProperties.isFirstInRange ? BorderRadius.only(topLeft: Radius.circular(4) , bottomLeft:  Radius.circular(4)) : dayProperties.isLastInRange ? BorderRadius.only(topRight: Radius.circular(4) , bottomRight:  Radius.circular(4)) :dayProperties.isCurrentDay ? BorderRadius.circular(4) : BorderRadius.circular(0)
          ),
          child: Center(child: Text("${dayProperties.dayNumber}" , style: utils.boldLabelStyle(blackColor),)),
        ),
        firstWeekDay: WeekDay.sunday,
        initialPickerDate: DateTime.now(),
        onDateRangeSelected: (DateTime? rangeBegin, DateTime? rangeEnd) {
          if(type == 0){
            validFrom = DateFormat("dd-MM-yyyy").format(rangeBegin??DateTime.now());
          }else if(type == 1){
            validBefore = DateFormat("dd-MM-yyyy").format(rangeBegin??DateTime.now());
          }else if(type == 2){
            validFromUser = DateFormat("dd-MM-yyyy").format(rangeBegin??DateTime.now());
          }else{
            validBeforeUser = DateFormat("dd-MM-yyyy").format(rangeBegin??DateTime.now());
          }
          setState(() {
          });
        },
        cancelButtonBuilder: (onPress) => GestureDetector(
            onTap: (){
              return onPress!();
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 14 , vertical: 6),
              decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(color: checkAdminController.system.mainColor),
                  borderRadius: BorderRadius.circular(8)
              ),
              child: Center(
                child: Text("CANCEL".tr , style: utils.boldLabelStyle(checkAdminController.system.mainColor),),
              ),
            )
        ),
        okButtonBuilder: (onPress) => GestureDetector(
            onTap: (){
              return onPress!();
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 14 , vertical: 6),
              decoration: BoxDecoration(
                  color: checkAdminController.system.mainColor,
                  borderRadius: BorderRadius.circular(8)
              ),
              child: Center(
                child: Text("OK".tr , style: utils.boldLabelStyle(whiteColor),),
              ),
            )
        ),
      ),
    );
  }

  String getWeekDay(int index) {
    return index == 0 ? "S" : index == 1 ? "M" : index == 2 ? "T" : index == 3 ? "W" :index == 4 ? "T" :index == 5 ? "F" : "S";
  }

}