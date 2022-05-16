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

class ItemWidgetStyle5 extends StatefulWidget {
  ItemModel itemModel;
  double? width;

  ItemWidgetStyle5(this.itemModel, this.width);

  @override
  _ItemWidgetStyle5 createState() => _ItemWidgetStyle5(itemModel);
}

class _ItemWidgetStyle5 extends State<ItemWidgetStyle5> {
  ItemModel item;

  _ItemWidgetStyle5(this.item);

  var utils = AppUtils();
  CartController cartController = Get.find();
  UserController userController = Get.find();
  FavoriteController favoriteController = Get.find();
  Map<String, dynamic> cartInfo = {};
  var inCart = false;
  var cartPosition = 0;
  ItemModel? cartItem;
  CheckAdminController checkAdminController = Get.find();
  var isRetailer = false;

  @override
  void didUpdateWidget(covariant ItemWidgetStyle5 oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    item = widget.itemModel;
    isRetailer = userController.user != null
        ? userController.user!.isRetailer
            ? userController.user!.retailerModel!.approved
                ? true
                : false
            : false
        : false;
    if (mounted) {
      setData();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isRetailer = userController.user != null
        ? userController.user!.isRetailer
            ? userController.user!.retailerModel!.approved
                ? true
                : false
            : false
        : false;
    if (mounted) {
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
    return GestureDetector(
      onTap: () async {
        await Get.to(()=> ProductDetailScreen(), routeName: "${item.code}", arguments: item);
        setState(() {});
      },
      child: Container(
        width: widget.width,
        margin: EdgeInsets.symmetric(horizontal: 4, vertical: 5),
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
            color: whiteColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                  blurRadius: 2,
                  spreadRadius: 2,
                  offset: Offset(0, 2),
                  color: grayColor)
            ]),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: Container(
                width: Get.width,
                child: Stack(
                  alignment: Alignment.topRight,
                  children: [
                    Container(
                      width: Get.width,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: whiteColor),
                      child: CachedNetworkImage(
                        imageUrl: item.images.length > 0 ? item.images[0] : "",
                        placeholder: (context, url) => SpinKitRotatingCircle(
                          color: checkAdminController.system.mainColor,
                        ),
                        errorWidget: (context, url, error) => Icon(
                          Icons.image_not_supported_rounded,
                          size: 25.w,
                        ),
                        fit: BoxFit.contain,
                      ),
                    ),
                    if (item.disCont != null &&
                        item.disCont! &&
                        item.discountVal != null &&
                        item.discountVal != 0)
                      Positioned(
                          top: 0,
                          left: 0,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 4, vertical: 2),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: redColor),
                            child: Text(
                              item.discountType == "%"
                                  ? "-${item.discountVal!.toInt()}%"
                                  : "-${utils.getFormattedPrice(item.discountVal)}",
                              style: utils.xSmallLabelStyle(whiteColor),
                            ),
                          ))
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            Text(
              "${item.name}\n",
              style: utils.xSmallLabelStyle(blackColor.withOpacity(0.7)),
              textAlign: TextAlign.center,
              maxLines: 2,
            ),
            SizedBox(
              height: 5.h,
            ),
            RichText(
              text: TextSpan(children: [
                TextSpan(
                  text: (isRetailer ? item.wholeSale : item.salesRate) !=
                          (isRetailer
                              ? item.discountedPriceW
                              : item.discountedPrice)
                      ? "${utils.getFormattedPrice(isRetailer ? item.wholeSale : item.salesRate)}"
                      : "",
                  style:
                      utils.xSmallLabelStyleSlash(blackColor.withOpacity(0.5)),
                ),
                TextSpan(
                  text: "  ",
                  style: utils.xSmallLabelStyle(blackColor),
                ),
                TextSpan(
                  text:
                      "${utils.getFormattedPrice(isRetailer ? item.discountedPriceW : item.discountedPrice)}",
                  style: utils.xSmallLabelStyle(blackColor),
                ),
              ]),
            ),
            SizedBox(
              height: 8.h,
            ),
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
                      itemSize: 12.w,
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
                InkWell(
                  onTap: () async {
                    if (item.code != "0") {
                      if (userController.user != null) {
                        await utils.showCartBottom(context, item, (count,
                            List<ProductAdons> adons,
                            ItemModel itemModel,
                            PColors? productColors) {
                          itemModel.selectedColors = productColors;
                          itemModel.selectedAddons = adons;
                          itemModel.selectedQuantity = count;
                          cartController.addToCart(itemModel);
                          Get.snackbar("Success", "Added to bag.");
                          cartInfo = cartController.checkInCart(itemModel);
                          inCart = cartInfo["inCart"];
                          cartPosition = cartInfo["position"];
                          cartItem = cartInfo["cartItem"];
                          setState(() {});
                        });
                      } else {
                        utils.loginBottomSheet(context);
                      }
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: checkAdminController.system.mainColor),
                    child: Icon(
                      CupertinoIcons.add,
                      color: whiteColor,
                      size: 18,
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 8,
            ),
            /*GestureDetector(
              child: Container(
                width: Get.width,
                padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                margin: EdgeInsets.symmetric(horizontal: 10),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                decoration: BoxDecoration(
                    color: checkAdminController.system.mainColor,
                    borderRadius: BorderRadius.circular(8)
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    */ /*if(inCart) Expanded(
                      child: GestureDetector(
                        child: Container(
                          color: checkAdminController.system.mainColor,
                          padding:
                          EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
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
                              SizedBox(width: 10.w,),
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
                    ),*/ /*
                    */ /*if(!inCart)*/ /* Expanded(
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
                          EdgeInsets.symmetric(horizontal: 12.w, vertical: 2.h),
                          child: Center(
                            child: Icon(
                              CupertinoIcons.cart_badge_plus,
                              size: 24.w,
                              color: whiteColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),*/
          ],
        ),
      ),
    );
  }

  setData() {
    setState(() {});
  }
}
