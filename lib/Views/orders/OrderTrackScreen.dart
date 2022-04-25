import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectsaleorder/AppConstants/Constants.dart';
import 'package:connectsaleorder/GetXController/CheckAdminController.dart';
import 'package:connectsaleorder/GetXController/OrderController.dart';
import 'package:connectsaleorder/Models/CartModel.dart';
import 'package:connectsaleorder/Utils/AppUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:timelines/timelines.dart';

class OrderTrackScreen extends StatefulWidget{
  @override
  _OrderTrackScreen createState() => _OrderTrackScreen();
}

class _OrderTrackScreen extends State<OrderTrackScreen>{
  var utils = AppUtils();
  CartModel? orderModel;
  List<_DeliveryProcess> deliveryProcesses = [];
  CheckAdminController checkAdminController = Get.find();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return GetBuilder<OrderController>(id: "0", builder: (orderController){
      orderModel = orderController.currentOrder;
      if(orderModel != null) {
        deliveryProcesses = [];
        deliveryProcesses.add(_DeliveryProcess(
            "Placed", orderModel!.status >= 0 ? "Done" : "Placed", messages: orderModel!.status >= 0 ? [
          _DeliveryMessage("", "Your Order is placed and is in que.")
        ]: []));
        deliveryProcesses.add(_DeliveryProcess(
            "Preparing", orderModel!.status >= 1 ? "Done" : "Preparing",
            messages: orderModel!.status >= 1 ?  [
              _DeliveryMessage("", "Your Order is preparing and packing.")
            ]: []));
        deliveryProcesses.add(_DeliveryProcess(
            "On the way", orderModel!.status >= 2 ? "Done" : "On the way",
             messages: orderModel!.status >= 2 ? [
              _DeliveryMessage(
                  "", "Your Order is on the way and will reach to you soon")
            ]: []));
        deliveryProcesses.add(_DeliveryProcess(
            "Delivered", orderModel!.status >= 3 ? "Done" : "Delivered", messages: orderModel!.status >= 3 ? [
          _DeliveryMessage(
              "", "Your order is at your door kindly receive your order.")
        ]: []));
      }
      return orderModel == null ? CircularProgressIndicator() : Scaffold(
          backgroundColor: whiteColor,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(0),
            child: AppBar(
              backgroundColor: checkAdminController.system.mainColor,
              elevation: 0,
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
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(12),bottomRight: Radius.circular(12)),
                        color: checkAdminController.system.mainColor
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Text("Track Order", style: utils.headingStyle(whiteColor),),
                        Positioned(
                            left: 0,
                            child: IconButton(
                              icon: Icon(CupertinoIcons.arrow_left, color: whiteColor, size: 24,),
                              onPressed: ()=> Get.back(),
                            )
                        )
                      ],
                    ),
                  ),
                  Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                              child: Row(
                                children: [
                                  Container(
                                    width: 80.w,
                                    height: 80.w,
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: checkAdminController.system.mainColor
                                    ),
                                    child: CachedNetworkImage(
                                        imageUrl: orderModel!.products[0].images.length > 0 ? orderModel!.products[0].images[0] : "",
                                        placeholder: (context, url) => SpinKitRotatingCircle(color: whiteColor,),
                                        errorWidget: (context, url, error) => Icon(
                                          Icons.image_not_supported_rounded,
                                          size: 25.h,
                                        ), fit: BoxFit.cover),
                                  ),
                                  SizedBox(width: 8,),
                                  Expanded(child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Order #${orderModel!.cartId}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        '${DateFormat("dd MMM, yyyy").format(DateTime.fromMillisecondsSinceEpoch(orderModel!.createdAt))}',
                                        style: TextStyle(
                                          color: Color(0xffb6b2b2),
                                        ),
                                      ),
                                      Text(
                                        '${utils.getOrderStatus(orderModel!.status)}',
                                        style: TextStyle(
                                          color: checkAdminController.system.mainColor,
                                        ),
                                      ),
                                    ],
                                  ))
                                ],
                              ),
                            ),
                            Divider(height: 1.0),
                            _DeliveryProcesses(processes: deliveryProcesses),
                            Divider(height: 1.0),
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: _OnTimeBar(driver: orderModel!),
                            ),
                          ],
                        ),
                      )
                  )],
              ),
            ),
          )
      );
    });
  }
}
class _InnerTimeline extends StatelessWidget {
  const _InnerTimeline({
    required this.messages,
  });

  final List<_DeliveryMessage> messages;

  @override
  Widget build(BuildContext context) {
    bool isEdgeIndex(int index) {
      return index == 0 || index == messages.length + 1;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: FixedTimeline.tileBuilder(
        theme: TimelineTheme.of(context).copyWith(
          nodePosition: 0,
          connectorTheme: TimelineTheme.of(context).connectorTheme.copyWith(
            thickness: 1.0,
          ),
          indicatorTheme: TimelineTheme.of(context).indicatorTheme.copyWith(
            size: 10.0,
            position: 0.5,
          ),
        ),
        builder: TimelineTileBuilder(
          indicatorBuilder: (_, index) =>
          !isEdgeIndex(index) ? Indicator.outlined(borderWidth: 1.0) : null,
          startConnectorBuilder: (_, index) => Connector.solidLine(),
          endConnectorBuilder: (_, index) => Connector.solidLine(),
          contentsBuilder: (_, index) {
            if (isEdgeIndex(index)) {
              return null;
            }

            return Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Text(messages[index - 1].toString()),
            );
          },
          itemExtentBuilder: (_, index) => isEdgeIndex(index) ? 10.0 : 30.0,
          nodeItemOverlapBuilder: (_, index) =>
          isEdgeIndex(index) ? true : null,
          itemCount: messages.length + 2,
        ),
      ),
    );
  }
}

class _DeliveryProcesses extends StatelessWidget {
  _DeliveryProcesses({Key? key, required this.processes})
      : super(key: key);

  final List<_DeliveryProcess> processes;
  var utils = AppUtils();
  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: TextStyle(
        color: Color(0xff9b9b9b),
        fontSize: 12.5,
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: FixedTimeline.tileBuilder(
          theme: TimelineThemeData(
            nodePosition: 0,
            color: Color(0xff989898),
            indicatorTheme: IndicatorThemeData(
              position: 0,
              size: 20.0,
            ),
            connectorTheme: ConnectorThemeData(
              thickness: 2.5,
            ),
          ),
          builder: TimelineTileBuilder.connected(
            connectionDirection: ConnectionDirection.before,
            itemCount: processes.length,
            contentsBuilder: (_, index) {
              return Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      processes[index].nameShow,
                      style: utils.boldLabelStyle(blackColor),
                    ),
                    _InnerTimeline(messages: processes[index].messages),
                  ],
                ),
              );
            },
            indicatorBuilder: (_, index) {
              if (processes[index].isCompleted) {
                return DotIndicator(
                  color: Color(0xff66c97f),
                  child: Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 18.0,
                  ),
                  size: 46,
                );
              } else {
                return  DotIndicator(
                  color: grayColor,
                  child: Icon(
                    index == 0 ? Icons.access_alarms : index == 1 ? CupertinoIcons.hare_fill : index == 2 ? CupertinoIcons.train_style_one :  CupertinoIcons.hand_thumbsup_fill,
                    color: blackColor.withOpacity(0.6),
                    size: 24.0,
                  ),
                  size: 46,
                );
              }
            },
            connectorBuilder: (_, index, ___) => SolidLineConnector(
              color: processes[index].isCompleted ? Color(0xff66c97f) : null,
            ),
          ),
        ),
      ),
    );
  }
}

class _OnTimeBar extends StatelessWidget {
   _OnTimeBar({Key? key, required this.driver}) : super(key: key);

  final CartModel driver;
  var utils = AppUtils();
  OrderController orderController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        MaterialButton(
          onPressed: () {
            if(driver.status < 2){
              orderController.changeStatus(-1, driver);
              Get.snackbar("Success", "Order cancel successfully");
              Get.back();
            }else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Can't cancel the order"),
                ),
              );
            }
          },
          elevation: 0,
          shape: StadiumBorder(),
          color: driver.status < 2 ? Color(0xffff0000) : grayColor,
          textColor: Colors.white,
          child: Text('Cancel' , style: utils.labelStyle(driver.status < 2 ? whiteColor : blackColor.withOpacity(0.6)),),
        ),
      ],
    );
  }
}

class _DeliveryProcess {
  const _DeliveryProcess(
      this.nameShow,this.name, {
        this.messages = const [],
      });

  const _DeliveryProcess.complete(this.nameShow)
      : this.name = 'Done',
        this.messages = const [];

  final String name;
  final String nameShow;
  final List<_DeliveryMessage> messages;

  bool get isCompleted => name == 'Done';
}

class _DeliveryMessage {
  const _DeliveryMessage(this.createdAt, this.message);

  final String createdAt; // final DateTime createdAt;
  final String message;

  @override
  String toString() {
    return '$createdAt $message';
  }
}