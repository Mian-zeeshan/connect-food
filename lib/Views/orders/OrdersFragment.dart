import 'package:connectsaleorder/AppConstants/Constants.dart';
import 'package:connectsaleorder/GetXController/CartController.dart';
import 'package:connectsaleorder/GetXController/CheckAdminController.dart';
import 'package:connectsaleorder/GetXController/OrderController.dart';
import 'package:connectsaleorder/GetXController/UserController.dart';
import 'package:connectsaleorder/Models/CartModel.dart';
import 'package:connectsaleorder/Utils/AppUtils.dart';
import 'package:connectsaleorder/Views/orders/OrderDetailScreen.dart';
import 'package:cr_calendar/cr_calendar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class OrderFragment extends StatefulWidget {
  bool fromNav;
  bool hideBack = true;
  OrderFragment(this.fromNav , {this.hideBack = true});
  @override
  _OrderFragment createState() => _OrderFragment();
}

class _OrderFragment extends State<OrderFragment> {
  var utils = AppUtils();
  var _dropDownValue = "Last 7 days";
  var _dropDownValues = [
    "Today",
    "Last 7 days",
    "This Month",
    "Last Month",
    "Custom"
  ];
  var selectedType = 0;
  CartController cartController = Get.find();
  CheckAdminController checkAdminController = Get.find();
  UserController userController = Get.find();

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
        child: GetBuilder<OrderController>(
            id: "0",
            builder: (orderController) {
              orderController.orders.sort((a,b) => b.createdAt.compareTo(a.createdAt));
              return DefaultTabController(
                length: 2,
                child: Container(
                  color: whiteColor,
                  width: Get.width,
                  height: Get.height,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if(!widget.fromNav) Container(
                        padding: EdgeInsets.only(left: widget.hideBack ? 8 : 0 , right: 8, top: widget.hideBack ? 12 : 6, bottom: widget.hideBack ? 12 :6),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12),),
                            color: checkAdminController.system.mainColor
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            if(!widget.hideBack) IconButton(
                                onPressed: (){
                                  Get.back();
                                },
                                icon: Icon(CupertinoIcons.arrow_left, color: whiteColor, size: 24,)
                            ),
                            Expanded(child: Text("Orders".tr, style: utils.headingStyle(whiteColor),)),
                            if(userController.user != null) GestureDetector(
                              onTap : (){
                                Get.toNamed(favoriteRoute);
                              },
                              child: Container(
                                width: 32,
                                height: 32,
                                child: Stack(
                                  alignment: Alignment.bottomCenter,
                                  children: [
                                    Icon(CupertinoIcons.heart , color: whiteColor,),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(width: 8,),
                            if(userController.user != null) GestureDetector(
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
                                width: 32,
                                height: 32,
                                child: Stack(
                                  alignment: Alignment.bottomCenter,
                                  children: [
                                    Icon(CupertinoIcons.shopping_cart , color: whiteColor,),
                                    Positioned(
                                        top: 0,
                                        right: 0,
                                        child: Container(
                                          width: 18,
                                          height: 18,
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
                            if(userController.user == null) GestureDetector(
                              onTap : (){
                                utils.loginBottomSheet(context);
                              },
                              child: Container(
                                width: 32,
                                height: 32,
                                child: Stack(
                                  alignment: Alignment.bottomCenter,
                                  children: [
                                    Image.asset("Assets/Images/account.png" , color: whiteColor,),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: ()=> showFilterBottom(context,orderController),
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                    color: checkAdminController.system.mainColor,
                                    borderRadius: BorderRadius.circular(8)),
                                child: Center(
                                  child: Icon(
                                    CupertinoIcons.slider_horizontal_3,
                                    color: whiteColor,
                                    size: 26,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              width: 140.w,
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: blackColor.withOpacity(0.6), width: 2),
                                  borderRadius: BorderRadius.circular(12)),
                              child: DropdownButtonFormField(
                                hint: Text('Last 7 days'),
                                // Not necessary for Option 1
                                value: _dropDownValue,
                                isExpanded: false,
                                onChanged: (newValue) {
                                  _dropDownValue = newValue as String;
                                  if (_dropDownValue == "Today") {
                                    var now = DateTime.now();
                                    orderController.setDateTime(
                                        DateTime(
                                            now.year, now.month, now.day, 0, 0, 0)
                                            .millisecondsSinceEpoch,
                                        DateTime(now.year, now.month, now.day, 23, 59,
                                            59)
                                            .millisecondsSinceEpoch);
                                    print(DateTime(
                                        now.year, now.month, now.day, 0, 0, 0));
                                    print(DateTime(
                                        now.year, now.month, now.day, 23, 59, 59));
                                  } else if (_dropDownValue == "Last 7 days") {
                                    orderController.setDateTime(
                                        DateTime.now()
                                            .subtract(Duration(days: 7))
                                            .millisecondsSinceEpoch,
                                        DateTime.now().millisecondsSinceEpoch);
                                  } else if (_dropDownValue == "This Month") {
                                    var now = DateTime.now();
                                    var from = DateTime(now.year, now.month, 1)
                                        .millisecondsSinceEpoch;
                                    var to = DateTime(
                                        now.year, now.month + 1, 0, 23, 59, 59)
                                        .millisecondsSinceEpoch;
                                    orderController.setDateTime(from, to);
                                  } else if (_dropDownValue == "Last Month") {
                                    var now = DateTime.now();
                                    var from = DateTime(now.year, now.month - 1, 1)
                                        .millisecondsSinceEpoch;
                                    var to =
                                        DateTime(now.year, now.month, 0, 23, 59, 59)
                                            .millisecondsSinceEpoch;
                                    orderController.setDateTime(from, to);
                                  } else {
                                    print("Came");
                                    showCalendarDialog(orderController);
                                  }
                                },
                                items: _dropDownValues.map((location) {
                                  return DropdownMenuItem(
                                    child: new Text(
                                      location,
                                      style: utils
                                          .labelStyle(blackColor.withOpacity(0.8)),
                                    ),
                                    value: location,
                                  );
                                }).toList(),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 5,
                                        height: 5,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: blackColor),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Expanded(
                                          child: Text(
                                            "${DateFormat("yyyy-MM-dd").format(DateTime.fromMillisecondsSinceEpoch(orderController.fromDate))}",
                                            style: utils.labelStyle(blackColor),
                                          )),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 5,
                                        height: 5,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: blackColor),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Expanded(
                                          child: Text(
                                            "${DateFormat("yyyy-MM-dd").format(DateTime.fromMillisecondsSinceEpoch(orderController.toDate))}",
                                            style: utils.labelStyle(blackColor),
                                          ))
                                    ],
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                          ],
                        ),
                      ),
                      TabBar(
                          labelPadding: EdgeInsets
                              .symmetric(
                              horizontal: 5),
                          onTap: (i) {
                            setState(() {
                              selectedType = i;
                            });
                            // _onSortChange(i);
                          },
                          isScrollable: true,
                          indicatorSize:
                          TabBarIndicatorSize.label,
                          indicator: BoxDecoration(
                            borderRadius:
                            BorderRadius.circular(5),
                            color: Colors.transparent,
                          ),
                          tabs: [
                            utils.tabStyle(
                                selectedType == 0,
                                "Dine-In",
                                checkAdminController.system.mainColor),
                            utils.tabStyle(
                                selectedType == 1,
                                "Home Delivery",
                                checkAdminController.system.mainColor),
                          ]),
                      Expanded(child: SingleChildScrollView(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 12,
                              ),
                              orderController.orders.length > 0
                                  ? Wrap(
                                alignment: WrapAlignment.spaceBetween,
                                children: [
                                  for (var i = 0;
                                  i < orderController.orders.length;
                                  i++)
                                    if(orderController.orders[i].orderType == selectedType)
                                    GestureDetector(
                                      onTap: (){
                                        if(orderController.orders[i].status != -1) {
                                          orderController.listenOrdersTrack(
                                              orderController.orders[i]);
                                          Get.toNamed(trackOrderRoute);
                                        }else{
                                          Get.snackbar("Opps!", "Your order is cancelled and can not track.");
                                        }
                                      },
                                      child: Container(
                                        width:  Get.width,
                                        margin: EdgeInsets.symmetric(
                                            vertical: 6, horizontal: 8),
                                        clipBehavior: Clip.antiAliasWithSaveLayer,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(12),
                                            color: whiteColor,
                                            boxShadow: [
                                              BoxShadow(
                                                  blurRadius: 2,
                                                  spreadRadius: 2,
                                                  offset: Offset(0, 2),
                                                  color: grayColor.withOpacity(0.7))
                                            ]),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              padding: EdgeInsets.all(12),
                                              child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                                children: [
                                                  Container(
                                                      width: 80,
                                                      height: 80,
                                                      clipBehavior:
                                                      Clip.antiAliasWithSaveLayer,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                          BorderRadius.circular(
                                                              12)),
                                                      child: Stack(
                                                        children: [
                                                          Image.network(
                                                            orderController
                                                                .orders[i]
                                                                .products[0]
                                                                .images.length > 0
                                                                ? orderController
                                                                .orders[i]
                                                                .products[0]
                                                                .images[0]
                                                                : "https://5.imimg.com/data5/SELLER/Default/2020/9/XP/HK/UQ/113167197/grocery-items-500x500.jpg",
                                                            fit: BoxFit.cover,
                                                          ),
                                                          Container(
                                                            width: 80,
                                                            height: 80,
                                                            clipBehavior: Clip
                                                                .antiAliasWithSaveLayer,
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                BorderRadius
                                                                    .circular(12),
                                                                color: blackColor
                                                                    .withOpacity(0.5)),
                                                            child: Center(
                                                              child: Text(
                                                                "+${orderController.orders[i].products.length} more",
                                                                style: utils
                                                                    .boldLabelStyle(
                                                                    whiteColor),
                                                                textAlign:
                                                                TextAlign.center,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      )),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Expanded(
                                                      child: Column(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment.start,
                                                        children: [
                                                          Text(
                                                            "Order ID : ${orderController.orders[i].cartId}",
                                                            style: utils.boldLabelStyle(
                                                                blackColor
                                                                    .withOpacity(0.7)),
                                                          ),
                                                          SizedBox(
                                                            height: 5,
                                                          ),
                                                          Text(
                                                            "${DateFormat("dd MMM yyyy hh:mm aa").format(DateTime.fromMillisecondsSinceEpoch(orderController.orders[i].createdAt))}",
                                                            style: utils.smallLabelStyle(
                                                                blackColor
                                                                    .withOpacity(0.5)),
                                                          ),
                                                          SizedBox(
                                                            height: 5,
                                                          ),
                                                          Text(
                                                            "Total Amount: ${utils.getFormattedPrice(orderController.orders[i].discountedBill.round())}",
                                                            style: utils.smallLabelStyle(
                                                                blackColor
                                                                    .withOpacity(0.5)),
                                                          ),
                                                          SizedBox(
                                                            height: 5,
                                                          ),
                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                            children: [
                                                              Expanded(child: Text(
                                                                "Total Items: ${orderController.orders[i].products.length}",
                                                                style: utils.smallLabelStyle(
                                                                    blackColor
                                                                        .withOpacity(0.5)),
                                                              ),),
                                                              SizedBox(width: 8,),
                                                              Container(
                                                                padding: EdgeInsets.symmetric(horizontal: 12,vertical: 6),
                                                                decoration: BoxDecoration(
                                                                    borderRadius: BorderRadius.circular(8),
                                                                    color: orderController.orders[i].status == -1 ? Colors.red.withOpacity(0.3) : orderController.orders[i].status == 0 ? Colors.blue.withOpacity(0.3) : orderController.orders[i].status == 1 ? Colors.greenAccent.withOpacity(0.3) : orderController.orders[i].status == 2 ? Colors.amber.withOpacity(0.3) : Colors.green.withOpacity(0.3)
                                                                ),
                                                                child: Text(utils.getOrderStatus(orderController.orders[i].status), style: utils.xSmallLabelStyle(orderController.orders[i].status == -1 ? Colors.red : orderController.orders[i].status == 0 ? Colors.blue : orderController.orders[i].status == 1 ? Colors.greenAccent : orderController.orders[i].status == 2 ? Colors.amber : Colors.green),),
                                                              )
                                                            ],
                                                          )
                                                        ],
                                                      )),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              width: Get.width,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 12, vertical: 6),
                                              decoration:
                                              BoxDecoration(color: checkAdminController.system.mainColor),
                                              child: IntrinsicHeight(
                                                child: Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      CupertinoIcons.bag_badge_plus,
                                                      color: whiteColor,
                                                      size: 20,
                                                    ),
                                                    SizedBox(
                                                      width: 12,
                                                    ),
                                                    GestureDetector(
                                                        onTap: () {
                                                          cartController.retriveOrder(
                                                              orderController
                                                                  .orders[i]);
                                                          Get.snackbar("Success", "");
                                                        },
                                                        child: Text(
                                                          "Reorder",
                                                          style: utils.boldLabelStyle(
                                                              whiteColor),
                                                        )),
                                                    SizedBox(
                                                      width: 12,
                                                    ),
                                                    Container(
                                                      width: 1,
                                                      color: whiteColor,
                                                    ),
                                                    SizedBox(
                                                      width: 12,
                                                    ),
                                                    Icon(
                                                      CupertinoIcons.eye,
                                                      color: whiteColor,
                                                      size: 20,
                                                    ),
                                                    SizedBox(
                                                      width: 12,
                                                    ),
                                                    GestureDetector(
                                                        onTap: () {
                                                          showOrderDetailBottom(
                                                              context,
                                                              orderController
                                                                  .orders[i]);
                                                        },
                                                        child: Text(
                                                          "View Order",
                                                          style: utils.boldLabelStyle(
                                                              whiteColor),
                                                        )),
                                                    SizedBox(
                                                      width: 12,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                ],
                              )
                                  : Container(
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Lottie.asset('Assets/lottie/searchempty.json'),
                                      Text(
                                        "No Order Available",
                                        style: utils
                                            .labelStyle(blackColor.withOpacity(0.5)),
                                      ),
                                    ]),
                              )
                            ],
                          ),
                        ),
                      ))
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }

  void showCalendarDialog(OrderController orderController) {
    showCrDatePicker(
      context,
      properties: DatePickerProperties(
        backButton: Icon(
          CupertinoIcons.back,
          color: blackColor,
        ),
        forwardButton: Icon(
          CupertinoIcons.forward,
          color: blackColor,
        ),
        pickerTitleBuilder: (DateTime dateTime) => Text(
          DateFormat("MMMM yyyy").format(dateTime),
          style: utils.labelStyle(blackColor),
        ),
        controlBarTitleBuilder: (DateTime dateTime) => Text(
          DateFormat("EEE, dd MMM yyyy").format(dateTime),
          style: utils.labelStyle(blackColor),
        ),
        weekDaysBuilder: (WeekDay weekDay) => Text(
          getWeekDay(weekDay.index),
          style: utils.labelStyle(blackColor),
        ),
        backgroundColor: whiteColor,
        dayItemBuilder: (DayItemProperties dayProperties) => Container(
          padding: EdgeInsets.all(4),
          decoration: BoxDecoration(
              color: dayProperties.isFirstInRange || dayProperties.isLastInRange
                  ? checkAdminController.system.mainColor
                  : dayProperties.isInRange
                      ? checkAdminController.system.mainColor.withOpacity(0.5)
                      : dayProperties.isSelected
                          ? checkAdminController.system.mainColor
                          : dayProperties.isCurrentDay
                              ? greenColor
                              : Colors.transparent,
              borderRadius: dayProperties.isFirstInRange
                  ? BorderRadius.only(
                      topLeft: Radius.circular(4),
                      bottomLeft: Radius.circular(4))
                  : dayProperties.isLastInRange
                      ? BorderRadius.only(
                          topRight: Radius.circular(4),
                          bottomRight: Radius.circular(4))
                      : dayProperties.isCurrentDay
                          ? BorderRadius.circular(4)
                          : BorderRadius.circular(0)),
          child: Center(
              child: Text(
            "${dayProperties.dayNumber}",
            style: utils.boldLabelStyle(blackColor),
          )),
        ),
        firstWeekDay: WeekDay.sunday,
        initialPickerDate: DateTime.now(),
        onDateRangeSelected: (DateTime? rangeBegin, DateTime? rangeEnd) {
          var to = DateTime(
              rangeEnd!.year, rangeEnd.month, rangeEnd.day, 23, 59, 59);
          orderController.setDateTime(
              rangeBegin!.millisecondsSinceEpoch, to.millisecondsSinceEpoch);
          print("Range selected");
        },
        cancelButtonBuilder: (onPress) => GestureDetector(
            onTap: () {
              return onPress!();
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(color: checkAdminController.system.mainColor),
                  borderRadius: BorderRadius.circular(8)),
              child: Center(
                child: Text(
                  "CANCEL",
                  style: utils.boldLabelStyle(blackColor),
                ),
              ),
            )),
        okButtonBuilder: (onPress) => GestureDetector(
            onTap: () {
              return onPress!();
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                  color: checkAdminController.system.mainColor, borderRadius: BorderRadius.circular(8)),
              child: Center(
                child: Text(
                  "OK",
                  style: utils.boldLabelStyle(whiteColor),
                ),
              ),
            )),
      ),
    );
  }

  String getWeekDay(int index) {
    return index == 0
        ? "S"
        : index == 1
            ? "M"
            : index == 2
                ? "T"
                : index == 3
                    ? "W"
                    : index == 4
                        ? "T"
                        : index == 5
                            ? "F"
                            : "S";
  }

  showOrderDetailBottom(BuildContext context, CartModel order) {
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
            Expanded(child: OrderDetailScreen(order))
          ],
        ),
      ),
    );
  }

  showFilterBottom(BuildContext context, OrderController orderController) {
    var status = ["All","Placed" , "Preparing" , "Shipping", "Shipped","Canceled"];
    var icons = [CupertinoIcons.cart , CupertinoIcons.hand_raised_fill , CupertinoIcons.bus, CupertinoIcons.check_mark_circled_solid,CupertinoIcons.xmark , CupertinoIcons.circle];
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
                          orderController.setFilter(i);
                          Navigator.pop(context);
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
                                    if(i == 0 ? orderController.selectedFilter == 5 : i == orderController.selectedFilter+1) Icon(CupertinoIcons.checkmark_alt, size: 24, color: blackColor.withOpacity(0.6),),
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
