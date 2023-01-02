
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
var databaseUrl = "https://mybagpack-68e63-default-rtdb.firebaseio.com/";
var appName = "MyBagPack";
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
final notificationRef = "Notifications";
final blogRef = "Blogs";
final addonRef = "Addons";

var htmlString = "";


//Json Database
final currentUser = "User";
final allCarts = "AllCarts";
final allFavorites = "allFavorites";
final recentItems = "recentItems";

final english = "en_US";
final arabic = "ar_AR";
final language = "language";
final isAdminGlobal = "isAdminGlobal";
final socialNotifications = "SocialNotifications";


//Firebase

FirebaseAuth auth = FirebaseAuth.instance;
FirebaseDatabase database = FirebaseDatabase.instance;
FirebaseStorage storage = FirebaseStorage.instance;

final smsKey = "AAAAL-Ym-xU:APA91bGQidLuvxVGj9GwOFb11jMsjiK-Y0kabsjHzQltgHHghFIZ2VNI_XqyaXCfvBp5CqhLc15n21-UXkW9zliK2qQfM7LNOzV243w_h259jEJvqNQMxx3noNy3wT8aM49Aqw8nVlWj";
//final smsKey = "AAAAbNsvnY8:APA91bGSFpUSKajg2XVZ-LxjKCpVC_iDg4hHHBWNu0NAREV6p-KGTPpF4bCA_Ruytrcl_vqSzTOG2vBf_Zo-Pl9UNnxLAHI_MNrkEmQbqHZ5zZV72_Lu2EF3_zd7pVWghENtyP7g9wiW";
