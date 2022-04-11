import 'dart:convert';

import 'package:connectsaleorder/AppConstants/Constants.dart';
import 'package:connectsaleorder/Models/CustomerModel.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';

class CustomerController extends GetxController{
  List<CustomerModel> customers = [];

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getCustomers();
  }

  void getCustomers() {
    FirebaseDatabase database = FirebaseDatabase(databaseURL: databaseUrl);
    
    if(!GetPlatform.isWeb) {
      database.setPersistenceEnabled(true);
      database.setPersistenceCacheSizeBytes(10000000);
    }
    DatabaseReference reference = database.reference();
    reference
        .child(customerRef)
        .onValue.listen((event) {
      customers = [];
      if(event.snapshot.exists){
        event.snapshot.value.forEach((key,value){
          CustomerModel customerModel = CustomerModel.fromJson(jsonDecode(jsonEncode(value)));
          customers.add(customerModel);
        });
      }
      update(["0"]);
      notifyChildrens();
    });
  }

  void addCustomer(CustomerModel customerModel) {
    customers.add(customerModel);
    update(["0"]);
    notifyChildrens();
  }
}