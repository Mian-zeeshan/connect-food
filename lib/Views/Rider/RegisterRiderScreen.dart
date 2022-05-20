import 'package:connectsaleorder/AppConstants/Constants.dart';
import 'package:connectsaleorder/GetXController/CheckAdminController.dart';
import 'package:connectsaleorder/GetXController/UserController.dart';
import 'package:connectsaleorder/Models/RetailerModel.dart';
import 'package:connectsaleorder/Models/RiderModel.dart';
import 'package:connectsaleorder/Utils/AppUtils.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class RegisterRiderScreen extends StatefulWidget{
  RegisterRiderScreen();
  @override
  _RegisterRiderScreen createState() => _RegisterRiderScreen();

}

class _RegisterRiderScreen extends State<RegisterRiderScreen>{
  var utils = AppUtils();
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();
  var addressController = TextEditingController();
  var cnicController = TextEditingController();
  var passwordController = TextEditingController();
  CheckAdminController adminController = Get.find();
  UserController userController = Get.find();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CheckAdminController>(id: "0",builder: (checkAController){
      adminController = checkAController;
      return Scaffold(
        backgroundColor: whiteColor,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(0),
          child: AppBar(
            backgroundColor: checkAController.system.mainColor,
            elevation: 0,
          ),
        ),
        body: SafeArea(
          child: Container(
            width: Get.width,
            height: Get.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: Get.width,
                  color: checkAController.system.mainColor,
                  padding: EdgeInsets.only(right: 12, top: 6, bottom: 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(onPressed: ()=> Navigator.pop(context), icon: Icon(CupertinoIcons.arrow_left , color: whiteColor, size: 24,)),
                      SizedBox(width: 12,),
                      Expanded(child: Text("Register Rider" , style: utils.headingStyle(whiteColor),)),
                    ],
                  ),
                ),
                Container(
                  width: Get.width,
                  height: 1,
                  color: grayColor,
                ),
                Expanded(child: SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 12,),
                        form("Name", "Name", nameController),
                        form("Phone", "Phone", phoneController),
                        form("Email", "Email", emailController),
                        form("Address", "Address", addressController),
                        form("CNIC", "CNIC", cnicController),
                        form("Password", "Password", passwordController),
                        SizedBox(height: 20,),
                        SizedBox(height: 20,),
                        Container(
                            width: Get.width,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [checkAController.system.mainColor, checkAController.system.mainColor])),
                            child: TextButton(
                              onPressed: () async {
                                if(nameController.text.isEmpty){
                                  Get.snackbar("Opps!", "Name is required");
                                  return;
                                }else if(phoneController.text.isEmpty){
                                  Get.snackbar("Opps","Phone is required");
                                  return;
                                }else if(emailController.text.isEmpty){
                                  Get.snackbar("Opps","Email is required");
                                  return;
                                }else if(addressController.text.isEmpty){
                                  Get.snackbar("Opps", "Address is required");
                                  return;
                                }else if(cnicController.text.isEmpty){
                                  Get.snackbar("Opps", "Contact Person name is required");
                                  return;
                                }else if(passwordController.text.isEmpty){
                                  Get.snackbar("Opps", "Password is required");
                                  return;
                                }else if(passwordController.text.length < 8){
                                  Get.snackbar("Opps", "Password is too short must be 8 characters.");
                                  return;
                                }
                                RiderModel riderModel = RiderModel(uid: "", name: nameController.text, email: emailController.text.toLowerCase(), phone: phoneController.text, password: passwordController.text, address: addressController.text, cnic: cnicController.text);
                                registerRider(riderModel);
                              },
                              child: Text(
                                  'Save',
                                  style: utils.smallLabelStyle(whiteColor)
                              ),
                            )),
                        SizedBox(height: 20,),
                        Text("")
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
  }

  Widget form(String hints, String label, TextEditingController controller,{onChange}) {
    return Container(
      height: MediaQuery.of(context).size.height / 12,
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.text,
        onChanged: onChange,
        style: utils.smallLabelStyle(blackColor),
        decoration: InputDecoration(
            labelStyle: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 10,
                color: blackColor
            ),
            hintStyle: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 10,
                color: blackColor
            ),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            labelText: label,
            hintText: hints),
      ),
    );
  }

  void setData() {
    setState(() {
    });
  }

  void registerRider(RiderModel riderModel) async {
    FirebaseDatabase database = FirebaseDatabase(databaseURL: databaseUrl);

    if(!GetPlatform.isWeb) {
      database.setPersistenceEnabled(true);
      database.setPersistenceCacheSizeBytes(10000000);
    }
    DatabaseReference reference = database.reference();
    EasyLoading.show(status: "Loading...");
    reference = reference
        .child(riderRef)
        .push();

    riderModel.uid = reference.key;
    await reference.set(riderModel.toJson());
    EasyLoading.dismiss();
    Get.back();
    Get.snackbar("Success", "Rider Register Successfully");
  }
}