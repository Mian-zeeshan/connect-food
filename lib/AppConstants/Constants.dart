
//Colors
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

final whiteColor = Color(0xFFFFFFFF);
final blackColor = Color(0xFF221e1e);
final grayColor = Color(0xFFE5E2E2);
final greenColor = Color(0xFF386A02);
final redColor = Color(0xFFC22505);

//font sizes
const labelSize = 15.0;
final buttonFontSize = 14.0;
final xHeadingFontSize = 24.0;
final xxHeadingFontSize = 36.0;
final headingFontSize = 20.0;
final titleFontSize = 18.0;
final labelFontSize = 15.0;
final descriptionFontSize = 14.0;
final smallFontSize = 14.0;
final xSmallFontSize = 10.0;

//font weights
final xBold = FontWeight.w900;
final bold = FontWeight.bold;
final normal = FontWeight.normal;
final light = FontWeight.w500;
final buttonFontWeight = FontWeight.w600;

//Route
final splashRoute = "/";
final mainAuth = "/mainAuth";
final loginRoute = "/login";
final signUpRoute = "/signUp";
final forgotRoute = "/forgotPassword";
final homeCRoute = "/homeCustomer";
final checkoutRoute = "/checkout";
final cartRoute = "/cartRoute";
final profileRoute = "/profileRoute";
final editProfileRoute = "/editprofileRoute";
final pdfRoute = "/pdf";
final homeFragmentRoute = "/homeFragment";
final addCategoryRoute = "/addCategory";
final addSubCategoryRoute = "/addSubCategory";
final addBrandRoute = "/addBrand";
final manageSubCategoryRoute = "/manageSub";
final changePasswordRoute = "/changePassword";
final changeEmailRoute = "/changeEmail";
final addressesRoute = "/addresses";
final trackOrderRoute = "/trackOrder";
final addProductRoute = "/addProduct";
final manageOrderRoute = "/manageOrder";
final manageBannerRoute = "/manageBanner";
final manageCurrencyRoute = "/manageCurrency";
final manageBrandRoute = "/manageBrand";
final manageCategoriesRoute = "/manageCategories";
final imageGalleryRoute = "/imageGallery";
final addBannerRoute = "/addBanner";
final favoriteRoute = "/favorite";
final systemConfigRoute = "/systemConfiguration";
final dealProductsRoute = "/dealProducts";
final chatRoute = "/chat";
final searchRoute = "/search";
final adminSupportRoute = "/adminSupport";
final adminChatRoute = "/adminChat";
final orderSuccessRoute = "/orderSuccess";
final configureCountryRoute = "/configureCountry";
final registerRetailerRoute = "/registerRetailer";
final retailersRoute = "/retailers";
final retailerDetailRoute = "/retailerDetail";
final addCouponRoute = "/addCoupon";
final couponListRoute = "/couponsPage";
final orderTypeRoute = "/orderType";

//daabase references
var databaseUrl = "https://mandi-online-5e4fa-default-rtdb.firebaseio.com/";
var appName = "Mandi Online";
final usersRef = "Users";
final tokenRef = "Tokens";
final adminTokenRef = "AdminTokens";
final categoryRef = "Category";
final brandRef = "Brands";
final subCategoryRef = "SubCategory";
final orderRef = "Orders";
final orderCRef = "CustomerOrders";
final itemRef = "Items";
final customerRef = "Customers";
final currencyRef = "Currency";
final bannerRef = "Banners";
final reviewRef = "Reviews";
final systemRef = "System";
final chatRef = "ChatSupport";
final chatItemRef = "Chat";
final couponRef = "Coupons";
final riderRef = "Riders";


//Json Database
final currentUser = "User";
final allCarts = "AllCarts";
final allFavorites = "allFavorites";
final recentItems = "recentItems";

final english = "en_US";
final arabic = "ar_AR";
final language = "language";
final isAdminGlobal = "isAdminGlobal";


//Firebase

FirebaseAuth auth = FirebaseAuth.instance;
FirebaseDatabase database = FirebaseDatabase.instance;
FirebaseStorage storage = FirebaseStorage.instance;

// final smsKey = "AAAArC48Y60:APA91bFAV5EhUCCs-8ZsqiY8gBrtVljc8gMLcThAPioJ-4v8LwupwEs-OpYw0eU9D9pdaq79GkAcdt56nUuQgxG2rL2U9a_zcXDNbB4n5p_osqtq385UD-E7fQM6rEpRn-8_sZm2--gO";
final smsKey = "AAAAbNsvnY8:APA91bGSFpUSKajg2XVZ-LxjKCpVC_iDg4hHHBWNu0NAREV6p-KGTPpF4bCA_Ruytrcl_vqSzTOG2vBf_Zo-Pl9UNnxLAHI_MNrkEmQbqHZ5zZV72_Lu2EF3_zd7pVWghENtyP7g9wiW";
