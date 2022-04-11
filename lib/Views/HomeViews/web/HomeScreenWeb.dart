import 'package:connectsaleorder/AppConstants/Constants.dart';
import 'package:connectsaleorder/GetXController/CartController.dart';
import 'package:connectsaleorder/GetXController/CheckAdminController.dart';
import 'package:connectsaleorder/GetXController/CustomerController.dart';
import 'package:connectsaleorder/GetXController/FavoriteController.dart';
import 'package:connectsaleorder/GetXController/OrderController.dart';
import 'package:connectsaleorder/GetXController/UserController.dart';
import 'package:connectsaleorder/GetXController/locale_controller.dart';
import 'package:connectsaleorder/Utils/AppUtils.dart';
import 'package:connectsaleorder/Views/Account/ConfigureCountryScreen.dart';
import 'package:connectsaleorder/Views/Account/CurrencyScreen.dart';
import 'package:connectsaleorder/Views/Account/SystemConfigScreen.dart';
import 'package:connectsaleorder/Views/Banner/ManageBannerScreen.dart';
import 'package:connectsaleorder/Views/Category/ManageCategoryScreen.dart';
import 'package:connectsaleorder/Views/Category/web/ManageBrandWebScreen.dart';
import 'package:connectsaleorder/Views/Product/AddProductNewScreen.dart';
import 'package:connectsaleorder/Views/Search/SearchScreen.dart';
import 'package:connectsaleorder/Views/Supprt/AdminSupportScreen.dart';
import 'package:connectsaleorder/Views/orders/ManageOrdersScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class HomeScreenWeb extends StatefulWidget{
  @override
  _HomeScreenWeb createState() => _HomeScreenWeb();

}

class _HomeScreenWeb extends State<HomeScreenWeb>{
  var utils = AppUtils();
  var box = GetStorage();
  List<TextEditingController> controllers = [];
  TextEditingController storeController = TextEditingController();
  TextEditingController discountController = TextEditingController();
  UserController uController = Get.put(UserController());
  CartController cController = Get.put(CartController());
  FavoriteController fController = Get.put(FavoriteController());
  CustomerController customerController = Get.put(CustomerController());
  OrderController orderController = Get.put(OrderController());
  LocaleController _localeController = Get.find();
  var isArabic = false;
  CheckAdminController checkAdminController = Get.find();
  var isExist = false;
  var selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0),
        child: AppBar(
          backgroundColor: whiteColor,
          elevation: 0,
        ),
      ),
      body: SafeArea(
        child: Container(
          width: Get.width,
          height: Get.height,
          child: SingleChildScrollView(
            child: Container(
              width: Get.width,
              height: Get.height,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: GetBuilder<UserController>(id: "0",builder: (userController){
                      return GetBuilder<CheckAdminController>(id: "0", builder: (checkAdminController){
                        return Container(
                          width: Get.width,
                          height: Get.height,
                          color: whiteColor,
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: Get.width,
                                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(16), bottomRight: Radius.circular(16),),
                                      color: checkAdminController.system.mainColor
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 100,
                                        height: 100,
                                        clipBehavior: Clip.antiAliasWithSaveLayer,
                                        decoration: BoxDecoration(
                                            color: whiteColor,
                                            borderRadius: BorderRadius.circular(12)
                                        ),
                                        child: Image.network(userController.user != null && userController.user!.image != null? userController.user!.image!:"https://www.nj.com/resizer/zovGSasCaR41h_yUGYHXbVTQW2A=/1280x0/smart/cloudfront-us-east-1.images.arcpublishing.com/advancelocal/SJGKVE5UNVESVCW7BBOHKQCZVE.jpg", fit: BoxFit.cover,),
                                      ),
                                      Text(userController.user == null ? "Guest":"${userController.user!.name}" , style: utils.headingStyle(whiteColor),),
                                      Text(userController.user == null ? "guest login":"${userController.user!.email}" , style: utils.labelStyle(whiteColor),),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 12,),
                                InkWell(
                                  onTap: (){
                                    setState(() {
                                      selectedTab = 0;
                                    });
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Icon(CupertinoIcons.settings , color: selectedTab == 0 ? checkAdminController.system.mainColor : blackColor, size: 24,),
                                        SizedBox(width: 12,),
                                        Expanded(child: Text("System Configuration" , style: utils.labelStyle(selectedTab == 0 ? checkAdminController.system.mainColor : blackColor),)),
                                        
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  width: Get.width,
                                  height: 1,
                                  margin: EdgeInsets.symmetric(horizontal: 12,vertical: 6),
                                  color: checkAdminController.system.mainColor.withOpacity(0.3),
                                ),
                                InkWell(
                                  onTap: (){
                                    setState(() {
                                      selectedTab = 1;
                                    });
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Icon(CupertinoIcons.bubble_left_bubble_right , color: selectedTab == 1 ? checkAdminController.system.mainColor : blackColor, size: 24,),
                                        SizedBox(width: 12,),
                                        Expanded(child: Text("Support Chat" , style: utils.labelStyle(selectedTab == 1 ? checkAdminController.system.mainColor : blackColor),)),
                                        
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  width: Get.width,
                                  height: 1,
                                  margin: EdgeInsets.symmetric(horizontal: 12,vertical: 6),
                                  color: checkAdminController.system.mainColor.withOpacity(0.3),
                                ),
                                InkWell(
                                  onTap: (){
                                    setState(() {
                                      selectedTab = 2;
                                    });
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Icon(CupertinoIcons.location , color: selectedTab == 2 ? checkAdminController.system.mainColor : blackColor, size: 24,),
                                        SizedBox(width: 12,),
                                        Expanded(child: Text("Address" , style: utils.labelStyle(selectedTab == 2 ? checkAdminController.system.mainColor : blackColor),)),
                                        
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  width: Get.width,
                                  height: 1,
                                  margin: EdgeInsets.symmetric(horizontal: 12,vertical: 6),
                                  color: checkAdminController.system.mainColor.withOpacity(0.3),
                                ),
                                InkWell(
                                  onTap: (){
                                    setState(() {
                                      selectedTab = 3;
                                    });
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Icon(CupertinoIcons.bag , color: selectedTab == 3 ? checkAdminController.system.mainColor : blackColor, size: 24,),
                                        SizedBox(width: 12,),
                                        Expanded(child: Text("Orders" , style: utils.labelStyle(selectedTab == 3 ? checkAdminController.system.mainColor : blackColor),)),
                                        
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  width: Get.width,
                                  height: 1,
                                  margin: EdgeInsets.symmetric(horizontal: 12,vertical: 6),
                                  color: checkAdminController.system.mainColor.withOpacity(0.3),
                                ),
                                InkWell(
                                  onTap: (){
                                    setState(() {
                                      selectedTab = 4;
                                    });
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Icon(CupertinoIcons.tv , color: selectedTab == 4 ? checkAdminController.system.mainColor : blackColor, size: 24,),
                                        SizedBox(width: 12,),
                                        Expanded(child: Text("Banners" , style: utils.labelStyle(selectedTab == 4 ? checkAdminController.system.mainColor : blackColor),)),
                                        
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  width: Get.width,
                                  height: 1,
                                  margin: EdgeInsets.symmetric(horizontal: 12,vertical: 6),
                                  color: checkAdminController.system.mainColor.withOpacity(0.3),
                                ),
                                InkWell(
                                  onTap: (){
                                    setState(() {
                                      selectedTab = 5;
                                    });
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Icon(CupertinoIcons.money_pound_circle , color: selectedTab == 5 ? checkAdminController.system.mainColor : blackColor, size: 24,),
                                        SizedBox(width: 12,),
                                        Expanded(child: Text("Currency" , style: utils.labelStyle(selectedTab == 5 ? checkAdminController.system.mainColor : blackColor),)),
                                        
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  width: Get.width,
                                  height: 1,
                                  margin: EdgeInsets.symmetric(horizontal: 12,vertical: 6),
                                  color: checkAdminController.system.mainColor.withOpacity(0.3),
                                ),
                                InkWell(
                                  onTap: (){
                                    setState(() {
                                      selectedTab = 6;
                                    });
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Icon(CupertinoIcons.rectangle_3_offgrid , color: selectedTab == 6 ? checkAdminController.system.mainColor : blackColor, size: 24,),
                                        SizedBox(width: 12,),
                                        Expanded(child: Text("Category" , style: utils.labelStyle(selectedTab == 6 ? checkAdminController.system.mainColor : blackColor),)),
                                        
                                      ],
                                    ),
                                  ),
                                ),
                                 Container(
                                  width: Get.width,
                                  height: 1,
                                  margin: EdgeInsets.symmetric(horizontal: 12,vertical: 6),
                                  color: checkAdminController.system.mainColor.withOpacity(0.3),
                                ),
                                InkWell(
                                  onTap: (){
                                    setState(() {
                                      selectedTab = 7;
                                    });
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Icon(CupertinoIcons.tornado , color: selectedTab == 7 ? checkAdminController.system.mainColor : blackColor, size: 24,),
                                        SizedBox(width: 12,),
                                        Expanded(child: Text("Brand" , style: utils.labelStyle(selectedTab == 7 ? checkAdminController.system.mainColor : blackColor),)),
                                        
                                      ],
                                    ),
                                  ),
                                ),
                                 Container(
                                  width: Get.width,
                                  height: 1,
                                  margin: EdgeInsets.symmetric(horizontal: 12,vertical: 6),
                                  color: checkAdminController.system.mainColor.withOpacity(0.3),
                                ),
                                InkWell(
                                  onTap: (){
                                    setState(() {
                                      selectedTab = 8;
                                    });
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Icon(CupertinoIcons.plus_circled , color: selectedTab == 8 ? checkAdminController.system.mainColor : blackColor, size: 24,),
                                        SizedBox(width: 12,),
                                        Expanded(child: Text("Products" , style: utils.labelStyle(selectedTab == 8 ? checkAdminController.system.mainColor : blackColor),)),
                                      ],
                                    ),
                                  ),
                                ),
                                 Container(
                                  width: Get.width,
                                  height: 1,
                                  margin: EdgeInsets.symmetric(horizontal: 12,vertical: 6),
                                  color: checkAdminController.system.mainColor.withOpacity(0.3),
                                ),
                                InkWell(
                                  onTap: (){
                                    setState(() {
                                      selectedTab = 9;
                                    });
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Icon(CupertinoIcons.plus_circled , color: selectedTab == 8 ? checkAdminController.system.mainColor : blackColor, size: 24,),
                                        SizedBox(width: 12,),
                                        Expanded(child: Text("Add Product" , style: utils.labelStyle(selectedTab == 8 ? checkAdminController.system.mainColor : blackColor),)),
                                      ],
                                    ),
                                  ),
                                ),
                                 Container(
                                  width: Get.width,
                                  height: 1,
                                  margin: EdgeInsets.symmetric(horizontal: 12,vertical: 6),
                                  color: checkAdminController.system.mainColor.withOpacity(0.3),
                                ),
                                InkWell(
                                  onTap: () async {
                                    Get.toNamed(loginRoute);
                                    await box.remove(currentUser);
                                    checkAdminController.updateAdmin("0");
                                    FirebaseAuth.instance.signOut();
                                    userController.removeUser();
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Icon(CupertinoIcons.square_arrow_left , color: blackColor, size: 24,),
                                        SizedBox(width: 12,),
                                        Expanded(child: Text("Logout" , style: utils.labelStyle(blackColor),)),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  width: Get.width,
                                  height: 1,
                                  margin: EdgeInsets.symmetric(horizontal: 12,vertical: 6),
                                  color: checkAdminController.system.mainColor.withOpacity(0.3),
                                ),
                              ],
                            ),
                          ),
                        );
                      },);
                    }),
                  ),Expanded(
                    flex: 8,
                    child: selectedTab == 0 ? SystemConfigScreen(fromWeb: true,) : selectedTab == 1 ? AdminSupportScreen(fromWeb: true,) : selectedTab == 2 ? ConfigureCountryScreen(fromWeb: true) : selectedTab == 3 ? ManageOrderScreen(fromWeb: true,) : selectedTab == 4 ? ManageBannerScreen(fromWeb: true,) :selectedTab == 5 ? CurrencyScreen(fromWeb: true,) : selectedTab == 6 ? ManageCategoryScreen(fromWeb: true,) : selectedTab == 7 ? ManageBrandWebScreen() : selectedTab == 8 ? SearchScreen(fromWeb : true) : selectedTab == 9 ? AddProductNewScreen() : Container(),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

}