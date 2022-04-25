import 'package:connectsaleorder/AppConstants/Constants.dart';
import 'package:connectsaleorder/GetXController/CartController.dart';
import 'package:connectsaleorder/GetXController/CheckAdminController.dart';
import 'package:connectsaleorder/GetXController/UserController.dart';
import 'package:connectsaleorder/Models/ItemModel.dart';
import 'package:connectsaleorder/Utils/AppUtils.dart';
import 'package:connectsaleorder/Views/orders/OrdersFragment.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../GetXController/ItemController.dart';
import '../../Utils/ItemWidget.dart';
import '../../Utils/ItemWidgetStyle2.dart';
import '../../Utils/ItemWidgetStyle3.dart';
import '../../Utils/ItemWidgetStyle4.dart';

class CartScreen extends StatefulWidget{
  @override
  _CartScreen createState() => _CartScreen();
}

class _CartScreen extends State<CartScreen>{
  var utils = AppUtils();
  List<ItemModel> products = [];
  CheckAdminController checkAdminController = Get.find();
  UserController userController = Get.find();
  CartController cartController = Get.find();
  var isRetailer = false;

  @override
  void initState() {
    // TODO: implement initState
    isRetailer = userController.user != null ? userController.user!.isRetailer? userController.user!.retailerModel!.approved ? true : false :false : false;
    if(userController.user != null) {
      cartController.updateBill();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CartController>(id: "0",builder: (_cController){
      return Scaffold(
        resizeToAvoidBottomInset: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: checkAdminController.system.mainColor,
        title: Text("CART" , style: utils.headingStyle(whiteColor),),
        leading: IconButton(icon: Icon(CupertinoIcons.arrow_left, color: whiteColor,) , onPressed: ()=> Get.back(),),
        centerTitle: true,
        actions: [
          if(_cController.myCart.products.length > 0) GestureDetector(
            onTap: (){
              _cController.emptyCart();
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Clear Cart" , style: utils.boldSmallLabelStyle(whiteColor),),
                SizedBox(width: 12,),
              ],
            )
          ),
        ],
      ),
      body: SafeArea(
        child: DefaultTabController(
          length: 2,
          child: Container(
            width: Get.width,
            height: Get.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(bottomRight: Radius.circular(12),bottomLeft: Radius.circular(12)),
                        color: checkAdminController.system.mainColor
                    ),
                    child: TabBar(
                      indicatorColor: whiteColor,
                      labelStyle: utils.boldLabelStyle(whiteColor),
                      tabs: [
                        Tab(
                          text: "Cart",
                        ),
                        Tab(
                          text: "Orders",
                        )
                      ],
                    )
                ),
                Expanded(
                  child: TabBarView(children: [
                    GetBuilder<CartController>(id: "0",builder: (cartController){
                      products = cartController.myCart.products;
                      return products.length > 0 ?
                      Container(
                        width: Get.width,
                        height: Get.height,
                        color: grayColor.withOpacity(0.1),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(height: 10,),
                            Expanded(child: ListView(
                              scrollDirection: Axis.vertical,
                              children: [
                                for(var i = 0; i < products.length; i++)
                                  SwipeActionCell(
                                      key: ObjectKey(products[i].code),///this key is necessary
                                      trailingActions: <SwipeAction>[
                                        SwipeAction(
                                            backgroundRadius: 12,
                                            widthSpace: 80,
                                            title: "Delete",
                                            onTap: (CompletionHandler handler) async {
                                              cartController.deleteItem(i);
                                            },
                                            color: Colors.red),
                                      ],
                                      child: Container(
                                        width: Get.width,
                                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                        margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(8),
                                            color: whiteColor,
                                            boxShadow: [
                                              BoxShadow(
                                                  blurRadius: 2,
                                                  spreadRadius: 2,
                                                  offset: Offset(0,2),
                                                  color: grayColor.withOpacity(0.3)
                                              )
                                            ]
                                        ),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Row(
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
                                                  child: Image.network(products[i].images.length > 0 ? products[i].images[0] :"https://5.imimg.com/data5/SELLER/Default/2020/9/XP/HK/UQ/113167197/grocery-items-500x500.jpg" , fit: BoxFit.cover,),
                                                ),
                                                SizedBox(width: 10,),
                                                Expanded(child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    if(products[i].sSize != null || products[i].color != null) Row(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      children: [
                                                        Expanded(child: Text((products[i].color != null ? "Color: ${products[i].color}, " : "")+ (products[i].sSize != null ? "Size: ${products[i].sSize}" : "") , style: utils.xSmallLabelStyle(checkAdminController.system.mainColor.withOpacity(0.7)),)),
                                                      ],
                                                    ),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      children: [
                                                        Expanded(child: Text("${products[i].name}", style: utils.boldSmallLabelStyle(blackColor.withOpacity(0.7)),)),
                                                      ],
                                                    ),
                                                    SizedBox(height: 5,),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        if(products[i].discountVal != null && products[i].discountVal! > 0) Text("${utils.getFormattedPrice(isRetailer ? products[i].wholeSale : products[i].salesRate)}" , style: utils.smallLabelStyleSlash(blackColor.withOpacity(0.5)),),
                                                        SizedBox(width: 5,),
                                                        Expanded(child: Text("${utils.getFormattedPrice(isRetailer ? products[i].discountedPriceW : products[i].discountedPrice)}" , style: utils.smallLabelStyle(blackColor.withOpacity(0.9)),)),
                                                      ],
                                                    ),
                                                    SizedBox(height: 5,),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        Text("Qty" , style: utils.smallLabelStyle(blackColor.withOpacity(0.7)),),
                                                        SizedBox(width: 12,),
                                                        if(products[i].totalStock > 0) Row(
                                                          mainAxisAlignment: MainAxisAlignment.end,
                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                          children: [
                                                            IconButton(
                                                                onPressed: (){
                                                                  if(products[i].selectedQuantity > 1){
                                                                    cartController.updateQuantity(i , (products[i].selectedQuantity-1).toString());
                                                                  }
                                                                }, icon: Icon(CupertinoIcons.minus_circled , size: 20, color: products[i].selectedQuantity > 1 ? blackColor : blackColor.withOpacity(0.5),)
                                                            ),
                                                            Text("${products[i].selectedQuantity}", style: utils.smallLabelStyle(blackColor),),
                                                            IconButton(
                                                                onPressed: (){
                                                                  if(products[i].selectedQuantity < products[i].totalStock){
                                                                    cartController.updateQuantity(i , (products[i].selectedQuantity+1).toString());
                                                                    setState(() {
                                                                    });
                                                                  }
                                                                }, icon: Icon(CupertinoIcons.add_circled , size: 20, color: products[i].selectedQuantity < products[i].totalStock ? blackColor : blackColor.withOpacity(0.5),)
                                                            )
                                                          ],
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                )),
                                              ],
                                            ),
                                            if(products[i].selectedAddons.length > 0) Container(
                                                width: Get.width,
                                                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(0),
                                                    color: whiteColor
                                                ),
                                                child: Wrap(
                                                  children: [
                                                    Container(
                                                      width: Get.width,
                                                      child: Text("Addons" , style: utils.labelStyle(blackColor),),
                                                    ),
                                                    for(var j = 0 ; j  < products[i].selectedAddons.length; j++)
                                                      Container(
                                                        width: Get.width,
                                                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                                        child: Column(
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                              children: [
                                                                Expanded(child: Text("${products[i].selectedAddons[j].adonDescription}",style: utils.boldSmallLabelStyle(blackColor))),
                                                                SizedBox(width: 12,),
                                                                Text(utils.getFormattedPrice(products[i].selectedAddons[j].adonPrice), style: utils.smallLabelStyle(blackColor),),
                                                                SizedBox(width: 12,),
                                                                Row(
                                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                  children: [
                                                                    IconButton(
                                                                        onPressed: (){
                                                                          cartController.updateAddons(i ,j, products[i].selectedAddons[j].quantity-1);
                                                                        }, icon: Icon(products[i].selectedAddons[j].quantity == 1 ? CupertinoIcons.delete:CupertinoIcons.minus_circled , size: 20, color: products[i].selectedAddons[j].quantity > 1 ? blackColor : blackColor.withOpacity(0.5),)
                                                                    ),
                                                                    Text("${products[i].selectedAddons[j].quantity}", style: utils.smallLabelStyle(blackColor),),
                                                                    IconButton(
                                                                        onPressed: (){
                                                                          cartController.updateAddons(i ,j, products[i].selectedAddons[j].quantity+1);
                                                                        }, icon: Icon(CupertinoIcons.add_circled , size: 20, color: blackColor,)
                                                                    )
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                            Container(
                                                              width: Get.width,
                                                              height: 1,
                                                              color: grayColor,
                                                            )
                                                          ],
                                                        ),
                                                      )
                                                  ],
                                                )
                                            ),

                                          ],
                                        ),
                                      )
                                  ),
                                SizedBox(height: 12.h,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(width: 12,),
                                    Text("Recommendation", style: utils.boldLabelStyle(blackColor),)
                                  ],
                                ),
                                SizedBox(height: 8.h,),
                                Container(
                                  width: Get.width,
                                  child: GetBuilder<ItemController>(id: "0" , builder: (itemController){
                                    return SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          for(var item in itemController.itemModelsTopDeals)
                                            Container(
                                              child: checkAdminController.system.itemGridStyle.code == "001" ? ItemWidget(item) : checkAdminController.system.itemGridStyle.code == "002" ? ItemWidgetStyle2(item) : checkAdminController.system.itemGridStyle.code == "003" ? ItemWidgetStyle3(item): checkAdminController.system.itemGridStyle.code == "004" ? ItemWidgetStyle4(item) : ItemWidget(item),
                                            )
                                        ],
                                      ),
                                    );
                                  },),
                                ),
                              ],
                            )),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 20),
                              color: whiteColor,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("Total", style: utils.boldLabelStyle(blackColor.withOpacity(0.5)),),
                                      Text("${utils.getFormattedPrice(cartController.myCart.discountedBill.round())}", style: utils.boldLabelStyle(blackColor),),
                                    ],
                                  )),
                                  utils.button(checkAdminController.system.mainColor, "Proceed to checkout", whiteColor, checkAdminController.system.mainColor, 1.0, (){
                                    if(checkAdminController.system.dineIn) {
                                      Get.toNamed(orderTypeRoute);
                                    }else{
                                      Get.toNamed(checkoutRoute, arguments: 1);
                                    }
                                  })
                                ],
                              ),
                            )
                          ],
                        ),
                      ) : Container(
                        width: Get.width,
                        height: Get.height,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Lottie.asset('Assets/lottie/searchempty.json'),
                            Text("Opps! No Cart available.\nAdd Items to your cart now" , style: utils.labelStyle(blackColor.withOpacity(0.7)),textAlign: TextAlign.center,),
                            SizedBox(height: 10,),
                            GestureDetector(
                              onTap: (){
                                Get.back();
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: checkAdminController.system.mainColor
                                ),
                                child: Text("Continue Shopping" , style: utils.boldLabelStyle(whiteColor),),
                              ),
                            )
                          ],
                        ),
                      );
                    },),
                    OrderFragment(true)
                  ]),
                )
              ],
            ),
          ),
        ),
      ),
    );
    });
  }

  void _presentBottomSheet(ItemModel itemModel, CartController cartController, position) {
    var quantityController = TextEditingController();
    quantityController.text = itemModel.selectedQuantity.toString();
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0), topRight: Radius.circular(20)),
      ),
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (BuildContext context1, StateSetter setState) {
          return Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20)),
                color: whiteColor),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    alignment: Alignment.center,
                    width: Get.width,
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Container(
                        width: 50,
                        height: 5,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: blackColor.withOpacity(0.3)
                        )
                    )
                ),
                SizedBox(height: 16,),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12 , vertical: 8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("Quantity" , style: utils.labelStyle(blackColor.withOpacity(0.8)),),
                          SizedBox(width: 12,),
                          utils.textField(whiteColor, null, null, null, null, blackColor, "", blackColor, blackColor.withOpacity(0.7), 1.0, 200.0, false, quantityController , onTextChange: (val){

                          })
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap : (){
                          cartController.deleteItem(position);
                          Navigator.pop(context);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          margin: EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                              color: grayColor,
                              borderRadius: BorderRadius.circular(8)
                          ),
                          child: Center(child: Text("Remove" , style: utils.labelStyle(blackColor.withOpacity(0.5)),)),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap : (){
                          if(quantityController.text.length > 0)
                            cartController.updateQuantity(position , quantityController.text);
                          Navigator.pop(context);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          margin: EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                              color: checkAdminController.system.mainColor,
                              borderRadius: BorderRadius.circular(8)
                          ),
                          child: Center(child: Text("Save" , style: utils.labelStyle(whiteColor),)),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

}