import 'dart:async';
import 'dart:convert';

import 'package:connectsaleorder/AppConstants/Constants.dart';
import 'package:connectsaleorder/GetXController/CheckAdminController.dart';
import 'package:connectsaleorder/GetXController/UserController.dart';
import 'package:connectsaleorder/Models/AddressModel.dart';
import 'package:connectsaleorder/Models/CountriesModel.dart';
import 'package:connectsaleorder/Utils/AppUtils.dart';
import 'package:connectsaleorder/Views/Address/MapScreen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:google_places_picker/google_places_picker.dart';

class AddAddressPage extends StatefulWidget{
  int type  = 0;
  AddressModel? addressModel;
  AddAddressPage(this.type ,this.addressModel);
  @override
  _AddAddressPage createState() => _AddAddressPage(type,addressModel);

}

class _AddAddressPage extends State<AddAddressPage>{
  var utils = AppUtils();
  var nameController = TextEditingController();
  var phoneController = TextEditingController();
  var addressController = TextEditingController();
  var selected = -1;
  var isDefault = false;
  List<CountriesModel> countriesModels = [];
  List<CountriesModel> countriesFilterModels = [];
  CountriesModel? selectedCountry;
  States? selectedState;
  Cities? selectedCity;
  AreaModel? selectedArea;
  CheckAdminController adminController = Get.find();
  UserController userController = Get.find();
  int type = 0;
  AddressModel? selectedAddress;
  _AddAddressPage(this.type , this.selectedAddress);
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
      if(countriesModels.length == 1){
        selectedCountry = countriesModels[0];
        selectedState = countriesModels[0].states.length > 0 ? countriesModels[0].states[0] : null;
        if(selectedState != null) {
          selectedCity = countriesModels[0].states[0].cities.length > 0
              ? countriesModels[0].states[0].cities[0]
              : null;
        }
      }
      if(type == 1){
        if(selectedAddress != null) {
          nameController.text = selectedAddress!.fullName;
          phoneController.text = selectedAddress!.mobile;
          addressController.text = selectedAddress!.address;
          selected = (selectedAddress!.title).toLowerCase() == "home" ? 0 : 1;
          isDefault = selectedAddress!.selected;
          for(var c in countriesModels){
            if(c.name == selectedAddress!.country){
              selectedCountry = c;
              break;
            }
          }
          if(selectedCountry != null) {
            for (var p in selectedCountry!.states) {
              if (p.name == selectedAddress!.province) {
                selectedState = p;
                break;
              }
            }
            if(selectedState != null) {
              for (var c in selectedState!.cities) {
                if (c.name == selectedAddress!.city) {
                  selectedCity = c;
                  break;
                }
              }
              if(selectedCity != null){
                for (var c in selectedCity!.areas) {
                  if (c.name == selectedAddress!.area) {
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
  }
  readJson() async {
    EasyLoading.show(status: "Loading...");
    var response = await rootBundle.loadString('Assets/lottie/countries.json');
    var resValue = await compute(jsonDecode , response);
    resValue.forEach((value){
      countriesModels.add(CountriesModel.fromJson(value));
    });
    countriesFilterModels = countriesModels;
    if(type == 1){
      if(selectedAddress != null) {
        nameController.text = selectedAddress!.fullName;
        phoneController.text = selectedAddress!.mobile;
        addressController.text = selectedAddress!.address;
        selected = (selectedAddress!.title).toLowerCase() == "home" ? 0 : 1;
        isDefault = selectedAddress!.selected;
        for(var c in countriesModels){
          if(c.name == selectedAddress!.country){
            selectedCountry = c;
            break;
          }
        }
        if(selectedCountry != null) {
          for (var p in selectedCountry!.states) {
            if (p.name == selectedAddress!.province) {
              selectedState = p;
              break;
            }
          }
          if(selectedState != null) {
            for (var c in selectedState!.cities) {
              if (c.name == selectedAddress!.city) {
                selectedCity = c;
                break;
              }
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
                      Expanded(child: Text(type != 2 ? "Add Address" : "Add Branch" , style: utils.headingStyle(blackColor),)),
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
                        form("Full Name", "Full Name", nameController),
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
                        GestureDetector(
                          onTap: () async {
                            _place = await Navigator.push(context, MaterialPageRoute(builder: (context) => MapScreen()));
                            setData();
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
                                  _place != null ? "${_place!.address}":"Select Address From Map",
                                  style: utils.labelStyle(blackColor),
                                )),
                                Icon(CupertinoIcons.chevron_down , color: blackColor, size: 20,)
                              ],
                            ),
                          ),
                        ),
                        form("Address", "Address", addressController),
                        if(type != 2) SizedBox(height: 20,),
                        if(type != 2) Container(
                          width: Get.width,
                          height: 1,
                          color: grayColor,
                        ),
                        if(type != 2) SizedBox(height: 20,),
                        if(type != 2) Text("Select a label for effective delivery" , style: utils.smallLabelStyle(blackColor),),
                        if(type != 2) SizedBox(height: 10,),
                        if(type != 2) Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap : (){
                                selected = 0;
                                setState(() {
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: selected == 0 ? checkAController.system.mainColor : blackColor.withOpacity(0.3))
                                ),
                                child: Wrap(
                                  alignment: WrapAlignment.center,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    Icon(CupertinoIcons.home , size: 24, color: selected == 0 ? checkAController.system.mainColor : blackColor.withOpacity(0.3),),
                                    SizedBox(width: 8,),
                                    Text("Home" , style: utils.boldSmallLabelStyle(selected == 0 ? checkAController.system.mainColor : blackColor.withOpacity(0.3)),)
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(width: 12,),
                            InkWell(
                              onTap : (){
                                selected = 1;
                                setState(() {
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: selected == 1 ? checkAController.system.mainColor : blackColor.withOpacity(0.3))
                                ),
                                child: Wrap(
                                  alignment: WrapAlignment.center,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    Icon(CupertinoIcons.bag_fill , size: 24, color: selected == 1 ? checkAController.system.mainColor : blackColor.withOpacity(0.3),),
                                    SizedBox(width: 8,),
                                    Text("Office" , style: utils.boldSmallLabelStyle(selected == 1 ? checkAController.system.mainColor : blackColor.withOpacity(0.3)),)
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                        if(type != 2) SizedBox(height: 20,),
                        if(type != 2) Container(
                          width: Get.width,
                          height: 1,
                          color: grayColor,
                        ),
                        if(type != 2) SizedBox(height: 6,),
                        if(type != 2) Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(child: Text("Make default shipping address" , style: utils.smallLabelStyle(blackColor),),),
                            Checkbox(value: isDefault, onChanged: (bool? value) {
                              if(value != null){
                                isDefault = value;
                              }
                              setState(() {
                              });
                            },
                              activeColor: checkAController.system.mainColor,
                              side: BorderSide(
                                  color: blackColor,
                                  width: 1.5
                              ),
                            ),
                          ],
                        ),
                        if(type != 2) SizedBox(height: 6,),
                        if(type != 2) Container(
                          width: Get.width,
                          height: 1,
                          color: grayColor,
                        ),
                        SizedBox(height: 20,),
                        Container(
                          width: Get.width,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [checkAController.system.mainColor, checkAController.system.mainColor])
                          ),
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
                              }else if(selected == -1 && type != 2){
                                Get.snackbar("Opps", "Select Label First!");
                                return;
                              }else if(_place == null && type != 2){
                                Get.snackbar("Opps", "Select Map Address First!");
                                return;
                              }
                                AddressModel aModel = AddressModel(
                                    id: type == 0 ? "${DateTime
                                        .now()
                                        .millisecondsSinceEpoch}" : type == 2 ?  "${DateTime
                                        .now()
                                        .millisecondsSinceEpoch}" : selectedAddress!.id,
                                    createdAt: type == 0 ? DateTime
                                        .now()
                                        .millisecondsSinceEpoch : type == 2 ? DateTime
                                        .now()
                                        .millisecondsSinceEpoch : selectedAddress!.createdAt,
                                    area: selectedArea!.name,
                                    updatedAt: DateTime
                                        .now()
                                        .millisecondsSinceEpoch,
                                    title: selected == 0 ? "Home" : "Office",
                                    fullName: nameController.text.toString(),
                                    mobile: phoneController.text.toString(),
                                    province: selectedState!.name,
                                    city: selectedCity!.name,
                                    country: selectedCountry!.name,
                                    address: addressController.text.toString(),
                                    lat: type == 0 ? _place!.latitude : selectedAddress!.lat,
                                    lng: type == 0 ? _place!.longitude: selectedAddress!.lng);
                                if(type != 2) {
                                  addAddress(aModel);
                                }else{
                                  addBranch(aModel);
                                }
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

  void addAddress(AddressModel aModel) async {
    EasyLoading.show(status: "Loading...");
    if(type != 0) {
      for (var i = 0; i < userController.user!.addressList.length; i++) {
        if (userController.user!.addressList[i].id == aModel.id) {
          userController.user!.addressList.removeAt(i);
        }
      }
    }
    userController.user!.addressList.add(aModel);

    FirebaseDatabase database = FirebaseDatabase(databaseURL: databaseUrl);
    
    database.setPersistenceEnabled(true);
    database.setPersistenceCacheSizeBytes(10000000);
    DatabaseReference reference = database.reference();
    await reference
        .child(usersRef)
        .child(userController.user!.uid)
        .update(userController.user!.toJsonAddresses());
    if(isDefault){
      await reference
          .child(usersRef)
          .child(userController.user!.uid)
          .update({"defaultAddressId" : aModel.id});
    }
    EasyLoading.dismiss();
    Navigator.pop(context);
  }

  void addBranch(AddressModel aModel) async {

    EasyLoading.show(status: "Loading...");
    CheckAdminController checkAdminController = Get.find();
    checkAdminController.system.branches.add(aModel);

    FirebaseDatabase database = FirebaseDatabase(databaseURL: databaseUrl);

    database.setPersistenceEnabled(true);
    database.setPersistenceCacheSizeBytes(10000000);
    DatabaseReference reference = database.reference();
    await reference
        .child(systemRef)
        .update(checkAdminController.system.toJsonBranches());

    EasyLoading.dismiss();
    Navigator.pop(context);
  }

}