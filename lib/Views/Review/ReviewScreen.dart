import 'package:connectsaleorder/AppConstants/Constants.dart';
import 'package:connectsaleorder/AppConstants/TimeAgo.dart';
import 'package:connectsaleorder/GetXController/CheckAdminController.dart';
import 'package:connectsaleorder/GetXController/ItemController.dart';
import 'package:connectsaleorder/GetXController/UserController.dart';
import 'package:connectsaleorder/Models/ItemModel.dart';
import 'package:connectsaleorder/Models/ReviewModel.dart';
import 'package:connectsaleorder/Utils/AppUtils.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

class ReviewScreen extends StatefulWidget{
  ItemModel itemModel;
  ReviewScreen(this.itemModel);
  @override
  _ReviewScreen createState() => _ReviewScreen(itemModel);

}

class _ReviewScreen extends State<ReviewScreen>{
  var utils = AppUtils();
  ItemModel itemModel;
  _ReviewScreen(this.itemModel);
  UserController userController = Get.find();
  double rate = 1;
  String comment = "";
  CheckAdminController checkAdminController = Get.find();

  var fiveStart = 0;
  var fourStart = 0;
  var threeStart = 0;
  var twoStart = 0;
  var oneStart = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: Get.width,
        height: Get.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: GetBuilder<ItemController>(id: "0", builder: (itemController){
              fiveStart = 0;
              fourStart = 0;
              threeStart = 0;
              twoStart = 0;
              oneStart = 0;
              for(var r in itemController.reviews){
                if(r.rating > 4){
                  fiveStart++;
                }else if(r.rating > 3){
                  fourStart++;
                }else if(r.rating > 2){
                  threeStart++;
                }else if(r.rating > 1){
                  twoStart++;
                }else if(r.rating > 0){
                  oneStart++;
                }
              }
              return itemController.reviews.isNotEmpty ? ListView(
                scrollDirection: Axis.vertical,
                children: [
                  SizedBox(height: 12,),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Text("Reviews" , style: utils.boldLabelStyle(blackColor),),
                  ),
                  SizedBox(height: 6,),
                  Container(
                    width: Get.width,
                    padding: EdgeInsets.symmetric(horizontal: 12,vertical: 12),
                    margin: EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: whiteColor,
                        boxShadow: [
                          BoxShadow(
                              spreadRadius: 2,
                              blurRadius: 2,
                              offset: Offset(0,2),
                              color: grayColor.withOpacity(0.5)
                          )
                        ]
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(CupertinoIcons.star_fill , size: 24, color: Colors.amber,),
                                SizedBox(width: 2,),
                                Text("${itemModel.rating}" , style: utils.xLHeadingStyle(blackColor),)
                              ],
                            )),
                            Text("Overall ${itemController.reviews.length} Reviews" , style: utils.xSmallLabelStyle(blackColor.withOpacity(0.4)),)
                          ],
                        ),
                        SizedBox(height: 12,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text("5 Star" , style: utils.boldSmallLabelStyle(blackColor),),
                            SizedBox(width: 16,),
                            RatingBar(
                              initialRating: 5,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              itemSize: 18,
                              ratingWidget: RatingWidget(
                                full: Icon(CupertinoIcons.star_fill , color: Colors.amber,),
                                half: Icon(CupertinoIcons.star_lefthalf_fill , color: Colors.amber,),
                                empty: Icon(CupertinoIcons.star , color: Colors.amber,),
                              ),
                              itemPadding: EdgeInsets.symmetric(horizontal: 3.0),
                              onRatingUpdate: (rating) {
                                print(rating);
                              },
                              ignoreGestures: true,
                            ),
                            SizedBox(width: 16,),
                            Text("($fiveStart)" , style: utils.xSmallLabelStyle(blackColor.withOpacity(0.4)),),
                          ],
                        ),
                        SizedBox(height: 6,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text("4 Star" , style: utils.boldSmallLabelStyle(blackColor),),
                            SizedBox(width: 16,),
                            RatingBar(
                              initialRating: 4,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              itemSize: 18,
                              ratingWidget: RatingWidget(
                                full: Icon(CupertinoIcons.star_fill , color: Colors.amber,),
                                half: Icon(CupertinoIcons.star_lefthalf_fill , color: Colors.amber,),
                                empty: Icon(CupertinoIcons.star , color: Colors.amber,),
                              ),
                              itemPadding: EdgeInsets.symmetric(horizontal: 3.0),
                              onRatingUpdate: (rating) {
                                print(rating);
                              },
                              ignoreGestures: true,
                            ),
                            SizedBox(width: 16,),
                            Text("($fourStart)" , style: utils.xSmallLabelStyle(blackColor.withOpacity(0.4)),),
                          ],
                        ),SizedBox(height: 6,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text("3 Star" , style: utils.boldSmallLabelStyle(blackColor),),
                            SizedBox(width: 16,),
                            RatingBar(
                              initialRating: 3,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              itemSize: 18,
                              ratingWidget: RatingWidget(
                                full: Icon(CupertinoIcons.star_fill , color: Colors.amber,),
                                half: Icon(CupertinoIcons.star_lefthalf_fill , color: Colors.amber,),
                                empty: Icon(CupertinoIcons.star , color: Colors.amber,),
                              ),
                              itemPadding: EdgeInsets.symmetric(horizontal: 3.0),
                              onRatingUpdate: (rating) {
                                print(rating);
                              },
                              ignoreGestures: true,
                            ),
                            SizedBox(width: 16,),
                            Text("($threeStart)" , style: utils.xSmallLabelStyle(blackColor.withOpacity(0.4)),),
                          ],
                        ),SizedBox(height: 6,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text("2 Star" , style: utils.boldSmallLabelStyle(blackColor),),
                            SizedBox(width: 16,),
                            RatingBar(
                              initialRating: 2,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              itemSize: 18,
                              ratingWidget: RatingWidget(
                                full: Icon(CupertinoIcons.star_fill , color: Colors.amber,),
                                half: Icon(CupertinoIcons.star_lefthalf_fill , color: Colors.amber,),
                                empty: Icon(CupertinoIcons.star , color: Colors.amber,),
                              ),
                              itemPadding: EdgeInsets.symmetric(horizontal: 3.0),
                              onRatingUpdate: (rating) {
                                print(rating);
                              },
                              ignoreGestures: true,
                            ),
                            SizedBox(width: 16,),
                            Text("($twoStart)" , style: utils.xSmallLabelStyle(blackColor.withOpacity(0.4)),),
                          ],
                        ),SizedBox(height: 6,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text("1 Star" , style: utils.boldSmallLabelStyle(blackColor),),
                            SizedBox(width: 16,),
                            RatingBar(
                              initialRating: 1,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              itemSize: 18,
                              ratingWidget: RatingWidget(
                                full: Icon(CupertinoIcons.star_fill , color: Colors.amber,),
                                half: Icon(CupertinoIcons.star_lefthalf_fill , color: Colors.amber,),
                                empty: Icon(CupertinoIcons.star , color: Colors.amber,),
                              ),
                              itemPadding: EdgeInsets.symmetric(horizontal: 3.0),
                              onRatingUpdate: (rating) {
                                print(rating);
                              },
                              ignoreGestures: true,
                            ),
                            SizedBox(width: 16,),
                            Text("($oneStart)" , style: utils.xSmallLabelStyle(blackColor.withOpacity(0.4)),),
                          ],
                        ),
                      ],
                    ),
                  ),
                  for(var review in itemController.reviews)
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: whiteColor,
                          boxShadow: [
                            BoxShadow(
                                spreadRadius: 2,
                                blurRadius: 2,
                                offset: Offset(0,2),
                                color: grayColor.withOpacity(0.5)
                            )
                          ]
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: checkAdminController.system.mainColor
                            ),
                            child: Image.network(review.image, fit: BoxFit.cover,),
                          ),
                          SizedBox(width: 8,),
                          Expanded(child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text("${review.name}", style: utils.boldLabelStyle(blackColor),),
                                  Text("${TimeAgo.timeAgoSinceDate(DateFormat("yyyy-MM-ddTHH:mm:ss").format(DateTime.fromMillisecondsSinceEpoch(review.createdAt)))}", style: utils.xSmallLabelStyle(blackColor),),
                                ],
                              ),
                              Text("${review.comment}", style: utils.smallLabelStyle(blackColor.withOpacity(0.4)),),
                              RatingBar(
                                initialRating: review.rating,
                                direction: Axis.horizontal,
                                allowHalfRating: true,
                                itemCount: 5,
                                itemSize: 14,
                                ratingWidget: RatingWidget(
                                  full: Icon(CupertinoIcons.star_fill , color: Colors.amber,),
                                  half: Icon(CupertinoIcons.star_lefthalf_fill , color: Colors.amber,),
                                  empty: Icon(CupertinoIcons.star , color: Colors.amber,),
                                ),
                                itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                                onRatingUpdate: (rating) {
                                  print(rating);
                                },
                                ignoreGestures: true,
                              ),
                            ],
                          ))
                        ],
                      ),
                    )
                ],
              ) : Container(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Lottie.asset('Assets/lottie/searchempty.json'),
                      Text(
                        "No Review Available",
                        style: utils.labelStyle(blackColor.withOpacity(0.5)),
                      ),
                    ]),
              );
            },)),
            SizedBox(height: 10,),
          ],
        )
      ),
    );
  }
}