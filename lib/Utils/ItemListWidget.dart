import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectsaleorder/AppConstants/Constants.dart';
import 'package:connectsaleorder/GetXController/CartController.dart';
import 'package:connectsaleorder/GetXController/CheckAdminController.dart';
import 'package:connectsaleorder/GetXController/FavoriteController.dart';
import 'package:connectsaleorder/GetXController/UserController.dart';
import 'package:connectsaleorder/Models/ItemModel.dart';
import 'package:connectsaleorder/Utils/AppUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

import '../Views/Product/ProductDetailScreen.dart';

class ItemListWidget extends StatefulWidget {
  ItemModel itemModel;

  ItemListWidget(this.itemModel);

  @override
  _ItemListWidget createState() => _ItemListWidget(itemModel);
}

class _ItemListWidget extends State<ItemListWidget> {
  ItemModel item;

  _ItemListWidget(this.item);

  var utils = AppUtils();
  CartController cartController = Get.find();
  UserController userController = Get.find();
  FavoriteController favoriteController = Get.find();
  CheckAdminController checkAdminController = Get.find();
  Map<String,dynamic> cartInfo = {};
  var inCart = false;
  var cartPosition = 0;
  ItemModel? cartItem;

  @override
  void didUpdateWidget(covariant ItemListWidget oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    item = widget.itemModel;
    isRetailer = userController.user != null ? userController.user!.isRetailer? userController.user!.retailerModel!.approved ? true : false :false : false;
    if(mounted) {
      setData();
    }
  }
  var isRetailer = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isRetailer = userController.user != null ? userController.user!.isRetailer? userController.user!.retailerModel!.approved ? true : false :false : false;
    if(mounted) {
      setData();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (userController.user != null) {
      item.isFav = favoriteController.checkFavorite(item);
      cartInfo = cartController.checkInCart(item);
      inCart = cartInfo["inCart"];
      cartPosition = cartInfo["position"];
      cartItem = cartInfo["cartItem"];
    }
    return Container(
      width: Get.width,
      margin: EdgeInsets.symmetric(vertical: 6.h , horizontal: 10.w),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.w),
          color: whiteColor,
          boxShadow: [
            BoxShadow(
                blurRadius: 2,
                spreadRadius: 2,
                offset: Offset(0,2),
                color: grayColor.withOpacity(0.7)
            )
          ]
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () async {
              await Get.to(()=> ProductDetailScreen(), routeName: "${item.code}", arguments: item);
              setState(() {
              });
            },
            child: Container(
              padding: EdgeInsets.all(12.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 80.w,
                    height: 80.w,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12)
                    ),
                    child: Stack(
                      children: [
                        Container(
                          width: 80.w,
                          height: 80.w,
                          child: CachedNetworkImage(
                            imageUrl: item.images.length > 0 ? item.images[0] : "" ,
                            placeholder: (context, url) => SpinKitRotatingCircle(color: checkAdminController.system.mainColor,),
                            errorWidget: (context, url, error) => Icon(
                              Icons.image_not_supported_rounded,
                              size: 25.w,
                            ), fit: BoxFit.contain,),
                        ),
                        if(item.disCont != null && item.disCont! && item.discountVal != null && item.discountVal != 0) Positioned(
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  color: redColor.withOpacity(0.7)
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                              child: Text(item.discountType == "%" ? "${item.discountVal!.toInt()}% OFF" : "Flat ${item.discountVal!.toInt()} OFF" , style: utils.xSmallLabelStyle(whiteColor),),
                            )
                        )
                      ],
                    ),
                  ),
                  SizedBox(width: 10.w,),
                  Expanded(child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("${item.name}" , style: utils.boldSmallLabelStyle(blackColor.withOpacity(0.7)),),
                      SizedBox(height: 5.h,),
                      if((isRetailer ? item.wholeSale : item.salesRate) != (isRetailer ? item.discountedPriceW : item.discountedPrice)) Text("${utils.getFormattedPrice(isRetailer ? item.wholeSale : item.salesRate)}" , style: utils.xSmallLabelStyleSlash(blackColor.withOpacity(0.5)),),
                      SizedBox(height: 5.h,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("${utils.getFormattedPrice(isRetailer ? item.discountedPriceW : item.discountedPrice)}" , style: utils.xSmallLabelStyle(blackColor.withOpacity(0.5)),),
                          Text("Size: ${item.mUnit}" , style: utils.xSmallLabelStyle(blackColor.withOpacity(0.9)),),
                        ],
                      ),
                      SizedBox(height: 5.h,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                              child: Container(
                                child: RatingBar(
                                  initialRating: item.rating,
                                  direction: Axis.horizontal,
                                  allowHalfRating: true,
                                  itemCount: 5,
                                  itemSize: 14.w,
                                  ratingWidget: RatingWidget(
                                    full: Icon(
                                      CupertinoIcons.star_fill,
                                      color: Colors.amber,
                                    ),
                                    half: Icon(
                                      CupertinoIcons.star_lefthalf_fill,
                                      color: Colors.amber,
                                    ),
                                    empty: Icon(
                                      CupertinoIcons.star,
                                      color: Colors.amber,
                                    ),
                                  ),
                                  itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                                  onRatingUpdate: (rating) {
                                    print(rating);
                                  },
                                  ignoreGestures: true,
                                ),
                              ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 6.w , vertical: 4.h),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: item.totalStock == 0? redColor.withOpacity(0.2) :checkAdminController.system.mainColor.withOpacity(0.2)
                            ),
                            child: Text("Stock: ${item.totalStock}" , style: utils.xSmallLabelStyle(item.totalStock == 0 ? redColor : checkAdminController.system.mainColor),),
                          )
                        ],
                      )
                    ],
                  )),
                ],
              ),
            ),
          ),
          Container(
            width: Get.width,
            decoration: BoxDecoration(
                color: checkAdminController.system.mainColor
            ),
            child: IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  /*if(inCart) Expanded(
                    child: GestureDetector(
                      child: Container(
                        color: checkAdminController.system.mainColor,
                        padding:
                        EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
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
                                  setState(() {});
                                },
                                child: Icon(cartItem!.selectedQuantity > 1 ? CupertinoIcons.minus:CupertinoIcons.delete , color: whiteColor, size: 20.w,)),
                            Expanded(
                                child: Center(
                                  child: Text("${cartItem!.selectedQuantity}", style: utils.boldLabelStyle(whiteColor),),
                                )
                            ),
                            SizedBox(width: 10.w,),
                            GestureDetector(
                                onTap : (){
                                  var quantity = cartItem!
                                      .selectedQuantity +
                                      1;
                                  cartController
                                      .updateQuantity(
                                      cartPosition,
                                      "$quantity");
                                  setState(() {});
                                },
                                child: Icon(CupertinoIcons.plus , color: whiteColor, size: 20.w,)),
                          ],
                        ),
                      ),
                    ),
                  ),*/
                  /*if(!inCart)*/ Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        if(item.code != "0") {
                          if(userController.user != null){
                            await utils.showCartBottom(context, item, (count, List<ProductAdons> adons, ItemModel itemModel, PColors? productColors){
                              itemModel.selectedColors = productColors;
                              itemModel.selectedAddons = adons;
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
                        }
                      },
                      child: Container(
                        color: checkAdminController.system.mainColor,
                        padding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        child: Center(
                          child: Icon(
                            CupertinoIcons.cart_badge_plus,
                            size: 20.w,
                            color: whiteColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  setData() {
    setState(() {});
  }
}
