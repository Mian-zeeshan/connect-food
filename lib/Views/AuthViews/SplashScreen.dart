import 'dart:async';

import 'package:animated_widgets/widgets/rotation_animated.dart';
import 'package:animated_widgets/widgets/size_animated.dart';
import 'package:connectsaleorder/AppConstants/Constants.dart';
import 'package:connectsaleorder/GetXController/CheckAdminController.dart';
import 'package:connectsaleorder/GetXController/locale_controller.dart';
import 'package:connectsaleorder/Utils/AppUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SplashScreen extends StatefulWidget{
  @override
  _SplashScreen createState() => _SplashScreen();

}

class _SplashScreen extends State<SplashScreen>{
  var isShow = true;
  var utils = AppUtils();
  var box = GetStorage();
  var userValue;
  LocaleController _localeController = Get.find();
  CheckAdminController checkAdminController = Get.find();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer.periodic(Duration(seconds: 3), (timer) async {
      EasyLoading.instance
        ..loadingStyle = EasyLoadingStyle.light
        ..indicatorSize = 45.0
        ..radius = 10.0
        ..progressColor = checkAdminController.system.mainColor
        ..backgroundColor = whiteColor
        ..indicatorColor = checkAdminController.system.mainColor.withOpacity(0.2)
        ..textColor = checkAdminController.system.mainColor
        ..maskColor = checkAdminController.system.mainColor
        ..userInteractions = true
        ..dismissOnTap = false
        ..textStyle = utils.labelStyle(checkAdminController.system.mainColor)
        ..indicatorWidget = Container(
            child: RotationAnimatedWidget.tween(
                enabled: true, //update this boolean to forward/reverse the animation
                duration: Duration(seconds: 30),
                rotationDisabled: Rotation.deg(z: 0),
                rotationEnabled: Rotation.deg(z: 7200),
                child: Image.asset("Assets/Images/logo.png", width: 80, height: 80,)
            )
        );
      //await box.remove(allCarts);
      //await box.remove(allFavorites);
      _localeController.updateLoc();
      userValue = await box.read(currentUser);
      if(userValue != null){
        Get.offAllNamed(homeCRoute);
      }else {
        if(GetPlatform.isWeb)
          Get.offAllNamed(loginRoute);
        else
          Get.offAllNamed(mainAuth);
      }
      timer.cancel();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0),
        child: AppBar(
          backgroundColor: whiteColor,
          elevation: 0,
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              width: Get.width,
              height: Get.height,
              child: Center(
                child: SizeAnimatedWidget(
                  enabled: true,
                  duration: Duration(milliseconds: 1200),
                  values: [Size(Get.width * 0.1, 1000),Size(Get.width * 0.2, 1000),  Size(Get.width * 0.4, 1500),  Size(Get.width * 0.6, 1500), Size(Get.width * 0.8, 1500), Size(Get.width, 1500), Size(Get.width * 0.7, 2000)],
                  curve: Curves.linear,
                  child: Image.asset("Assets/Images/logo.png", width: Get.width * 0.6,),
                ),
              ),
            ),
            Container(
              width: Get.width,
              height: Get.height,
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Powered BY " , style: utils.labelStyle(blackColor),),
                  Image.asset("Assets/Images/logo.png", width: 80)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}