import 'dart:convert';

import 'package:connectsaleorder/AppConstants/Constants.dart';
import 'package:connectsaleorder/GetXController/CheckAdminController.dart';
import 'package:connectsaleorder/Models/CountriesModel.dart';
import 'package:connectsaleorder/Utils/AppUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class ConfigureCountryScreen extends StatefulWidget{
  bool fromWeb;
  ConfigureCountryScreen({this.fromWeb = false});
  @override
  _ConfigureCountryScreen createState() => _ConfigureCountryScreen();

}

class _ConfigureCountryScreen extends State<ConfigureCountryScreen>{
  var utils = AppUtils();
  CheckAdminController checkAdminController = Get.find();
  List<CountriesModel> countriesModels = [];
  List<CountriesModel> countriesFilterModels = [];
  CountriesModel? selectedCountry;
  CountriesModel? checkSelectedCountry;
  States? selectedState;
  States? checkSelectedState;
  Cities? selectedCity;
  Cities? checkSelectedCity;
  var otherCountryController = TextEditingController();
  var otherStateController = TextEditingController();
  var otherCityController = TextEditingController();
  var areaController = TextEditingController();
  var showCountry = false;
  var showState = false;
  var showCity = false;
  var showStateDrop = true;
  var showCityDrop = true;
  List<AreaModel> areas = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readJson();
  }

  readJson() async {
    EasyLoading.show(status: "Loading...", maskType: EasyLoadingMaskType.black);
    var response = await rootBundle.loadString('Assets/lottie/countries.json');
    var resValue = await compute(jsonDecode , response);
    resValue.forEach((value){
      countriesModels.add(CountriesModel.fromJson(value));
    });
    countriesFilterModels = countriesModels;
    if(checkAdminController.system.defaultCountry != null){
      for(var c in countriesModels){
        if(c.name == checkAdminController.system.defaultCountry!.name){
          checkSelectedCountry = c;
          break;
        }
      }
      if(checkSelectedCountry != null) {
        selectedCountry = checkSelectedCountry;
        for (var p in checkSelectedCountry!.states) {
          if (p.name == checkAdminController.system.defaultCountry!.states[0].name) {
            checkSelectedState = p;
            break;
          }
        }

        if(checkSelectedState != null) {
          selectedState = checkSelectedState;
          for (var c in checkSelectedState!.cities) {
            if (c.name == checkAdminController.system.defaultCountry!.states[0].cities[0].name) {
              checkSelectedCity = c;
              break;
            }
          }

          if(checkSelectedCity != null){
            selectedCity = checkSelectedCity;
            areas = checkAdminController.system.defaultCountry!.states[0].cities[0].areas;
          }else{
            showCity = true;
            otherCityController.text = checkAdminController.system.defaultCountry!.states[0].cities[0].name;
            areas = checkAdminController.system.defaultCountry!.states[0].cities[0].areas;
          }
        }else{
          showState = true;
          showCity = true;
          showCityDrop = false;
          otherStateController.text = checkAdminController.system.defaultCountry!.states[0].name;
          otherCityController.text = checkAdminController.system.defaultCountry!.states[0].cities[0].name;
          areas = checkAdminController.system.defaultCountry!.states[0].cities[0].areas;
        }
      }
      else{
        showCountry = true;
        showState = true;
        showCity = true;
        showCityDrop = false;
        showStateDrop = false;
        otherCountryController.text = checkAdminController.system.defaultCountry!.name;
        otherStateController.text = checkAdminController.system.defaultCountry!.states[0].name;
        otherCityController.text = checkAdminController.system.defaultCountry!.states[0].cities[0].name;
        areas = checkAdminController.system.defaultCountry!.states[0].cities[0].areas;
      }
    }
    EasyLoading.dismiss();
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0),
        child: AppBar(
          elevation: 0,
          backgroundColor: checkAdminController.system.mainColor,
        ),
      ),
      backgroundColor: whiteColor,
      body: SafeArea(
        child: Container(
          width: Get.width,
          height: Get.height,
          color: whiteColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if(!widget.fromWeb) Container(
                padding: EdgeInsets.symmetric(horizontal: 1, vertical: 6),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12),),
                    color: checkAdminController.system.mainColor
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed : (){
                        setState(() {
                          Get.back();
                        });
                      },
                      icon: Icon(CupertinoIcons.arrow_left, size: 24, color: whiteColor,),
                    ),
                    Expanded(child: Text("Configure Country" , style: utils.headingStyle(whiteColor),)),
                  ],
                ),
              ),
              Expanded(child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 12,),
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
                                selectedCountry != null ? "${selectedCountry!.name}"  : showCountry ? "Other" :"Select Country",
                                style: utils.labelStyle(blackColor),
                              )),
                              Icon(CupertinoIcons.chevron_down , color: blackColor, size: 20,)
                            ],
                          ),
                        ),
                      ),
                      if(showCountry) form("Country", "Country", otherCountryController),
                      SizedBox(height: 12,),
                      if(showStateDrop) GestureDetector(
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
                                selectedState != null ? "${selectedState!.name}"  : showState ? "Other" :"Select State",
                                style: utils.labelStyle(blackColor),
                              )),
                              Icon(CupertinoIcons.chevron_down , color: blackColor, size: 20,)
                            ],
                          ),
                        ),
                      ),
                      if(showState) form("State", "State", otherStateController),
                      SizedBox(height: 12,),
                      if(showCityDrop) GestureDetector(
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
                                selectedCity != null ? "${selectedCity!.name}"  : showCity ? "Other" :"Select City",
                                style: utils.labelStyle(blackColor),
                              )),
                              Icon(CupertinoIcons.chevron_down , color: blackColor, size: 20,)
                            ],
                          ),
                        ),
                      ),
                      if(showCity) form("City", "City", otherCityController),
                      form("Area with comma (,) separated", "Area", areaController , onChange: (val){
                        if(areaController.text.isNotEmpty){
                          if(areaController.text.length > 3){
                            if(areaController.text.endsWith(",")){
                              areas.add(AreaModel(id: "${DateTime.now().microsecondsSinceEpoch}", name: areaController.text.substring(0,areaController.text.length-1)));
                              areaController.clear();
                              setData();
                            }
                          }
                        }
                      }),
                      SizedBox(height: 10,),
                      Wrap(
                        alignment: WrapAlignment.start,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          for(var i = 0 ; i < areas.length; i++)
                            Container(
                              padding: EdgeInsets.only(left: 12),
                              margin: EdgeInsets.symmetric(horizontal: 2, vertical: 5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: grayColor.withOpacity(0.4)
                              ),
                              child: Wrap(
                                alignment: WrapAlignment.start,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Text("${areas[i].name}" , style: utils.smallLabelStyle(blackColor),),
                                  IconButton(onPressed: (){
                                    areas.removeAt(i);
                                    setData();
                                  }, icon: Icon(CupertinoIcons.xmark_circle_fill , size: 20 , color: blackColor,))
                                ],
                              ),
                            )
                        ],
                      ),
                      SizedBox(height: 20,),
                      utils.button(whiteColor, "Configure", checkAdminController.system.mainColor, checkAdminController.system.mainColor, 2.0, (){
                        if(selectedCountry == null){
                          if(!showCountry){
                            Get.snackbar("Opps!", "Country is required");
                            return;
                          }else{
                            if(otherCountryController.text.isEmpty){
                              Get.snackbar("Opps!", "Country is required");
                              return;
                            }
                          }
                        }else if(selectedState == null){
                          if(!showState){
                            Get.snackbar("Opps!", "State is required");
                            return;
                          }else{
                            if(otherStateController.text.isEmpty){
                              Get.snackbar("Opps!", "State is required");
                              return;
                            }
                          }
                        }else if(selectedCity == null){
                          if(!showCity){
                            Get.snackbar("Opps!", "City is required");
                            return;
                          }else{
                            if(otherCityController.text.isEmpty){
                              Get.snackbar("Opps!", "City is required");
                              return;
                            }
                          }
                        }else if(areas.length <= 0){
                            Get.snackbar("Opps!", "Area is required");
                            return;
                        }
                        updateAddress();
                      })
                    ],
                  ),
                ),
              ))
            ],
          ),
        ),
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
                      child: Icon(CupertinoIcons.xmark , color: checkAdminController.system.mainColor,),
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
                                  showCountry = false;
                                  showCity = false;
                                  showState = false;
                                  showStateDrop = true;
                                  showCityDrop = true;
                                  selectedCountry = countriesModels[i];
                                  selectedState = null;
                                  selectedCity = null;
                                  setState((){
                                    setData();
                                    Navigator.pop(context);
                                  });
                                }),

                            utils.countryList(CountriesModel(id: 0, name: "Other", iso3: "", iso2: "", numericCode: "", phoneCode: "", currency: "", capital: "", currencyName: "", currencySymbol: "", tld: "tld", native: "", region: "", subregion: "", timezones: [], latitude: "", longitude: "", emoji: "", emojiU: "", states: []) , (){
                              showCountry = true;
                              showCity = true;
                              showState = true;
                              showStateDrop = false;
                              showCityDrop = false;
                              selectedCountry = null;
                              selectedState = null;
                              selectedCity = null;
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
                      child: Icon(CupertinoIcons.xmark , color: checkAdminController.system.mainColor,),
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
                                  showCity = false;
                                  showState = false;
                                  showCityDrop = true;
                                  selectedCity = null;
                                  setState((){
                                    setData();
                                    Navigator.pop(context);
                                  });
                                }),

                            utils.stateList(States(id: 0, name: "Other", stateCode: "", latitude: "", longitude: "", cities: []) , (){
                                  selectedState = null;
                                  showCity = true;
                                  showState = true;
                                  showCityDrop = false;
                                  selectedState = null;
                                  selectedCity = null;
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
                      child: Icon(CupertinoIcons.xmark , color: checkAdminController.system.mainColor,),
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
                                  showCity = false;
                                  setState((){
                                    setData();
                                    Navigator.pop(context);
                                  });
                                }),

                            utils.citiesList(Cities(id: 0, name: "Other", latitude: "", longitude: "") , (){
                                  selectedCity = null;
                                  showCity = true;
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

  updateAddress() async{
    EasyLoading.show(status: "Loading...");
    CountriesModel countriesModel;
    if(selectedCountry != null){
      countriesModel = selectedCountry!;
      countriesModel.states = [];
    }else{
      countriesModel = CountriesModel(id: 0, name: otherCountryController.text.toString(), iso3: "", iso2: "", numericCode: "", phoneCode: "", currency: "", capital: "", currencyName: "", currencySymbol: "", tld: "tld", native: "", region: "", subregion: "", timezones: [], latitude: "", longitude: "", emoji: "", emojiU: "", states: []);
    }

    if(selectedState != null){
      countriesModel.states.add(selectedState!);
      countriesModel.states[0].cities = [];
    }else{
      States states = States(id: 0, name: otherStateController.text.toString(), stateCode: "", latitude: "", longitude: "", cities: []);
      countriesModel.states.add(states);
    }

    if(selectedCity != null){
      countriesModel.states[0].cities.add(selectedCity!);
    }else{
      Cities cities = Cities(id: 0, name: otherCityController.text.toString(), latitude: "", longitude: "");
      countriesModel.states[0].cities.add(cities);
    }

    countriesModel.states[0].cities[0].areas = areas;

    await checkAdminController.setSystemCountries(countriesModel);
    Get.snackbar("Success", "Address Configure Success");
    EasyLoading.dismiss();
  }

}