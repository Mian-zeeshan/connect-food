import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:connectsaleorder/AppConstants/Constants.dart';
import 'package:connectsaleorder/AppConstants/TimeAgo.dart';
import 'package:connectsaleorder/GetXController/CartController.dart';
import 'package:connectsaleorder/GetXController/ChatController.dart';
import 'package:connectsaleorder/GetXController/CheckAdminController.dart';
import 'package:connectsaleorder/GetXController/FavoriteController.dart';
import 'package:connectsaleorder/GetXController/ItemController.dart';
import 'package:connectsaleorder/GetXController/UserController.dart';
import 'package:connectsaleorder/Models/ItemModel.dart';
import 'package:connectsaleorder/Models/ReviewModel.dart';
import 'package:connectsaleorder/Utils/AppUtils.dart';
import 'package:connectsaleorder/Views/Review/ReviewScreen.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:swipe_image_gallery/swipe_image_gallery.dart';

class ProductDetailScreen extends StatefulWidget{
  @override
  _ProductDetailScreen createState() => _ProductDetailScreen();

}

class _ProductDetailScreen extends State<ProductDetailScreen>{
  var utils = AppUtils();
  ItemModel itemModel = Get.arguments;

  CartController cartController = Get.find();
  UserController userController = Get.find();
  FavoriteController favoriteController = Get.find();
  ItemController itemController = Get.find();
  CheckAdminController checkAdminController = Get.find();
  late ChatController chatController;
  var index = 0;
  var selectedQuantity = 1;
  Map<String,dynamic> cartInfo = {};
  var inCart = false;
  var cartPosition = 0;
  ItemModel? cartItem;
  var rate = 0.0;
  var commentController = TextEditingController();
  ScrollController _scrollController = ScrollController();
  double opacity = 0;
  var isRetailer = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isRetailer = userController.user != null ? userController.user!.isRetailer? userController.user!.retailerModel!.approved ? true : false :false : false;
    cartInfo = cartController.checkInCart(itemModel);
    inCart = cartInfo["inCart"];
    cartPosition = cartInfo["position"];
    cartItem = cartInfo["cartItem"];
    Timer.periodic(Duration(seconds: 1), (timer) {
      itemController.addRecentItems(itemModel);
      itemController.getItemReviews(itemModel);
      timer.cancel();
    });
    if(userController.user != null){
      chatController = Get.find();
    }
    setState(() {
    });

    _scrollController.addListener(() {
      var matrix = _scrollController.position.pixels;
      if(matrix < 20){
        opacity = 0;
      }else if(matrix < 40){
        opacity = 0.2;
      }else if(matrix < 60){
        opacity = 0.4;
      }else if(matrix < 80){
        opacity = 0.6;
      }else if(matrix < 100){
        opacity = 0.8;
      }else if(matrix < 120){
        opacity = 1;
      }
      setState(() {
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if(userController.user != null){
      itemModel.isFav = favoriteController.checkFavorite(itemModel);
    }
    return Scaffold(
        backgroundColor: whiteColor,
        body: Container(
          width: Get.width,
          height: Get.height,
          color: whiteColor,
          child: Stack(
            children: [
              Container(
                width: Get.width,
                height: Get.height,
                child: GetBuilder<ItemController>(id: "0",builder: (__itemController){
                  return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20)),
                              color: whiteColor,
                              boxShadow: [
                                BoxShadow(
                                    blurRadius: 4,
                                    spreadRadius: 2,
                                    offset: Offset(0,3),
                                    color: grayColor
                                )
                              ]
                          ),
                          child: SingleChildScrollView(
                            controller: _scrollController,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: Get.width,
                                  height: 300,
                                  color: whiteColor,
                                  child: Stack(
                                    children: [
                                      Container(
                                        width: Get.width,
                                        height: 300,
                                        clipBehavior: Clip.antiAliasWithSaveLayer,
                                        decoration: BoxDecoration(
                                            color: whiteColor
                                        ),
                                        child: Stack(
                                          children: [
                                            itemModel.images.length > 0 ? Container(
                                              width: Get.width,
                                              height: 300,
                                              child: CarouselSlider(
                                                items: [
                                                  for(var b in itemModel.images)
                                                    GestureDetector(
                                                      onTap : (){
                                                        SwipeImageGallery(
                                                          context: context,
                                                          itemBuilder: (context, index) {
                                                            return CachedNetworkImage(
                                                              imageUrl: itemModel.images[index],
                                                              placeholder: (context, url) => SpinKitRotatingCircle(color: checkAdminController.system.mainColor,),
                                                              errorWidget: (context, url, error) => Icon(
                                                                Icons.image_not_supported_rounded,
                                                                size: 25,
                                                              ),
                                                            );
                                                          },
                                                          onSwipe: (index){
                                                            this.index = index;
                                                          },
                                                          itemCount: itemModel.images.length,
                                                        ).show();
                                                      },
                                                      child: Container(
                                                          width: Get.width,
                                                          height: 300,
                                                          child: Image.network(b, fit: BoxFit.contain,)
                                                      ),
                                                    ),
                                                ],
                                                options: CarouselOptions(
                                                    autoPlay: true,
                                                    enlargeCenterPage: false,
                                                    viewportFraction: 1,
                                                    aspectRatio: 2.0,
                                                    initialPage: 0,
                                                    onPageChanged: (position,reason){
                                                      index = position;
                                                      setState(() {
                                                      });
                                                    }
                                                ),
                                              ),
                                            ) : Container(),
                                            Container(
                                              width: Get.width,
                                              height: 300,
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  DotsIndicator(
                                                    dotsCount: itemModel.images.length,
                                                    position: index.toDouble(),
                                                    decorator: DotsDecorator(
                                                        size: const Size.square(9.0),
                                                        activeSize: const Size(18.0, 9.0),
                                                        activeShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                                                        activeColor: checkAdminController.system.mainColor,
                                                        color: grayColor
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            if((checkAdminController.isAdmin == "1" || GetPlatform.isWeb) && opacity <= 0.5) Positioned(
                                                right: 12,
                                                bottom: 10,
                                                child: GestureDetector(
                                                  onTap: () async {
                                                    await Get.toNamed(addProductRoute , arguments: itemModel);
                                                    index = 0;
                                                    setState(() {
                                                    });
                                                  },
                                                  child: Container(
                                                    width: 50,
                                                    height: 50,
                                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                                    decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: checkAdminController.system.mainColor
                                                    ),
                                                    child: Center(
                                                      child: Icon(CupertinoIcons.pen, color: whiteColor, size: 24,),
                                                    ),
                                                  ),
                                                ))
                                          ],
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 10,
                                        left: 10,
                                        child: Container(
                                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(8),
                                              color: itemModel.totalStock > 0 ? greenColor.withOpacity(0.3) : redColor.withOpacity(0.3)
                                          ),
                                          child: Text(itemModel.totalStock > 0 ? "In Stock" : "Out Stock" , style: utils.xSmallLabelStyle(itemModel.totalStock > 0 ? greenColor : redColor),),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  width: Get.width,
                                  height: 1,
                                  color: grayColor,
                                ),
                                SizedBox(height: 10,),
                                Container(
                                    width: Get.width,
                                    padding: EdgeInsets.symmetric(horizontal: 4),
                                    child: Text("${itemModel.name}" , style: utils.boldLabelStyle(blackColor.withOpacity(0.7)),)

                                ),
                                SizedBox(height: 2,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(child: RatingBar(
                                      initialRating: itemModel.rating,
                                      direction: Axis.horizontal,
                                      allowHalfRating: true,
                                      itemCount: 5,
                                      itemSize: 16,
                                      ratingWidget: RatingWidget(
                                        full: Icon(CupertinoIcons.star_fill , color: Colors.amber,),
                                        half: Icon(CupertinoIcons.star_lefthalf_fill , color: Colors.amber,),
                                        empty: Icon(CupertinoIcons.star , color: Colors.amber,),
                                      ),
                                      itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                                      onRatingUpdate: (rating) {
                                        print(rating);
                                      },
                                      ignoreGestures: true,
                                    ),),
                                    Container(
                                      child: GestureDetector(
                                        onTap: (){
                                          if(userController.user != null) {
                                            if(itemModel.isFav){
                                              favoriteController.removeFavoriteWithCode(
                                                  itemModel.code);
                                            }else {
                                              favoriteController.addToFav(
                                                  itemModel);
                                            }
                                            setState(() {
                                            });
                                          }
                                        },
                                        child: Container(
                                          child: Icon(itemModel.isFav ? CupertinoIcons.heart_fill :CupertinoIcons.heart , color: checkAdminController.system.mainColor, size: 24,),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 2,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    if((isRetailer ? itemModel.wholeSale : itemModel.salesRate) != (isRetailer ? itemModel.discountedPriceW : itemModel.discountedPrice))  Text(
                                        "${utils.getFormattedPrice(isRetailer ? itemModel.wholeSale : itemModel.salesRate)}",
                                        style: utils.boldLabelStyleSlash(blackColor.withOpacity(0.5))
                                    ),
                                    SizedBox(width: 12,),
                                    Text(
                                        "${utils.getFormattedPrice(isRetailer ? itemModel.discountedPriceW : itemModel.discountedPrice)}",
                                        style: utils.boldLabelStyle(blackColor)
                                    ),
                                  ],
                                ),
                                SizedBox(height: 4,),
                                Text(
                                    "${itemModel.shortDescription??""}",
                                    style: utils.xSmallLabelStyle(blackColor)
                                ),
                                SizedBox(height: 4,),
                                Text(
                                    "Description",
                                    style: utils.boldLabelStyle(blackColor)
                                ),
                                SizedBox(height: 4,),
                                Text(
                                    "${itemModel.description??"N/A"}",
                                    style: utils.xSmallLabelStyle(blackColor)
                                ),
                                if(itemModel.specs.length > 0) SizedBox(height: 10,),
                                if(itemModel.specs.length > 0) Text(
                                    "Specifications",
                                    style: utils.boldLabelStyle(blackColor)
                                ),
                                if(itemModel.specs.length > 0) SizedBox(height: 4,),
                                if(itemModel.specs.length > 0)
                                  for(var  i = 0 ; i < itemModel.specs.length; i++)
                                    Container(
                                      padding: EdgeInsets.symmetric(vertical: 2),
                                      child: Column(
                                        children: [
                                          IntrinsicHeight(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Expanded(child: Text("${itemModel.specs[i].specTitle}" , style: utils.xBoldSmallLabelStyle(blackColor),)),
                                                SizedBox(width: 6,),
                                                Container(
                                                  width: 0.5,
                                                  color: grayColor,
                                                ),
                                                SizedBox(width: 6,),
                                                Expanded(child: Text("${itemModel.specs[i].specDescription}" , style: utils.xSmallLabelStyle(blackColor),)),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 4,),
                                          Container(
                                            width: Get.width,
                                            height: 0.5,
                                            color: grayColor,
                                          )
                                        ],
                                      ),
                                    ),
                                SizedBox(height: 10,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text("Reviews" , style: utils.boldLabelStyle(blackColor),),
                                    InkWell(
                                      onTap: (){
                                        showReviewBottom(context, itemModel);
                                      },
                                      child: Container(
                                          padding: EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                                          child: Text("View all" , style: utils.xBoldSmallLabelStyle(checkAdminController.system.mainColor),)),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10,),
                                Container(
                                  width: Get.width,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        child: utils.textField(whiteColor, CupertinoIcons.doc_text, blackColor, null, null, blackColor, "Comment", blackColor.withOpacity(0.4), blackColor, 1.0, GetPlatform.isWeb ? 400 : Get.size.width, false, commentController, multiline: true),
                                      ),
                                      SizedBox(height: 6,),
                                      RatingBar(
                                        initialRating: 1,
                                        direction: Axis.horizontal,
                                        allowHalfRating: true,
                                        itemCount: 5,
                                        itemSize: 24,
                                        ratingWidget: RatingWidget(
                                          full: Icon(CupertinoIcons.star_fill , color: Colors.amber,),
                                          half: Icon(CupertinoIcons.star_lefthalf_fill , color: Colors.amber,),
                                          empty: Icon(CupertinoIcons.star , color: Colors.amber,),
                                        ),
                                        itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                                        onRatingUpdate: (rating) {
                                          rate = rating;
                                        },
                                      ),
                                      SizedBox(height: 6,),
                                      Container(
                                        child: InkWell(
                                          onTap: (){
                                            if(commentController.text.isEmpty){
                                              Get.snackbar("Error", "Kindly enter some review.");
                                            }
                                            if(userController.user != null) {
                                              addReview(itemModel);
                                            }else{
                                              Get.snackbar("Error", "Please Login and than provide us your feedback.");
                                            }
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(horizontal: 12 , vertical: 6),
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(8),
                                                border: Border.all(color: checkAdminController.system.mainColor , width: 1.0),
                                                color: checkAdminController.system.mainColor
                                            ),
                                            child: Text("Submit" , style: utils.buttonStyle(whiteColor),),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 10,),
                                if(itemController.reviews.length > 0)
                                  for(var i = 0 ; i < (itemController.reviews.length > 1 ? 1 : itemController.reviews.length); i++)
                                    Container(
                                      margin: EdgeInsets.symmetric(horizontal: 2, vertical: 1),
                                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(12),
                                          color: whiteColor,
                                          boxShadow: [
                                            BoxShadow(
                                                spreadRadius: 2,
                                                blurRadius: 2,
                                                offset: Offset(0,2),
                                                color: grayColor.withOpacity(0.5)
                                            )
                                          ]
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: 60,
                                            height: 60,
                                            clipBehavior: Clip.antiAliasWithSaveLayer,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(8),
                                                color: checkAdminController.system.mainColor
                                            ),
                                            child: Image.network(itemController.reviews[i].image, fit: BoxFit.cover,),
                                          ),
                                          SizedBox(width: 8,),
                                          Expanded(child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Text("${itemController.reviews[i].name}", style: utils.boldLabelStyle(blackColor),),
                                                  Text("${TimeAgo.timeAgoSinceDate(DateFormat("yyyy-MM-ddTHH:mm:ss").format(DateTime.fromMillisecondsSinceEpoch(itemController.reviews[i].createdAt)))}", style: utils.xSmallLabelStyle(blackColor),),
                                                ],
                                              ),
                                              Text("${itemController.reviews[i].comment}", style: utils.smallLabelStyle(blackColor.withOpacity(0.4)),),
                                              RatingBar(
                                                initialRating: itemController.reviews[i].rating,
                                                direction: Axis.horizontal,
                                                allowHalfRating: true,
                                                itemCount: 5,
                                                itemSize: 14,
                                                ratingWidget: RatingWidget(
                                                  full: Icon(CupertinoIcons.star_fill , color: Colors.amber,),
                                                  half: Icon(CupertinoIcons.star_lefthalf_fill , color: Colors.amber,),
                                                  empty: Icon(CupertinoIcons.star , color: Colors.amber,),
                                                ),
                                                itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                                                onRatingUpdate: (rating) {
                                                  print(rating);
                                                },
                                                ignoreGestures: true,
                                              ),
                                            ],
                                          ))
                                        ],
                                      ),
                                    ),

                                SizedBox(height: 20,),
                              ],
                            ),
                          ),
                        ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                          color: whiteColor,
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 2,
                                spreadRadius: 2,
                                offset: Offset(0,2),
                                color: grayColor
                            )
                          ]
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          if(!inCart || userController.user == null) Expanded(
                            child: Container(
                              padding: EdgeInsets.all(10),
                              child: GestureDetector(
                                onTap: () async {
                                  if(userController.user != null){
                                    await utils.showCartBottom(context, itemModel, (count){
                                      itemModel.selectedQuantity = count;
                                      cartController.addToCart(itemModel);
                                      Get.snackbar("Success", "Added to bag.");
                                      cartInfo = cartController.checkInCart(itemModel);
                                      inCart = cartInfo["inCart"];
                                      cartPosition = cartInfo["position"];
                                      cartItem = cartInfo["cartItem"];
                                      setState(() {
                                      });
                                    });
                                  }else{
                                    utils.loginBottomSheet(context);
                                  }
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                                  decoration: BoxDecoration(
                                      color: checkAdminController.system.mainColor,
                                      borderRadius: BorderRadius.circular(8)
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Icon(CupertinoIcons.bag_badge_plus , color: whiteColor, size: 24,),
                                      SizedBox(width: 10,),
                                      Center(child: Text("Add to bag" , style: utils.boldLabelStyle(whiteColor),))
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          if(inCart && userController.user != null) Expanded(
                            child: Container(
                              padding: EdgeInsets.all(10),
                              child: GestureDetector(
                                onTap: (){
                                  if(userController.user != null){
                                  }
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                                  decoration: BoxDecoration(
                                      color: whiteColor,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: checkAdminController.system.mainColor, width: 2)
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      GestureDetector(
                                          onTap: (){
                                            if(cartItem!.selectedQuantity > 1) {
                                              var quantity = cartItem!
                                                  .selectedQuantity -
                                                  1;
                                              cartController
                                                  .updateQuantity(
                                                  cartPosition,
                                                  "$quantity");
                                            }else{
                                              cartController.deleteItem(cartPosition);
                                            }
                                            cartInfo =
                                                cartController
                                                    .checkInCart(
                                                    itemModel);
                                            inCart =
                                            cartInfo["inCart"];
                                            cartPosition =
                                            cartInfo["position"];
                                            cartItem =
                                            cartInfo["cartItem"];
                                            setState(() {});
                                          },
                                          child: Icon(cartItem!.selectedQuantity > 1 ? CupertinoIcons.minus:CupertinoIcons.delete , color: cartItem!.selectedQuantity > 1 ? checkAdminController.system.mainColor : redColor, size: 24,)),
                                      Expanded(
                                          child: Center(
                                            child: Text("${cartItem!.selectedQuantity}", style: utils.boldLabelStyle(checkAdminController.system.mainColor),),
                                          )
                                      ),
                                      SizedBox(width: 10,),
                                      GestureDetector(
                                          onTap : (){
                                            var quantity = cartItem!
                                                .selectedQuantity +
                                                1;
                                            cartController
                                                .updateQuantity(
                                                cartPosition,
                                                "$quantity");
                                            cartInfo =
                                                cartController
                                                    .checkInCart(
                                                    itemModel);
                                            inCart =
                                            cartInfo["inCart"];
                                            cartPosition =
                                            cartInfo["position"];
                                            cartItem =
                                            cartInfo["cartItem"];
                                            setState(() {});
                                          },
                                          child: Icon(CupertinoIcons.plus , color: checkAdminController.system.mainColor, size: 24,)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          if(userController.user != null) Container(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: GestureDetector(
                              onTap: (){
                                chatController.sendMessage("Hello, Hope you are doing well. Can I get More specs for ${itemModel.name}", itemModel, null, null, userController.user!.uid, "admin");
                                Get.toNamed(chatRoute , arguments: 0);
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                                decoration: BoxDecoration(
                                    border: Border.all(color: checkAdminController.system.mainColor,width: 2),
                                    borderRadius: BorderRadius.circular(8)
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(CupertinoIcons.conversation_bubble , color: checkAdminController.system.mainColor, size: 24,),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                );
                }),
              ),
              Container(
                width: Get.width,
                padding: EdgeInsets.only(left: 12, right: checkAdminController.isAdmin == "1" ? 4 : 12, top: checkAdminController.isAdmin == "1" ? 30 : 40, bottom: checkAdminController.isAdmin == "1" ? 6 : 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12)),
                  color: checkAdminController.system.mainColor.withOpacity(opacity),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: checkAdminController.system.mainColor.withOpacity(0),
                          borderRadius: BorderRadius.circular(8)
                      ),
                      child: GestureDetector(
                        onTap: (){
                          Get.back();
                        },
                        child: Icon(CupertinoIcons.arrow_left , color: opacity > 0.5 ? whiteColor : blackColor, size: 24,),
                      ),
                    ),
                    SizedBox(width: 12,),
                    if(opacity > 0.5) Expanded(child: Text("${itemModel.name}" , style: utils.boldLabelStyle(whiteColor),maxLines: 1, overflow: TextOverflow.ellipsis,)),
                    if(opacity > 0.5 && userController.user != null) GestureDetector(
                      onTap : (){
                        if(userController.user != null) {
                          setState(() {
                            Get.toNamed(cartRoute);
                          });
                        }else{
                          utils.loginBottomSheet(context);
                        }
                      },
                      child: Container(
                        width: 24.w,
                        height: 24.w,
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            Icon(CupertinoIcons.shopping_cart , color: whiteColor, size: 20.w,),
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
                    if(opacity > 0.5 && userController.user != null && checkAdminController.isAdmin == "1") IconButton(
                      onPressed : () async {
                        await Get.toNamed(addProductRoute , arguments: itemModel);
                        index = 0;
                        setState(() {
                        });
                      },
                      icon: Icon(CupertinoIcons.pen , color: whiteColor, size: 20.w,),
                    ),
                  ],
                )
              )
            ],
          ),
        ),
      );
  }


  void addReview(ItemModel itemModel) async {
    EasyLoading.show(status: "Loading...");
    FirebaseDatabase database = FirebaseDatabase(databaseURL: databaseUrl);
    
    if(!GetPlatform.isWeb) {
      database.setPersistenceEnabled(true);
      database.setPersistenceCacheSizeBytes(10000000);
    }
    DatabaseReference reference = database.reference();
    reference = reference
        .child(reviewRef)
        .child(itemModel.code)
        .push();
    ReviewModel reviewModel = ReviewModel(name: userController.user!.name, uid: userController.user!.uid, image: userController.user!.image != null ? userController.user!.image! : "https://img.freepik.com/free-vector/golden-star-3d_1053-79.jpg?size=338&ext=jpg", key: reference.key, createdAt: DateTime.now().millisecondsSinceEpoch, rating: rate, comment: commentController.text.toString());
    await reference.set(reviewModel.toJson());
    updateItemRating(itemModel);
    EasyLoading.dismiss();
  }

  void updateItemRating(ItemModel itemModel) async {
    FirebaseDatabase database = FirebaseDatabase(databaseURL: databaseUrl);
    
    if(!GetPlatform.isWeb) {
      database.setPersistenceEnabled(true);
      database.setPersistenceCacheSizeBytes(10000000);
    }
    DatabaseReference reference = database.reference();
    var rating = (itemModel.rating != 0 ? itemModel.rating : rate + rate)/2;
    await reference
        .child(itemRef)
        .child(itemModel.code)
        .update({
      "rating" : rating
    });
  }

}

showReviewBottom(BuildContext context , ItemModel itemModel) {
  showCupertinoModalBottomSheet(
    context: context,
    backgroundColor: whiteColor,
    topRadius: Radius.circular(30),
    builder: (context) => Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: whiteColor,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(child: Container()),
              Expanded(
                  child: Container(
                    height: 3,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: blackColor.withOpacity(0.8),
                    ),
                  )),
              Expanded(child: Container()),
            ],
          ),
          Expanded(child: ReviewScreen(itemModel))
        ],
      ),
    ),
  );
}
class CustomClipPath extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height - 80);
    path.lineTo(size.width, 0);

    return path;
  }
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}