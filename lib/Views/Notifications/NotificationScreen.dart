import 'package:connectsaleorder/AppConstants/Constants.dart';
import 'package:connectsaleorder/GetXController/CheckAdminController.dart';
import 'package:connectsaleorder/Utils/AppUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../AppConstants/TimeAgo.dart';
import '../../GetXController/ItemController.dart';
import '../../GetXController/NotificationController.dart';
import '../../Utils/ItemWidgetStyle5.dart';
import '../../Widgets/Blogs/BlogWidget.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreen createState() => _NotificationScreen();
}

class _NotificationScreen extends State<NotificationScreen> {
  var utils = AppUtils();
  var page = 1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CheckAdminController>(
        id: "0",
        builder: (checkAdminController) {
          return GetBuilder<NotificationController>(
              id: "0",
              builder: (notificationController) {
                return Container(
                  width: Get.width,
                  padding: EdgeInsets.all(12),
                  child: SingleChildScrollView(
                    child: notificationController.notifications.length > 0
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              for (var i = 0;
                                  i <
                                      notificationController
                                          .notifications.length;
                                  i++)
                                Container(
                                  width: Get.width,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: 60,
                                            height: 60,
                                            child: Center(
                                              child: Icon(
                                                CupertinoIcons.bell_fill,
                                                color: checkAdminController
                                                    .system.mainColor,
                                                size: 26,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                              child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "${notificationController.notifications[i].title}",
                                                style: utils
                                                    .boldLabelStyle(blackColor),
                                              ),
                                              Text(
                                                "${notificationController.notifications[i].body}",
                                                style: utils.xSmallLabelStyle(
                                                    blackColor
                                                        .withOpacity(0.8)),
                                              ),
                                            ],
                                          )),
                                          Text(
                                            "${TimeAgo.timeAgoSinceDate(DateFormat("yyyy-MM-ddTHH:mm:ss").format(DateTime.fromMillisecondsSinceEpoch(notificationController.notifications[i].timestamp)))}",
                                            style: utils.xSmallLabelStyle(
                                                blackColor.withOpacity(0.6)),
                                          )
                                        ],
                                      ),
                                      Container(
                                        width: Get.width,
                                        height: 1,
                                        color: grayColor,
                                      ),
                                      SizedBox(
                                        height: 4,
                                      )
                                    ],
                                  ),
                                )
                            ],
                          )
                        : Container(
                            width: Get.width,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(height: 50,),
                                Icon(
                                  CupertinoIcons.bell_slash,
                                  color: checkAdminController.system.mainColor,
                                  size: 42,
                                ),
                                SizedBox(
                                  height: 12,
                                ),
                                Text(
                                  "No notification available",
                                  style: utils.smallLabelStyle(blackColor),
                                )
                              ],
                            ),
                          ),
                  ),
                );
              });
        });
  }
}
