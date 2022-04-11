import 'package:connectsaleorder/AppConstants/Constants.dart';
import 'package:connectsaleorder/GetXController/CheckAdminController.dart';
import 'package:connectsaleorder/GetXController/ItemController.dart';
import 'package:connectsaleorder/Models/CountriesModel.dart';
import 'package:connectsaleorder/Models/CurrencyModel.dart';
import 'package:connectsaleorder/Models/CustomerModel.dart';
import 'package:connectsaleorder/Models/ItemModel.dart';
import 'package:connectsaleorder/Views/orders/bottomsheet/AddToCartBottomsheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class AppUtils{
  xLHeadingStyle(color){
    return TextStyle(
        color: color,
        fontSize: xHeadingFontSize.sp,
        fontWeight: xBold,
        decoration: TextDecoration.none,
        fontFamily: 'Roboto'
    );
  }

  xxLHeadingStyle(color){
    return TextStyle(
        color: color,
        fontSize: xxHeadingFontSize.sp,
        fontWeight: xBold,
        decoration: TextDecoration.none,
        fontFamily: 'Roboto'
    );
  }

  smallLabelStyle(color){
    return TextStyle(
        color: color,
        fontSize: smallFontSize.sp,
        fontWeight: normal,
        decoration: TextDecoration.none,
        fontFamily: 'Roboto'
    );
  }

  xSmallLabelStyle(color){
    return TextStyle(
        color: color,
        fontSize: xSmallFontSize.sp,
        fontWeight: normal,
        decoration: TextDecoration.none,
        fontFamily: 'Roboto'
    );
  }

  xBoldSmallLabelStyle(color){
    return TextStyle(
        color: color,
        fontSize: xSmallFontSize.sp,
        fontWeight: bold,
        decoration: TextDecoration.none,
        fontFamily: 'Roboto'
    );
  }

  smallLabelStyleSlash(color){
    return TextStyle(
        color: color,
        fontSize: smallFontSize.sp,
        fontWeight: normal,
        decoration: TextDecoration.lineThrough,
        fontFamily: 'Roboto'
    );
  }
  xSmallLabelStyleSlash(color){
    return TextStyle(
        color: color,
        fontSize: xSmallFontSize.sp,
        fontWeight: normal,
        decoration: TextDecoration.lineThrough,
        fontFamily: 'Roboto'
    );
  }

  boldSmallLabelStyle(color){
    return TextStyle(
        color: color,
        fontSize: smallFontSize.sp,
        fontWeight: bold,
        decoration: TextDecoration.none,
        fontFamily: 'Roboto'
    );
  }

  labelStyle(color){
    return TextStyle(
        color: color,
        fontSize: labelFontSize.sp,
        fontWeight: normal,
        decoration: TextDecoration.none,
        fontFamily: 'Roboto'
    );
  }

  labelStyleUnderline(color){
    return TextStyle(
        color: color,
        fontSize: labelFontSize.sp,
        fontWeight: normal,
        decoration: TextDecoration.underline,
        fontFamily: 'Roboto'
    );
  }

  headingStyle(color){
    return TextStyle(
        color: color,
        fontSize: headingFontSize.sp,
        fontWeight: bold,
        decoration: TextDecoration.none,
        fontFamily: 'Roboto'
    );
  }

  headingStyle2(color){
    return TextStyle(
        color: color,
        fontSize: headingFontSize.sp,
        fontWeight: normal,
        decoration: TextDecoration.none,
        fontFamily: 'Roboto'
    );
  }

  boldLabelStyle(color){
    return TextStyle(
        color: color,
        fontSize: labelFontSize.sp,
        fontWeight: bold,
        decoration: TextDecoration.none,
        fontFamily: 'Roboto'
    );
  }

  boldLabelStyleSlash(color){
    return TextStyle(
        color: color,
        fontSize: labelFontSize.sp,
        fontWeight: bold,
        decoration: TextDecoration.lineThrough,
        fontFamily: 'Roboto'
    );
  }

  buttonStyle(color){
    return TextStyle(
        color: color,
        fontSize: buttonFontSize.sp,
        fontWeight: bold,
        decoration: TextDecoration.none,
        fontFamily: 'Roboto'
    );
  }

  button( bgColor,  text,  textColor,  borderColor,  borderWidth,  onPress) {
    return InkWell(
      onTap: onPress,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12 , vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: borderColor , width: borderWidth),
          color: bgColor
        ),
        child: Center(
          child: Text(text , style: buttonStyle(textColor),),
        ),
      ),
    );
  }

  textField(bgColor , preIcon , preIconColor, suffixIcon , suffixIconColor, textColor , hint, hintColor, borderColor , borderWidth , width , isSecure , controller , {multiline ,isNumber, isPhone , onTextChange , imageIcon , onClick}){
    return InkWell(
      onTap: onClick,
      child: Container(
        width: width,
        padding: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
            color: bgColor,
            borderRadius: multiline != null ? BorderRadius.circular(12) : BorderRadius.circular(8),
            border: Border.all(color: borderColor , width: borderWidth)
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: multiline != null ? CrossAxisAlignment.center: CrossAxisAlignment.center,
          children: [
            if(preIcon != null) imageIcon == null ? Icon(preIcon, color: preIconColor,size: 20,) : Image.asset(imageIcon , width: 20 , height: 20, color: preIconColor,),
            if(preIcon != null) SizedBox(width: 10,),
            Expanded(child: TextFormField(
              onChanged: onTextChange,
              enabled: onClick == null,
              obscureText: isSecure,
              controller: controller,
              keyboardType: isPhone != null ? TextInputType.phone : isNumber != null ? TextInputType.number : TextInputType.text,
              maxLines: multiline != null ? 3 : 1,
              decoration: InputDecoration(
                  hintText: hint,
                  hintStyle: labelStyle(hintColor),
                  border: InputBorder.none,
              ),
              style: labelStyle(textColor),
            )),
            if(suffixIcon != null) SizedBox(width: 10,),
            if(suffixIcon != null) Icon(suffixIcon, color: suffixIconColor,size: 20,),
          ],
        ),
      ),
    );
  }
  
  void loginBottomSheet(context) {
    CheckAdminController checkAdminController = Get.find();
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
            height: Get.size.height/2,
            color: Colors.transparent,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: Get.width,
                  height: 60,
                  child: Stack(
                    children: [
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
                          "Login Required",
                          style: headingStyle(checkAdminController.system.mainColor),
                        ),
                      ),
                      Positioned(
                        top: 8 ,
                          right: 10,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(CupertinoIcons.xmark_circle_fill  ,color: checkAdminController.system.mainColor, size: 26,),
                          )
                      )
                    ],
                  ),
                ),
                Expanded(
                    child: Container(
                      color: whiteColor,
                      width: Get.width,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: button(checkAdminController.system.mainColor, "Login", whiteColor, checkAdminController.system.mainColor, 2.0 , (){
                              Get.offAllNamed(loginRoute);
                            }),
                          ),
                          SizedBox(height: 10,),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: button(whiteColor, "Sign up", checkAdminController.system.mainColor, checkAdminController.system.mainColor, 2.0, (){
                              Get.offAllNamed(signUpRoute);
                            }),
                          ),
                        ],
                      ),
                    )
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  dateFromStamp(int createdAt) {
    return DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.fromMillisecondsSinceEpoch(createdAt));
  }
  selectionWidget(CustomerModel customer,isSelected, textColor, checkColor, onPress) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 4),
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(CupertinoIcons.checkmark_alt , color: isSelected ? checkColor : Colors.transparent, size: 20,),
                SizedBox(width: 10,),
                Expanded(child: Text(customer.name, style: boldLabelStyle(textColor),)),
                Expanded(child: Container(
                  alignment: Alignment.centerRight,
                  child: Text("${customer.phone}", style: boldLabelStyle(textColor),),
                )),
              ],
            ),
            SizedBox(height: 10,),
            Container(
              height: 1,
              width: double.infinity,
              color: grayColor.withOpacity(0.5),
            )
          ],
        ),
      ),
    );
  }

  String getFormattedPrice(pricea){
    double price = double.parse(pricea.toString()).toPrecision(2);
    ItemController itemController = Get.find();
    final oCcy = new NumberFormat("#,##0", "en_US");
    return oCcy.format(price) + itemController.currencyModel.currencyCode;
  }

  String getOrderStatus(int index){
    switch(index){
      case 0:
        return "Placed";
      case 1:
        return "Preparing";
      case 2:
        return "Shipping";
      case 3:
        return "Shipped";
      case -1:
        return "Canceled";
      default:
        return "N/A";
    }
  }


  selectionItem(itemName ,itemCode, isSelected , onPress){
    CheckAdminController checkAdminController = Get.find();
    return GestureDetector(
      onTap: onPress,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10 , vertical: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(CupertinoIcons.checkmark_alt , size: 24, color: isSelected ? checkAdminController.system.mainColor : whiteColor,),
                  SizedBox(width: 10,),
                  Expanded(child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(itemName , style: boldLabelStyle(blackColor)),
                      Text(itemCode , style: xSmallLabelStyle(blackColor)),
                    ],
                  ))
                ],
              ),
            ),
            SizedBox(height: 10,),
            Container(
              width: Get.width,
              height: 1,
              color: checkAdminController.system.mainColor.withOpacity(0.4),
            )
          ],
        ),
      ),
    );
  }

  selectionList(CurrencyModel currencyModel , isSelected, onPress) {
    CheckAdminController checkAdminController = Get.find();
    return GestureDetector(
      onTap: onPress,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if(isSelected) Icon(CupertinoIcons.checkmark_alt , color: checkAdminController.system.mainColor, size: 20,),
              Expanded(child: Container(
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(horizontal: 12),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  child: RichText(
                    text: TextSpan(
                        children: [
                          TextSpan(
                              text: currencyModel.countryName,
                              style: boldSmallLabelStyle(blackColor)
                          ),TextSpan(
                              text: " (${currencyModel.currencyCode})",
                              style: boldSmallLabelStyle(blackColor)
                          ),
                        ]
                    ),
                  )
              ))
            ],
          ),
          SizedBox(height: 5,),
          Container(
            width: double.infinity,
            color: checkAdminController.system.mainColor.withOpacity(0.3),
            height: 1,
          )
        ],
      ),
    );
  }


  countryList(CountriesModel countriesModel , onPress) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: RichText(
            text: TextSpan(
                children: [
                  TextSpan(
                      text: countriesModel.name,
                      style: labelStyle(blackColor)
                  ),
                  TextSpan(
                      text: ", ",
                      style: labelStyle(blackColor)
                  ),
                  TextSpan(
                      text: countriesModel.capital,
                      style: boldSmallLabelStyle(blackColor)
                  ),
                ]
            ),
          )
      ),
    );
  }

  citiesList(Cities city , onPress) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: RichText(
            text: TextSpan(
                children: [
                  TextSpan(
                      text: city.name,
                      style: labelStyle(blackColor)
                  ),
                ]
            ),
          )
      ),
    );
  }

  areaList(AreaModel area , onPress) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: RichText(
            text: TextSpan(
                children: [
                  TextSpan(
                      text: area.name,
                      style: labelStyle(blackColor)
                  ),
                ]
            ),
          )
      ),
    );
  }

  stateList(States countriesModel , onPress) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: RichText(
            text: TextSpan(
                children: [
                  TextSpan(
                      text: countriesModel.name,
                      style: labelStyle(blackColor)
                  ),
                ]
            ),
          )
      ),
    );
  }

  void snackBar(BuildContext context, {String? message}) {
    Get.snackbar("", message??"Something went wrong");
  }


  showCartBottom(BuildContext context , ItemModel itemModel, onAdd) {
    showMaterialModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,

      barrierColor: Colors.transparent,
      isDismissible: true,
      elevation: 0,
      expand: true,
      builder: (context) => AddToCartBottom(itemModel, onAdd)
    );
  }

}