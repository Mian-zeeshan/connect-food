import 'package:animated_widgets/widgets/rotation_animated.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:connectsaleorder/GetXController/BannerController.dart';
import 'package:connectsaleorder/GetXController/BrandController.dart';
import 'package:connectsaleorder/GetXController/CategoryController.dart';
import 'package:connectsaleorder/GetXController/CheckAdminController.dart';
import 'package:connectsaleorder/GetXController/DrawerCustomController.dart';
import 'package:connectsaleorder/GetXController/ItemController.dart';
import 'package:connectsaleorder/Views/Account/ChangeEmailScreen.dart';
import 'package:connectsaleorder/Views/Account/ChangePasswordScreen.dart';
import 'package:connectsaleorder/Views/AuthViews/ForgotPasswordScreen.dart';
import 'package:connectsaleorder/Views/AuthViews/LoginScreen.dart';
import 'package:connectsaleorder/Views/AuthViews/SignUpScreen.dart';
import 'package:connectsaleorder/Views/AuthViews/web/ForgotPasswordScreenWeb.dart';
import 'package:connectsaleorder/Views/AuthViews/web/LoginScreenWeb.dart';
import 'package:connectsaleorder/Views/Banner/ManageBannerScreen.dart';
import 'package:connectsaleorder/Views/Category/web/AddBrandWebScreen.dart';
import 'package:connectsaleorder/Views/Category/web/AddCategoryWebScreen.dart';
import 'package:connectsaleorder/Views/Category/web/AddSubCategoryWebScreen.dart';
import 'package:connectsaleorder/Views/Coupon/AddCoupons.dart';
import 'package:connectsaleorder/Views/HomeViews/web/HomeScreenWeb.dart';
import 'package:connectsaleorder/Views/orders/ManageOrdersScreen.dart';
import 'package:connectsaleorder/Views/WishList/WishListFragment.dart';
import 'package:connectsaleorder/Views/Banner/AddBannerScreen.dart';
import 'package:connectsaleorder/Views/Category/AddBrandScreen.dart';
import 'package:connectsaleorder/Views/Category/AddCategoryScreen.dart';
import 'package:connectsaleorder/Views/Product/AddProductScreen.dart';
import 'package:connectsaleorder/Views/Category/AddSubCategoryScreen.dart';
import 'package:connectsaleorder/Views/orders/CartScreen.dart';
import 'package:connectsaleorder/Views/Supprt/ChatScreen.dart';
import 'package:connectsaleorder/Views/orders/CheckoutScreen.dart';
import 'package:connectsaleorder/Views/Category/DealProductsScreen.dart';
import 'package:connectsaleorder/Views/HomeViews/HomeScreenCustomer.dart';
import 'package:connectsaleorder/Views/Product/ImageGalleryScreen.dart';
import 'package:connectsaleorder/Views/Category/ManageSubCategoriesScreen.dart';
import 'package:connectsaleorder/Views/orders/OrderTrackScreen.dart';
import 'package:connectsaleorder/Views/Product/PdfScreen.dart';
import 'package:connectsaleorder/Views/Product/ProductDetailScreen.dart';
import 'package:connectsaleorder/Views/Account/ProfileScreen.dart';
import 'package:connectsaleorder/Views/Account/SystemConfigScreen.dart';
import 'package:connectsaleorder/Views/orders/OrderTypeScreen.dart';
import 'package:connectsaleorder/Views/retailer/RegisterRetailerScreen.dart';
import 'package:connectsaleorder/Views/retailer/RetailerDetailScreen.dart';
import 'package:connectsaleorder/Views/retailer/RetailersScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_places_picker/google_places_picker.dart';

import 'AppConstants/Constants.dart';
import 'GetXController/locale_controller.dart';
import 'Utils/world_language.dart';
import 'Views/Account/ConfigureCountryScreen.dart';
import 'Views/AuthViews/MainAuthScreen.dart';
import 'Views/AuthViews/SplashScreen.dart';
import 'Views/Banner/web/AddBannerWebScreen.dart';
import 'Views/Category/web/ManageBrandWebScreen.dart';
import 'Views/Coupon/CouponListPage.dart';
import 'Views/Fragments/HomeFragmentCustomer.dart';
import 'Views/Category/ManageBrandScreen.dart';
import 'Views/Category/ManageCategoryScreen.dart';
import 'Views/Address/AddressesScreen.dart';
import 'Views/Account/CurrencyScreen.dart';
import 'Views/Account/EditProfileScreen.dart';
import 'Views/Product/AddProductNewScreen.dart';
import 'Views/Search/SearchScreen.dart';
import 'Views/Supprt/AdminSupportScreen.dart';
import 'Views/orders/OrderSuccessScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  AwesomeNotifications().initialize(
    // set the icon to null if you want to use the default app icon
      'resource://drawable/logo',
      [
        NotificationChannel(
            channelGroupKey: 'Mothas',
            channelKey: 'Mithas',
            channelName: 'Mithas notifications',
            channelDescription: 'Notification channel for Mithas',
            defaultColor: Color(0xFFEFEFEF),
            ledColor: Colors.white)
      ],
      debug: true
  );
  AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
    if (!isAllowed) {
      AwesomeNotifications().requestPermissionToSendNotifications();
    }
  });

  await PluginGooglePlacePicker.initialize(
    androidApiKey: "AIzaSyDnN0CXbNpwghnn0-I37oNUAf3wgWa2N_Q",
    iosApiKey: "AIzaSyDVYkQEnJBVVNgWM8NkKN94NmyPktLtl6k",
  );

  if(GetPlatform.isWeb) {
    await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "AIzaSyBtWh6iZ6_HSpRIpnKstVvfcK_rba0QOB0",
        authDomain: "sales-orders-374ef.firebaseapp.com",
        databaseURL: "https://sales-orders-374ef-default-rtdb.firebaseio.com",
        projectId: "sales-orders-374ef",
        storageBucket: "sales-orders-374ef.appspot.com",
        messagingSenderId: "306941672152",
        appId: "1:306941672152:web:59eb72337bb3c8acae75ad",
        measurementId: "G-DDTLMXHZ5V",
    ),
  );
  }else{
    await Firebase.initializeApp();
  }
  FirebaseApp app = await _configureAbnApp();
  auth = await FirebaseAuth.instanceFor(app: app);
  storage = FirebaseStorage.instanceFor(app: app);
  await GetStorage.init();
  Get.put(LocaleController());
  Get.put(ItemController());
  Get.put(CategoryController());
  Get.put(BrandController());
  Get.put(DrawerCustomController());
  Get.put(BannerController());
  CheckAdminController checkAdminController = Get.put(CheckAdminController());

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);
  EasyLoading.instance
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = checkAdminController.system.mainColor
    ..backgroundColor = whiteColor
    ..indicatorColor = checkAdminController.system.mainColor.withOpacity(0.2)
    ..textColor = checkAdminController.system.mainColor
    ..maskColor = checkAdminController.system.mainColor
    ..userInteractions = true
    ..dismissOnTap = false
    ..maskType = EasyLoadingMaskType.black
    ..textStyle = TextStyle(
        color: checkAdminController.system.mainColor,
        fontSize: labelFontSize,
        fontWeight: normal,
        decoration: TextDecoration.none,
        fontFamily: 'Roboto'
    )..indicatorWidget = Container(
        child: RotationAnimatedWidget.tween(
            enabled: true, //update this boolean to forward/reverse the animation
            duration: Duration(seconds: 30),
            rotationDisabled: Rotation.deg(z: 0),
            rotationEnabled: Rotation.deg(z: 7200),
            child: Image.asset("Assets/Images/logom.png", width: 80, height: 80,)
        )
    );
  runApp(MyApp());
}

//Hya-Collection
//Package Command "flutter pub run change_app_package_name:main com.connect.hayacollections"
// _configureAbnApp() async {
//   FirebaseOptions abnOptions = FirebaseOptions(
//       databaseURL: "https://haya-collections-default-rtdb.firebaseio.com/",
//       apiKey: "AIzaSyAB_jf7ibugIQ4VrZV0ItbDzHSAgpJZV4w",
//       messagingSenderId: "495746155139",
//       projectId: "haya-collections",
//       appId: "1:495746155139:android:cb464888b80f805abd11b6"
//   );
//   FirebaseApp app = await Firebase.initializeApp(name: "https://haya-collections-default-rtdb.firebaseio.com/", options: abnOptions);
//   database = FirebaseDatabase(databaseURL: "https://haya-collections-default-rtdb.firebaseio.com/");
//   databaseUrl = "https://haya-collections-default-rtdb.firebaseio.com/";
//   appName = "Haya Collections";
//   return app;
// }

//Electronics
//Package Command "flutter pub run change_app_package_name:main com.connectsol.electronics"
// _configureAbnApp() async {
//   FirebaseOptions abnOptions = FirebaseOptions(
//       databaseURL: "https://electronics-demo-38010-default-rtdb.firebaseio.com/",
//       apiKey: "AIzaSyCoVD4CO9qc03af4Irnb38qtjo1nCh52vc",
//       messagingSenderId: "738550336424",
//       projectId: "electronics-demo-38010",
//       appId: "1:738550336424:android:0228de3091e994cbb06b9d"
//   );
//   FirebaseApp app = await Firebase.initializeApp(name: "https://electronics-demo-38010-default-rtdb.firebaseio.com/", options: abnOptions);
//   database = FirebaseDatabase(databaseURL: "https://electronics-demo-38010-default-rtdb.firebaseio.com/");
//   databaseUrl = "https://electronics-demo-38010-default-rtdb.firebaseio.com/";
//   appName = "Electro Home";
//   return app;
// }

//Connect Food
//Package Command "flutter pub run change_app_package_name:main com.connectsol.foodecom"
// _configureAbnApp() async {
//   FirebaseOptions abnOptions = FirebaseOptions(
//       databaseURL: "https://connect-foods-2a2d2-default-rtdb.firebaseio.com/",
//       apiKey: "AIzaSyAu0slv7W4-MVjr19sBGA2eLtn_2kvubSs",
//       messagingSenderId: "1059382918533",
//       projectId: "connect-foods-2a2d2",
//       appId: "1:1059382918533:android:68dd14317d443c242a58ec",
//       storageBucket: "gs://connect-foods-2a2d2.appspot.com",
//   );
//   FirebaseApp app = await Firebase.initializeApp(name: "https://connect-foods-2a2d2-default-rtdb.firebaseio.com/", options: abnOptions);
//   database = FirebaseDatabase(databaseURL: "https://connect-foods-2a2d2-default-rtdb.firebaseio.com/");
//   databaseUrl = "https://connect-foods-2a2d2-default-rtdb.firebaseio.com/";
//   appName = "Connect Food";
//   return app;
// }

//Mithas
//Package Command "flutter pub run change_app_package_name:main com.connectsol.foodecom"
_configureAbnApp() async {
  FirebaseOptions abnOptions = FirebaseOptions(
      databaseURL: "https://mithas-fa138-default-rtdb.firebaseio.com/",
      apiKey: "AIzaSyC6n_GorpjXCsnez_V0kQhTGVc_yY0rplU",
      messagingSenderId: "739510084525",
      projectId: "mithas-fa138",
      appId: "1:739510084525:android:0a7dca33de0996e833b724",
      storageBucket: "gs://mithas-fa138.appspot.com",
  );
  FirebaseApp app = await Firebase.initializeApp(name: "https://mithas-fa138-default-rtdb.firebaseio.com/", options: abnOptions);
  database = FirebaseDatabase(databaseURL: "https://mithas-fa138-default-rtdb.firebaseio.com/");
  databaseUrl = "https://mithas-fa138-default-rtdb.firebaseio.com/";
  appName = "Mithas";
  return app;
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown
    ]);
    return ScreenUtilInit(
          designSize: GetPlatform.isWeb ? Size(1600, 900) : Size(360, 690),
          minTextAdapt: true,
          splitScreenMode: true,
      builder: () => GetMaterialApp(
        transitionDuration: Duration(microseconds: 300),
        translations: WorldLanguage(),
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', 'US'),
          Locale('ar', 'AR'),
        ],
        locale: const Locale('en', 'US'),
        getPages: [
          GetPage(name: splashRoute, page: () => SplashScreen() ,),
          GetPage(name: mainAuth, page: () => MainAuthScreen() ,),
          GetPage(name: loginRoute, page: () => (GetPlatform.isWeb ? LoginScreenWeb() : LoginScreen()) ,),
          GetPage(name: signUpRoute, page: () => SignUpScreen() ,),
          GetPage(name: forgotRoute, page: () => (GetPlatform.isWeb ? ForgotPasswordScreenWeb() : ForgotPasswordScreen()) ,),
          GetPage(name: homeCRoute, page: () => (GetPlatform.isWeb ? HomeScreenWeb() : HomeScreenCustomer()) ,),
          GetPage(name: productDetailRoute, page: () => ProductDetailScreen() ,),
          GetPage(name: pdfRoute, page: () => PdfScreen() ,),
          GetPage(name: cartRoute, page: () => CartScreen() ,),
          GetPage(name: checkoutRoute, page: () => CheckoutScreen() ,),
          GetPage(name: profileRoute, page: () => ProfileScreen() ,),
          GetPage(name: editProfileRoute, page: () => EditProfileScreen() ,),
          GetPage(name: homeFragmentRoute, page: () => HomeFragmentCustomer(false) ,),
          GetPage(name: addCategoryRoute, page: () => (GetPlatform.isWeb ? AddCategoryWebScreen() :AddCategoryScreen()),),
          GetPage(name: addSubCategoryRoute, page: () => (GetPlatform.isWeb ? AddSubCategoryWebScreen() :AddSubCategoryScreen()) ,),
          GetPage(name: manageSubCategoryRoute, page: () => ManageSubCategoryScreen() ,),
          GetPage(name: addBrandRoute, page: () => (GetPlatform.isWeb ? AddBrandWebScreen() : AddBrandScreen()) ,),
          GetPage(name: changePasswordRoute, page: () => ChangePasswordScreen() ,),
          GetPage(name: changeEmailRoute, page: () => ChangeEmailScreen() ,),
          GetPage(name: addressesRoute, page: () => AddressesScreen() ,),
          GetPage(name: trackOrderRoute, page: () => OrderTrackScreen() ,),
          GetPage(name: manageOrderRoute, page: () => ManageOrderScreen() ,),
          GetPage(name: manageBannerRoute, page: () => ManageBannerScreen() ,),
          GetPage(name: manageCurrencyRoute, page: () => CurrencyScreen() ,),
          GetPage(name: addProductRoute, page: () => AddProductNewScreen() ,),
          GetPage(name: manageBrandRoute, page: () => (GetPlatform.isWeb ? ManageBrandWebScreen() :ManageBrandScreen()) ,),
          GetPage(name: manageCategoriesRoute, page: () => ManageCategoryScreen() ,),
          GetPage(name: imageGalleryRoute, page: () => ImageGalleryScreen() ,),
          GetPage(name: addBannerRoute, page: () => (GetPlatform.isWeb ? AddBannerWebScreen() :AddBannerScreen()) ,),
          GetPage(name: favoriteRoute, page: () => WishListFragment(false) ,),
          GetPage(name: systemConfigRoute, page: () => SystemConfigScreen() ,),
          GetPage(name: dealProductsRoute, page: () => DealProductsScreen(false) ,),
          GetPage(name: chatRoute, page: () => ChatScreen() ,),
          GetPage(name: searchRoute, page: () => SearchScreen(),),
          GetPage(name: adminSupportRoute, page: () => AdminSupportScreen(),),
          GetPage(name: orderSuccessRoute, page: () => OrderSuccessScreen(),),
          GetPage(name: configureCountryRoute, page: () => ConfigureCountryScreen(),),
          GetPage(name: registerRetailerRoute, page: () => RegisterRetailerScreen(),),
          GetPage(name: retailersRoute, page: () => RetailersScreen(),),
          GetPage(name: retailerDetailRoute, page: () => RetailerDetailScreen(),),
          GetPage(name: addCouponRoute, page: () => AddCoupons(),),
          GetPage(name: couponListRoute, page: () => CouponListPage(),),
          GetPage(name: orderTypeRoute, page: () => OrderTypeScreen(),),
        ],
        initialRoute: splashRoute,
        title: appName,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          bottomSheetTheme: BottomSheetThemeData(
              backgroundColor: Colors.black.withOpacity(0)),
        ),
        builder: (context, child) {
          child = EasyLoading.init()(context,child);
          return GetBuilder<LocaleController>(id: "0", builder: (localeController){
            return Directionality(
              textDirection: localeController.locale == english ? TextDirection.ltr :TextDirection.rtl,
              child: child!,
            );
          });
        },
      ),
    );
  }
}
