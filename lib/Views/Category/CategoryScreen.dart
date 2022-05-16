import 'package:connectsaleorder/AppConstants/Constants.dart';
import 'package:connectsaleorder/GetXController/BrandController.dart';
import 'package:connectsaleorder/GetXController/CategoryController.dart';
import 'package:connectsaleorder/GetXController/CheckAdminController.dart';
import 'package:connectsaleorder/GetXController/DrawerCustomController.dart';
import 'package:connectsaleorder/GetXController/ItemController.dart';
import 'package:connectsaleorder/GetXController/SubCategoryController.dart';
import 'package:connectsaleorder/GetXController/UserController.dart';
import 'package:connectsaleorder/Models/CustomerModel.dart';
import 'package:connectsaleorder/Utils/AppUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../GetXController/CartController.dart';
import '../../Utils/ItemWidget.dart';
import '../../Utils/ItemWidgetStyle2.dart';
import '../../Utils/ItemWidgetStyle3.dart';
import '../../Utils/ItemWidgetStyle4.dart';
import '../../Utils/ItemWidgetStyle5.dart';

class CategoryScreen extends StatefulWidget{
  bool fromNav;
  CategoryScreen({this.fromNav = true});
  @override
  _CategoryScreen createState() => _CategoryScreen();

}

class _CategoryScreen extends State<CategoryScreen>{
  var utils = AppUtils();
  var searchController = TextEditingController();
  SubCategoryController _sCategoryController = Get.find();
  CategoryController _cController = Get.find();
  BrandController _bController = Get.find();
  ScrollController _scrollController = ScrollController();
  ScrollController _scrollControllerSub = ScrollController();
  List<TextEditingController> controllers = [];
  DrawerCustomController drawerCustomController = Get.find();
  UserController userController = Get.find();
  CustomerModel? selectedCModel;
  var lengthCategories = 10;
  var lengthSubCategories = 6;
  var lengthBrands = 8;
  var selectedCategoryName = "";
  var totalSubCategories = 0;
  var totalBrands = 0;
  CheckAdminController checkAdminController = Get.find();
  var selectedSub = 0;


  @override
  void initState() {
    if(_cController.categories.isNotEmpty)
      selectedCategoryName = selectedCategoryName == "" ? _cController.categories[0].name : selectedCategoryName;
    totalBrands = _bController.brands.length;
    totalSubCategories = _sCategoryController.subCategories.length;
    // TODO: implement initState
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        lengthCategories = lengthCategories + 3;
        setData();
      }
    });
    setData();
  }
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
          color: grayColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.only(left: widget.fromNav ? 8 : 0 , right: 8, top: widget.fromNav ? 12 : 6, bottom: widget.fromNav ? 12 :6),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12),),
                    color: checkAdminController.system.mainColor
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if(!widget.fromNav) IconButton(
                        onPressed: (){
                          Get.back();
                        },
                        icon: Icon(CupertinoIcons.arrow_left, color: whiteColor, size: 24,)
                    ),
                    Expanded(child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: whiteColor
                      ),
                      child: TextField(
                        onTap: () async {
                          await Get.toNamed(searchRoute);
                          FocusManager.instance.primaryFocus?.unfocus();
                        },
                        decoration: InputDecoration.collapsed(hintText: "Search"),
                        obscureText: false,
                        maxLines: 1,
                      ),
                    )),
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
                            GetBuilder<CartController>(id: "0", builder: (cartController){
                              return cartController.myCart.totalItems > 0 ? Positioned(
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
                                        child: Text("${cartController.myCart.totalItems}" , style: utils.xSmallLabelStyle(whiteColor),)
                                    ),
                                  )
                              ) : Container();}),
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
              SizedBox(height: 8,),
              Expanded(child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                      flex: 2,
                      child: Container(
                        height: Get.height,
                        child: GetBuilder<CategoryController>(id: "0" , builder: (categoryController){
                          lengthCategories = categoryController.categories.length > lengthCategories ? lengthCategories : categoryController.categories.length;
                          if(categoryController.categories.isNotEmpty)
                            selectedCategoryName = selectedCategoryName == "" ? categoryController.categories[0].name : selectedCategoryName;
                          return ListView(
                            controller: _scrollController,
                            scrollDirection: Axis.vertical,
                            children: [
                              SizedBox(height: 12,),
                              Text("Categories" , style: utils.boldLabelStyle(blackColor),),
                              for(var i = 0; i < lengthCategories; i++)
                                GestureDetector(
                                  onTap: (){
                                    selectedSub = 0;
                                    setData();
                                    selectedCategoryName = categoryController.categories[i].name;
                                    categoryController.updateCategory(categoryController.categories[i].code);
                                    _sCategoryController.getSubCategories(categoryController.categories[i].code);
                                    lengthSubCategories = 6;
                                  },
                                  child: Container(
                                      width: Get.width,
                                      height: 80,
                                      margin: EdgeInsets.symmetric(vertical: 2),
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      decoration: BoxDecoration(
                                          color: whiteColor,
                                          borderRadius: BorderRadius.only(topRight: Radius.circular(8),bottomRight: Radius.circular(8))
                                      ),
                                      child: Stack(
                                        alignment: Alignment.centerLeft,
                                        children: [
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Container(
                                                width: Get.width,
                                                height: 60,
                                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                                decoration: BoxDecoration(
                                                    color: whiteColor
                                                ),
                                                child: Image.network(categoryController.categories[i].image != null ? categoryController.categories[i].image! :"https://s7d2.scene7.com/is/image/Caterpillar/CM20200212-04866-33d60", fit: BoxFit.contain,),
                                              ),
                                              SizedBox(height: 5,),
                                              Expanded(child: Text("${categoryController.categories[i].name}" , style: utils.xSmallLabelStyle(blackColor),textAlign: TextAlign.center,overflow: TextOverflow.ellipsis, maxLines: 1,)),
                                            ],
                                          ),
                                          if(categoryController.selectedCategory == i) Container(
                                            width: 5,
                                            height: 80,
                                            clipBehavior: Clip.antiAliasWithSaveLayer,
                                            decoration: BoxDecoration(
                                                color: checkAdminController.system.mainColor,
                                                borderRadius: BorderRadius.only(topRight: Radius.circular(12), bottomRight: Radius.circular(12))
                                            ),
                                          ),
                                        ],
                                      )
                                  ),
                                )
                            ],
                          );
                        },),
                      )
                  ),
                  Expanded(
                      flex: 6,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        height: Get.height,
                        color: grayColor.withOpacity(0.4),
                        child: SingleChildScrollView(
                            controller: _scrollControllerSub,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 12,),
                                if(selectedSub == 0) Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Sub Categories" , style: utils.boldLabelStyle(blackColor),),
                                    SizedBox(height: 6,),
                                    GetBuilder<SubCategoryController>(id: "0" , builder: (subCategoryController){
                                      lengthSubCategories = subCategoryController.subCategories.length > lengthSubCategories ? lengthSubCategories : subCategoryController.subCategories.length;
                                      totalSubCategories = subCategoryController.subCategories.length;
                                      return lengthSubCategories > 0 ? Container(
                                        width: Get.width,
                                        padding: EdgeInsets.symmetric(vertical: 8 , horizontal: 4),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(12),
                                            color: whiteColor
                                        ),
                                        child: Wrap(
                                          alignment: WrapAlignment.spaceEvenly,
                                          children: [
                                            for(var i = 0; i < lengthSubCategories; i++)
                                              GestureDetector(
                                                onTap: (){
                                                  selectedSub = -1;
                                                  setData();
                                                  subCategoryController.updateSubCategory(i, true);

                                                  // drawerCustomController.setDrawer("", 1);
                                                },
                                                child: Container(
                                                  width: 60,
                                                  height: 85,
                                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                                  margin: EdgeInsets.symmetric(horizontal: 5, vertical: 4),
                                                  decoration: BoxDecoration(
                                                      color: whiteColor
                                                  ),
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      Container(
                                                        width: 70,
                                                        height: 50,
                                                        clipBehavior: Clip.antiAliasWithSaveLayer,
                                                        decoration: BoxDecoration(
                                                            color: whiteColor
                                                        ),
                                                        child: Image.network(subCategoryController.subCategories[i].image != null ? subCategoryController.subCategories[i].image! :"https://s7d2.scene7.com/is/image/Caterpillar/CM20200212-04866-33d60", fit: BoxFit.cover,),
                                                      ),
                                                      SizedBox(height: 5,),
                                                      Expanded(child: Text("${subCategoryController.subCategories[i].name}" , style: utils.xSmallLabelStyle(blackColor),textAlign: TextAlign.center,overflow: TextOverflow.ellipsis, maxLines: 2,)),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            if(lengthSubCategories < totalSubCategories) Container(
                                              width: Get.width,
                                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  GestureDetector(
                                                    onTap : (){
                                                      lengthSubCategories = lengthSubCategories + 3;
                                                      setData();
                                                    },
                                                    child: Container(
                                                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                                      decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(8),
                                                          color: whiteColor
                                                      ),
                                                      child: Text("Load More", style: utils.xSmallLabelStyle(checkAdminController.system.mainColor),),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ):Container();
                                    },),
                                  ],
                                ),
                                if(selectedSub != 0) Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Products" , style: utils.boldLabelStyle(blackColor),),
                                    SizedBox(height: 6,),
                                    GetBuilder<ItemController>(id: "0" , builder: (itemController){
                                      return itemController.isLoadingSub ? Container(
                                        width: Get.width,
                                        height: Get.height,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            SpinKitChasingDots(color: checkAdminController.system.mainColor,)
                                          ],
                                        ),
                                      ) :itemController.itemsLengthSub > 0 ? Container(
                                        width: Get.width,
                                        child: GridView.builder(
                                          primary: false,
                                          shrinkWrap: true,
                                          itemCount: itemController.itemModelsSub.length,
                                          gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisSpacing: 10,
                                              mainAxisSpacing: 10,
                                              crossAxisCount: 2,
                                              childAspectRatio: 2 / 3.5),
                                          itemBuilder: (context, i) {
                                            return /*checkAdminController.system.itemGridStyle.code == "001" ? ItemWidget(itemController.itemModelsSub[i]) : checkAdminController.system.itemGridStyle.code == "002" ? ItemWidgetStyle2(itemController.itemModelsSub[i]) : checkAdminController.system.itemGridStyle.code == "003" ? ItemWidgetStyle3(itemController.itemModelsSub[i]): checkAdminController.system.itemGridStyle.code == "004" ? ItemWidgetStyle4(itemController.itemModelsSub[i]) : checkAdminController.system.itemGridStyle.code == "005" ?*/ ItemWidgetStyle5(itemController.itemModelsSub[i],null) /*: ItemWidget(itemController.itemModelsSub[i])*/;
                                          },
                                        ),
                                      ) : Container(
                                        width: Get.width,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Lottie.asset("Assets/lottie/searchempty.json"),
                                            SizedBox(height: 12,),
                                            Text("No product available", style: utils.labelStyle(grayColor),)
                                          ],
                                        ),
                                      );
                                    },),
                                    SizedBox(height: 20,),
                                  ],
                                ),

                                //todo Brands to be shift
                                /*Text("Brands" , style: utils.boldLabelStyle(blackColor),),
                                SizedBox(height: 12,),
                                GetBuilder<BrandController>(id: "0" , builder: (brandController){
                                  lengthBrands = brandController.brands.length > lengthBrands ? lengthBrands : brandController.brands.length;
                                  totalBrands = brandController.brands.length;
                                  return Container(
                                    width: Get.width,
                                    padding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: whiteColor,
                                    ),
                                    child: Wrap(
                                      alignment: WrapAlignment.spaceEvenly,
                                      children: [
                                        for(var i = 0; i < lengthBrands; i++)
                                          GestureDetector(
                                            onTap: (){
                                              brandController.updateBrand(brandController.brands[i].code);
                                            },
                                            child: Container(
                                              width: 60,
                                              height: 85,
                                              clipBehavior: Clip.antiAliasWithSaveLayer,
                                              margin: EdgeInsets.symmetric(horizontal: 5, vertical: 4),
                                              decoration: BoxDecoration(
                                                  color: whiteColor
                                              ),
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    width: 70,
                                                    height: 50,
                                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                                    decoration: BoxDecoration(
                                                        color: whiteColor
                                                    ),
                                                    child: Image.network( brandController.brands[i].image != null ? brandController.brands[i].image! :"https://s7d2.scene7.com/is/image/Caterpillar/CM20200212-04866-33d60", fit: BoxFit.cover,),
                                                  ),
                                                  SizedBox(height: 5,),
                                                  Expanded(child: Text("${brandController.brands[i].name}" , style: utils.xSmallLabelStyle(blackColor),textAlign: TextAlign.center,overflow: TextOverflow.ellipsis, maxLines: 2,)),
                                                ],
                                              ),
                                            ),
                                          ),
                                        if(lengthBrands < totalBrands) Container(
                                          width: Get.width,
                                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              GestureDetector(
                                                onTap : (){
                                                  lengthBrands = lengthBrands + 4;
                                                  setData();
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(8),
                                                      color: whiteColor
                                                  ),
                                                  child: Text("Load More", style: utils.xSmallLabelStyle(checkAdminController.system.mainColor),),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },),*/
                              ],
                            )
                        ),
                      )
                  ),
                ],
              ),)
            ],
          )
        ),
      ),
    );
  }

  void setData() {
    setState(() {
    });
  }

}

/*
Container(
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("All Categories", style: utils.boldLabelStyle(blackColor),),
                      GestureDetector(
                          onTap: (){
                            lengthCategories = 6;
                            setData();
                          },
                          child: Text("Collapsed All", style: utils.xSmallLabelStyle(blackColor.withOpacity(0.4)),)),
                    ],
                  ),
                  SizedBox(height: 16,),
                  Container(
                    width: Get.width,
                    child: GetBuilder<CategoryController>(id: "0" , builder: (categoryController){
                      lengthCategories = categoryController.categories.length > lengthCategories ? lengthCategories : categoryController.categories.length;
                      return Wrap(
                        alignment: WrapAlignment.spaceBetween,
                        children: [
                          for(var i = 0; i < lengthCategories; i++)
                            GestureDetector(
                              onTap: (){
                                categoryController.updateCategory(categoryController.categories[i].code);
                                _sCategoryController.getSubCategories(categoryController.categories[i].code);
                                lengthSubCategories = 6;
                              },
                              child: Container(
                                width: 80,
                                height: 120,
                                margin: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: categoryController.selectedCategory == i ? checkAdminController.system.mainColor.withOpacity(0.5) : whiteColor
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 80,
                                      height: 80,
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8),
                                          color: checkAdminController.system.mainColor
                                      ),
                                      child: Image.network(categoryController.categories[i].image != null ? categoryController.categories[i].image! :"https://s7d2.scene7.com/is/image/Caterpillar/CM20200212-04866-33d60", fit: BoxFit.cover,),
                                    ),
                                    SizedBox(height: 5,),
                                    Expanded(child: Text("${categoryController.categories[i].name}" , style: utils.xSmallLabelStyle(blackColor),textAlign: TextAlign.center,overflow: TextOverflow.ellipsis, maxLines: 2,)),
                                  ],
                                ),
                              ),
                            )
                        ],
                      );
                    },),
                  ),
                  SizedBox(height: 10,),
                  GestureDetector(
                    onTap: (){
                      lengthCategories = lengthCategories + 3;
                      setData();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("Load More Categories", style: utils.xSmallLabelStyle(Colors.blue),),
                      ],
                    ),
                  ),
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("Sub Categories", style: utils.boldLabelStyle(blackColor),),
                      GestureDetector(
                          onTap: (){
                            lengthSubCategories = 6;
                            setData();
                          },
                          child: Text("Collapsed All", style: utils.xSmallLabelStyle(blackColor.withOpacity(0.4)),)),
                    ],
                  ),
                  SizedBox(height: 16,),
                  Container(
                    width: Get.width,
                    child: GetBuilder<SubCategoryController>(id: "0" , builder: (subCategoryController){
                      lengthSubCategories = subCategoryController.subCategories.length > lengthSubCategories ? lengthSubCategories : subCategoryController.subCategories.length;
                      return Wrap(
                        alignment: WrapAlignment.spaceBetween,
                        children: [
                          for(var i = 0; i < lengthSubCategories; i++)
                            GestureDetector(
                              onTap: (){
                                subCategoryController.updateSubCategory(i);
                              },
                              child: Container(
                                width: 80,
                                height: 120,
                                margin: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: subCategoryController.selectedSubCategory == i ? checkAdminController.system.mainColor.withOpacity(0.5) : whiteColor
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 80,
                                      height: 80,
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: checkAdminController.system.mainColor
                                      ),
                                      child: Image.network(/*subCategoryController.subCategories[i].image != null ? subCategoryController.subCategories[i].image! :*/"https://s7d2.scene7.com/is/image/Caterpillar/CM20200212-04866-33d60", fit: BoxFit.cover,),
                                    ),
                                    SizedBox(height: 5,),
                                    Expanded(child: Text("${subCategoryController.subCategories[i].name}" , style: utils.xSmallLabelStyle(blackColor),textAlign: TextAlign.center,overflow: TextOverflow.ellipsis, maxLines: 2,)),
                                  ],
                                ),
                              ),
                            )
                        ],
                      );
                    },),
                  ),
                  SizedBox(height: 10,),
                  GestureDetector(
                    onTap: (){
                      lengthSubCategories = lengthSubCategories + 3;
                      setData();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("Load More Sub Categories", style: utils.xSmallLabelStyle(Colors.blue),),
                      ],
                    ),
                  ),
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("Brands", style: utils.boldLabelStyle(blackColor),),
                      GestureDetector(
                          onTap: (){
                            lengthBrands = 6;
                            setData();
                          },
                          child: Text("Collapsed All", style: utils.xSmallLabelStyle(blackColor.withOpacity(0.4)),)),
                    ],
                  ),
                  SizedBox(height: 16,),
                  Container(
                    width: Get.width,
                    child: GetBuilder<BrandController>(id: "0" , builder: (brandController){
                      lengthBrands = brandController.brands.length > lengthBrands ? lengthBrands :brandController.brands.length;
                      return Wrap(
                        alignment: WrapAlignment.spaceBetween,
                        children: [
                          for(var i = 0; i < lengthBrands; i++)
                            GestureDetector(
                              onTap: (){
                                brandController.updateBrand(brandController.brands[i].code);
                              },
                              child: Container(
                                width: 80,
                                height: 120,
                                margin: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: brandController.selectedBrand == i ? checkAdminController.system.mainColor.withOpacity(0.5) : whiteColor
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 80,
                                      height: 80,
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: checkAdminController.system.mainColor
                                      ),
                                      child: Image.network(/*subCategoryController.subCategories[i].image != null ? subCategoryController.subCategories[i].image! :*/"https://s7d2.scene7.com/is/image/Caterpillar/CM20200212-04866-33d60", fit: BoxFit.cover,),
                                    ),
                                    SizedBox(height: 5,),
                                    Expanded(child: Text("${brandController.brands[i].name}" , style: utils.xSmallLabelStyle(blackColor),textAlign: TextAlign.center,overflow: TextOverflow.ellipsis, maxLines: 2,)),
                                  ],
                                ),
                              ),
                            )
                        ],
                      );
                    },),
                  ),
                  SizedBox(height: 10,),
                  GestureDetector(
                    onTap: (){
                      lengthBrands = lengthBrands + 3;
                      setData();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("Load More Brands", style: utils.xSmallLabelStyle(Colors.blue),),
                      ],
                    ),
                  ),
                  SizedBox(height: 10,),
                ],
              ),
            ),
          ),
          Container(
            width: Get.width,
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: utils.button(checkAdminController.system.mainColor, "Go to products", whiteColor, checkAdminController.system.mainColor, 1.0, (){
             Get.toNamed(homeFragmentRoute);
            }),
          )
        ],
      ),
    )
*/