import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectsaleorder/AppConstants/Constants.dart';
import 'package:connectsaleorder/GetXController/CartController.dart';
import 'package:connectsaleorder/GetXController/CheckAdminController.dart';
import 'package:connectsaleorder/Models/CartModel.dart';
import 'package:connectsaleorder/Models/ItemModel.dart';
import 'package:connectsaleorder/Utils/AppUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

class OrderDetailScreen extends StatefulWidget{
  CartModel cartModel;
  OrderDetailScreen(this.cartModel);
  @override
  _OrderDetailScreen createState() => _OrderDetailScreen();

}

class _OrderDetailScreen extends State<OrderDetailScreen>{
  var utils = AppUtils();
  List<bool> isSelected = [false,false,false,false,false,false,false,false,false,false];
  bool isSelectedAll = false;
  CartController cartController = Get.find();
  CheckAdminController checkAdminController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      height: Get.height,
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10,),
            Text("Shipping Detail" , style: utils.boldLabelStyle(blackColor),),
            SizedBox(height: 6,),
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
                                  text: widget.cartModel.products[i].disCont??false? "${(widget.cartModel.products[i].discountVal??0).toInt()}${widget.cartModel.products[i].discountType == "%" ? "%" : ""} OFF " :"",
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
            tableItemBold("Total" , "${utils.getFormattedPrice(widget.cartModel.discountedBill+widget.cartModel.deliveryPrice)}"),
          ],
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
          )
        ],
      ),
    );
  }
}