import 'package:connectsaleorder/AppConstants/Constants.dart';
import 'package:connectsaleorder/GetXController/CartController.dart';
import 'package:connectsaleorder/GetXController/ChatController.dart';
import 'package:connectsaleorder/GetXController/CheckAdminController.dart';
import 'package:connectsaleorder/GetXController/ItemController.dart';
import 'package:connectsaleorder/GetXController/UserController.dart';
import 'package:connectsaleorder/Models/ItemModel.dart';
import 'package:connectsaleorder/Utils/AppUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddToCartBottom extends StatefulWidget{
  ItemModel itemModel;
  var onAdd;
  AddToCartBottom(this.itemModel, this.onAdd);
  @override
  _AddToCartBottom createState() => _AddToCartBottom();
}

class _AddToCartBottom extends State<AddToCartBottom>{
  var utils = AppUtils();
  CheckAdminController checkAdminController = Get.find();
  ChatController chatController = Get.find();
  UserController userController = Get.find();
  CartController cartController = Get.find();
  var count = 1;
  var selectedColor = 0;
  var selectedSize = 0;
  List<ProductAdons> selectedAddOns = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      color: Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: Get.width,
            height: 20,
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 2),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(0),
                color: whiteColor,
                boxShadow: [
                  BoxShadow(
                      color: grayColor.withOpacity(0.5),
                      blurRadius: 2,
                      spreadRadius: 2,
                      offset: Offset(0,2)
                  )
                ]
            ),
          ),
          if(widget.itemModel.colors.length > 0) Container(
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
                  child: Text("Colors" , style: utils.labelStyle(blackColor),),
                ),
                for(var i = 0 ; i  < widget.itemModel.colors.length; i++)
                  InkWell(
                    onTap: (){
                      selectedColor = i;
                      widget.itemModel.color = widget.itemModel.colors[i].color;
                      setState(() {
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 6,vertical: 4),
                      margin: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: selectedColor == i ? checkAdminController.system.mainColor : whiteColor,
                          border: Border.all(color: checkAdminController.system.mainColor, width: 1)
                      ),
                      child: Text("${widget.itemModel.colors[i].color}", style: utils.smallLabelStyle(selectedColor == i ? whiteColor : checkAdminController.system.mainColor),),
                    ),
                  )
              ],
            )
          ),
          if(widget.itemModel.addons.length > 0) Container(
            width: Get.width,
            constraints: BoxConstraints(
              maxHeight: Get.height * 0.5,
              minHeight: 0
            ),
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(0),
                  color: whiteColor
              ),
            child: SingleChildScrollView(
              child: Wrap(
                children: [
                  Container(
                    width: Get.width,
                    child: Text("Addons" , style: utils.labelStyle(blackColor),),
                  ),
                  for(var i = 0 ; i  < widget.itemModel.addons.length; i++)
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
                              Expanded(child: Text("${widget.itemModel.addons[i].adonDescription}",style: utils.boldSmallLabelStyle(blackColor))),
                              SizedBox(width: 12,),
                              Text(utils.getFormattedPrice(widget.itemModel.addons[i].adonPrice), style: utils.smallLabelStyle(blackColor),),
                              SizedBox(width: 12,),
                              IconButton(onPressed: (){
                                addToAddons(widget.itemModel.addons[i]);
                              }, icon: Icon(CupertinoIcons.add_circled, color: checkAdminController.system.mainColor, size: 20,))
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
              ),
            )
          ),

          if(selectedAddOns.length > 0) Container(
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
                  child: Text("Your Addons" , style: utils.labelStyle(blackColor),),
                ),
                SizedBox(height: 8,),
                for(var i = 0 ; i  < selectedAddOns.length; i++)
                  InkWell(
                    onTap: (){
                      selectedAddOns.removeAt(i);
                      setState(() {
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      margin: EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(200),
                        color: grayColor
                      ),
                      child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        alignment: WrapAlignment.start,
                        children: [
                          Text("${selectedAddOns[i].adonDescription}x${selectedAddOns[i].quantity}", style: utils.xSmallLabelStyle(blackColor),),
                          SizedBox(width: 4,),
                          Icon(CupertinoIcons.xmark_octagon_fill, color: checkAdminController.system.mainColor, size: 16,)
                        ],
                      ),
                    ),
                  )
              ],
            )
          ),
          GetBuilder<ItemController>(id: "0", builder: (itemController){
            return itemController.sizedProducts.length > 0 ? Container(
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
                      child: Text("Sizes" , style: utils.labelStyle(blackColor),),
                    ),
                    for(var i = 0 ; i  < itemController.sizedProducts.length; i++)
                      InkWell(
                        onTap: (){
                          selectedSize = i;
                          widget.itemModel = itemController.sizedProducts[i];
                          setState(() {
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 6,vertical: 4),
                          margin: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: selectedSize == i ? checkAdminController.system.mainColor : whiteColor,
                              border: Border.all(color: checkAdminController.system.mainColor, width: 1)
                          ),
                          child: Text("${itemController.sizedProducts[i].name.substring(itemController.sizedProducts[i].name.indexOf("-")+1)}", style: utils.smallLabelStyle(selectedSize == i ? whiteColor : checkAdminController.system.mainColor),),
                        ),
                      )
                  ],
                )
            ) : Container();
          }),
          Container(
            width: Get.width,
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 2),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(0),
                color: whiteColor,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(child: Text("${utils.getFormattedPrice(widget.itemModel.discountedPrice??"0")}", style: utils.boldSmallLabelStyle(checkAdminController.system.mainColor),)),
                SizedBox(width: 8,),
                if(widget.itemModel.totalStock > 0) Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                        onPressed: (){
                          if(count > 1){
                            count--;
                            setState(() {
                            });
                          }
                        }, icon: Icon(CupertinoIcons.minus_circled , size: 24, color: count > 1 ? blackColor : blackColor.withOpacity(0.5),)
                    ),
                    Text("$count", style: utils.xSmallLabelStyle(blackColor),),
                    IconButton(
                        onPressed: (){
                          if(count < widget.itemModel.totalStock){
                            count++;
                            setState(() {
                            });
                          }
                        }, icon: Icon(CupertinoIcons.add_circled , size: 24, color: count < widget.itemModel.totalStock ? blackColor : blackColor.withOpacity(0.5),)
                    )
                  ],
                )
              ],
            ),
          ),
          Container(color: whiteColor,height: 6,),
          Container(
            width: Get.width,
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(0),
                color: whiteColor,
                boxShadow: [
                  BoxShadow(
                      color: grayColor.withOpacity(0.5),
                      blurRadius: 2,
                      spreadRadius: 2,
                      offset: Offset(0,2)
                  )
                ]
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                 child: utils.button(checkAdminController.system.mainColor, "Add to cart", whiteColor, checkAdminController.system.mainColor, 1.0, (){
                   if(widget.itemModel.totalStock > 0){
                     Navigator.pop(context);
                     return widget.onAdd(count, selectedAddOns, widget.itemModel, widget.itemModel.colors.length > 0 ? widget.itemModel.colors[selectedColor] : null);
                   }else{
                     Get.snackbar("Error", "Sorry no stock available at this time. please contact us in case of any query");
                   }
                 }),
                ),
                SizedBox(width: 12,),
                Expanded(
                 child: utils.button(whiteColor, "Contact Seller",  checkAdminController.system.mainColor, checkAdminController.system.mainColor, 1.0, (){
                   chatController.sendMessage("Hello, Hope you are doing well. Can I get More specs for ${widget.itemModel.name}", widget.itemModel, null, null, userController.user!.uid, "admin");
                   Navigator.pop(context);
                   Get.toNamed(chatRoute , arguments: 0);
                 }),
                ),
                SizedBox(width: 12,),
              ],
            )
          )
        ],
      ),
    );
  }

  addToAddons(ProductAdons adons){
    var isExist = false;
    var position = 0;
    for(var i = 0 ; i < selectedAddOns.length; i++){
      if(selectedAddOns[i].adonDescription == adons.adonDescription){
        isExist = true;
        position = i;
      }
    }

    if(isExist){
      selectedAddOns[position].quantity = selectedAddOns[position].quantity + 1;
    }else{
      adons.quantity = 1;
      selectedAddOns.add(adons);
    }
    setState(() {
    });
  }

}