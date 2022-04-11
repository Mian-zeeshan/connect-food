import 'dart:convert';

import 'package:connectsaleorder/AppConstants/Constants.dart';
import 'package:connectsaleorder/GetXController/CheckAdminController.dart';
import 'package:connectsaleorder/GetXController/UserController.dart';
import 'package:connectsaleorder/Models/AddressModel.dart';
import 'package:connectsaleorder/Models/CountriesModel.dart';
import 'package:connectsaleorder/Models/RetailerModel.dart';
import 'package:connectsaleorder/Utils/AppUtils.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:google_places_picker/google_places_picker.dart';

class RegisterRetailerScreen extends StatefulWidget{
  RegisterRetailerScreen();
  @override
  _RegisterRetailerScreen createState() => _RegisterRetailerScreen();

}

class _RegisterRetailerScreen extends State<RegisterRetailerScreen>{
  var utils = AppUtils();
  var nameController = TextEditingController();
  var phoneController = TextEditingController();
  var addressController = TextEditingController();
  var contactPersonController = TextEditingController();
  var contactPhoneController = TextEditingController();
  List<CountriesModel> countriesModels = [];
  List<CountriesModel> countriesFilterModels = [];
  CountriesModel? selectedCountry;
  States? selectedState;
  Cities? selectedCity;
  AreaModel? selectedArea;
  CheckAdminController adminController = Get.find();
  UserController userController = Get.find();
  RetailerModel? retailerModel;
  Place? _place;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(adminController.system.defaultCountry == null) {
      readJson();
    }else{
      countriesModels.add(adminController.system.defaultCountry!);
      countriesFilterModels.add(adminController.system.defaultCountry!);
      if(userController.user!.retailerModel != null) {
        nameController.text = userController.user!.retailerModel!.shopName;
        phoneController.text = userController.user!.retailerModel!.phone;
        addressController.text = userController.user!.retailerModel!.address;
        contactPersonController.text = userController.user!.retailerModel!.contactPerson;
        contactPhoneController.text = userController.user!.retailerModel!.contactPersonPhone;
        for(var c in countriesModels){
          if(c.name == userController.user!.retailerModel!.country){
            selectedCountry = c;
            break;
          }
        }
        if(selectedCountry != null) {
          for (var p in selectedCountry!.states) {
            if (p.name == userController.user!.retailerModel!.province) {
              selectedState = p;
              break;
            }
          }
          if(selectedState != null) {
            for (var c in selectedState!.cities) {
              if (c.name == userController.user!.retailerModel!.city) {
                selectedCity = c;
                break;
              }
            }
            if(selectedCity != null){
              for (var c in selectedCity!.areas) {
                if (c.name == userController.user!.retailerModel!.area) {
                  selectedArea = c;
                  break;
                }
              }
            }
          }
        }
      }
    }
  }
  readJson() async {
    EasyLoading.show(status: "Loading...");
    var response = await rootBundle.loadString('Assets/lottie/countries.json');
    var resValue = await compute(jsonDecode , response);
    resValue.forEach((value){
      countriesModels.add(CountriesModel.fromJson(value));
    });
    countriesFilterModels = countriesModels;
    if(userController.user!.retailerModel != null) {
      nameController.text = userController.user!.retailerModel!.shopName;
      phoneController.text = userController.user!.retailerModel!.phone;
      addressController.text = userController.user!.retailerModel!.address;
      contactPersonController.text = userController.user!.retailerModel!.contactPerson;
      contactPhoneController.text = userController.user!.retailerModel!.contactPersonPhone;
      for(var c in countriesModels){
        if(c.name == userController.user!.retailerModel!.country){
          selectedCountry = c;
          break;
        }
      }
      if(selectedCountry != null) {
        for (var p in selectedCountry!.states) {
          if (p.name == userController.user!.retailerModel!.province) {
            selectedState = p;
            break;
          }
        }
        if(selectedState != null) {
          for (var c in selectedState!.cities) {
            if (c.name == userController.user!.retailerModel!.city) {
              selectedCity = c;
              break;
            }
          }
        }
      }
    }
    EasyLoading.dismiss();
    setState(() {
    });
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
                  padding: EdgeInsets.only(right: 12, top: 6, bottom: 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(onPressed: ()=> Navigator.pop(context), icon: Icon(CupertinoIcons.arrow_left , color: blackColor, size: 24,)),
                      SizedBox(width: 12,),
                      Expanded(child: Text("Register Retailer" , style: utils.headingStyle(blackColor),)),
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
                        form("Shop Name", "Shop Name", nameController),
                        form("Phone", "Phone", phoneController),
                        GestureDetector(
                          onTap: (){
                            _presentBottomSheet(context);
                          },
                          child: Container(
                            width: Get.size.width,
                            padding: EdgeInsets.symmetric(horizontal: 10 , vertical: 12),
                            decoration: BoxDecoration(
                                color: whiteColor,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: blackColor.withOpacity(0.4) , width: 1)
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(width: 10,),
                                Expanded(child: Text(
                                  selectedCountry != null ? "${selectedCountry!.name}"  :"Select Country",
                                  style: utils.labelStyle(blackColor),
                                )),
                                Icon(CupertinoIcons.chevron_down , color: blackColor, size: 20,)
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 12,),
                        GestureDetector(
                          onTap: (){
                            if(selectedCountry != null) {
                              _presentBottomSheetState(context);
                            }else{
                              Get.snackbar("Opps!","Select the country First!");
                            }
                          },
                          child: Container(
                            width: Get.size.width,
                            padding: EdgeInsets.symmetric(horizontal: 10 , vertical: 12),
                            decoration: BoxDecoration(
                                color: whiteColor,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: blackColor.withOpacity(0.4) , width: 1)
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(width: 10,),
                                Expanded(child: Text(
                                  selectedState != null ? "${selectedState!.name}"  :"Select State",
                                  style: utils.labelStyle(blackColor),
                                )),
                                Icon(CupertinoIcons.chevron_down , color: blackColor, size: 20,)
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 12,),
                        GestureDetector(
                          onTap: (){
                            if(selectedState != null) {
                              _presentBottomSheetCity(context);
                            }else{
                              Get.snackbar("Opps","Select the State First!");
                            }
                          },
                          child: Container(
                            width: Get.size.width,
                            padding: EdgeInsets.symmetric(horizontal: 10 , vertical: 12),
                            decoration: BoxDecoration(
                                color: whiteColor,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: blackColor.withOpacity(0.4) , width: 1)
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(width: 10,),
                                Expanded(child: Text(
                                  selectedCity != null ? "${selectedCity!.name}"  :"Select City",
                                  style: utils.labelStyle(blackColor),
                                )),
                                Icon(CupertinoIcons.chevron_down , color: blackColor, size: 20,)
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 12,),
                        GestureDetector(
                          onTap: (){
                            if(selectedCity != null) {
                              _presentBottomSheetArea(context);
                            }else{
                              Get.snackbar("Opps","Select the City First!");
                            }
                          },
                          child: Container(
                            width: Get.size.width,
                            padding: EdgeInsets.symmetric(horizontal: 10 , vertical: 12),
                            decoration: BoxDecoration(
                                color: whiteColor,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: blackColor.withOpacity(0.4) , width: 1)
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(width: 10,),
                                Expanded(child: Text(
                                  selectedArea != null ? "${selectedArea!.name}"  :"Select Area",
                                  style: utils.labelStyle(blackColor),
                                )),
                                Icon(CupertinoIcons.chevron_down , color: blackColor, size: 20,)
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 12,),
                        form("Address", "Address", addressController),
                        form("Contact Person", "Name", contactPersonController),
                        form("Contact Person Phone", "Phone", contactPhoneController),
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
                            height: 30,
                            child: TextButton(
                              onPressed: () async {
                                if(nameController.text.isEmpty){
                                  Get.snackbar("Opps!", "Name is required");
                                  return;
                                }else if(phoneController.text.isEmpty){
                                  Get.snackbar("Opps","Phone is required");
                                  return;
                                }else if(selectedCountry == null){
                                  Get.snackbar("Opps", "Country is required");
                                  return;
                                }else if(selectedState == null){
                                  Get.snackbar("Opps", "State is required");
                                  return;
                                }else if(selectedCity == null){
                                  Get.snackbar("OPPS", "City is required");
                                  return;
                                }else if(selectedArea == null){
                                  Get.snackbar("OPPS", "Area is required");
                                  return;
                                }else if(addressController.text.isEmpty){
                                  Get.snackbar("Opps", "Address is required");
                                  return;
                                }else if(contactPersonController.text.isEmpty){
                                  Get.snackbar("Opps", "Contact Person name is required");
                                  return;
                                }else if(contactPhoneController.text.isEmpty){
                                  Get.snackbar("Opps", "Contact Person phone is required");
                                  return;
                                }
                                RetailerModel retailerModel = RetailerModel(shopName: nameController.text.toString(), phone: phoneController.text.toString(), city: selectedCity!.name, country: selectedCountry!.name, area: selectedArea!.name, province: selectedState!.name, address: addressController.text.toString(), updatedAt: DateTime.now().millisecondsSinceEpoch, createdAt: userController.user!.retailerModel != null ? userController.user!.retailerModel!.createdAt : DateTime.now().millisecondsSinceEpoch, contactPerson: contactPersonController.text.toString(), contactPersonPhone: contactPhoneController.text.toString(), approved: userController.user!.retailerModel != null ? userController.user!.retailerModel!.approved : false);
                                updateRetailer(retailerModel);

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

  void _presentBottomSheet(BuildContext context) {
    var searchController = TextEditingController();
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0) , topRight: Radius.circular(20)),
      ),
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (BuildContext context1,StateSetter setState){
          return Container(
            height: Get.size.height - 30,
            color: Colors.transparent,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: whiteColor
                    ),
                    child: Center(
                      child: Icon(CupertinoIcons.xmark , color: adminController.system.mainColor,),
                    ),
                  ),
                ),
                SizedBox(height: 10,),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(topRight: Radius.circular(20) , topLeft: Radius.circular(20)),
                      color: whiteColor
                  ),
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 12),
                    width: double.infinity,
                    child: form("Search", "Search", searchController,onChange: (val){
                      setState((){});
                    }),
                  ),
                ),
                Expanded(child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 10,vertical: 12),
                  decoration: BoxDecoration(
                      color: whiteColor
                  ),
                  child: SingleChildScrollView(
                    child: Wrap(
                      children: <Widget>[
                        Wrap(
                          children: [
                            for(var i = 0 ; i < countriesFilterModels.length ; i++)
                              if(countriesFilterModels[i].name.toLowerCase().contains(searchController.text.toLowerCase()))
                                utils.countryList(countriesFilterModels[i] , (){
                                  selectedCountry = countriesModels[i];
                                  setState((){
                                    setData();
                                    Navigator.pop(context);
                                  });
                                })
                          ],
                        )
                      ],
                    ),
                  ),
                ))
              ],
            ),
          );
        },
      ),
    );
  }

  void _presentBottomSheetState(BuildContext context) {
    var searchController = TextEditingController();
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0) , topRight: Radius.circular(20)),
      ),
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (BuildContext context1,StateSetter setState){
          return Container(
            height: Get.size.height - 30,
            color: Colors.transparent,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: whiteColor
                    ),
                    child: Center(
                      child: Icon(CupertinoIcons.xmark , color: adminController.system.mainColor,),
                    ),
                  ),
                ),
                SizedBox(height: 10,),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(topRight: Radius.circular(20) , topLeft: Radius.circular(20)),
                      color: whiteColor
                  ),
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 12),
                    width: double.infinity,
                    child: form("Search", "Search", searchController,onChange: (val){
                      setState((){});
                    }),
                  ),
                ),
                Expanded(child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 10,vertical: 12),
                  decoration: BoxDecoration(
                      color: whiteColor
                  ),
                  child: SingleChildScrollView(
                    child: Wrap(
                      children: <Widget>[
                        Wrap(
                          children: [
                            for(var i = 0 ; i < selectedCountry!.states.length ; i++)
                              if(selectedCountry!.states[i].name.toLowerCase().contains(searchController.text.toLowerCase()))
                                utils.stateList(selectedCountry!.states[i] , (){
                                  selectedState = selectedCountry!.states[i];
                                  setState((){
                                    setData();
                                    Navigator.pop(context);
                                  });
                                })
                          ],
                        )
                      ],
                    ),
                  ),
                ))
              ],
            ),
          );
        },
      ),
    );
  }

  void _presentBottomSheetCity(BuildContext context) {
    var searchController = TextEditingController();
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0) , topRight: Radius.circular(20)),
      ),
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (BuildContext context1,StateSetter setState){
          return Container(
            height: Get.size.height - 30,
            color: Colors.transparent,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: whiteColor
                    ),
                    child: Center(
                      child: Icon(CupertinoIcons.xmark , color: adminController.system.mainColor,),
                    ),
                  ),
                ),
                SizedBox(height: 10,),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(topRight: Radius.circular(20) , topLeft: Radius.circular(20)),
                      color: whiteColor
                  ),
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 12),
                    width: double.infinity,
                    child: form("Search", "Search", searchController,onChange: (val){
                      setState((){});
                    }),
                  ),
                ),
                Expanded(child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 10,vertical: 12),
                  decoration: BoxDecoration(
                      color: whiteColor
                  ),
                  child: SingleChildScrollView(
                    child: Wrap(
                      children: <Widget>[
                        Wrap(
                          children: [
                            for(var i = 0 ; i < selectedState!.cities.length ; i++)
                              if(selectedState!.cities[i].name.toLowerCase().contains(searchController.text.toLowerCase()))
                                utils.citiesList(selectedState!.cities[i] , (){
                                  selectedCity = selectedState!.cities[i];
                                  setState((){
                                    setData();
                                    Navigator.pop(context);
                                  });
                                })
                          ],
                        )
                      ],
                    ),
                  ),
                ))
              ],
            ),
          );
        },
      ),
    );
  }

  void _presentBottomSheetArea(BuildContext context) {
    var searchController = TextEditingController();
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0) , topRight: Radius.circular(20)),
      ),
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (BuildContext context1,StateSetter setState){
          return Container(
            height: Get.size.height - 30,
            color: Colors.transparent,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: whiteColor
                    ),
                    child: Center(
                      child: Icon(CupertinoIcons.xmark , color: adminController.system.mainColor,),
                    ),
                  ),
                ),
                SizedBox(height: 10,),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(topRight: Radius.circular(20) , topLeft: Radius.circular(20)),
                      color: whiteColor
                  ),
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 12),
                    width: double.infinity,
                    child: form("Search", "Search", searchController,onChange: (val){
                      setState((){});
                    }),
                  ),
                ),
                Expanded(child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 10,vertical: 12),
                  decoration: BoxDecoration(
                      color: whiteColor
                  ),
                  child: SingleChildScrollView(
                    child: Wrap(
                      children: <Widget>[
                        Wrap(
                          children: [
                            for(var i = 0 ; i < selectedCity!.areas.length ; i++)
                              if(selectedCity!.areas[i].name.toLowerCase().contains(searchController.text.toLowerCase()))
                                utils.areaList(selectedCity!.areas[i] , (){
                                  selectedArea = selectedCity!.areas[i];
                                  setState((){
                                    setData();
                                    Navigator.pop(context);
                                  });
                                })
                          ],
                        )
                      ],
                    ),
                  ),
                ))
              ],
            ),
          );
        },
      ),
    );
  }

  void setData() {
    setState(() {
    });
  }

  void updateRetailer(RetailerModel retailerModel) async {
    userController.user!.retailerModel = retailerModel;
    userController.user!.isRetailer = true;
    FirebaseDatabase database = FirebaseDatabase(databaseURL: databaseUrl);
    
    if(!GetPlatform.isWeb) {
      database.setPersistenceEnabled(true);
      database.setPersistenceCacheSizeBytes(10000000);
    }
    DatabaseReference reference = database.reference();
    EasyLoading.show(status: "Loading...");
    await reference
        .child(usersRef)
        .child(userController.user!.uid)
        .update(userController.user!.toJson());
    EasyLoading.dismiss();
  }
}