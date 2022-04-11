import 'package:connectsaleorder/AppConstants/Constants.dart';
import 'package:connectsaleorder/GetXController/CategoryController.dart';
import 'package:connectsaleorder/GetXController/CheckAdminController.dart';
import 'package:connectsaleorder/GetXController/SubCategoryController.dart';
import 'package:connectsaleorder/Models/CustomerModel.dart';
import 'package:connectsaleorder/Utils/AppUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ManageCategoryScreen extends StatefulWidget{
  bool fromWeb;
  ManageCategoryScreen({this.fromWeb = false});
  @override
  _ManageCategoryScreen createState() => _ManageCategoryScreen();

}

class _ManageCategoryScreen extends State<ManageCategoryScreen>{
  var utils = AppUtils();
  var searchController = TextEditingController();
  SubCategoryController _subCategoryController = Get.find();
  CategoryController __categoryController = Get.find();
  CustomerModel? selectedCModel;
  var lengthCategories = 12;
  CheckAdminController checkAdminController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          color: whiteColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if(!widget.fromWeb) Container(
                padding: EdgeInsets.symmetric(horizontal: 15 , vertical: 16),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12),),
                    color: checkAdminController.system.mainColor
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap : (){
                        setState(() {
                          Get.back();
                        });
                      },
                      child: Icon(CupertinoIcons.arrow_left, size: 24, color: whiteColor,),
                    ),
                    SizedBox(width: 20,),
                    Expanded(child: Text("Manage Category" , style: utils.headingStyle(whiteColor),)),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12 , vertical: 12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 8,),
                        utils.textField(whiteColor, null, null,  CupertinoIcons.search, blackColor.withOpacity(0.6), blackColor, "Search...", blackColor.withOpacity(0.5), blackColor.withOpacity(0.6), 2.0, Get.width-12, false, searchController , onTextChange: (val){
                          lengthCategories = 12;
                          if(val != null)
                            __categoryController.filterCategory(val);
                          else
                            __categoryController.filterCategory("");
                        }),
                        SizedBox(height: 8,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(child: Text("All Categories", style: utils.boldLabelStyle(blackColor),)),
                            GestureDetector(
                                onTap: (){
                                  Get.toNamed(addCategoryRoute);
                                },
                                child: Icon(CupertinoIcons.add , color: checkAdminController.system.mainColor, size: 18,)
                            ),
                            SizedBox(width: 6,),
                            GestureDetector(
                                onTap: () async {
                                  lengthCategories = 12;
                                  Get.toNamed(addCategoryRoute);
                                },
                                child: Text("Add Category", style: utils.smallLabelStyle(checkAdminController.system.mainColor),)),
                          ],
                        ),
                        SizedBox(height: 16,),
                        Container(
                          width: Get.width,
                          child: GetBuilder<CategoryController>(id: "0" , builder: (categoryController){
                            categoryController.filterCategories.sort((a,b)=> b.code.compareTo(a.code));
                            lengthCategories = categoryController.filterCategories.length > lengthCategories ? lengthCategories : categoryController.filterCategories.length;
                            return Wrap(
                              alignment: WrapAlignment.spaceBetween,
                              children: [
                                for(var i = 0; i < lengthCategories; i++)
                                  GestureDetector(
                                    onTap: (){
                                      categoryController.updateCategory(categoryController.filterCategories[i].code);
                                      _subCategoryController.getSubCategories(categoryController.filterCategories[i].code);
                                      Get.toNamed(manageSubCategoryRoute, arguments: categoryController.filterCategories[i]);
                                    },
                                    child: Container(
                                      width: GetPlatform.isWeb ? Get.width * 0.15 : Get.width * 0.4,
                                      height: GetPlatform.isWeb ? Get.width * 0.15 : 160,
                                      margin: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8),
                                          color: whiteColor
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: GetPlatform.isWeb ? Get.width * 0.15 : Get.width * 0.4,
                                            height: GetPlatform.isWeb ? Get.width * 0.12 : 140,
                                            clipBehavior: Clip.antiAliasWithSaveLayer,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(8),
                                                color: checkAdminController.system.mainColor
                                            ),
                                            child: Stack(
                                              children: [
                                                Container(
                                                  width: Get.width * 0.4,
                                                  height: 140,
                                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(8),
                                                      color: checkAdminController.system.mainColor
                                                  ),
                                                  child: Image.network(categoryController.filterCategories[i].image != null ? categoryController.filterCategories[i].image! :"https://s7d2.scene7.com/is/image/Caterpillar/CM20200212-04866-33d60", fit: GetPlatform.isWeb ? BoxFit.contain : BoxFit.cover,),
                                                ),
                                                GestureDetector(
                                                  onTap: (){
                                                    Get.toNamed(addCategoryRoute , arguments: categoryController.filterCategories[i]);
                                                  },
                                                  child: Container(
                                                    padding: EdgeInsets.symmetric(horizontal: 6 , vertical: 12),
                                                    margin: EdgeInsets.symmetric(horizontal: 10),
                                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                                    decoration: BoxDecoration(
                                                        color: checkAdminController.system.mainColor,
                                                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30))
                                                    ),
                                                    child: Icon(CupertinoIcons.pen, color: whiteColor, size: 24,),
                                                  ),
                                                ),

                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 5,),
                                          Expanded(child: Text("${categoryController.filterCategories[i].name}" , style: utils.xSmallLabelStyle(blackColor),textAlign: TextAlign.center,overflow: TextOverflow.ellipsis, maxLines: 2,)),
                                        ],
                                      ),
                                    ),
                                  )
                              ],
                            );
                          },),
                        ),
                        SizedBox(height: 10,),
                        GetBuilder<CategoryController>(id: "0", builder: (categoryController){
                          return categoryController.filterCategories.length > lengthCategories ? GestureDetector(
                            onTap: (){
                              lengthCategories = lengthCategories + 12;
                              setData();
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text("Load More Categories", style: utils.xSmallLabelStyle(Colors.blue),),
                              ],
                            ),
                          ) : Container();
                        },)
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void setData() {
    setState(() {
    });
  }

}