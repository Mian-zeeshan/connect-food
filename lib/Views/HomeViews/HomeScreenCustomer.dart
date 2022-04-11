import 'dart:async';

import 'package:connectsaleorder/AppConstants/Constants.dart';
import 'package:connectsaleorder/GetXController/CartController.dart';
import 'package:connectsaleorder/GetXController/CheckAdminController.dart';
import 'package:connectsaleorder/GetXController/Couponcontroller.dart';
import 'package:connectsaleorder/GetXController/CustomerController.dart';
import 'package:connectsaleorder/GetXController/DrawerCustomController.dart';
import 'package:connectsaleorder/GetXController/FavoriteController.dart';
import 'package:connectsaleorder/GetXController/OrderController.dart';
import 'package:connectsaleorder/GetXController/UserController.dart';
import 'package:connectsaleorder/GetXController/locale_controller.dart';
import 'package:connectsaleorder/Utils/AppUtils.dart';
import 'package:connectsaleorder/Views/Category/CategoryScreen.dart';
import 'package:connectsaleorder/Views/Fragments/HomeFragment.dart';
import 'package:connectsaleorder/Views/Fragments/HomeFragmentCustomer.dart';
import 'package:connectsaleorder/Views/orders/OrdersFragment.dart';
import 'package:connectsaleorder/Views/Account/SettingScreen.dart';
import 'package:connectsaleorder/Views/WishList/WishListFragment.dart';
import 'package:connectsaleorder/Views/orders/CartScreen.dart';
import 'package:connectsaleorder/Views/Category/DealProductsScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class HomeScreenCustomer extends StatefulWidget{
  @override
  _HomeScreenCustomer createState() => _HomeScreenCustomer();

}

class _HomeScreenCustomer extends State<HomeScreenCustomer>{
  var utils = AppUtils();
  var zoomDrawerController = ZoomDrawerController();
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
  late PersistentTabController _controller;
  CheckAdminController checkAdminController = Get.find();
  CouponController couponController = Get.put(CouponController());
  var isExist = false;
  var type = Get.arguments??0;
  var selectedIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = PersistentTabController(initialIndex: 0);
    discountController.selection = TextSelection.fromPosition(TextPosition(offset: discountController.text.length));
    if(type == 1){
      EasyLoading.show(status: "Loading...");
      Timer.periodic(Duration(seconds: 3), (timer) {
        timer.cancel();
        Get.to(()=>OrderFragment(false,hideBack: false));
        EasyLoading.dismiss();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserController>(id: "0", builder: (userController){
      return GetBuilder<DrawerCustomController>(id: "0",builder: (customDController){
        return GetBuilder<LocaleController>(id: "0",builder: (lController){
          _controller.index = customDController.selectedTab;
        return PersistentTabView(
          context,
          controller: _controller,
          screens: _buildScreens(userController),
          items: _navBarsItems(),
          confineInSafeArea: true,
          backgroundColor: checkAdminController.system.mainColor, // Default is Colors.white.
          handleAndroidBackButtonPress: true, // Default is true.
          resizeToAvoidBottomInset: true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
          stateManagement: true, // Default is true.
          hideNavigationBarWhenKeyboardShows: true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
          decoration: NavBarDecoration(
            borderRadius: BorderRadius.circular(10.0),
            colorBehindNavBar: checkAdminController.system.mainColor,
          ),
          popAllScreensOnTapOfSelectedTab: true,
          popActionScreens: PopActionScreensType.all,
          itemAnimationProperties: ItemAnimationProperties( // Navigation Bar's items animation properties.
            duration: Duration(milliseconds: 200),
            curve: Curves.ease,
          ),
          onItemSelected: (index){
            switch(index){
              case 0:
                selectedIndex = index;
              break;
              case 1:
                if(userController.user == null) {
                  selectedIndex = 3;
                }else{
                  if(checkAdminController.system.bottomNavigationChecks.isProducts){
                    selectedIndex = 1;
                  }
                  else if(checkAdminController.system.bottomNavigationChecks.isCategories){
                    selectedIndex = 2;
                  }
                  else if(checkAdminController.system.bottomNavigationChecks.isOrders){
                    selectedIndex = 4;
                  }
                  else if(checkAdminController.system.bottomNavigationChecks.isCart){
                    selectedIndex = 5;
                  }
                  else if(checkAdminController.system.bottomNavigationChecks.isFavorite){
                    selectedIndex = 6;
                  }
                  else if(checkAdminController.system.bottomNavigationChecks.isDeals){
                    selectedIndex = 7;
                  }
                }
              break;
              case 2:
                if(userController.user == null) {
                  selectedIndex = 8;
                }
                else{
                  if(checkAdminController.system.bottomNavigationChecks.isProducts){
                    selectedIndex = 2;
                  }

                  if(checkAdminController.system.bottomNavigationChecks.isCategories){
                    selectedIndex = 2;
                  }
                  else if(checkAdminController.system.bottomNavigationChecks.isOrders){
                    selectedIndex = 4;
                  }else if(checkAdminController.system.bottomNavigationChecks.isCart){
                    selectedIndex = 5;
                  }else if(checkAdminController.system.bottomNavigationChecks.isFavorite){
                    selectedIndex = 6;
                  }else if(checkAdminController.system.bottomNavigationChecks.isDeals){
                    selectedIndex = 7;
                  }
                }
              break;
              case 3:
                if(checkAdminController.system.bottomNavigationChecks.isProducts){
                  selectedIndex = 2;
                }

                if(checkAdminController.system.bottomNavigationChecks.isCategories){
                  selectedIndex = 3;
                }

                if(checkAdminController.system.bottomNavigationChecks.isOrders){
                  selectedIndex = 4;
                }
                else if(checkAdminController.system.bottomNavigationChecks.isCart){
                  selectedIndex = 5;
                }
                else if(checkAdminController.system.bottomNavigationChecks.isFavorite){
                  selectedIndex = 6;
                }
                else if(checkAdminController.system.bottomNavigationChecks.isDeals){
                  selectedIndex = 7;
                }
              break;
              case 4:
                selectedIndex = 9;
              break;
            }
            customDController.setDrawer("", index);
          },
          onWillPop: (context) async {
            if(isExist){
              return true;
            }else {
              isExist = true;
              utils.snackBar(context!,message: "Press again to exit");
              Timer.periodic(Duration(seconds: 2), (timer) {
                isExist = false;
                timer.cancel();
              });
              return false;
            }
          },
          screenTransitionAnimation: ScreenTransitionAnimation( // Screen transition animation on change of selected tab.
            animateTabTransition: true,
            curve: Curves.ease,
            duration: Duration(milliseconds: 200),
          ),
          navBarStyle: checkAdminController.system.bottomNavigationChecks.bottomStyle == 0 ? NavBarStyle.style9 :checkAdminController.system.bottomNavigationChecks.bottomStyle == 1 ? NavBarStyle.style1 :checkAdminController.system.bottomNavigationChecks.bottomStyle == 2 ? NavBarStyle.style3 :checkAdminController.system.bottomNavigationChecks.bottomStyle == 3 ? NavBarStyle.style6 :checkAdminController.system.bottomNavigationChecks.bottomStyle == 4 ? NavBarStyle.style7 : checkAdminController.system.bottomNavigationChecks.bottomStyle == 5 ? NavBarStyle.style10 :checkAdminController.system.bottomNavigationChecks.bottomStyle == 6 ? NavBarStyle.style12 :checkAdminController.system.bottomNavigationChecks.bottomStyle == 7 ? NavBarStyle.style13 : checkAdminController.system.bottomNavigationChecks.bottomStyle == 8 ? NavBarStyle.style15 :checkAdminController.system.bottomNavigationChecks.bottomStyle == 9 ? NavBarStyle.style16 : NavBarStyle.style9, // Choose the nav bar style with this property.
        );
      });
      });
    });
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
          icon: Image.asset("Assets/Images/home.png", width: 24.w, height: 24.w, color: selectedIndex == 0 ? (checkAdminController.system.bottomNavigationChecks.bottomStyle == 4 || checkAdminController.system.bottomNavigationChecks.bottomStyle == 5 ? checkAdminController.system.mainColor : whiteColor ): whiteColor,),
          title: ("Home"),
        iconSize: 20.w,
        activeColorPrimary: whiteColor,
          inactiveColorPrimary: whiteColor,
          activeColorSecondary: checkAdminController.system.bottomNavigationChecks.bottomStyle == 4 || checkAdminController.system.bottomNavigationChecks.bottomStyle == 5 ? checkAdminController.system.mainColor : whiteColor
      ),
      if(uController.user != null && checkAdminController.system.bottomNavigationChecks.isProducts) PersistentBottomNavBarItem(
          icon: Image.asset("Assets/Images/products.png", width: 24.w, height: 24.w, color: selectedIndex == 1 ? (checkAdminController.system.bottomNavigationChecks.bottomStyle == 4 || checkAdminController.system.bottomNavigationChecks.bottomStyle == 5 ? checkAdminController.system.mainColor : whiteColor): whiteColor,),
          title: ("Products"),
          iconSize: 20.w,
          activeColorPrimary: whiteColor,
          inactiveColorPrimary: whiteColor,
          activeColorSecondary: checkAdminController.system.bottomNavigationChecks.bottomStyle == 4 || checkAdminController.system.bottomNavigationChecks.bottomStyle == 5 ? checkAdminController.system.mainColor : whiteColor
      ),
      if(uController.user != null && checkAdminController.system.bottomNavigationChecks.isCategories) PersistentBottomNavBarItem(
         icon: Image.asset("Assets/Images/category.png", width: 24.w, height: 24.w, color: selectedIndex == 2 ? ((checkAdminController.system.bottomNavigationChecks.bottomStyle == 4 || checkAdminController.system.bottomNavigationChecks.bottomStyle == 5|| checkAdminController.system.bottomNavigationChecks.bottomStyle == 8 || checkAdminController.system.bottomNavigationChecks.bottomStyle == 9) && (checkAdminController.system.bottomNavigationChecks.isProducts) ? checkAdminController.system.mainColor : whiteColor): whiteColor,),
          title: ("Category"),
          iconSize: 20.w,
          activeColorPrimary: whiteColor,
          inactiveColorPrimary: whiteColor,
          activeColorSecondary: (checkAdminController.system.bottomNavigationChecks.bottomStyle == 4 || checkAdminController.system.bottomNavigationChecks.bottomStyle == 5|| checkAdminController.system.bottomNavigationChecks.bottomStyle == 8 || checkAdminController.system.bottomNavigationChecks.bottomStyle == 9) && (checkAdminController.system.bottomNavigationChecks.isProducts) ? checkAdminController.system.mainColor : whiteColor
      ),
      if(uController.user == null) PersistentBottomNavBarItem(
          icon: Image.asset("Assets/Images/products.png", width: 24.w, height: 24.w, color: selectedIndex == 3 ? (checkAdminController.system.bottomNavigationChecks.bottomStyle == 4 || checkAdminController.system.bottomNavigationChecks.bottomStyle == 5 || checkAdminController.system.bottomNavigationChecks.bottomStyle == 8 || checkAdminController.system.bottomNavigationChecks.bottomStyle == 9 ? checkAdminController.system.mainColor : whiteColor): whiteColor,),
          title: ("Products"),
          iconSize: 20.w,
          activeColorPrimary: whiteColor,
          inactiveColorPrimary: whiteColor,
          activeColorSecondary: checkAdminController.system.bottomNavigationChecks.bottomStyle == 4 || checkAdminController.system.bottomNavigationChecks.bottomStyle == 5 || checkAdminController.system.bottomNavigationChecks.bottomStyle == 8 || checkAdminController.system.bottomNavigationChecks.bottomStyle == 9 ? checkAdminController.system.mainColor : whiteColor
      ),
      if(uController.user != null && checkAdminController.system.bottomNavigationChecks.isOrders) PersistentBottomNavBarItem(
          icon: Image.asset("Assets/Images/order.png", width: 24.w, height: 24.w, color: selectedIndex == 4 ? (checkAdminController.system.bottomNavigationChecks.bottomStyle == 4 || checkAdminController.system.bottomNavigationChecks.bottomStyle == 5 ? checkAdminController.system.mainColor : whiteColor): whiteColor,),
          title: ("Orders"),
          iconSize: 20.w,
          activeColorPrimary: whiteColor,
          inactiveColorPrimary: whiteColor,
          activeColorSecondary: checkAdminController.system.bottomNavigationChecks.bottomStyle == 4 || checkAdminController.system.bottomNavigationChecks.bottomStyle == 5 ? checkAdminController.system.mainColor : whiteColor
      ),
      if(uController.user != null && checkAdminController.system.bottomNavigationChecks.isCart) PersistentBottomNavBarItem(
          icon: Image.asset("Assets/Images/cart.png", width: 24.w, height: 24.w, color: selectedIndex == 5 ? (checkAdminController.system.bottomNavigationChecks.bottomStyle == 7 || checkAdminController.system.bottomNavigationChecks.bottomStyle == 6 || checkAdminController.system.bottomNavigationChecks.bottomStyle == 3 || checkAdminController.system.bottomNavigationChecks.bottomStyle == 2 ||checkAdminController.system.bottomNavigationChecks.bottomStyle == 1 ||checkAdminController.system.bottomNavigationChecks.bottomStyle == 0 || ((checkAdminController.system.bottomNavigationChecks.bottomStyle == 8 || checkAdminController.system.bottomNavigationChecks.bottomStyle == 9) && (checkAdminController.system.bottomNavigationChecks.isOrders)) ? whiteColor : checkAdminController.system.mainColor): whiteColor,),
          title: ("Cart"),
          iconSize: 20.w,
          activeColorPrimary: whiteColor,
        inactiveColorPrimary: whiteColor,
        activeColorSecondary: checkAdminController.system.bottomNavigationChecks.bottomStyle == 7 || checkAdminController.system.bottomNavigationChecks.bottomStyle == 6 || checkAdminController.system.bottomNavigationChecks.bottomStyle == 3 || checkAdminController.system.bottomNavigationChecks.bottomStyle == 2 ||checkAdminController.system.bottomNavigationChecks.bottomStyle == 1 ||checkAdminController.system.bottomNavigationChecks.bottomStyle == 0 || ((checkAdminController.system.bottomNavigationChecks.bottomStyle == 8 || checkAdminController.system.bottomNavigationChecks.bottomStyle == 9) && (checkAdminController.system.bottomNavigationChecks.isOrders)) ? whiteColor : checkAdminController.system.mainColor
      ),
      if(uController.user != null && checkAdminController.system.bottomNavigationChecks.isFavorite) PersistentBottomNavBarItem(
          icon: Image.asset("Assets/Images/fav.png", width: 24.w, height: 24.w, color: selectedIndex == 6 ? (checkAdminController.system.bottomNavigationChecks.bottomStyle == 7 || checkAdminController.system.bottomNavigationChecks.bottomStyle == 6 || checkAdminController.system.bottomNavigationChecks.bottomStyle == 3 || checkAdminController.system.bottomNavigationChecks.bottomStyle == 2 ||checkAdminController.system.bottomNavigationChecks.bottomStyle == 1 ||checkAdminController.system.bottomNavigationChecks.bottomStyle == 0 || ((checkAdminController.system.bottomNavigationChecks.bottomStyle == 8 || checkAdminController.system.bottomNavigationChecks.bottomStyle == 9) && (checkAdminController.system.bottomNavigationChecks.isCart ||checkAdminController.system.bottomNavigationChecks.isOrders )) ? whiteColor : checkAdminController.system.mainColor): whiteColor,),
          title: ("Favorite"),
          iconSize: 20.w,
          activeColorPrimary: whiteColor,
          inactiveColorPrimary: whiteColor,
          activeColorSecondary: checkAdminController.system.bottomNavigationChecks.bottomStyle == 7 || checkAdminController.system.bottomNavigationChecks.bottomStyle == 6 || checkAdminController.system.bottomNavigationChecks.bottomStyle == 3 || checkAdminController.system.bottomNavigationChecks.bottomStyle == 2 ||checkAdminController.system.bottomNavigationChecks.bottomStyle == 1 ||checkAdminController.system.bottomNavigationChecks.bottomStyle == 0 || ((checkAdminController.system.bottomNavigationChecks.bottomStyle == 8 || checkAdminController.system.bottomNavigationChecks.bottomStyle == 9) && (checkAdminController.system.bottomNavigationChecks.isCart ||checkAdminController.system.bottomNavigationChecks.isOrders )) ? whiteColor : checkAdminController.system.mainColor
      ),
      if(uController.user != null && checkAdminController.system.bottomNavigationChecks.isDeals) PersistentBottomNavBarItem(
          icon: Image.asset("Assets/Images/deals.png", width: 24.w, height: 24.w, color: selectedIndex == 7 ? (checkAdminController.system.bottomNavigationChecks.bottomStyle == 4 || checkAdminController.system.bottomNavigationChecks.bottomStyle == 5 ? checkAdminController.system.mainColor : whiteColor): whiteColor,),
          title: ("Deals"),
          iconSize: 20.w,
          activeColorPrimary: whiteColor,
          inactiveColorPrimary: whiteColor,
          activeColorSecondary: checkAdminController.system.bottomNavigationChecks.bottomStyle == 4 || checkAdminController.system.bottomNavigationChecks.bottomStyle == 5 ? checkAdminController.system.mainColor : whiteColor
      ),
      if(uController.user == null) PersistentBottomNavBarItem(
          icon: Image.asset("Assets/Images/deals.png", width: 24.w, height: 24.w, color: selectedIndex == 8 ? (checkAdminController.system.bottomNavigationChecks.bottomStyle == 4 || checkAdminController.system.bottomNavigationChecks.bottomStyle == 5 ? checkAdminController.system.mainColor : whiteColor): whiteColor,),
          title: ("Deals"),
          iconSize: 20.w,
          activeColorPrimary: whiteColor,
          inactiveColorPrimary: whiteColor,
          activeColorSecondary: checkAdminController.system.bottomNavigationChecks.bottomStyle == 4 || checkAdminController.system.bottomNavigationChecks.bottomStyle == 5 ? checkAdminController.system.mainColor : whiteColor
      ),
      if(uController.user != null) PersistentBottomNavBarItem(
          icon: Image.asset("Assets/Images/account.png", width: 24.w, height: 24.w, color: selectedIndex == 9 ? (checkAdminController.system.bottomNavigationChecks.bottomStyle == 4 || checkAdminController.system.bottomNavigationChecks.bottomStyle == 5 ? checkAdminController.system.mainColor : whiteColor): whiteColor,),
          title: ("Account"),
          iconSize: 20.w,
          activeColorPrimary: whiteColor,
          inactiveColorPrimary: whiteColor,
          activeColorSecondary: checkAdminController.system.bottomNavigationChecks.bottomStyle == 4 || checkAdminController.system.bottomNavigationChecks.bottomStyle == 5 ? checkAdminController.system.mainColor : whiteColor
      ),
    ];
  }

  List<Widget> _buildScreens(UserController userController) {
    return [
      Scaffold(
        backgroundColor: whiteColor,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(0),
          child: AppBar(
            backgroundColor: checkAdminController.system.mainColor,
            elevation: 0,
          ),
        ),
        body: SafeArea(
          child: Container(
            width: Get.width,
            height: Get.height,
            color: grayColor.withOpacity(0.3),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15 , vertical: 4),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12),),
                      color: checkAdminController.system.mainColor
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(child: Text("home".tr, style: utils.headingStyle(whiteColor),)),
                      if(userController.user != null) IconButton(
                        onPressed : (){
                          Get.toNamed(chatRoute, arguments: 0);
                        },
                        icon: Icon(CupertinoIcons.conversation_bubble, color: whiteColor, size: 24.w,),
                      ),
                      if(userController.user != null) IconButton(
                        onPressed : (){
                          Get.toNamed(favoriteRoute);
                        },
                        icon: Icon(CupertinoIcons.heart, color: whiteColor, size: 24.w,),
                      ),
                      if(userController.user != null) IconButton(
                        onPressed : (){
                          if(userController.user != null) {
                            setState(() {
                              Get.toNamed(cartRoute);
                            });
                          }else{
                            utils.loginBottomSheet(context);
                          }
                        },
                        icon: Container(
                          width: 24.w,
                          height: 24.w,
                          child: Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              Icon(CupertinoIcons.shopping_cart , color: whiteColor, size: 24.w,),
                              Positioned(
                                  top: 0,
                                  right: 0,
                                  child: Container(
                                    width: 14.w,
                                    height: 14.w,
                                    padding: EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                        color: redColor,
                                        shape: BoxShape.circle
                                    ),
                                    child: Center(
                                      child: GetBuilder<CartController>(id: "0", builder: (cartController){
                                        return Text("${cartController.myCart.totalItems}" , style: utils.xSmallLabelStyle(whiteColor),);
                                      },),
                                    ),
                                  )
                              )
                            ],
                          ),
                        ),
                      ),
                      if(userController.user == null) IconButton(
                        onPressed : (){
                          utils.loginBottomSheet(context);
                        },
                        icon: Container(
                          width: 28,
                          height: 28,
                          child: Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              Image.asset("Assets/Images/account.png" , color: whiteColor,),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                    child: HomeFragment()
                )
              ],
            ),
          ),
        ),
      ),
      if(uController.user != null && checkAdminController.system.bottomNavigationChecks.isProducts) HomeFragmentCustomer(true),
      if(uController.user == null) HomeFragmentCustomer(true),
      if(uController.user != null && checkAdminController.system.bottomNavigationChecks.isCategories) CategoryScreen(),
      if(uController.user != null && checkAdminController.system.bottomNavigationChecks.isOrders) OrderFragment(false),
      if(uController.user != null && checkAdminController.system.bottomNavigationChecks.isCart) CartScreen(),
      if(uController.user != null && checkAdminController.system.bottomNavigationChecks.isFavorite) WishListFragment(true),
      if(uController.user != null && checkAdminController.system.bottomNavigationChecks.isDeals) DealProductsScreen(true),
      if(uController.user == null) DealProductsScreen(true),
      if(uController.user != null) SettingScreen()
    ];
  }

}
