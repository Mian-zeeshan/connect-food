import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';

import '../AppConstants/Constants.dart';
import '../Models/NotificationModel.dart';
import 'UserController.dart';

class NotificationController extends GetxController{
  List<NotificationModel> notifications = [];
  UserController userController = Get.find();

  @override
  void onInit() {
    getNotifications();
    super.onInit();
  }

  getNotifications() async {
    FirebaseDatabase database = FirebaseDatabase(databaseURL: databaseUrl);

    if(!GetPlatform.isWeb) {
      database.setPersistenceEnabled(true);
      database.setPersistenceCacheSizeBytes(10000000);
    }
    DatabaseReference reference = database.reference();
    reference
        .child(notificationRef)
        .child(userController.user!.uid)
        .limitToLast(100)
        .onValue.listen((event) {
      notifications = [];
      if(event.snapshot.exists){
        if(event.snapshot.value != null) {
          event.snapshot.value.forEach((key,value) {
            NotificationModel subCategoryModel = NotificationModel.fromJson(
                jsonDecode(jsonEncode(value)));
            notifications.add(subCategoryModel);
          });
        }
      }
      update(["0"]);
      notifyChildrens();
    });
  }
}