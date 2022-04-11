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

class ItemWidget extends StatefulWidget {
  ItemModel itemModel;

  ItemWidget(this.itemModel);

  @override
  _ItemWidget createState() => _ItemWidget(itemModel);
}

class _ItemWidget extends State<ItemWidget> {
  ItemModel item;

  _ItemWidget(this.item);

  var utils = AppUtils();
  CartController cartController = Get.find();
  UserController userController = Get.find();
  FavoriteController favoriteController = Get.find();
  Map<String,dynamic> cartInfo = {};
  var inCart = false;
  var cartPosition = 0;
  ItemModel? cartItem;
  var isRetailer = false;
  CheckAdminController checkAdminController = Get.find();
  @override
  void didUpdateWidget(covariant ItemWidget oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    item = widget.itemModel;
    isRetailer = userController.user != null ? userController.user!.isRetailer? userController.user!.retailerModel!.approved ? true : false :false : false;
    if(mounted) {
      setData();
    }
  }

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
    return GestureDetector(
      onTap: () async {
        await Get.toNamed(productDetailRoute , arguments: item);
        setState(() {
        });
      },
      child: Container(
        width: 220.w,
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: whiteColor,
            boxShadow: [
              BoxShadow(
                  blurRadius: 2,
                  spreadRadius: 2,
                  offset: Offset(0, 2),
                  color: grayColor)
            ]),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: Get.width,
              height: 80.h,
              child: Stack(
                children: [
                  Container(
                    width: Get.width,
                    height: 80.h,
                    child: CachedNetworkImage(
                      imageUrl: item.images.length > 0 ? item.images[0] : "" ,
                      placeholder: (context, url) => SpinKitRotatingCircle(color: checkAdminController.system.mainColor,),
                      errorWidget: (context, url, error) => Icon(
                        Icons.image_not_supported_rounded,
                        size: 25.w,
                      ), fit: BoxFit.contain,),
                  ),
                  if (item.disCont != null && item.disCont! && item.discountVal != null && item.discountVal != 0)
                    Positioned(
                        child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: redColor.withOpacity(0.7)),
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
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
            SizedBox(
              height: 5.h,
            ),
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                "${item.name}\n",
                style: utils.xSmallLabelStyle(blackColor),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(
              height: 5.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  child: RatingBar(
                    initialRating: item.rating,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemSize: 14,
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
                Expanded(
                  child: Container(
                    alignment: Alignment.centerRight,
                    margin: EdgeInsets.symmetric(horizontal: 4.w),
                    child: Text(
                      "${utils.getFormattedPrice(isRetailer ? item.discountedPriceW : item.discountedPrice)}",
                      style: utils.xSmallLabelStyle(blackColor),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 4.h,
            ),
            Container(
              color: checkAdminController.system.mainColor,
              child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if(inCart) Expanded(
                child: GestureDetector(
                  onTap: () {

                  },
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
                          child: Icon(cartItem!.selectedQuantity > 1 ? CupertinoIcons.minus:CupertinoIcons.delete , color: whiteColor, size: 24.w,)),
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
                          child: Icon(CupertinoIcons.plus , color: whiteColor, size: 24.w,)),
                    ],
                  ),
                  ),
                ),
              ),
              if(!inCart) Expanded(
                child: GestureDetector(
                  onTap: () async {
                    if(item.code != "0") {
                      if(userController.user != null){
                        await utils.showCartBottom(context, item, (count, List<ProductAdons> adons, PSizes? productSized, PColors? productColors){
                          item.selectedSizes = productSized;
                          item.selectedColors = productColors;
                          item.selectedAddons = adons;
                          item.selectedQuantity = count;
                          cartController.addToCart(item);
                          Get.snackbar("Success", "Added to bag.");
                          cartInfo = cartController.checkInCart(item);
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
                        EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
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
            )
          ],
        ),
      ),
    );
  }

  setData() {
    setState(() {});
  }
}
