import 'dart:convert';

import 'package:connectsaleorder/AppConstants/Constants.dart';
import 'package:connectsaleorder/Models/CartModel.dart';
import 'package:connectsaleorder/Models/UserModel.dart';
import 'package:connectsaleorder/Utils/AppUtils.dart';
import 'package:connectsaleorder/services/NotificationApis.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class OrderController extends GetxController{
  List<CartModel> ordersAll = [];
  List<CartModel> ordersAllAdmin = [];
  List<CartModel> orders = [];
  List<CartModel> ordersAdmin = [];
  CartModel? currentOrder;
  List<CartModel> ordersRecent = [];
  late int fromDate;
  late int toDate;
  late UserModel user;
  var box = GetStorage();
  var selectedFilter = 5;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    fromDate = DateTime.now().subtract(Duration(days: 7)).millisecondsSinceEpoch;
    toDate = DateTime.now().millisecondsSinceEpoch;
    getUser();
  }

  setFilter(int filter){
    if(filter == 0){
      this.selectedFilter = 5;
    }else{
      this.selectedFilter = filter-1;
    }
    filterOrder();
    if(user.type == 0){
      getOrdersForAdmin();
    }
  }

  setDateTime(from,to){
    fromDate = from;
    toDate = to;
    filterOrder();
    if(user.type == 0){
      filterOrderAdmin();
    }
  }

  void getOrders() {
      FirebaseDatabase database = FirebaseDatabase(databaseURL: databaseUrl);
      
      if(!GetPlatform.isWeb) {
        database.setPersistenceEnabled(true);
        database.setPersistenceCacheSizeBytes(10000000);
      }
      DatabaseReference reference = database.reference();
      reference
          .child(orderCRef)
          .orderByChild("userId")
          .equalTo(user.uid)
          .onValue
          .listen((event) {
        ordersAll = [];
        if (event.snapshot.exists) {
          event.snapshot.value.forEach((key, value) {
            CartModel order = CartModel.fromJson(jsonDecode(jsonEncode(value)));
            ordersAll.add(order);
          });
        }
        if(DateTime.fromMillisecondsSinceEpoch(toDate).day == DateTime.now().day && DateTime.fromMillisecondsSinceEpoch(toDate).month == DateTime.now().month) {
          toDate = DateTime
              .now()
              .add(Duration(hours: 1))
              .millisecondsSinceEpoch;
        }
        filterOrder();
        recentOrders();
      });
  }

  void getOrdersForAdmin() {
      FirebaseDatabase database = FirebaseDatabase(databaseURL: databaseUrl);
      
      if(!GetPlatform.isWeb) {
        database.setPersistenceEnabled(true);
        database.setPersistenceCacheSizeBytes(10000000);
      }
      DatabaseReference reference1 = database.reference();
      reference1.child(orderCRef).onValue
            .listen((event) {
          ordersAllAdmin = [];
          print("ADMIN ORDERS ${event.snapshot.value.toString()}");
          if (event.snapshot.exists) {
            event.snapshot.value.forEach((key, value) {
              CartModel order = CartModel.fromJson(jsonDecode(jsonEncode(value)));
              if(selectedFilter == 5){
                ordersAllAdmin.add(order);
              }else {
                if (order.status == selectedFilter)
                  ordersAllAdmin.add(order);
              }
            });
          }
          if(DateTime.fromMillisecondsSinceEpoch(toDate).day == DateTime.now().day && DateTime.fromMillisecondsSinceEpoch(toDate).month == DateTime.now().month)
          {
            toDate = DateTime
                .now()
                .add(Duration(hours: 1))
                .millisecondsSinceEpoch;
          }
          filterOrderAdmin();
        });
  }

  void listenOrdersTrack(CartModel cartModel) {
    print(user.uid);
    FirebaseDatabase database = FirebaseDatabase(databaseURL: databaseUrl);
      
    if(!GetPlatform.isWeb) {
      database.setPersistenceEnabled(true);
      database.setPersistenceCacheSizeBytes(10000000);
    }
      DatabaseReference reference = database.reference();
      reference
          .child(orderCRef)
          .child(cartModel.cartId)
          .onValue
          .listen((event) {
        if (event.snapshot.exists) {
          currentOrder = CartModel.fromJson(jsonDecode(jsonEncode(event.snapshot.value)));
        }
        update(["0"]);
        notifyChildrens();
      });
  }

  void getUser() async {
    var value = await box.read(currentUser);
    if(value != null) {
      user = UserModel.fromJson(value);
      getOrders();
      if(user.type == 0){
        getOrdersForAdmin();
      }
    }
  }

  void filterOrder() {
    orders = [];
    print(ordersAll.length);
    for(var order in ordersAll){
      if(order.createdAt >= fromDate && order.createdAt <= toDate) {
        if(selectedFilter == 5){
          orders.add(order);
        }else if(selectedFilter == 4) {
          if(order.status == -1) {
            orders.add(order);
          }
        }else{
          if(order.status == selectedFilter) {
            orders.add(order);
          }
        }
      }
    }
    update(["0"]);
    notifyChildrens();
  }

  void filterOrderAdmin() {
    ordersAdmin = [];
    print(ordersAllAdmin.length);
    for(var order in ordersAllAdmin){
      if(order.createdAt >= fromDate && order.createdAt <= toDate) {
        ordersAdmin.add(order);
      }
    }
    update(["0"]);
    notifyChildrens();
  }

  void recentOrders() {
    ordersRecent = [];
    ordersAll.sort((a,b) => a.createdAt.compareTo(b.createdAt));
    var i=0;
    for(var order in ordersAll){
      ordersRecent.add(order);
      if(i > 4){
        break;
      }
    }
    update(["0"]);
    notifyChildrens();
  }

  void changeStatus(int status, CartModel cartModel) async {
    AppUtils utils = AppUtils();
    EasyLoading.show(status : "Loading...");
    FirebaseDatabase database = FirebaseDatabase(databaseURL: databaseUrl);
    
    if(!GetPlatform.isWeb) {
      database.setPersistenceEnabled(true);
      database.setPersistenceCacheSizeBytes(10000000);
    }
    DatabaseReference reference = database.reference();
    await reference
        .child(orderCRef)
        .child(cartModel.cartId)
        .update({
      "status" : status
    });
    this.selectedFilter = selectedFilter;
    EasyLoading.dismiss();
    sendNotification(cartModel.userId, "Order Updated", "Your order status is updated to ${utils.getOrderStatus(status)}. please check your order");
  }

  sendNotification(uid, title, message) async {
    FirebaseDatabase database = FirebaseDatabase(databaseURL: databaseUrl);

    if(!GetPlatform.isWeb) {
      database.setPersistenceEnabled(true);
      database.setPersistenceCacheSizeBytes(10000000);
    }
    DatabaseReference reference = database.reference();
    reference
        .child(tokenRef)
        .child(uid)
        .onValue
        .listen((event) {
      if (event.snapshot.exists) {
        var token = jsonDecode(jsonEncode(event.snapshot.value))["token"];

        NotificationApis notificationApis = NotificationApis();

        notificationApis.sendNotification(token, title, message);

      }
      update(["0"]);
      notifyChildrens();
    });
  }

  sendNotificationAdmin(title, message) async {
    FirebaseDatabase database = FirebaseDatabase(databaseURL: databaseUrl);

    if(!GetPlatform.isWeb) {
      database.setPersistenceEnabled(true);
      database.setPersistenceCacheSizeBytes(10000000);
    }
    DatabaseReference reference = database.reference();
    reference
        .child(adminTokenRef)
        .onValue
        .listen((event) {
      if (event.snapshot.exists) {
        List<String> tokens = [];
        event.snapshot.value.forEach((key, value){
          var token = jsonDecode(jsonEncode(value))["token"];
          tokens.add(token);
        });

        NotificationApis notificationApis = NotificationApis();

        for(var t in tokens) {
          notificationApis.sendNotification(t, title, message);
        }
      }
      update(["0"]);
      notifyChildrens();
    });
  }
}