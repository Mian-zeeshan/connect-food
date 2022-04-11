
import 'package:connectsaleorder/AppConstants/Constants.dart';
import 'package:connectsaleorder/GetXController/CategoryController.dart';
import 'package:connectsaleorder/GetXController/CheckAdminController.dart';
import 'package:connectsaleorder/GetXController/SubCategoryController.dart';
import 'package:connectsaleorder/Models/CategoryModel.dart';
import 'package:connectsaleorder/Utils/AppUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ManageSubCategoryScreen extends StatefulWidget{
  @override
  _ManageSubCategoryScreen createState() => _ManageSubCategoryScreen();

}

class _ManageSubCategoryScreen extends State<ManageSubCategoryScreen>{
  var utils = AppUtils();
  var searchController = TextEditingController();

  CategoryModel categoryModel = Get.arguments;
  var lengthSubCategories = 12;
  CheckAdminController checkAdminController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    Expanded(child: Text("Manage Subcategories", style: utils.headingStyle(whiteColor),)),
                  ],
                ),
              ),
              Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      width: Get.width,
                      height: Get.height,
                      padding: EdgeInsets.symmetric(horizontal: 12 , vertical: 12),
                      color: whiteColor,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 8,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Expanded(child: Text("${categoryModel.name}", style: utils.boldLabelStyle(blackColor),)),
                                      GestureDetector(
                                          onTap: (){
                                            Get.toNamed(addSubCategoryRoute);
                                          },
                                          child: Icon(CupertinoIcons.add , color: checkAdminController.system.mainColor, size: 18,)
                                      ),
                                      SizedBox(width: 6,),
                                      GestureDetector(
                                          onTap: (){
                                            lengthSubCategories = 12;
                                            Get.toNamed(addSubCategoryRoute);
                                          },
                                          child: Text("Add Subcategory", style: utils.smallLabelStyle(checkAdminController.system.mainColor),)),
                                    ],
                                  ),
                                  SizedBox(height: 16,),
                                  Container(
                                    width: Get.width,
                                    child: GetBuilder<SubCategoryController>(id: "0" , builder: (subCategoriesController){
                                      lengthSubCategories = lengthSubCategories < 12 ? 12:  lengthSubCategories;
                                      lengthSubCategories = subCategoriesController.subCategories.length > lengthSubCategories ? lengthSubCategories : subCategoriesController.subCategories.length;
                                      return Wrap(
                                        alignment: WrapAlignment.spaceBetween,
                                        children: [
                                          for(var i = 0; i < lengthSubCategories; i++)
                                            GestureDetector(
                                              onTap: (){

                                              },
                                              child: Container(
                                                width: Get.width * 0.4,
                                                height: 160,
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
                                                      width: Get.width * 0.4,
                                                      height: 140,
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
                                                            child: Image.network(subCategoriesController.subCategories[i].image != null ? subCategoriesController.subCategories[i].image! :"https://s7d2.scene7.com/is/image/Caterpillar/CM20200212-04866-33d60", fit: BoxFit.cover,),
                                                          ),
                                                          GestureDetector(
                                                            onTap: (){
                                                              Get.toNamed(addSubCategoryRoute , arguments: subCategoriesController.subCategories[i]);
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
                                                    Expanded(child: Text("${subCategoriesController.subCategories[i].name}" , style: utils.xSmallLabelStyle(blackColor),textAlign: TextAlign.center,overflow: TextOverflow.ellipsis, maxLines: 2,)),
                                                  ],
                                                ),
                                              ),
                                            )
                                        ],
                                      );
                                    },),
                                  ),
                                  SizedBox(height: 10,),
                                    GetBuilder<SubCategoryController>(id: "0", builder: (subCController){
                                    return subCController.subCategories.length > lengthSubCategories ? GestureDetector(
                                    onTap: (){
                                      lengthSubCategories = lengthSubCategories + 12;
                                      setData();
                                    },
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text("Load More Subcategories", style: utils.xSmallLabelStyle(Colors.blue),),
                                      ],
                                    ),
                                  ) : Container();}),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
              )
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