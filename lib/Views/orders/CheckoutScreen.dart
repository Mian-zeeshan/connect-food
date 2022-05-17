import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectsaleorder/AppConstants/Constants.dart';
import 'package:connectsaleorder/GetXController/CartController.dart';
import 'package:connectsaleorder/GetXController/CheckAdminController.dart';
import 'package:connectsaleorder/GetXController/UserController.dart';
import 'package:connectsaleorder/Models/AddressModel.dart';
import 'package:connectsaleorder/Models/CartModel.dart';
import 'package:connectsaleorder/Models/CustomerModel.dart';
import 'package:connectsaleorder/Models/ItemModel.dart';
import 'package:connectsaleorder/Utils/AppUtils.dart';
import 'package:connectsaleorder/Views/Address/AddAddressPage.dart';
import 'package:connectsaleorder/Views/Address/AddressItem.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'PaymentScreen.dart';

class CheckoutScreen extends StatefulWidget{
  @override
  _CheckoutScreen createState() => _CheckoutScreen();

}

class _CheckoutScreen extends State<CheckoutScreen>{
  var utils = AppUtils();
  CheckAdminController checkAdminController = Get.find();
  UserController userController = Get.find();
  var phoneController = TextEditingController();
  var tNoController = TextEditingController();
  var emailController = TextEditingController();
  AddressModel? selectedAddress;
  var isRetailer = false;
  var orderType = Get.arguments;
  AddressModel? selectedBranch;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isRetailer = userController.user != null ? userController.user!.isRetailer? userController.user!.retailerModel!.approved ? true : false :false : false;
    phoneController.text = userController.user!.phone;
    emailController.text = userController.user!.email;
  }
  @override
  Widget build(BuildContext context) {
    return GetBuilder<CheckAdminController>(id: "0", builder: (adminController){
      checkAdminController = adminController;
      if(checkAdminController.system.branches.length > 0){
        if(selectedBranch == null){
          selectedBranch = checkAdminController.system.branches[0];
        }
      }
      return Scaffold(
        backgroundColor: whiteColor,
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
                Container(
                  width: Get.width,
                  padding: EdgeInsets.symmetric(horizontal: 2, vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(onPressed: (){
                        Get.back();
                      }, icon: Icon(CupertinoIcons.arrow_left , size: 20, color: blackColor,)),
                      Text("Checkout" , style: utils.labelStyle(blackColor),)
                    ],
                  ),
                ),
                Expanded(child: SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if(checkAdminController.system.branches.length > 0) Container(
                          width: Get.width,
                          child: Text("Branch" , style: utils.smallLabelStyle(blackColor),),
                        ),
                        if(checkAdminController.system.branches.length > 0) GestureDetector(
                          onTap: (){
                            _presentBottomSheet(context, checkAdminController);
                          },
                          child: Container(
                            width: Get.size.width,
                            padding: EdgeInsets.symmetric(horizontal: 10 , vertical: 12),
                            decoration: BoxDecoration(
                                color: whiteColor,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: blackColor.withOpacity(0.4) , width: 1)
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(width: 10,),
                                Expanded(child: Text(
                                  "${selectedBranch!.area},${selectedBranch!.city}",
                                  style: utils.labelStyle(blackColor),
                                )),
                                Icon(CupertinoIcons.chevron_down , color: blackColor, size: 20,)
                              ],
                            ),
                          ),
                        ),
                        if(orderType == 1) GetBuilder<UserController>(id: "0", builder: (userController){
                          for(var  i = 0 ; i < userController.user!.addressList.length; i++){
                            if(userController.user!.addressList[i].selected){
                              selectedAddress = userController.user!.addressList[i];
                              break;
                            }
                          }
                          return selectedAddress == null ? InkWell(
                            onTap: (){
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) => AddAddressPage(0,null)));
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 24),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: whiteColor,
                                  border: Border.all(color: checkAdminController.system.mainColor),
                                  boxShadow: [
                                    BoxShadow(
                                        spreadRadius: 2,
                                        blurRadius: 12,
                                        offset: Offset(0,2),
                                        color: grayColor.withOpacity(0.3)
                                    )
                                  ]
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(CupertinoIcons.add , size: 24, color: checkAdminController.system.mainColor,),
                                  SizedBox(width: 8,),
                                  Text("Add address", style: utils.labelStyle(checkAdminController.system.mainColor),)
                                ],
                              ),
                            ),
                          ) : AddressItem(selectedAddress!,0,1, (){});
                        },),
                        if(orderType == 0) Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(CupertinoIcons.table , color: checkAdminController.system.mainColor, size: 20,),
                            SizedBox(width: 12,),
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: blackColor)
                                ),
                                child: TextFormField(
                                  style: utils.smallLabelStyle(blackColor),
                                  decoration: InputDecoration.collapsed(hintText: "Table No" , hintStyle: utils.smallLabelStyle(blackColor.withOpacity(0.4))),
                                  controller: tNoController,
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 5,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(CupertinoIcons.phone , color: checkAdminController.system.mainColor, size: 20,),
                            SizedBox(width: 12,),
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: blackColor)
                                ),
                                child: TextFormField(
                                  style: utils.smallLabelStyle(blackColor),
                                  decoration: InputDecoration.collapsed(hintText: "Phone" , hintStyle: utils.smallLabelStyle(blackColor.withOpacity(0.4))),
                                  controller: phoneController,
                                  keyboardType: TextInputType.phone,
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 5,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(CupertinoIcons.envelope_fill , color: checkAdminController.system.mainColor, size: 20,),
                            SizedBox(width: 12,),
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: blackColor)
                                ),
                                child: TextFormField(
                                  style: utils.smallLabelStyle(blackColor),
                                  decoration: InputDecoration.collapsed(hintText: "Email" , hintStyle: utils.smallLabelStyle(blackColor.withOpacity(0.4))),
                                  controller: emailController,
                                  keyboardType: TextInputType.emailAddress,
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 12,),
                        Container(
                          width: Get.width,
                          height: 1,
                          color: blackColor.withOpacity(0.3),
                        ),
                        SizedBox(height: 12,),
                        GetBuilder<CartController>(id: "0", builder: (cartController){
                          List<ItemModel> mProducts = [];
                          var totalValue = 0.0;
                          var grandValue = 0.0;
                          List<double> addons = [];
                          for(var p in cartController.myCart.products){
                            mProducts.add(p);
                            var addonPrices = 0.0;
                            for(var a in p.selectedAddons){
                              addonPrices = addonPrices + (int.parse(a.adonPrice) * a.quantity);
                            }
                            addons.add(addonPrices);
                            totalValue += ((isRetailer ? p.discountedPriceW??0 : p.discountedPrice??0.0)) * p.selectedQuantity + addonPrices;
                            grandValue += (isRetailer ? p.wholeSale : p.salesRate) * p.selectedQuantity + addonPrices;
                          }
                          if(mProducts.length <= 0){
                            Get.back();
                          }
                          cartController.myCart.totalBill = grandValue;
                          cartController.myCart.discountedBill = totalValue;
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                  width: Get.width,
                                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: whiteColor,
                                      boxShadow: [
                                        BoxShadow(
                                            blurRadius: 2,
                                            spreadRadius: 2,
                                            offset: Offset(0,2),
                                            color: blackColor.withOpacity(0.3)
                                        )
                                      ]
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      for(var j = 0 ; j < mProducts.length; j++)
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(height: 12,),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  width: Get.width * 0.6,
                                                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(8),
                                                      border: Border.all(color: checkAdminController.system.mainColor)
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Icon(CupertinoIcons.check_mark_circled_solid, color: checkAdminController.system.mainColor, size: 18,),
                                                      SizedBox(width: 8,),
                                                      Expanded(
                                                        child: Column(
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Text("${mProducts[j].selectedQuantity < mProducts[j].freeDeliveryItems ? utils.getFormattedPrice(mProducts[j].selectedQuantity > mProducts[j].deliveryApplyItem ? (mProducts[j].deliveryPrice * mProducts[j].deliveryApplyItem): (mProducts[j].deliveryPrice * mProducts[j].selectedQuantity)): "Free Delivery"}", style: utils.smallLabelStyle(blackColor),),
                                                            Text("Home Delivery", style: utils.smallLabelStyle(blackColor),),
                                                            SizedBox(height: 4,),
                                                            Text("Est. Delivery ${DateFormat("dd MMM, yyyy").format(DateTime.now().add(Duration(hours: mProducts[j].minDeliveryTime)))} to ${DateFormat("dd MMM, yyyy").format(DateTime.now().add(Duration(hours: mProducts[j].maxDeliveryTime)))}",style: utils.xSmallLabelStyle(blackColor.withOpacity(0.5)),),
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                Expanded(child: Container(
                                                  width: Get.width,
                                                  alignment: Alignment.centerRight,
                                                  child: IconButton(
                                                    onPressed: (){
                                                      cartController.deleteItem(j);
                                                    },
                                                    icon: Icon(CupertinoIcons.delete, color: redColor)
                                                  ),
                                                ))
                                              ],
                                            ),
                                            SizedBox(height: 8,),
                                            Container(
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    width: 100,
                                                    height: 100,
                                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(5),
                                                    ),
                                                    child: CachedNetworkImage(
                                                      imageUrl: mProducts[j].images.length > 0 ? mProducts[j].images[0] : "",
                                                      placeholder: (context, url) => SpinKitRotatingCircle(color: checkAdminController.system.mainColor,),
                                                      errorWidget: (context, url, error) => Icon(
                                                        Icons.image_not_supported_rounded,
                                                        size: 25,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(width: 8,),
                                                  Expanded(
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Container(
                                                          margin:
                                                          EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                                                          child: Text(
                                                            mProducts[j].name,
                                                            maxLines: 2,
                                                            overflow: TextOverflow.ellipsis,
                                                            style: TextStyle(fontSize: 10, color: blackColor),
                                                          ),
                                                        ),
                                                        Container(
                                                          margin: EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                  Column(
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    children: [
                                                                      Visibility(
                                                                        visible: (isRetailer ? mProducts[j].wholeSale : mProducts[j].salesRate) != (isRetailer ? mProducts[j].discountedPriceW : mProducts[j].discountedPrice),
                                                                        child: Row(
                                                                          children: [
                                                                            Container(
                                                                              alignment: Alignment.center,
                                                                              decoration: BoxDecoration(
                                                                                borderRadius: BorderRadius.circular(2),
                                                                                color: checkAdminController.system.mainColor,
                                                                              ),
                                                                              padding:
                                                                              EdgeInsets.symmetric(horizontal: 5),
                                                                              child: Text(
                                                                                  (isRetailer ? mProducts[j].discountedPriceW : mProducts[j].discountedPrice) != null ? "${100-(((isRetailer ? mProducts[j].discountedPriceW??0 : mProducts[j].discountedPrice??0)/(isRetailer ? (mProducts[j].wholeSale > 0 ? mProducts[j].wholeSale : 1) : mProducts[j].salesRate))*100).ceil()}%":"0%",
                                                                                style: TextStyle(
                                                                                    color: Colors.white,
                                                                                    fontSize: 9),
                                                                              ),
                                                                            ),
                                                                            Container(
                                                                              width: 5,
                                                                            ),
                                                                            Text(
                                                                              utils.getFormattedPrice(
                                                                                  double.parse("${(isRetailer ? mProducts[j].wholeSale : mProducts[j].salesRate)}")),
                                                                              style: TextStyle(
                                                                                  fontSize: 8,
                                                                                  color: blackColor.withOpacity(0.6),
                                                                                  decoration:
                                                                                  TextDecoration.lineThrough),
                                                                            )
                                                                          ],
                                                                        ),
                                                                      ),

                                                                      FittedBox(
                                                                        child: AutoSizeText(
                                                                          utils.getFormattedPrice(
                                                                              double.parse("${(isRetailer ? mProducts[j].discountedPriceW??0 : mProducts[j].discountedPrice??0)}")),
                                                                          minFontSize: 10,
                                                                          style: TextStyle(
                                                                              fontSize: 10,
                                                                              color: checkAdminController.system.mainColor,
                                                                              fontWeight: FontWeight.w600),
                                                                        ),
                                                                      ),

                                                                      Row(
                                                                        mainAxisAlignment: MainAxisAlignment.end,
                                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                                        children: [
                                                                          IconButton(
                                                                              onPressed: (){
                                                                                if(mProducts[j].selectedQuantity > 1){
                                                                                  cartController.updateQuantity(j , (mProducts[j].selectedQuantity-1).toString());
                                                                                }
                                                                              }, icon: Icon(CupertinoIcons.minus_circled , size: 20, color: mProducts[j].selectedQuantity > 1 ? blackColor : blackColor.withOpacity(0.5),)
                                                                          ),
                                                                          Text("${mProducts[j].selectedQuantity}", style: utils.smallLabelStyle(blackColor),),
                                                                          IconButton(
                                                                              onPressed: (){
                                                                                if(mProducts[j].selectedQuantity < mProducts[j].totalStock){
                                                                                  cartController.updateQuantity(j , (mProducts[j].selectedQuantity+1).toString());
                                                                                  setState(() {
                                                                                  });
                                                                                }
                                                                              }, icon: Icon(CupertinoIcons.add_circled , size: 20, color: mProducts[j].selectedQuantity < mProducts[j].totalStock ? blackColor : blackColor.withOpacity(0.5),)
                                                                          )
                                                                        ],
                                                                      ),

                                                                      if(mProducts[j].selectedAddons.length > 0) Wrap(
                                                                        children: [
                                                                          for(var l = 0 ; l < mProducts[j].selectedAddons.length; l++)
                                                                            Text(
                                                                                "${mProducts[j].selectedAddons[l].adonDescription}x${mProducts[j].selectedAddons[l].quantity}${l < mProducts[j].selectedAddons.length - 1 ? ",":""} ",
                                                                                style: utils.xSmallLabelStyle(blackColor)
                                                                            ),

                                                                          Text(
                                                                              " = ${utils.getFormattedPrice(addons[j])}",
                                                                              style: utils.xSmallLabelStyle(checkAdminController.system.mainColor)
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            SizedBox(height: 5,),
                                            Container(
                                              width: Get.width,
                                              height: 1,
                                              color: blackColor.withOpacity(0.4),
                                            )
                                          ],
                                        ),
                                      SizedBox(height: 12,),
                                      Container(
                                        width: Get.width,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            RichText(
                                              text: TextSpan(
                                                  children: [
                                                    TextSpan(
                                                        text: "${mProducts.length} item(s), Total: ",
                                                        style: utils.xSmallLabelStyle(blackColor)
                                                    ),
                                                    TextSpan(
                                                        text: "${utils.getFormattedPrice(double.parse(totalValue.toString()))}",
                                                        style: utils.xSmallLabelStyle(checkAdminController.system.mainColor)
                                                    )
                                                  ]
                                              ),
                                            ),
                                            RichText(
                                              text: TextSpan(
                                                  children: [
                                                    TextSpan(
                                                        text: "price Dropped Saved: ${utils.getFormattedPrice(double.parse((grandValue - totalValue).toString()))}",
                                                        style: utils.xSmallLabelStyle(blackColor.withOpacity(0.6))
                                                    ),
                                                  ]
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                )
                            ],
                          );
                        }),
                        SizedBox(height: 12,),
                      ],
                    ),
                  ),
                )),
                GetBuilder<CartController>(id: "0", builder: (cartController){
                  var totalPrice = cartController.myCart.discountedBill;
                  var deliveryPrice = 0.0;
                  for(var  i = 0  ; i < cartController.myCart.products.length; i++){
                    // totalPrice += (cartController.myCart.products[i].discountedPrice??0) * cartController.myCart.products[i].selectedQuantity;
                    deliveryPrice += cartController.myCart.products[i].selectedQuantity < cartController.myCart.products[i].freeDeliveryItems ? cartController.myCart.products[i].selectedQuantity > cartController.myCart.products[i].deliveryApplyItem ? (cartController.myCart.products[i].deliveryPrice * cartController.myCart.products[i].deliveryApplyItem) : (cartController.myCart.products[i].deliveryPrice * cartController.myCart.products[i].selectedQuantity) : 0;
                  }
                  return Container(
                      width: Get.width,
                      color: whiteColor,
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                text: TextSpan(
                                    children: [
                                      TextSpan(
                                          text: "Total: ",
                                          style: utils.labelStyle(blackColor)
                                      ),
                                      TextSpan(
                                          text: "${utils.getFormattedPrice(totalPrice.toDouble())}",
                                          style: utils.boldLabelStyle(checkAdminController.system.mainColor)
                                      ),
                                    ]
                                ),
                              ),
                              RichText(
                                text: TextSpan(
                                    children: [
                                      TextSpan(
                                          text: "Delivery Price: ",
                                          style: utils.xSmallLabelStyle(blackColor)
                                      ),
                                      TextSpan(
                                          text: "${utils.getFormattedPrice(deliveryPrice.toDouble())}",
                                          style: utils.xSmallLabelStyle(checkAdminController.system.mainColor)
                                      ),
                                    ]
                                ),
                              ),
                              RichText(
                                text: TextSpan(
                                    children: [
                                      TextSpan(
                                          text: "Tax included where implemented",
                                          style: utils.xSmallLabelStyle(blackColor.withOpacity(0.4))
                                      ),
                                    ]
                                ),
                              )
                            ],
                          )
                          ),
                          InkWell(
                            onTap : (){
                              if(orderType == 1){
                                if(selectedAddress == null){
                                  Get.snackbar("Address Required", "Add Address First!");
                                  return;
                                }
                              } else if(orderType == 0){
                                if(tNoController.text.isEmpty){
                                  Get.snackbar("Table no Required", "Kindly give us your table number!");
                                  return;
                                }
                              } else if(phoneController.text.isEmpty){
                                Get.snackbar("Phone Required", "Kindly give us your phone number!");
                                return;
                              }
                              cartController.myCart.branch = selectedBranch;
                              addOrderToFirebase(cartController.myCart, cartController,deliveryPrice);
                            },
                            child: Container(
                              width: Get.width * 0.35,
                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  gradient: LinearGradient(colors: [checkAdminController.system.mainColor,checkAdminController.system.mainColor])
                              ),
                              child: Center(
                                child: Text("Proceed to Pay" , style: utils.smallLabelStyle(whiteColor),),
                              ),
                            ),
                          )
                        ],
                      )
                  );
                },)
              ],
            ),
          ),
        ),
      );
    },);
  }

  void addOrderToFirebase(CartModel myCart, CartController cartController , double deliveryPrice) async {
    myCart.createdAt = DateTime.now().millisecondsSinceEpoch;
    myCart.isRetailer = isRetailer;
    myCart.orderType = orderType;
    if(orderType == 1) {
      myCart.customer = CustomerModel(id: userController.user!.uid,
          name: selectedAddress!.fullName.toString(),
          phone: phoneController.text.toString(),
          type: 0,
          address: selectedAddress!.address + ", " + selectedAddress!.city +
              " " + selectedAddress!.province + " " + selectedAddress!.country,
          area: selectedAddress!.area,
          lat: selectedAddress!.lat,
          lng: selectedAddress!.lng);
    }else{
      myCart.customer = CustomerModel(id: userController.user!.uid,
          name: "Dine-in customer",
          phone: phoneController.text.toString(),
          type: 0,
          area: "Dine-In",
          address: "Table#"+tNoController.text.toString(),
          lat: 0,
          lng: 0);
    }
    myCart.deliveryPrice = deliveryPrice;
    if(checkAdminController.system.maxDeliveryPrice <= myCart.discountedBill)
      Get.to(()=>PaymentScreen(myCart));
    else
      Get.snackbar("Opps", "Your order price must be greater ${checkAdminController.system.maxDeliveryPrice -1 }");
  }

  void _presentBottomSheet(BuildContext context, CheckAdminController checkAdminController) {
    var searchController = TextEditingController();
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0) , topRight: Radius.circular(20)),
      ),
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (BuildContext context1,StateSetter setState){
          return Container(
            height: Get.size.height - 30,
            color: Colors.transparent,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: whiteColor
                    ),
                    child: Center(
                      child: Icon(CupertinoIcons.xmark , color: checkAdminController.system.mainColor,),
                    ),
                  ),
                ),
                SizedBox(height: 10,),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(topRight: Radius.circular(20) , topLeft: Radius.circular(20)),
                      color: whiteColor
                  ),
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 12),
                    width: double.infinity,
                    child: form("Search", "Search", searchController,onChange: (val){
                      setState((){});
                    }),
                  ),
                ),
                Expanded(child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 10,vertical: 12),
                  decoration: BoxDecoration(
                      color: whiteColor
                  ),
                  child: SingleChildScrollView(
                    child: Wrap(
                      children: <Widget>[
                        Wrap(
                          children: [
                            for(var i = 0 ; i < checkAdminController.system.branches.length ; i++)
                              if(checkAdminController.system.branches[i].area.toLowerCase().contains(searchController.text.toLowerCase()))
                                GestureDetector(
                                  onTap: (){
                                    selectedBranch = checkAdminController.system.branches[i];
                                    setData();
                                  },
                                  child: Container(
                                      width: double.infinity,
                                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                      child: RichText(
                                        text: TextSpan(
                                            children: [
                                              TextSpan(
                                                  text: checkAdminController.system.branches[i].area,
                                                  style: utils.labelStyle(blackColor)
                                              ),
                                              TextSpan(
                                                  text: ", ",
                                                  style: utils.labelStyle(blackColor)
                                              ),
                                              TextSpan(
                                                  text: checkAdminController.system.branches[i].city,
                                                  style: utils.boldSmallLabelStyle(blackColor)
                                              ),
                                            ]
                                        ),
                                      )
                                  ),
                                )
                          ],
                        )
                      ],
                    ),
                  ),
                ))
              ],
            ),
          );
        },
      ),
    );
  }

  setData(){
    if(mounted){
      setState(() {
      });
    }
  }
  Widget form(String hints, String label, TextEditingController controller,{onChange}) {
    return Container(
      height: MediaQuery.of(context).size.height / 12,
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.text,
        onChanged: onChange,
        style: utils.smallLabelStyle(blackColor),
        decoration: InputDecoration(
            labelStyle: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 10,
                color: blackColor
            ),
            hintStyle: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 10,
                color: blackColor
            ),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            labelText: label,
            hintText: hints),
      ),
    );
  }


}