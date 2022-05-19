import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectsaleorder/AppConstants/TimeAgo.dart';
import 'package:connectsaleorder/GetXController/CheckAdminController.dart';
import 'package:connectsaleorder/Utils/AppUtils.dart';
import 'package:connectsaleorder/Views/Blogs/BlogDetailScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../AppConstants/Constants.dart';

class BlogWidget extends StatefulWidget{
  bool isViewAll;
  BlogWidget(this.isViewAll);
  @override
  _BlogWidget createState() => _BlogWidget();
}

class _BlogWidget extends State<BlogWidget>{
  CheckAdminController checkAdminController = Get.find();
  var utils = AppUtils();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      margin: EdgeInsets.only(bottom: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: Get.width,
            child: AspectRatio(
              aspectRatio: 16/7,
              child: Container(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: checkAdminController.system.mainColor
                ),
                child: CachedNetworkImage(
                  imageUrl: "https://www.agric.wa.gov.au/sites/gateway/files/EweandLamb%202.jpg",
                  errorWidget: (_,__,___) => Image.asset("Assets/Images/logo.png"),
                  placeholder: (_,__) => SpinKitChasingDots(color: whiteColor,),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SizedBox(height: 4,),
          Text("Posted ${TimeAgo.timeAgoSinceDate(DateFormat("yyyy-MM-ddTHH:mm:ss").format(DateTime.fromMillisecondsSinceEpoch(DateTime.now().millisecondsSinceEpoch)))}", style: utils.xSmallLabelStyle(blackColor.withOpacity(0.5)),),
          SizedBox(height: 6,),
          Text("Mastitis in sheep | Agriculture and Food", style: utils.boldLabelStyle(blackColor),),
          SizedBox(height: 12,),
          Text("""Subclinical mastitis may be difficult to identify. The udder may be firm and hot and lambs of affected ewes may have poor growth rates with occasional deaths in twin lambs.
In clinical mastitis, the infection rapidly progresses over several days to blackening of the udder, which feels cold to the touch due to the death of udder tissue (often called 'black mastitis'). The ewe may appear lame or continually lie down and the lambs become hollow and depressed. Lambs may die from lack of milk or from a bacterial infection from consuming infected milk. Poor weather or inadequate nutrition may trigger the progression from subclinical to clinical mastitis.
Producers should consider humane euthanasia of ewes with black mastitis that do not show an immediate response to veterinary treatment, and culling of recovered ewes after weaning as they may have permanent damage to one or more teats.

How can I prevent mastitis?
Good ewe nutrition and providing a clean lambing paddock are important factors in reducing the incidence of mastitis.
Maintain good hygiene if sheep are housed, and avoid prolonged periods in muddy yards and laneways during the first six weeks of lactation.
Depending on the severity of the mastitis, ewes may have permanent damage to the udder after an infection. Culling these ewes after their lambs have been weaned will help to prevent a recurring problem with mastitis in the flock.
                    """, style: utils.xSmallLabelStyle(blackColor),maxLines: widget.isViewAll ? null : 8,),
          if(!widget.isViewAll) InkWell(
            onTap: (){
              Get.to(()=> BlogDetailScreen());
            },
            child: Container(
              width: Get.width,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: blackColor.withOpacity(0.5)),
                  color: whiteColor,
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 12,
                        spreadRadius: 12,
                        color: grayColor,
                        offset: Offset(0,2)
                    )
                  ]
              ),
              padding: EdgeInsets.all(8),
              child: Center(child: Text("View All", style: utils.boldSmallLabelStyle(checkAdminController.system.mainColor),)),
            ),
          )
        ],
      ),
    );
  }

}