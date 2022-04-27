import 'dart:io';

import 'package:connectsaleorder/AppConstants/Constants.dart';
import 'package:connectsaleorder/GetXController/BrandController.dart';
import 'package:connectsaleorder/GetXController/CategoryController.dart';
import 'package:connectsaleorder/GetXController/CheckAdminController.dart';
import 'package:connectsaleorder/GetXController/ItemController.dart';
import 'package:connectsaleorder/GetXController/SubCategoryController.dart';
import 'package:connectsaleorder/Models/BrandModel.dart';
import 'package:connectsaleorder/Models/CategoryModel.dart';
import 'package:connectsaleorder/Models/ItemModel.dart';
import 'package:connectsaleorder/Models/SubCategoryModel.dart';

import 'package:connectsaleorder/Utils/AppUtils.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class AddProductScreen extends StatefulWidget{
  @override
  _AddProductScreen createState() => _AddProductScreen();

}

class _AddProductScreen extends State<AddProductScreen>{
  var utils = AppUtils();
  var searchController = TextEditingController();
  var nameController = TextEditingController();
  var nameTwoController = TextEditingController();
  var priceController = TextEditingController();
  var descriptionController = TextEditingController();
  var discountController = TextEditingController();
  var unitController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  var isDiscounted = false;
  var isNewArrival = false;
  var isTopDeal = false;
  List<File> _images = [];
  FirebaseStorage _storage = FirebaseStorage.instance;
  List<String> selectedImages = [];
  //ItemModel? selectedProductModel = Get.arguments;
  int selectedDiscount = 0;
  BrandModel? selectedBrand;
  CategoryModel? selectedCategory;
  SubCategoryModel? selectedSubCategory;
  SubCategoryController _subCategoryController = Get.find();
  BrandController _brandController = Get.find();
  CategoryController _categoryController = Get.find();
  var discountTypes = ["Percent (%)" , "Flat"];
  ItemModel? itemModel = Get.arguments;
  CheckAdminController checkAdminController = Get.find();



  Future _getImage() async {
    var image =
    await _picker.pickImage(source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      _images.add(File(image!.path));
    });
  }


  Future<String> uploadPic(file) async {
    var random = DateTime.now();
    //Create a reference to the location you want to upload to in firebase
    firebase_storage.Reference reference =
    _storage.ref().child("images/$random.JPG");
    //Upload the file to firebase
    firebase_storage.UploadTask uploadTask = reference.putFile(file);
    var downUrl = await (await uploadTask).ref.getDownloadURL();
    return downUrl;
  }

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
          color: whiteColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15 , vertical: 16),
                decoration: BoxDecoration(
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
                    Expanded(child: Text(itemModel == null ? "Add Product" : "Update Product" , style: utils.headingStyle(whiteColor),)),
                  ],
                ),
              ),
              Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      width: Get.width,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 15 , vertical: 12),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12),),
                                color: checkAdminController.system.mainColor
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 80,
                                  child: ListView(
                                    scrollDirection: Axis.horizontal,
                                    children: [
                                      GestureDetector(
                                        onTap: (){
                                          _getImage();
                                        },
                                        child: Container(
                                          width: 80,
                                          height: 80,
                                          clipBehavior: Clip.antiAliasWithSaveLayer,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(12),
                                              color: whiteColor
                                          ),
                                          child: Icon(CupertinoIcons.add , color: checkAdminController.system.mainColor, size: 42,),
                                        ),
                                      ),
                                      for(var i = 0 ; i < (itemModel != null && itemModel!.images.isNotEmpty ? itemModel!.images.length : 0); i++)
                                        Container(
                                            width: 80,
                                            height: 80,
                                            margin: EdgeInsets.symmetric(horizontal: 5),
                                            clipBehavior: Clip.antiAliasWithSaveLayer,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(12),
                                                color: whiteColor
                                            ),
                                            child: Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                Image.network(itemModel!.images[i], width: 80, height: 80,),
                                                Positioned(
                                                    top: 2,
                                                    child: GestureDetector(
                                                      onTap: (){
                                                        itemModel!.images.removeAt(i);
                                                        setState(() {
                                                        });
                                                      },
                                                      child: Container(
                                                        width: 24,
                                                        height: 24,
                                                        decoration: BoxDecoration(
                                                            shape: BoxShape.circle,
                                                            color: blackColor.withOpacity(0.3)
                                                        ),
                                                        child: Center(child: Icon(CupertinoIcons.xmark_circle_fill, color: whiteColor,size: 18,)),
                                                      ),
                                                    ))
                                              ],
                                            )
                                        ),
                                      for(var i = 0 ; i < _images.length; i++)
                                        Container(
                                            width: 80,
                                            height: 80,
                                            margin: EdgeInsets.symmetric(horizontal: 5),
                                            clipBehavior: Clip.antiAliasWithSaveLayer,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(12),
                                                color: whiteColor
                                            ),
                                            child: Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                Image.file(_images[i], width: 80, height: 80,),
                                                Positioned(
                                                    top: 2,
                                                    child: GestureDetector(
                                                      onTap: (){
                                                        _images.removeAt(i);
                                                        setState(() {
                                                        });
                                                      },
                                                      child: Container(
                                                        width: 24,
                                                        height: 24,
                                                        decoration: BoxDecoration(
                                                            shape: BoxShape.circle,
                                                            color: blackColor.withOpacity(0.3)
                                                        ),
                                                        child: Center(child: Icon(CupertinoIcons.xmark_circle_fill, color: whiteColor,size: 18,)),
                                                      ),
                                                    ))
                                              ],
                                            )
                                        ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 8,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(CupertinoIcons.info , color: whiteColor, size: 18,),
                                    SizedBox(width: 12,),
                                    Expanded(child: Text("Add at least one image of product!" , style: utils.xSmallLabelStyle(whiteColor),))
                                  ],
                                )
                              ],
                            ),
                          ),
                          SizedBox(height: 16,),
                          GestureDetector(
                            onTap : (){
                              _presentBottomSheet(1);
                            },
                            child: Container(
                              width: Get.width-40,
                              padding: EdgeInsets.symmetric(horizontal: 10,vertical: 12),
                              decoration: BoxDecoration(
                                  color: whiteColor,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: checkAdminController.system.mainColor , width: 1.0)
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(CupertinoIcons.circle_grid_hex, color: checkAdminController.system.mainColor, size: 20,),
                                  SizedBox(width: 12,),
                                  Expanded(child: Text(selectedCategory != null ? "${selectedCategory!.name}":"Select Category" , style: utils.labelStyle(blackColor),)),
                                  SizedBox(width: 12,),
                                  Icon(CupertinoIcons.chevron_down, color: checkAdminController.system.mainColor, size: 20,),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 10,),
                          GestureDetector(
                            onTap : (){
                              if(selectedCategory != null){
                                _presentBottomSheet(2);
                              }else{
                                Get.snackbar("Error", "Select the category First!");
                              }
                            },
                            child: Container(
                              width: Get.width-40,
                              padding: EdgeInsets.symmetric(horizontal: 10,vertical: 12),
                              decoration: BoxDecoration(
                                  color: whiteColor,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: checkAdminController.system.mainColor , width: 1.0)
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(CupertinoIcons.circle_grid_hex, color: checkAdminController.system.mainColor, size: 20,),
                                  SizedBox(width: 12,),
                                  Expanded(child: Text(selectedSubCategory != null ? "${selectedSubCategory!.name}":"Select Subcategory" , style: utils.labelStyle(blackColor),)),
                                  SizedBox(width: 12,),
                                  Icon(CupertinoIcons.chevron_down, color: checkAdminController.system.mainColor, size: 20,),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 10,),
                          GestureDetector(
                            onTap  : (){
                              _presentBottomSheet(0);
                            },
                            child: Container(
                              width: Get.width-40,
                              padding: EdgeInsets.symmetric(horizontal: 10,vertical: 12),
                              decoration: BoxDecoration(
                                  color: whiteColor,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: checkAdminController.system.mainColor , width: 1.0)
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(CupertinoIcons.rectangle_grid_1x2, color: checkAdminController.system.mainColor, size: 20,),
                                  SizedBox(width: 12,),
                                  Expanded(child: Text(selectedBrand != null ? "${selectedBrand!.name}":"Select Brand" , style: utils.labelStyle(blackColor),)),
                                  SizedBox(width: 12,),
                                  Icon(CupertinoIcons.chevron_down, color: checkAdminController.system.mainColor, size: 20,),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 10,),
                          Container(
                            child: utils.textField(whiteColor, CupertinoIcons.doc, checkAdminController.system.mainColor, null, null, blackColor, "Name", blackColor.withOpacity(0.4), checkAdminController.system.mainColor, 1.0, Get.width-40, false, nameController),
                          ),
                          SizedBox(height: 10,),
                          Container(
                            child: utils.textField(whiteColor, CupertinoIcons.doc, checkAdminController.system.mainColor, null, null, blackColor, "Second Name", blackColor.withOpacity(0.4), checkAdminController.system.mainColor, 1.0, Get.width-40, false, nameTwoController),
                          ),
                          SizedBox(height: 10,),
                          Container(
                            child: utils.textField(whiteColor, CupertinoIcons.tag, checkAdminController.system.mainColor, null, null, blackColor, "Sale Rate", blackColor.withOpacity(0.4), checkAdminController.system.mainColor, 1.0, Get.width-40, false, priceController, isNumber: "yes"),
                          ),
                          SizedBox(height: 10,),
                          Container(
                            child: utils.textField(whiteColor, CupertinoIcons.upload_circle, checkAdminController.system.mainColor, null, null, blackColor, "Unit", blackColor.withOpacity(0.4), checkAdminController.system.mainColor, 1.0, Get.width-40, false, unitController),
                          ),
                          SizedBox(height: 10,),
                          Container(
                            child: utils.textField(whiteColor, CupertinoIcons.circle, checkAdminController.system.mainColor, null, null, blackColor, "Description", blackColor.withOpacity(0.4), checkAdminController.system.mainColor, 1.0, Get.width-40, false, descriptionController, multiline: true),
                          ),
                          if(isDiscounted) SizedBox(height: 10,),
                          if(isDiscounted) GestureDetector(
                            onTap : (){
                              _presentBottomSheet(3);
                            },
                            child: Container(
                              width: Get.width-40,
                              padding: EdgeInsets.symmetric(horizontal: 10,vertical: 12),
                              decoration: BoxDecoration(
                                  color: whiteColor,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: checkAdminController.system.mainColor , width: 1.0)
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(CupertinoIcons.percent, color: checkAdminController.system.mainColor, size: 20,),
                                  SizedBox(width: 12,),
                                  Expanded(child: Text(selectedDiscount == 0 ? "Percent (%) ":"Flat" , style: utils.labelStyle(blackColor),)),
                                  SizedBox(width: 12,),
                                  Icon(CupertinoIcons.chevron_down, color: checkAdminController.system.mainColor, size: 20,),
                                ],
                              ),
                            ),
                          ),
                          if(isDiscounted) SizedBox(height: 10,),
                          if(isDiscounted) Container(
                            child: utils.textField(whiteColor, CupertinoIcons.percent, checkAdminController.system.mainColor, null, null, blackColor, "Discount Value", blackColor.withOpacity(0.4), checkAdminController.system.mainColor, 1.0, Get.width-40, false, discountController , isNumber: "true"),
                          ),
                          SizedBox(height: 10,),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(width: 12,),
                                  Checkbox(
                                    value: isDiscounted, onChanged: (bool? value) {
                                    isDiscounted = value != null ? value : false;
                                    setData();
                                  },
                                    activeColor: checkAdminController.system.mainColor,
                                  ),
                                  Expanded(child: Text("Discount" , style: utils.smallLabelStyle(blackColor),))
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(width: 12,),
                                  Checkbox(
                                    value: isNewArrival, onChanged: (bool? value) {
                                    isNewArrival = value != null ? value : false;
                                    setData();
                                  },
                                    activeColor: checkAdminController.system.mainColor,
                                  ),
                                  Expanded(child: Text("New Arrival" , style: utils.smallLabelStyle(blackColor),))
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(width: 12,),
                                  Checkbox(
                                    value: isTopDeal, onChanged: (bool? value) {
                                    isTopDeal = value != null ? value : false;
                                    setData();
                                  },
                                    activeColor: checkAdminController.system.mainColor,
                                  ),
                                  Expanded(child: Text("Top Deal" , style: utils.smallLabelStyle(blackColor),))
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 20,),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 20),
                            child: utils.button(checkAdminController.system.mainColor, itemModel != null ? "Update" :"Add", whiteColor, checkAdminController.system.mainColor, 1.0, (){
                              if(selectedCategory == null){
                                Get.snackbar("Error", "Category is required!");
                                return;
                              }else if(selectedSubCategory == null){
                                Get.snackbar("Error", "Subcategory is required!");
                                return;
                              }
                              else if(nameController.text.isEmpty){
                                Get.snackbar("Error", "Name is required!");
                                return;
                              }else if(priceController.text.isEmpty){
                                Get.snackbar("Error", "Sale Rate is required!");
                                return;
                              }else if(unitController.text.isEmpty){
                                Get.snackbar("Error", "Unit is required!");
                                return;
                              }else if(unitController.text.length < 3){
                                Get.snackbar("Error", "Unit is too short!");
                                return;
                              }else if(isDiscounted){
                                if(discountController.text.isEmpty){
                                  Get.snackbar("Error", "Discount Value is required!");
                                  return;
                                }else if(selectedDiscount == 0){
                                  if(int.parse(discountController.text) > 100) {
                                    Get.snackbar(
                                        "Error", "Discount Value is invalid!");
                                    return;
                                  }
                                }
                              }else if(itemModel == null && _images.length <= 0) {
                                Get.snackbar("Error", "Image is required!");
                                return;
                              }

                              if(itemModel != null) {
                                updateProduct();
                              }else{
                                addProduct();
                              }
                            }),
                          ),
                          SizedBox(height: 12,)
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


  void addProduct() async {
    ItemController productController = Get.find();
    EasyLoading.show(status: "Loading...");

    if (_images.isNotEmpty) {
      for(var  i = 0 ; i < _images.length; i++)
        selectedImages.add(await uploadPic(_images[i]));
    }

    var code = productController.lastItem == null ? 1 : int.parse(productController.lastItem!.code)+1;
    var child = code < 10 ? "0000000$code" : code < 100 ? "000000$code" : code < 1000 ? "00000$code" : code < 10000 ? "0000$code" : code < 100000 ? "000$code" : code < 1000000 ? "00$code" : code < 10000000 ? "0$code" : "$code";

    ItemModel productModel = new ItemModel(code: "$child",images: selectedImages, name: nameController.text.toString(), type: "${selectedCategory!.code}",typeName: "${selectedCategory!.name}", salesRate: double.parse(priceController.text.toString()), style: "${selectedSubCategory!.code}",styleName: "${selectedSubCategory!.name}", mUnit: "${unitController.text}", purchaseRate: 0, stock: [], deliveryApplyItem: 0, deliveryPrice: 0, freeDeliveryItems: -1, maxDeliveryTime: 0, minDeliveryTime: 0, parentId: null);
    if(selectedBrand != null) {
      productModel.brandCode = selectedBrand!.code;
      productModel.brandName = selectedBrand!.name;
    }

    if(isDiscounted){
      productModel.disCont = true;
      productModel.discountType = selectedDiscount == 0 ? "%" : "";
      productModel.discountVal = double.parse(discountController.text.toString());
    }else{
      productModel.disCont = false;
      productModel.discountType = selectedDiscount == 0 ? "%" : "";
      productModel.discountVal = 0.0;
    }
    productModel.discountedPrice = 0.0;
    productModel.discountedPriceW = 0.0;
    productModel.sMRate = 0.0;
    productModel.color = "";
    productModel.commission = 0.0;
    productModel.companyFix = 0.0;
    productModel.groupFix = 0.0;
    productModel.lockRate = 0.0;
    productModel.isTopDeal = isTopDeal;
    productModel.isNewArrival = isNewArrival;
    productModel.description = descriptionController.text.isNotEmpty ? descriptionController.text.toString() : "";



    FirebaseDatabase database = FirebaseDatabase(databaseURL: databaseUrl);
    
    database.setPersistenceEnabled(true);
    database.setPersistenceCacheSizeBytes(10000000);
    DatabaseReference reference = database.reference();
    reference.child(itemRef).child("$child").set(
        productModel.toJson());
    EasyLoading.dismiss();
    Get.back();
    Get.snackbar("Success", "Product Added!");
  }

  void updateProduct() async {
    ItemController productController = Get.find();
    EasyLoading.show(status: "Loading...");

    if (_images.isNotEmpty) {
      for(var  i = 0 ; i < _images.length; i++)
        selectedImages.add(await uploadPic(_images[i]));
    }

    itemModel!.images.addAll(selectedImages);
    itemModel!.name = nameController.text;
    itemModel!.description = descriptionController.text;
    itemModel!.type = "${selectedCategory!.code}";
    itemModel!.typeName = "${selectedCategory!.name}";
    itemModel!.salesRate = double.parse(priceController.text.toString());
    itemModel!.style = "${selectedSubCategory!.code}";
    itemModel!.styleName = "${selectedSubCategory!.name}";
    itemModel!.mUnit = "${unitController.text}";
    itemModel!.images.removeAt(0);
    if(selectedBrand != null) {
      itemModel!.brandCode = selectedBrand!.code;
      itemModel!.brandName = selectedBrand!.name;
    }

    if(isDiscounted){
      itemModel!.disCont = true;
      itemModel!.discountType = selectedDiscount == 0 ? "%" : "";
      itemModel!.discountVal = double.parse(discountController.text.toString());
    }else{
      itemModel!.disCont = false;
      itemModel!.discountType = selectedDiscount == 0 ? "%" : "";
      itemModel!.discountVal = 0.0;
    }
    double discountedP = 0;
    if(itemModel!.disCont! && itemModel!.discountType == "%"){
      discountedP = itemModel!.salesRate - ((itemModel!.salesRate * itemModel!.discountVal!)/100);
    }else{
      discountedP = itemModel!.salesRate - itemModel!.discountVal!;
    }
    itemModel!.discountedPrice = discountedP;
    itemModel!.isTopDeal = isTopDeal;
    itemModel!.isNewArrival = isNewArrival;



    FirebaseDatabase database = FirebaseDatabase(databaseURL: databaseUrl);
    
    database.setPersistenceEnabled(true);
    database.setPersistenceCacheSizeBytes(10000000);
    DatabaseReference reference = database.reference();
    await reference.child(itemRef).child("${itemModel!.code}").update(
        itemModel!.toJson());
    EasyLoading.dismiss();
    Get.back();
    Get.snackbar("Success", "Updated");
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    EasyLoading.dismiss();
  }

  void setData() {
    setState(() {
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(itemModel != null){
      print(itemModel!.toJson());
      nameController.text = itemModel!.name;
      try {
        selectedSubCategory =
            _subCategoryController.subCategoriesAll.singleWhere((
                element) => element.code == itemModel!.style);
        selectedCategory =
            _categoryController.getCategory(selectedSubCategory!.type);
        selectedBrand =
        itemModel!.brandCode == null ? null : _brandController.brands
            .singleWhere((element) => element.code == itemModel!.brandCode);
      }catch(e){

      }
      priceController.text = "${itemModel!.salesRate}";
      unitController.text = itemModel!.mUnit;
      descriptionController.text = itemModel!.description ?? '';
      isDiscounted = itemModel!.disCont ?? false;
      if(isDiscounted){
        selectedDiscount = itemModel!.discountType == "%" ? 0 : 1;
        discountController.text = "${itemModel!.discountVal ?? 0}";
      }
      isNewArrival = itemModel!.isNewArrival;
      isTopDeal = itemModel!.isTopDeal;
      setState(() {
      });
    }
  }

  void _presentBottomSheet(int type) {
    searchController.clear();
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0), topRight: Radius.circular(20)),
      ),
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (BuildContext context1, StateSetter setState) {
          return Container(
            height: Get.size.height - 30,
            color: Colors.transparent,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: Get.width,
                  child: Stack(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(20),
                                topLeft: Radius.circular(20)),
                            color: whiteColor),
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          type == 0
                              ? "Select Brand"
                              : type == 1 ? "Select Category"
                              : type == 2 ? "Select SubCategory"
                              : "Discount",
                          style: utils.boldLabelStyle(blackColor),
                        ),
                      ),
                      Positioned(top: 10 ,right : 10,child: GestureDetector(onTap : (){Navigator.pop(context);},child: Icon(CupertinoIcons.xmark_circle_fill , color: checkAdminController.system.mainColor, size: 24,))),
                    ],
                  ),
                ),
                if(type != 3) Container(
                  color: whiteColor,
                  width: Get.width,
                  padding: EdgeInsets.symmetric(horizontal: 20 , vertical: 10),
                  child: utils.textField(whiteColor, CupertinoIcons.search, checkAdminController.system.mainColor, null, null, blackColor, "Search...", blackColor.withOpacity(0.4), checkAdminController.system.mainColor, 1.0, Get.width-40, false, searchController , onTextChange: (value){
                    setState((){});
                  }),
                ),
                Expanded(
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                      decoration: BoxDecoration(color: whiteColor),
                      child: SingleChildScrollView(
                        child: type == 0 ? GetBuilder<BrandController>(id: "0",builder: (brandController){
                          return Wrap(
                            children:[
                              for(var  i = 0; i < brandController.brands.length; i++)
                                brandController.brands[i].name.toLowerCase().contains(searchController.text.toLowerCase())?
                                utils.selectionItem(brandController.brands[i].name,brandController.brands[i].code, selectedBrand == null ? false : selectedBrand!.code == brandController.brands[i].code, (){
                                  selectedBrand = brandController.brands[i];
                                  Navigator.pop(context);
                                  setData();
                                }) : Container()
                            ],
                          );
                        })
                            : type == 1 ? GetBuilder<CategoryController>(id: "0",builder: (categoryController){
                          return Wrap(
                            children:[
                              for(var  i = 0; i < categoryController.categories.length; i++)
                                categoryController.categories[i].name.toLowerCase().contains(searchController.text.toLowerCase())?
                                utils.selectionItem(categoryController.categories[i].name,categoryController.categories[i].code, selectedCategory == null ? false : selectedCategory!.code == categoryController.categories[i].code, (){
                                  selectedCategory = categoryController.categories[i];
                                  _subCategoryController.getSubCategories(categoryController.categories[i].code);
                                  selectedSubCategory = null;
                                  Navigator.pop(context);
                                  setData();
                                }) : Container()
                            ],
                          );
                        })
                            : type == 2 ? GetBuilder<SubCategoryController>(id: "0",builder: (subCategoryController){
                          return Wrap(
                            children:[
                              for(var  i = 0; i < subCategoryController.subCategories.length; i++)
                                subCategoryController.subCategories[i].name.toLowerCase().contains(searchController.text.toLowerCase())?
                                utils.selectionItem(subCategoryController.subCategories[i].name,subCategoryController.subCategories[i].code, selectedSubCategory == null ? false : selectedSubCategory!.code == subCategoryController.subCategories[i].code, (){
                                  selectedSubCategory = subCategoryController.subCategories[i];
                                  Navigator.pop(context);
                                  setData();
                                }) : Container()
                            ],
                          );
                        }):
                        Wrap(
                          children:[
                            for(var  i = 0; i < discountTypes.length; i++)
                              discountTypes[i].toLowerCase().contains(searchController.text.toLowerCase())?
                              utils.selectionItem(discountTypes[i],"", selectedDiscount == i, (){
                                selectedDiscount = i;
                                Navigator.pop(context);
                                setData();
                              }) : Container()
                          ],
                        ),
                      ),
                    )),
              ],
            ),
          );
        },
      ),
    );
  }
}