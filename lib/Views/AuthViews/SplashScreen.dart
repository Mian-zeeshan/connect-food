import 'dart:async';

import 'package:animated_widgets/widgets/rotation_animated.dart';
import 'package:animated_widgets/widgets/size_animated.dart';
import 'package:connectsaleorder/AppConstants/Constants.dart';
import 'package:connectsaleorder/GetXController/CheckAdminController.dart';
import 'package:connectsaleorder/GetXController/locale_controller.dart';
import 'package:connectsaleorder/Utils/AppUtils.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';


final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (message.notification != null) {
    final title = message.notification!.title??"Mithas";
    final body = message.notification!.body??"Congratulation! thanks for using Mithas.";
    //showNotification(title: title, body: body);
  }
  print('Handling a background message ${message.messageId}');
  return Future<void>.value();
}

void showNotification({required String title, required String body}) {
  var androidPlatformChannelSpecifics = AndroidNotificationDetails('Mithas', 'Mithas notifications',
      icon: 'logo', importance: Importance.max, priority: Priority.max, ticker: 'ticker', playSound: true);

  var iOSPlatformChannelSpecifics = IOSNotificationDetails();

  var platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);

  flutterLocalNotificationsPlugin.show(0, title, body, platformChannelSpecifics, payload: 'Custom_Sound');
}

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


  checkForInitialMessage() async {
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null && initialMessage.notification != null) {
      print("app is terminated and opened from notification:\n" +"title: " +(initialMessage.notification!.title??"") +"\n" +"body: " +(initialMessage.notification!.body??""));
      if (initialMessage.data != null) {
        // isRedirected = true;
        // Get.offAllNamed(notificationRoute);
        print(initialMessage.data);
      }
    }
  }

  registerNotification() async {
    FirebaseMessaging.instance.subscribeToTopic(socialNotifications);
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    var initializationSettingsAndroid = AndroidInitializationSettings('logo');
    var initializationSettingsIOS = IOSInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        onDidReceiveLocalNotification: (int id, String? title, String? body, String? payload) async {

        });
    var initializationSettings = InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: (String? payload) async {
      if (payload != null) {
        // isRedirected = true;
        // Get.offAllNamed(notificationRoute);
        print('notification payload: ' + payload);
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                'Mithas',
                'Mithas notifications',
                icon: 'logo',
              ),
            ));

        /*if (message.data != null) {
          isRedirected = true;
          Get.offAllNamed(notificationRoute);
        }*/
      }
    });
  }

  @override
  void initState() {
    checkForInitialMessage();
    //when app is in background but not terminated
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if(message.notification != null) {
        print(
            "app in background but not terminated and opened from notification:\n" +
                "title: " +
                (message.notification!.title ?? "") +
                "\n" +
                "body: " +
                (message.notification!.body ?? ""));
      }

      if (message.data != null) {
        // isRedirected = true;
        // Get.offAllNamed(notificationRoute);
        // print(message.data);
      }
    });
    registerNotification();

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
                child: Image.asset("Assets/Images/mi_logo.jpeg", width: 80, height: 80,)
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
                  child: Image.asset("Assets/Images/mi_logo.jpeg", width: Get.width * 0.6,),
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