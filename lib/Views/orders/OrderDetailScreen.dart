import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectsaleorder/AppConstants/Constants.dart';
import 'package:connectsaleorder/GetXController/CartController.dart';
import 'package:connectsaleorder/GetXController/CheckAdminController.dart';
import 'package:connectsaleorder/GetXController/OrderController.dart';
import 'package:connectsaleorder/Models/CartModel.dart';
import 'package:connectsaleorder/Models/ItemModel.dart';
import 'package:connectsaleorder/Utils/AppUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class OrderDetailScreen extends StatefulWidget{
  CartModel cartModel;
  var fromBottom = true;
  var fromCustomer = true;
  OrderDetailScreen(this.cartModel, {this.fromBottom = true, this.fromCustomer = true});
  @override
  _OrderDetailScreen createState() => _OrderDetailScreen();

}

class _OrderDetailScreen extends State<OrderDetailScreen>{
  var utils = AppUtils();
  List<bool> isSelected = [false,false,false,false,false,false,false,false,false,false];
  bool isSelectedAll = false;
  CartController cartController = Get.find();
  CheckAdminController checkAdminController = Get.find();
  OrderController orderController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0),
        child: AppBar(
          elevation: 0,
          backgroundColor: checkAdminController.system.mainColor,
        ),
      ),
      body: SafeArea(
        child: Container(
          width: Get.width,
          height: Get.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if(!widget.fromBottom) Container(
                width: Get.width,
                color: checkAdminController.system.mainColor,
                padding: EdgeInsets.only(right: 12, top: 6, bottom: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(onPressed: ()=> Navigator.pop(context), icon: Icon(CupertinoIcons.arrow_left , color: whiteColor, size: 24,)),
                    SizedBox(width: 12,),
                    Expanded(child: Text("Order" , style: utils.headingStyle(whiteColor),)),
                  ],
                ),
              ),
              Expanded(child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10,),
                      Text("Shipping Detail" , style: utils.boldLabelStyle(blackColor),),
                      SizedBox(height: 6,),
                      tableItem("Order For" , widget.cartModel.orderType == 0 ? "Dine-In" : "Home-Delivery"),
                      tableItem("Name" , widget.cartModel.customer!.name),
                      tableItem("Retailer" , widget.cartModel.isRetailer??false ? "Yes" : "No"),
                      tableItem("Phone" , widget.cartModel.customer!.phone),
                      tableItem("Address" , (widget.cartModel.customer!.address??"N/A")),
                      tableItem("Payment Method" , "COD"),
                      tableItem("Order Status" , "${utils.getOrderStatus(widget.cartModel.status)}"),
                      SizedBox(height: 10,),
                      Text("Order Detail" , style: utils.boldLabelStyle(blackColor),),
                      SizedBox(height: 2,),
                      Wrap(
                        children: [
                          for(var i = 0; i < widget.cartModel.products.length; i++)
                            Container(
                              width: Get.width,
                              padding: EdgeInsets.all(12),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 60,
                                    height: 60,
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        color: blackColor.withOpacity(0.5)
                                    ),
                                    child: CachedNetworkImage(
                                      imageUrl: widget.cartModel.products[i].images.length > 0 ? widget.cartModel.products[i].images[0] :"" ,
                                      placeholder: (context, url) => SpinKitRotatingCircle(color: checkAdminController.system.mainColor,),
                                      errorWidget: (context, url, error) => Icon(
                                        Icons.image_not_supported_rounded,
                                        size: 25,
                                      ), fit: BoxFit.cover,),
                                  ),
                                  SizedBox(width: 10,),
                                  Expanded(child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("${widget.cartModel.products[i].name}" , style: utils.boldLabelStyle(blackColor),),
                                      RichText(text: TextSpan(
                                          children: [
                                            TextSpan(
                                                text: (widget.cartModel.products[i].disCont??false) && (widget.cartModel.products[i].discountVal??0).toInt() > 0 ? "${(widget.cartModel.products[i].discountVal??0).toInt()}${widget.cartModel.products[i].discountType == "%" ? "%" : ""} OFF " :"",
                                                style: utils.smallLabelStyle(blackColor)
                                            ),
                                            TextSpan(
                                                text: widget.cartModel.products[i].salesRate != widget.cartModel.products[i].discountedPrice ? "${utils.getFormattedPrice(widget.cartModel.products[i].salesRate)}" : "",
                                                style: utils.xSmallLabelStyleSlash(blackColor)
                                            ),
                                            TextSpan(
                                                text: " ${utils.getFormattedPrice(widget.cartModel.products[i].discountedPrice)}",
                                                style: utils.smallLabelStyle(blackColor)
                                            ),
                                          ]
                                      )),
                                      Text("Quantity : ${widget.cartModel.products[i].selectedQuantity}" , style: utils.smallLabelStyle(blackColor),),
                                      if(widget.cartModel.products[i].selectedAddons.length > 0) RichText(text: TextSpan(
                                          children: [
                                            for(var l = 0 ; l < widget.cartModel.products[i].selectedAddons.length; l++)
                                              TextSpan(
                                                  text: "${widget.cartModel.products[i].selectedAddons[l].adonDescription}x${widget.cartModel.products[i].selectedAddons[l].quantity}${l < widget.cartModel.products[i].selectedAddons.length - 1 ? ",":""} ",
                                                  style: utils.xSmallLabelStyle(blackColor)
                                              )
                                          ]
                                      ))
                                    ],
                                  )),
                                ],
                              ),
                            ),
                        ],
                      ),
                      Text("Payment Detail" , style: utils.boldLabelStyle(blackColor),),
                      SizedBox(height: 10,),
                      tableItemBold("Sub Total" , "${utils.getFormattedPrice(widget.cartModel.totalBill - ((widget.cartModel.totalBill * 5)/100))}"),
                      tableItemBold("Delivery" , "${utils.getFormattedPrice(widget.cartModel.deliveryPrice)}"),
                      tableItemBold("Saving" , "${utils.getFormattedPrice(widget.cartModel.totalBill - (widget.cartModel.discountedBill))}"),
                      tableItemBold("Tax" , "${utils.getFormattedPrice((widget.cartModel.totalBill * 5)/100)}" ),
                      if(widget.cartModel.couponValue > 0) tableItemBold("Coupon Saved" , "${utils.getFormattedPrice(widget.cartModel.couponValue)}"),
                      tableItemBold("Total" , "${utils.getFormattedPrice(widget.cartModel.discountedBill+widget.cartModel.deliveryPrice-widget.cartModel.couponValue)}"),
                      SizedBox(height: 20,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          if(widget.fromCustomer) Expanded(child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.transparent,
                                border: Border.all(color: checkAdminController.system.mainColor, width: 2)
                            ),
                            child: Center(
                              child: TextButton(
                                onPressed: (){
                                  cartController.retriveOrder(
                                      widget.cartModel);
                                  Get.snackbar("Success", "");
                                },
                                child: Text("Re-Order", style: utils.boldLabelStyle(checkAdminController.system.mainColor),),
                              ),
                            ),
                          )),
                          if(!widget.fromCustomer) Expanded(child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.transparent,
                                border: Border.all(color: checkAdminController.system.mainColor, width: 2)
                            ),
                            child: Center(
                              child: TextButton(
                                onPressed: (){
                                  showFilterBottom(context, orderController, 1 , widget.cartModel);
                                },
                                child: Text("Change Status", style: utils.boldLabelStyle(checkAdminController.system.mainColor),),
                              ),
                            ),
                          )),

                          Expanded(child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: checkAdminController.system.mainColor,
                                border: Border.all(color: checkAdminController.system.mainColor, width: 2)
                            ),
                            child: Center(
                              child: TextButton(
                                onPressed: (){
                                  if(widget.cartModel.status != -1) {
                                    orderController.listenOrdersTrack(
                                        widget.cartModel);
                                    Get.toNamed(trackOrderRoute);
                                  }else{
                                    Get.snackbar("Opps!", "Your order is cancelled and can not track.");
                                  }
                                },
                                child: Text("Track", style: utils.boldLabelStyle(whiteColor),),
                              ),
                            ),
                          )),
                        ],
                      )
                    ],
                  ),
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }

  tableItem(String title, String name) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("$title" , style: utils.xSmallLabelStyle(blackColor.withOpacity(0.8)),),
              SizedBox(width: Get.width * 0.3,),
              Expanded(
                  child: Container(
                    alignment: Alignment.centerRight,
                      child: Text("$name" , style: utils.xSmallLabelStyle(blackColor.withOpacity(0.8)),))),
            ],
          ),
          SizedBox(height: 6,),
          Container(
            width: Get.width,
            height: 0.5,
            color: blackColor.withOpacity(0.3),
          )
        ],
      ),
    );
  }

  tableItemBold(String title, String name) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("$title" , style: utils.boldSmallLabelStyle(blackColor.withOpacity(0.9)),),
              SizedBox(width: Get.width * 0.3,),
              Expanded(
                  child: Container(
                    alignment: Alignment.centerRight,
                      child: Text("$name" , style: utils.boldSmallLabelStyle(blackColor),))),
            ],
          ),
          SizedBox(height: 6,),
          Container(
            width: Get.width,
            height: 0.5,
            color: blackColor.withOpacity(0.3),
          ),
        ],
      ),
    );
  }

  showFilterBottom(BuildContext context, OrderController orderController, type , CartModel? cartModel) {
    var status = ["Placed" , "Preparing" , "Shipping", "Shipped","Canceled"];
    var icons = [CupertinoIcons.cart , CupertinoIcons.hand_raised_fill , CupertinoIcons.bus, CupertinoIcons.check_mark_circled_solid,CupertinoIcons.xmark];
    if(type == 0){
      status.add("All");
      icons.add(CupertinoIcons.circle);
    }
    showCupertinoModalBottomSheet(
      context: context,
      backgroundColor: whiteColor,
      topRadius: Radius.circular(30),
      builder: (context) => Container(
        height: Get.height * 0.42,
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
            Expanded(
                child: ListView(
                  scrollDirection: Axis.vertical,
                  children: [
                    for(var i = 0 ; i < icons.length; i++)
                      GestureDetector(
                        onTap: (){
                          if(type == 0) {
                            orderController.setFilter(i);
                            Navigator.pop(context);
                          }else{
                            orderController.changeStatus(i == 4 ? -1 : i , cartModel!);
                            Navigator.pop(context);
                          }
                        },
                        child: Container(
                          width: Get.width,
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(vertical: 8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(icons[i] , size: 24, color: blackColor.withOpacity(0.9),),
                                    SizedBox(width: 10,),
                                    Expanded(child: Text(status[i],style: utils.labelStyle(blackColor.withOpacity(0.9)),)),
                                    if(i == orderController.selectedFilter) Icon(CupertinoIcons.checkmark_alt, size: 24, color: blackColor.withOpacity(0.6),),
                                  ],
                                ),
                              ),
                              Container(
                                width: Get.width,
                                height: 1,
                                color: grayColor,
                              )
                            ],
                          ),
                        ),
                      )
                  ],
                )
            )
          ],
        ),
      ),
    );
  }
}