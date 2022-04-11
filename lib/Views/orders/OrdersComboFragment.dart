
import 'package:connectsaleorder/AppConstants/Constants.dart';
import 'package:connectsaleorder/GetXController/CheckAdminController.dart';
import 'package:connectsaleorder/Utils/AppUtils.dart';
import 'package:connectsaleorder/Views/orders/OrdersFragment.dart';
import 'package:connectsaleorder/Views/orders/CartScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrdersComboFragment extends StatefulWidget {
  @override
  _OrdersComboFragment createState() => _OrdersComboFragment();
}

class _OrdersComboFragment extends State<OrdersComboFragment> {
  var utils = AppUtils();
  CheckAdminController checkAdminController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0),
        child: AppBar(
          backgroundColor: checkAdminController.system.mainColor,
        ),
      ),
      body: SafeArea(
        child: Container(
          width: Get.width,
          height: Get.height,
          child: DefaultTabController(
            length: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  color: checkAdminController.system.mainColor,
                  child: TabBar(
                    indicatorColor: whiteColor,
                    tabs: [
                      Tab(
                        text: "Cart",
                      ),
                      Tab(
                        text: "Orders",
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: TabBarView(children: [
                    CartScreen(),
                    OrderFragment(true)
                  ]),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
