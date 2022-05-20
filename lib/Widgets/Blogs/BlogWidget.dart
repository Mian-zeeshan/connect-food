import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectsaleorder/AppConstants/TimeAgo.dart';
import 'package:connectsaleorder/GetXController/CheckAdminController.dart';
import 'package:connectsaleorder/Models/BlogModel.dart';
import 'package:connectsaleorder/Utils/AppUtils.dart';
import 'package:connectsaleorder/Views/Blogs/BlogDetailScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../AppConstants/Constants.dart';
import 'package:html/parser.dart';

class BlogWidget extends StatefulWidget{
  bool isViewAll;
  BlogModel blogModel;
  BlogWidget(this.blogModel, this.isViewAll);
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
                  imageUrl: widget.blogModel.image,
                  errorWidget: (_,__,___) => Image.asset("Assets/Images/logo.png"),
                  placeholder: (_,__) => SpinKitChasingDots(color: whiteColor,),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SizedBox(height: 4,),
          Text("Posted ${TimeAgo.timeAgoSinceDate(DateFormat("yyyy-MM-ddTHH:mm:ss").format(DateTime.fromMillisecondsSinceEpoch(widget.blogModel.timestamp)))}", style: utils.xSmallLabelStyle(blackColor.withOpacity(0.5)),),
          SizedBox(height: 6,),
          Text("${widget.blogModel.title}", style: utils.boldLabelStyle(blackColor),),
          SizedBox(height: 12,),
          if(!widget.isViewAll) Text("""${_parseHtmlString(widget.blogModel.body)}
                    """, style: utils.xSmallLabelStyle(blackColor),maxLines: widget.isViewAll ? null : 8,),
          if(widget.isViewAll) Html(data: "${widget.blogModel.body}",),

          if(!widget.isViewAll) InkWell(
            onTap: (){
              Get.to(()=> BlogDetailScreen(widget.blogModel));
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

  String _parseHtmlString(String htmlS) {
    final document = parse(htmlS);
    final String parsedString = parse(document.body!.text).documentElement!.text;
    return parsedString;
  }

}