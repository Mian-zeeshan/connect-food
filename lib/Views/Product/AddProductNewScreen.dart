import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

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
import 'package:connectsaleorder/Views/Category/AddBrandScreen.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:im_stepper/stepper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import 'EditorPage.dart';


class AddProductNewScreen extends StatefulWidget {
  @override
  _AddProductNewScreen createState() => _AddProductNewScreen();
}

class _AddProductNewScreen extends State<AddProductNewScreen> {
  CheckAdminController checkAdminController = Get.find();
  var activeStep = 0;
  var utils = AppUtils();
  ItemModel addProductModel = Get.arguments??ItemModel(status: 0, code: "", name: "", type: "", salesRate: 0, style: "", mUnit: "", images: [], purchaseRate: 0, stock: [], deliveryApplyItem: 0, deliveryPrice: 0, freeDeliveryItems: -1, maxDeliveryTime: 0, minDeliveryTime: 0, parentId: null, sold: 0);
  CategoryModel? selectedCategoryItem;
  BrandModel? selectedBrand;
  SubCategoryModel? selectedSubCategoryItem;
  List<Specs> specs = [];
  List<ProductAdons> addons = [];
  List<PColors> pColors = [];
  List<PSizes> pSizes = [];
  List<PColors> pColorsDefault = [];
  PColors? selectedPColor;
  PSizes? selectedPSize;
  List<File> _productImages = [];
  List<PlatformFile> _productImagesWeb = [];
  var discountTypes = ["Percent (%)" , "Flat"];

  ImagePicker _picker = ImagePicker();
  var isNewArrival = false;
  var isTopDeal = false;

  var nameController = TextEditingController();
  var priceController = TextEditingController();
  var wholeSalePriceController = TextEditingController();
  var discPriceController = TextEditingController();
  var stockController = TextEditingController();
  var gstController = TextEditingController();

  /*
  todo implement later
  var skuController = TextEditingController();
  var videoLinkController = TextEditingController();
  var tagsController = TextEditingController();
  var brandController = TextEditingController();
  */

  var ingredientController = TextEditingController();
  var unitController = TextEditingController();
  var sDescriptionController = TextEditingController();
  var descriptionController = TextEditingController();
  var pDeliveryPriceController = TextEditingController();
  var pDeliveryApplyController = TextEditingController();
  var pDeliveryFreeController = TextEditingController();
  var pMaxDeliveryController = TextEditingController();
  var pMinDeliveryController = TextEditingController();
  var psTitleController = TextEditingController();
  var psDescriptionController = TextEditingController();
  var aNameController = TextEditingController();
  var aPriceController = TextEditingController();
  var sNameController = TextEditingController();
  var sPriceController = TextEditingController();
  var sWPriceController = TextEditingController();
  var isExist = false;
  int selectedDiscount = 0;
  CategoryController _categoryController = Get.find();
  SubCategoryController _subCategoryController = Get.find();
  ItemController __itemController = Get.find();
  var shortDLength = 0;
  var longDLength = 0;
  @override
  void initState() {
    super.initState();
    __itemController.getLastItems();
    _categoryController.getCategories();
    pColorsDefault.add(PColors(color: "Black", colorId: "000000"));
    pColorsDefault.add(PColors(color: "white", colorId: "ffffff"));
    pColorsDefault.add(PColors(color: "red", colorId: "ff0000"));
    pColorsDefault.add(PColors(color: "blue", colorId: "00ff00"));
    pColorsDefault.add(PColors(color: "green", colorId: "0000ff"));


    if(addProductModel.code != ""){
      nameController.text = addProductModel.name;
      selectedCategoryItem = CategoryModel(code: addProductModel.type, image: "", name: addProductModel.typeName??"", secondName: addProductModel.typeName,isEnable: true);
      selectedSubCategoryItem = SubCategoryModel(type: addProductModel.type, code: addProductModel.style, image: "", name: addProductModel.styleName??"", secondName: addProductModel.styleName,isEnable: true);
      priceController.text = addProductModel.salesRate.toString();
      wholeSalePriceController.text = addProductModel.wholeSale.toString();
      discPriceController.text = (addProductModel.discountVal??0).toString();
      selectedDiscount = (addProductModel.discountType??"%") == "%" ? 0 : 1;
      stockController.text = addProductModel.totalStock.toString();
      ingredientController.text = addProductModel.ingredients??"";
      unitController.text = addProductModel.mUnit;
      gstController.text = "${addProductModel.gSTTax??0}";
      selectedBrand = BrandModel(code: addProductModel.brandCode??"", name: addProductModel.brandName??"Select Brand", image: "", secondName: addProductModel.brandName??"Select Brand",isEnable: true);
      sDescriptionController.text = addProductModel.shortDescription??"";
      descriptionController.text = addProductModel.description??"";
      pDeliveryPriceController.text = addProductModel.deliveryPrice != 0 ? addProductModel.deliveryPrice.toString() : "";
      pDeliveryApplyController.text = addProductModel.deliveryApplyItem != 0 ? addProductModel.deliveryApplyItem.toString() : "";
      pDeliveryFreeController.text = addProductModel.freeDeliveryItems != -1 ? addProductModel.freeDeliveryItems.toString() : "";
      pMaxDeliveryController.text = addProductModel.maxDeliveryTime != 0 ? addProductModel.maxDeliveryTime.toString() : "";
      pMinDeliveryController.text = addProductModel.minDeliveryTime != 0 ? addProductModel.minDeliveryTime.toString() : "";
      specs = addProductModel.specs;
      pColors = addProductModel.colors;
      addons = addProductModel.addons;
      isNewArrival = addProductModel.isNewArrival;
      isTopDeal = addProductModel.isTopDeal;
    }
  }

  getImage() async {
    EasyLoading.show(status: "Loading...");
    var result = await _picker.getImage(source: ImageSource.gallery);
    if(result != null){
      var b = await result.readAsBytes();
      final bytes = b.lengthInBytes;
      var decodedImage = await decodeImageFromList(b);
      if(bytes/1024 > 50){
        Get.snackbar("Error", "Kindly upload image of maximum 50kb");
      }else {
        _productImages.add(File(result.path));
      }
    }
    EasyLoading.dismiss();
    setData();
  }


  Future _getImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.image , allowMultiple: false);
    if (result != null) {
      var b = result.files.single.bytes;
      final bytes = b!.lengthInBytes;
      if(bytes/1024 > 50){
        Get.snackbar("Error", "Kindly upload image of maximum 50kb");
      }else {
        _productImagesWeb.add(result.files.single);
      }
      setData();
    } else {
      // User canceled the picker
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CheckAdminController>(
        id: "0",
        builder: (_checkAdminController) {
          checkAdminController = _checkAdminController;
          return WillPopScope(
            onWillPop: () async {
              Timer.periodic(Duration(seconds: 6), (timer) {
                timer.cancel();
                isExist = false;
              });
              if(isExist){
                return true;
              }else{
                utils.snackBar(context, message: "Press again to exit!");
                isExist = true;
                setData();
                return false;
              }
            },
            child: Scaffold(
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
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12),),
                          color: checkAdminController.system.mainColor,
                        ),
                        padding: EdgeInsets.only(right: 12, top: 6, bottom: 6),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            IconButton(onPressed: ()=> Get.back(), icon: Icon(CupertinoIcons.arrow_left , color: whiteColor, size: 24,)),
                            SizedBox(width: 12,),
                            Expanded(child: Text(Get.arguments == null ? "Add Product" : "Update Product" , style: utils.headingStyle(whiteColor),)),
                          ],
                        ),
                      ),
                      IconStepper(
                        icons: [
                          Icon(CupertinoIcons.person , color: whiteColor,),
                          Icon(CupertinoIcons.rectangle_3_offgrid, color: whiteColor,),
                          Icon(CupertinoIcons.cube_box, color: whiteColor,),
                          Icon(CupertinoIcons.archivebox, color: whiteColor,),
                          Icon(CupertinoIcons.add_circled, color: whiteColor,),
                          Icon(CupertinoIcons.circle_grid_hex, color: whiteColor,),
                          Icon(CupertinoIcons.app, color: whiteColor,),
                          Icon(CupertinoIcons.flag, color: whiteColor,),
                          Icon(Icons.add_photo_alternate_sharp , color: whiteColor,),
                        ],
                        activeStepColor: checkAdminController.system.mainColor,
                        lineLength: 60,
                        stepColor: blackColor.withOpacity(0.3),
                        activeStepBorderColor: checkAdminController.system.mainColor,
                        lineColor: checkAdminController.system.mainColor,
                        stepRadius: 16,
                        enableStepTapping: activeStep == 0 ? false : true,
                        enableNextPreviousButtons: false,
                        // activeStep property set to activeStep variable defined above.
                        activeStep: activeStep,
                        onStepReached: (index) {
                          setState(() {
                            activeStep = index;
                          });
                        },
                      ),
                      Expanded(
                          child:
                          activeStep == 0 ? Container(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            width: Get.width,
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text("Product Information" , style: utils.boldSmallLabelStyle(blackColor),),
                                  SizedBox(height: 10,),
                                  form("Name", nameController),
                                  SizedBox(height: 12,),
                                  InkWell(
                                    onTap: (){
                                      FocusScope.of(context).unfocus();
                                      showSearchDialog(context, 0);
                                    },
                                    child: Container(
                                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(8),
                                            border: Border.all(color: blackColor , width: 0.5)
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Expanded(child: Text(
                                              selectedCategoryItem == null ? "Select Category" : selectedCategoryItem!.name,
                                              style: utils.smallLabelStyle(blackColor),
                                            ),),
                                            SizedBox(width: 8,),
                                            Icon(CupertinoIcons.chevron_down, color: blackColor, size: 16,)
                                          ],
                                        )
                                    ),
                                  ),
                                  SizedBox(height: 12,),
                                  GetBuilder<SubCategoryController>(id: "0",builder: (subCategoryController){
                                    return InkWell(
                                      onTap: (){
                                        if(selectedCategoryItem != null) {
                                          FocusScope.of(context).unfocus();
                                          showSearchDialog(context, 1);
                                        }else{
                                          utils.snackBar(context, message: "Select the category First!");
                                        }
                                      },
                                      child: Container(
                                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(8),
                                              border: Border.all(color: blackColor , width: 0.5)
                                          ),
                                          child: !subCategoryController.isLoadingSubCategories ? Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Expanded(child: Text(
                                                selectedSubCategoryItem == null ? "Select Sub Category" : selectedSubCategoryItem!.name,
                                                style: utils.smallLabelStyle(blackColor),
                                              ),),
                                              SizedBox(width: 8,),
                                              Icon(CupertinoIcons.chevron_down, color: blackColor, size: 16,)
                                            ],
                                          ) : CircularProgressIndicator()
                                      ),
                                    );
                                  }),
                                  SizedBox(height: 12,),
                                  form("Price", priceController, isNumber: true),
                                  SizedBox(height: 12,),
                                  form("Whole Sale Price", wholeSalePriceController, isNumber: true),
                                  SizedBox(height: 12,),
                                  GestureDetector(
                                    onTap : (){
                                      FocusScope.of(context).unfocus();
                                      showSearchDialog(context, 5);
                                    },
                                    child: Container(
                                      width: Get.width,
                                      padding: EdgeInsets.symmetric(horizontal: 10,vertical: 12),
                                      decoration: BoxDecoration(
                                          color: whiteColor,
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(color: blackColor , width: 0.5)
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Expanded(child: Text(selectedDiscount == 0 ? "% Discount":"Flat Discount" , style: utils.smallLabelStyle(blackColor),)),
                                          SizedBox(width: 12,),
                                          Icon(CupertinoIcons.chevron_down, color: blackColor.withOpacity(0.6), size: 16,),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 12,),
                                  form("Discount", discPriceController, isNumber: true),
                                  SizedBox(height: 12,),
                                  form("GST %", gstController, isNumber: true),
                                  SizedBox(height: 12,),
                                  form("Stock", stockController, isNumber: true),
                                  //SizedBox(height: 12,),
                                  //form("SKU", skuController),
                                  /*SizedBox(height: 12,),
                                  form("Youtube Video Link", videoLinkController),*/
                                ],
                              ),
                            ),
                          ) :
                          activeStep == 1 ? Container(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            width: Get.width,
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text("Product Description" , style: utils.boldSmallLabelStyle(blackColor),),
                                  SizedBox(height: 10,),
                                  form("Ingredients separated with Comma (,)", ingredientController),
                                  SizedBox(height: 12,),
                                  form("Unit", unitController),
                                  SizedBox(height: 12,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: InkWell(
                                        onTap: (){
                                          FocusScope.of(context).unfocus();
                                          showSearchDialog(context, 4);
                                        },
                                        child: Container(
                                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(8),
                                                border: Border.all(color: blackColor , width: 0.5)
                                            ),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Expanded(child: Text(
                                                  selectedBrand == null ? "Select Brand" : selectedBrand!.name,
                                                  style: utils.smallLabelStyle(blackColor),
                                                ),),
                                                SizedBox(width: 8,),
                                                Icon(CupertinoIcons.chevron_down, color: blackColor, size: 16,)
                                              ],
                                            )
                                        ),
                                      ),
                                      ),
                                      IconButton(
                                          onPressed: (){
                                            showAddBrandDialog(context);
                                          },
                                          icon: Icon(CupertinoIcons.add_circled, color: checkAdminController.system.mainColor, size: 24,),
                                      )
                                    ],
                                  ),
                                  //SizedBox(height: 12,),
                                  //form("Tags separated with comma", tagsController),
                                  SizedBox(height: 12,),
                                  form("Short Description of 50 characters", sDescriptionController, onChange: (val){
                                    if(val == null){
                                      shortDLength = 0;
                                    }else{
                                      shortDLength = val.toString().length;
                                    }
                                    setData();
                                  }),
                                  SizedBox(height: 2,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text("$shortDLength/50" , style: utils.xSmallLabelStyle(blackColor),)
                                    ],
                                  ),
                                  SizedBox(height: 12,),
                                  form("Long Description of 200 characters", descriptionController, isMultiline: true, onChange: (val){
                                    //Get.to(()=> EditorPage());
                                    if(val == null){
                                      longDLength = 0;
                                    }else{
                                      longDLength = val.toString().length;
                                    }
                                    setData();
                                  }),
                                  SizedBox(height: 2,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text("$longDLength/200" , style: utils.xSmallLabelStyle(blackColor),)
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ) :
                          activeStep == 2 ? Container(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            width: Get.width,
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text("Product Delivery" , style: utils.boldSmallLabelStyle(blackColor),),
                                  SizedBox(height: 10,),
                                  Text("important note No delivery charges will be apply if not specified." , style: utils.boldSmallLabelStyle(redColor),),
                                  SizedBox(height: 20,),
                                  form("Delivery Price", pDeliveryPriceController, isNumber : true),
                                  SizedBox(height: 12,),
                                  form("Max items delivery apply", pDeliveryApplyController, isNumber : true),
                                  SizedBox(height: 12,),
                                  form("Number of items for free delivery", pDeliveryFreeController, isNumber : true),
                                  SizedBox(height: 12,),
                                  form("Min Delivery time in hours(s)", pMinDeliveryController, isNumber : true),
                                  SizedBox(height: 12,),
                                  form("Max Delivery time in hours(s)", pMaxDeliveryController, isNumber : true),
                                ],
                              ),
                            ),
                          ) :
                          activeStep == 3 ? Container(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            width: Get.width,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text("Product Specs" , style: utils.boldSmallLabelStyle(blackColor),),
                                SizedBox(height: 10,),
                                form("Title", psTitleController),
                                SizedBox(height: 12,),
                                form("Description", psDescriptionController, isMultiline : true),
                                SizedBox(height: 12,),
                                utils.button(checkAdminController.system.mainColor, "Add", whiteColor,checkAdminController.system.mainColor,1.0, (){
                                  if(psTitleController.text.isEmpty){
                                    utils.snackBar(context, message: "Title is required");
                                    return;
                                  }else if(psDescriptionController.text.isEmpty){
                                    utils.snackBar(context, message: "Description is required");
                                    return;
                                  }
                                  specs.add(Specs(specTitle: psTitleController.text.toString(), specDescription: psDescriptionController.text.toString()));
                                  psTitleController.clear();
                                  psDescriptionController.clear();
                                  setData();
                                }),
                                SizedBox(height: 12,),
                                Container(
                                  width: Get.width,
                                  height: 0.5,
                                  color: blackColor,
                                ),
                                Expanded(child: SingleChildScrollView(
                                  child: Wrap(
                                    children: [
                                      for(var i = 0 ; i < specs.length; i++)
                                        Container(
                                          width: Get.width,
                                          padding: EdgeInsets.symmetric(horizontal: 2, vertical: 8),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                  flex: 1,
                                                  child: Text("${specs[i].specTitle}" , style: utils.boldSmallLabelStyle(blackColor),)),
                                              Expanded(
                                                  flex: 3,
                                                  child: Text("${specs[i].specDescription}" , style: utils.xSmallLabelStyle(blackColor),)),
                                              SizedBox(width: 6,),
                                              InkWell(
                                                  onTap : (){
                                                    specs.removeAt(i);
                                                    setData();
                                                  },
                                                  child: Icon(CupertinoIcons.xmark_circle, color: blackColor, size: 24,)
                                              )
                                            ],
                                          ),
                                        )
                                    ],
                                  ),
                                ))
                              ],
                            ),
                          ) :
                          activeStep == 4 ? Container(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            width: Get.width,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text("Product Addons" , style: utils.boldSmallLabelStyle(blackColor),),
                                SizedBox(height: 10,),
                                form("Addon Name", aNameController, ),
                                SizedBox(height: 12,),
                                form("Price", aPriceController, isNumber : true),
                                SizedBox(height: 12,),
                                utils.button(checkAdminController.system.mainColor, "Add", whiteColor,checkAdminController.system.mainColor,1.0, (){
                                  if(aNameController.text.isEmpty){
                                    utils.snackBar(context, message: "Name is required");
                                    return;
                                  }else if(aPriceController.text.isEmpty){
                                    utils.snackBar(context, message: "Price is required");
                                    return;
                                  }
                                  addons.add(ProductAdons(adonDescription: aNameController.text.toString(), adonPrice: aPriceController.text.toString()));
                                  aNameController.clear();
                                  aPriceController.clear();
                                  setData();
                                }),
                                SizedBox(height: 12,),
                                Container(
                                  width: Get.width,
                                  height: 0.5,
                                  color: blackColor,
                                ),
                                Expanded(child: SingleChildScrollView(
                                  child: Wrap(
                                    children: [
                                      for(var i = 0 ; i < addons.length; i++)
                                        Container(
                                          width: Get.width,
                                          padding: EdgeInsets.symmetric(horizontal: 2, vertical: 8),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                  flex: 1,
                                                  child: Text("${addons[i].adonDescription}" , style: utils.boldSmallLabelStyle(blackColor),)),
                                              Expanded(
                                                  flex: 1,
                                                  child: Text("${addons[i].adonPrice}" , style: utils.xSmallLabelStyle(blackColor),)),
                                              SizedBox(width: 6,),
                                              InkWell(
                                                  onTap : (){
                                                    addons.removeAt(i);
                                                    setData();
                                                  },
                                                  child: Icon(CupertinoIcons.xmark_circle, color: blackColor, size: 24,)
                                              )
                                            ],
                                          ),
                                        )
                                    ],
                                  ),
                                ))
                              ],
                            ),
                          ) :
                          activeStep == 5 ? Container(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            width: Get.width,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text("Product Colors" , style: utils.boldSmallLabelStyle(blackColor),),
                                SizedBox(height: 10,),
                                InkWell(
                                  onTap: (){
                                    FocusScope.of(context).unfocus();
                                    showSearchDialog(context, 2);
                                  },
                                  child: Container(
                                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(color: blackColor , width: 0.5)
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Expanded(child: Text(
                                            selectedPColor == null ? "Select Color" : selectedPColor!.color,
                                            style: utils.smallLabelStyle(blackColor),
                                          ),),
                                          SizedBox(width: 8,),
                                          Icon(CupertinoIcons.chevron_down, color: blackColor, size: 16,)
                                        ],
                                      )
                                  ),
                                ),
                                SizedBox(height: 12,),
                                utils.button(checkAdminController.system.mainColor, "Add",whiteColor,checkAdminController.system.mainColor,1.0, (){
                                  if(selectedPColor == null){
                                    utils.snackBar(context, message: "Select Size");
                                    return;
                                  }
                                  pColors.add(selectedPColor!);
                                  selectedPColor = null;
                                  setData();
                                }),
                                SizedBox(height: 12,),
                                Container(
                                  width: Get.width,
                                  height: 0.5,
                                  color: blackColor,
                                ),
                                Expanded(child: SingleChildScrollView(
                                  child: Wrap(
                                    children: [
                                      for(var i = 0 ; i < pColors.length; i++)
                                        Container(
                                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                            margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(20),
                                                color: blackColor.withOpacity(0.3)
                                            ),
                                            child: Text("${pColors[i].color}" , style: utils.smallLabelStyle(blackColor),)
                                        )
                                    ],
                                  ),
                                ))
                              ],
                            ),
                          ) :
                          activeStep == 6 ? Container(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            width: Get.width,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                if(addProductModel.parentId == null) Text("Product Size" , style: utils.boldSmallLabelStyle(blackColor),),
                                if(addProductModel.parentId == null) SizedBox(height: 10,),
                                if(addProductModel.parentId == null) form("Size Name", sNameController, enable: addProductModel.parentId == null),
                                if(addProductModel.parentId == null) SizedBox(height: 12,),
                                if(addProductModel.parentId == null) form("Sales Price", sPriceController, isNumber : true, enable: addProductModel.parentId == null),
                                if(addProductModel.parentId == null) SizedBox(height: 12,),
                                if(addProductModel.parentId == null) form("Wholesales Price", sWPriceController, isNumber : true, enable: addProductModel.parentId == null),
                                if(addProductModel.parentId == null) SizedBox(height: 12,),
                                if(addProductModel.parentId == null) utils.button(checkAdminController.system.mainColor, "Add", whiteColor,checkAdminController.system.mainColor,1.0, (){
                                  if(addProductModel.parentId == null) {
                                    if (sNameController.text.isEmpty) {
                                      utils.snackBar(
                                          context, message: "Name is required");
                                      return;
                                    } else if (sPriceController.text.isEmpty) {
                                      utils.snackBar(context,
                                          message: "Price is required");
                                      return;
                                    }

                                    if (sWPriceController.text.isEmpty) {
                                      sWPriceController.text =
                                          sPriceController.text;
                                    }
                                    pSizes.add(PSizes(
                                        size: sNameController.text.toString(),
                                        price: sPriceController.text.toString(),
                                        wPrice: sWPriceController.text
                                            .toString(),
                                        sizeId: "${DateTime
                                            .now()
                                            .millisecondsSinceEpoch}"));
                                    sNameController.clear();
                                    sPriceController.clear();
                                    sWPriceController.clear();
                                    setData();
                                  }else{
                                    Get.snackbar("Error", "Edit Parent product to add more sizes");
                                  }
                                }),
                                SizedBox(height: 12,),
                                Container(
                                  width: Get.width,
                                  height: 0.5,
                                  color: blackColor,
                                ),
                                Expanded(child: SingleChildScrollView(
                                  child: Wrap(
                                    children: [
                                      if(pSizes.length > 0 || addProductModel.sizes.length > 0) Container(
                                        width: Get.width,
                                        padding: EdgeInsets.symmetric(horizontal: 2, vertical: 8),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                                flex: 1,
                                                child: Text("Name" , style: utils.boldSmallLabelStyle(blackColor),)),
                                            Expanded(
                                                flex: 1,
                                                child: Text("Sale Rate" , style: utils.boldSmallLabelStyle(blackColor),)),
                                            Expanded(
                                                flex: 1,
                                                child: Text("Whole Sale" , style: utils.boldSmallLabelStyle(blackColor),)),
                                            SizedBox(width: 6,),
                                            InkWell(
                                                onTap : (){
                                                },
                                                child: Icon(CupertinoIcons.xmark_circle, color: Colors.transparent, size: 24,)
                                            )
                                          ],
                                        ),
                                      ),
                                      for(var i = 0 ; i < addProductModel.sizes.length; i++)
                                        Container(
                                          width: Get.width,
                                          padding: EdgeInsets.symmetric(horizontal: 2, vertical: 8),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                  flex: 1,
                                                  child: Text("${addProductModel.sizes[i].size}" , style: utils.boldSmallLabelStyle(blackColor),)),
                                              Expanded(
                                                  flex: 1,
                                                  child: Text("${addProductModel.sizes[i].price}" , style: utils.xSmallLabelStyle(blackColor),)),
                                              Expanded(
                                                  flex: 1,
                                                  child: Text("${addProductModel.sizes[i].wPrice}" , style: utils.xSmallLabelStyle(blackColor),)),
                                              SizedBox(width: 6,),
                                              if(addProductModel.parentId == null) InkWell(
                                                  onTap : (){
                                                    pSizes.removeAt(i);
                                                    setData();
                                                  },
                                                  child: Icon(CupertinoIcons.xmark_circle, color: blackColor, size: 24,)
                                              )
                                            ],
                                          ),
                                        ),
                                      for(var i = 0 ; i < pSizes.length; i++)
                                        Container(
                                          width: Get.width,
                                          padding: EdgeInsets.symmetric(horizontal: 2, vertical: 8),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                  flex: 1,
                                                  child: Text("${pSizes[i].size}" , style: utils.boldSmallLabelStyle(blackColor),)),
                                              Expanded(
                                                  flex: 1,
                                                  child: Text("${pSizes[i].price}" , style: utils.xSmallLabelStyle(blackColor),)),
                                              Expanded(
                                                  flex: 1,
                                                  child: Text("${pSizes[i].wPrice}" , style: utils.xSmallLabelStyle(blackColor),)),
                                              SizedBox(width: 6,),
                                              if(addProductModel.parentId == null) InkWell(
                                                  onTap : (){
                                                    pSizes.removeAt(i);
                                                    setData();
                                                  },
                                                  child: Icon(CupertinoIcons.xmark_circle, color: blackColor, size: 24,)
                                              )
                                            ],
                                          ),
                                        )
                                    ],
                                  ),
                                ))
                              ],
                            ),
                          )
                          /*Container(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            width: Get.width,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text("Product Sizes" , style: utils.boldSmallLabelStyle(blackColor),),
                                SizedBox(height: 10,),
                                InkWell(
                                  onTap: (){
                                    FocusScope.of(context).unfocus();
                                    showSearchDialog(context, 3);
                                  },
                                  child: Container(
                                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(color: blackColor , width: 0.5)
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Expanded(child: Text(
                                            selectedPSize == null ? "Select Size" : selectedPSize!.size,
                                            style: utils.smallLabelStyle(blackColor),
                                          ),),
                                          SizedBox(width: 8,),
                                          Icon(CupertinoIcons.chevron_down, color: blackColor, size: 16,)
                                        ],
                                      )
                                  ),
                                ),
                                SizedBox(height: 12,),
                                utils.button(checkAdminController.system.mainColor, "Add",whiteColor,checkAdminController.system.mainColor,1.0, (){
                                  if(selectedPSize == null){
                                    utils.snackBar(context, message: "Select Size");
                                    return;
                                  }
                                  pSizes.add(selectedPSize!);
                                  selectedPSize = null;
                                  setData();
                                }),
                                SizedBox(height: 12,),
                                Container(
                                  width: Get.width,
                                  height: 0.5,
                                  color: blackColor,
                                ),
                                Expanded(child: SingleChildScrollView(
                                  child: Wrap(
                                    children: [
                                      for(var i = 0 ; i < pSizes.length; i++)
                                        Container(
                                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                            margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(20),
                                                color: blackColor.withOpacity(0.3)
                                            ),
                                            child: Text("${pSizes[i].size}" , style: utils.smallLabelStyle(blackColor),)
                                        )
                                    ],
                                  ),
                                ))
                              ],
                            ),
                          )*/ :
                          activeStep == 7 ? Container(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            width: Get.width,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text("Product Flags" , style: utils.boldSmallLabelStyle(blackColor),),
                                SizedBox(height: 20,),
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
                                    Expanded(child: Text("Popular" , style: utils.smallLabelStyle(blackColor),))
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
                          ) :
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            width: Get.width,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text("Product Images" , style: utils.boldSmallLabelStyle(blackColor),),
                                SizedBox(height: 10,),
                                Text("Important Note: Image should be in Maximum of 50kb size" , style: utils.xSmallLabelStyle(redColor),),
                                SizedBox(height: 10,),
                                InkWell(
                                  onTap: (){
                                    if(addProductModel.images.length + (GetPlatform.isWeb ? _productImagesWeb.length : _productImages.length) < 4) {
                                      GetPlatform.isWeb ? _getImage() : getImage();
                                    }else{
                                      Get.snackbar("Error", "Maximum 3 Images are allowed delete old to add new One.");
                                    }
                                  },
                                  child: Container(
                                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(color: blackColor , width: 0.5)
                                      ),
                                      child: Center(
                                        child: Icon(CupertinoIcons.add , color: blackColor, size: 32,),
                                      )
                                  ),
                                ),
                                SizedBox(height: 12,),
                                Container(
                                  width: Get.width,
                                  height: 0.5,
                                  color: blackColor,
                                ),
                                Expanded(child: SingleChildScrollView(
                                  child: Wrap(
                                    children: [
                                      for(var i = 0 ; i < (GetPlatform.isWeb ? _productImagesWeb.length : _productImages.length); i++)
                                        Container(
                                            height: 200.h,
                                            child : Stack(
                                            children: [
                                              Container(
                                                height: 200.h,
                                                  margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(8),
                                                      color: blackColor.withOpacity(0.3),
                                                      boxShadow: [
                                                        BoxShadow(
                                                            spreadRadius: 2,
                                                            blurRadius: 2,
                                                            offset: Offset(0,2),
                                                            color: blackColor.withOpacity(0.2)
                                                        )
                                                      ]
                                                  ),
                                                  child: GetPlatform.isWeb ? Image.memory(_productImagesWeb[i].bytes!,fit: BoxFit.cover,) : Image.file(_productImages[i], fit: BoxFit.cover,)
                                              ),
                                              Positioned(
                                                top: 0,
                                                right: 10,
                                                child: IconButton(
                                                  onPressed: (){
                                                    _productImages.removeAt(i);
                                                    setData();
                                                  },
                                                  icon: Icon(CupertinoIcons.xmark_circle_fill, color: redColor, size: 32,),
                                                ),
                                              )
                                            ],
                                          )
                                        ),
                                      for(var i = 0 ; i < addProductModel.images.length; i++)
                                        Container(
                                            height: 200.h,
                                            child: Stack(
                                            children: [
                                              Container(
                                                  height: 200.h,
                                                  margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(8),
                                                      color: blackColor.withOpacity(0.3),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        spreadRadius: 2,
                                                        blurRadius: 2,
                                                        offset: Offset(0,2),
                                                        color: blackColor.withOpacity(0.2)
                                                      )
                                                    ]
                                                  ),
                                                  child: Image.network(addProductModel.images[i], fit: BoxFit.cover,)
                                              ),
                                              Positioned(
                                                top: 0,
                                                right: 10,
                                                child: IconButton(
                                                  onPressed: (){
                                                    addProductModel.images.removeAt(i);
                                                    setData();
                                                  },
                                                  icon: Icon(CupertinoIcons.xmark_circle_fill, color: redColor, size: 32,),
                                                ),
                                              )
                                            ],
                                          )
                                        )
                                    ],
                                  ),
                                ))
                              ],
                            ),
                          )
                      ),
                      Container(
                        width: Get.width,
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            InkWell(
                                onTap : (){
                                  setState(() {
                                    if(activeStep > 0) {
                                      activeStep--;
                                      FocusScope.of(context).unfocus();
                                    }
                                  });
                                },
                                child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(color: activeStep > 0 ? checkAdminController.system.mainColor : Colors.transparent, width: 2)
                                    ),
                                    child: Text(activeStep > 0 ? "Previous" : "" , style: utils.boldSmallLabelStyle(checkAdminController.system.mainColor),))),
                            InkWell(
                                onTap : () async {
                                  if(activeStep < 8) {
                                    if(activeStep == 0){
                                      if(nameController.text.isEmpty){
                                        utils.snackBar(context, message: "Name is required");
                                        return;
                                      }else if(selectedCategoryItem == null){
                                        utils.snackBar(context, message: "Category is required");
                                        return;
                                      }else if(selectedSubCategoryItem == null){
                                        utils.snackBar(context, message: "Subcategory is required");
                                        return;
                                      }else if(priceController.text.isEmpty){
                                        utils.snackBar(context, message: "Price is required");
                                        return;
                                      }else if(wholeSalePriceController.text.isEmpty){
                                        utils.snackBar(context, message: "Wholesale price is required");
                                        return;
                                      }
                                      if(discPriceController.text.isEmpty){
                                        discPriceController.text = "0";
                                      }

                                      if(stockController.text.isEmpty){
                                        stockController.text = "0";
                                      }

                                      if(gstController.text.isEmpty){
                                        gstController.text = "0";
                                      }

                                      /*if(skuController.text.isEmpty){
                                        skuController.text = "N/A";
                                      }*/

                                      /*if(videoLinkController.text.isEmpty){
                                        videoLinkController.text = "N/A";
                                      }*/

                                      addProductModel.name = nameController.text.toString();
                                      addProductModel.type = selectedCategoryItem!.code.toString();
                                      addProductModel.style = selectedSubCategoryItem!.code.toString();
                                      addProductModel.typeName = selectedCategoryItem!.name.toString();
                                      addProductModel.styleName = selectedSubCategoryItem!.name.toString();
                                      addProductModel.salesRate = double.parse(priceController.text.toString());
                                      addProductModel.wholeSale = double.parse(wholeSalePriceController.text.toString());
                                      addProductModel.gSTTax = double.parse(gstController.text.toString());
                                      addProductModel.purchaseRate = 0;
                                      addProductModel.lockRate = 0;
                                      addProductModel.rating = 0;
                                      addProductModel.sMRate = 0;
                                      addProductModel.disCont = discPriceController.text.isEmpty ? false : true;
                                      addProductModel.discountType = selectedDiscount == 0 ? "%" : "@";
                                      addProductModel.discountVal = double.parse(discPriceController.text.toString());
                                      addProductModel.totalStock = int.parse(stockController.text.toString());
                                      activeStep++;
                                      FocusScope.of(context).unfocus();
                                    }
                                    else if(activeStep == 1){

                                      if(sDescriptionController.text.isEmpty){
                                        addProductModel.shortDescription = "N/A";
                                      }else if(descriptionController.text.isEmpty){
                                        addProductModel.description = "N/A";
                                      }

                                      if(ingredientController.text.isNotEmpty){
                                        addProductModel.ingredients = ingredientController.text;
                                      }

                                      /*if(tagsController.text.isNotEmpty){
                                        addProductModel.product.tags = tagsController.text.toString();
                                      }*/

                                      addProductModel.mUnit = unitController.text.isNotEmpty ? unitController.text.toString() : "N/A";
                                      addProductModel.brandCode = selectedBrand != null ? selectedBrand!.code.toString() : null;
                                      addProductModel.brandName = selectedBrand != null ? selectedBrand!.name.toString() : null;
                                      addProductModel.shortDescription = sDescriptionController.text.toString();
                                      addProductModel.description = descriptionController.text.toString();

                                      activeStep++;
                                      FocusScope.of(context).unfocus();
                                    }
                                    else if(activeStep == 2){
                                      if(pDeliveryPriceController.text.isNotEmpty){
                                        addProductModel.deliveryPrice = double.parse(pDeliveryPriceController.text.toString());
                                      }

                                      if(pDeliveryApplyController.text.isNotEmpty){
                                        addProductModel.deliveryApplyItem = int.parse(pDeliveryApplyController.text.toString());
                                      }

                                      if(pDeliveryFreeController.text.isNotEmpty){
                                        addProductModel.freeDeliveryItems = int.parse(pDeliveryFreeController.text.toString());
                                      }

                                      if(pMinDeliveryController.text.isNotEmpty){
                                        addProductModel.minDeliveryTime = int.parse(pMinDeliveryController.text.toString());
                                      }

                                      if(pMaxDeliveryController.text.isNotEmpty){
                                        addProductModel.maxDeliveryTime = int.parse(pMaxDeliveryController.text.toString());
                                      }

                                      activeStep++;
                                      FocusScope.of(context).unfocus();
                                    }
                                    else if(activeStep == 3){
                                      addProductModel.specs = specs;
                                      activeStep++;
                                      FocusScope.of(context).unfocus();
                                    }
                                    else if(activeStep == 4){
                                      addProductModel.addons = addons;
                                      activeStep++;
                                      FocusScope.of(context).unfocus();
                                    }
                                    else if(activeStep == 5){
                                      addProductModel.colors = pColors;
                                      activeStep++;
                                      FocusScope.of(context).unfocus();
                                    }
                                    else if(activeStep == 6){
                                      activeStep++;
                                      FocusScope.of(context).unfocus();
                                    }else if(activeStep == 7){
                                      addProductModel.isNewArrival = isNewArrival;
                                      addProductModel.isTopDeal = isTopDeal;
                                      activeStep++;
                                      FocusScope.of(context).unfocus();
                                    }
                                    setData();
                                  }
                                  else{

                                    if (addProductModel.images.length + (GetPlatform.isWeb ? _productImagesWeb.length : _productImages.length) <= 0) {
                                      utils.snackBar(context,
                                          message: "Add at least one image.");
                                      return;
                                    }

                                    EasyLoading.show(status: "Uploading images...");
                                    if(GetPlatform.isWeb){
                                      for(var img in _productImagesWeb){
                                        String? imageUrl = await uploadPicWeb(img);
                                        addProductModel.images.add(imageUrl);
                                      }
                                    }else{
                                      for(var img in _productImages){
                                        String? imageUrl = await uploadPic(img);
                                        addProductModel.images.add(imageUrl);
                                      }
                                    }
                                    EasyLoading.dismiss();
                                    addProduct();
                                  }
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: checkAdminController.system.mainColor
                                    ),
                                    child: Text(activeStep < 8 ? "Next" : "Done", style: utils.boldSmallLabelStyle(whiteColor),))),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  Widget form(String hints, TextEditingController controller,{onChange,isMultiline,isNumber, enable}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: blackColor , width: 0.5)
      ),
      child: TextField(
        enabled: enable,
        controller: controller,
        maxLines: isMultiline != null ? 8 : 1,
        keyboardType: isNumber != null ? TextInputType.number : TextInputType.text,
        onChanged: onChange,
        style: utils.smallLabelStyle(blackColor),
        decoration: InputDecoration.collapsed(hintStyle: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 12,
            color: blackColor
        ),
            hintText: hints),
      ),
    );
  }

  showSearchDialog(BuildContext context, type){
    var searchText = "";
    var searchController = TextEditingController();
    showCupertinoModalBottomSheet(
      enableDrag: true,
      expand: false,
      context: context,
      closeProgressThreshold: 100,
      backgroundColor: whiteColor,
      elevation: 0,
      builder: (context) => StatefulBuilder(builder: (BuildContext context , StateSetter setState){
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 5 , vertical: 12),
          width: double.infinity,
          decoration: BoxDecoration(
              color: whiteColor,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20))
          ),
          constraints: BoxConstraints(
              minWidth: Get.width,
              maxWidth: Get.width,
              minHeight: 0,
              maxHeight: Get.height * 0.5
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 12 , vertical: 5),
                      child: Icon(CupertinoIcons.arrow_left  ,color: blackColor, size: 24,),
                    ),
                  ),
                  SizedBox(width: 12,),
                  Text(type == 0 ? "Choose Category" : type == 1 ? "Choose Subcategory" : type == 2 ? "Choose Color" : type == 3 ? "Choose Size" : type == 4 ? "Choose Brand" : "Choose discount type", style: utils.headingStyle(blackColor),)
                ],
              ),
              if(type != 5) SizedBox(height: 10,),
              if(type != 5) form("Search", searchController , onChange: (val){
                searchText = val;
                setState((){});
              }),
              SizedBox(height: 10,),
              Expanded(child: SingleChildScrollView(
                  child: type == 0 ? GetBuilder<CategoryController>(id: "0", builder: (categoryController){
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 12,),
                        for(var i = 0 ; i < categoryController.categories.length; i++)
                          categoryController.categories[i].name.toLowerCase().contains(searchText.toLowerCase()) ?
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 16 , vertical: 5),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap :(){
                                    _subCategoryController.getSubCategories(categoryController.categories[i].code);
                                    selectedCategoryItem = categoryController.categories[i];
                                    selectedSubCategoryItem = null;
                                    setState((){});
                                    setData();
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 20,
                                        height: 20,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(color: checkAdminController.system.mainColor , width: 2)
                                        ),
                                        child: Center(
                                          child: Container(
                                            width: 8,
                                            height: 8,
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: selectedCategoryItem != null && selectedCategoryItem!.code == categoryController.categories[i].code ? checkAdminController.system.mainColor : Colors.transparent
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 12,),
                                      Expanded(child: Text("${categoryController.categories[i].name}" , style: utils.boldLabelStyle(blackColor),))
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                  width: Get.width,
                                  height: 1,
                                  color: blackColor.withOpacity(0.3),
                                ),
                              ],
                            ),
                          ) : Container()
                      ],
                    );
                  },) :
                  type == 1 ? GetBuilder<SubCategoryController>(id: "0", builder: (subCategoryController){
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 12,),
                        for(var i = 0 ; i < subCategoryController.subCategories.length; i++)
                          subCategoryController.subCategories[i].name.toLowerCase().contains(searchText.toLowerCase()) ?
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 16 , vertical: 5),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap :(){
                                    selectedSubCategoryItem = subCategoryController.subCategories[i];
                                    setState((){});
                                    setData();
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 20,
                                        height: 20,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(color: checkAdminController.system.mainColor , width: 2)
                                        ),
                                        child: Center(
                                          child: Container(
                                            width: 8,
                                            height: 8,
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: selectedSubCategoryItem != null && selectedSubCategoryItem!.code == subCategoryController.subCategories[i].code ? checkAdminController.system.mainColor : Colors.transparent
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 12,),
                                      Expanded(child: Text("${subCategoryController.subCategories[i].name}" , style: utils.boldLabelStyle(blackColor),))
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                  width: Get.width,
                                  height: 1,
                                  color: blackColor.withOpacity(0.3),
                                ),
                              ],
                            ),
                          ) : Container()
                      ],
                    );
                  },) :
                  type == 2 ? GetBuilder<CategoryController>(id: "0", builder: (categoryController){
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 12,),
                        for(var i = 0 ; i < pColorsDefault.length; i++)
                          pColorsDefault[i].color.toLowerCase().contains(searchText.toLowerCase()) ?
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 16 , vertical: 5),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap :(){
                                    selectedPColor = pColorsDefault[i];
                                    setState((){});
                                    setData();
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 20,
                                        height: 20,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(color: checkAdminController.system.mainColor , width: 2)
                                        ),
                                        child: Center(
                                          child: Container(
                                            width: 8,
                                            height: 8,
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: selectedPColor != null && selectedPColor!.colorId == pColorsDefault[i].colorId.toString() ? checkAdminController.system.mainColor : Colors.transparent
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 12,),
                                      Expanded(child: Text("${pColorsDefault[i].color}" , style: utils.boldLabelStyle(blackColor),))
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                  width: Get.width,
                                  height: 1,
                                  color: blackColor.withOpacity(0.3),
                                ),
                              ],
                            ),
                          ) : Container()
                      ],
                    );
                  },):
                  type == 4 ?GetBuilder<BrandController>(id: "0", builder: (brandController){
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 12,),
                        for(var i = 0 ; i < brandController.brands.length; i++)
                          brandController.brands[i].name.toLowerCase().contains(searchText.toLowerCase()) ?
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 16 , vertical: 5),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap :(){
                                    selectedBrand = brandController.brands[i];
                                    setState((){});
                                    setData();
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 20,
                                        height: 20,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(color: checkAdminController.system.mainColor , width: 2)
                                        ),
                                        child: Center(
                                          child: Container(
                                            width: 8,
                                            height: 8,
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: selectedBrand != null && selectedBrand!.code == brandController.brands[i].code.toString() ? checkAdminController.system.mainColor : Colors.transparent
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 12,),
                                      Expanded(child: Text("${brandController.brands[i].name}" , style: utils.boldLabelStyle(blackColor),))
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                  width: Get.width,
                                  height: 1,
                                  color: blackColor.withOpacity(0.3),
                                ),
                              ],
                            ),
                          ) : Container()
                      ],
                    );
                  },) :
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
              ))
            ],
          ),
        );
      }),
    );
  }

  showAddBrandDialog(BuildContext context){
    showCupertinoModalBottomSheet(
      enableDrag: true,
      expand: true,
      context: context,
      closeProgressThreshold: 100,
      backgroundColor: whiteColor,
      elevation: 0,
      builder: (context) => StatefulBuilder(builder: (BuildContext context , StateSetter setState){
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 5 , vertical: 12),
          width: double.infinity,
          decoration: BoxDecoration(
              color: whiteColor,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20))
          ),
          constraints: BoxConstraints(
              minWidth: Get.width,
              maxWidth: Get.width,
              minHeight: 0,
              maxHeight: Get.height * 0.5
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 12 , vertical: 5),
                      child: Icon(CupertinoIcons.arrow_left  ,color: blackColor, size: 24,),
                    ),
                  ),
                  SizedBox(width: 12,),
                  Text("Add Brand", style: utils.headingStyle(blackColor),)
                ],
              ),
              Expanded(child: AddBrandScreen(fromBottom: true,))
            ],
          ),
        );
      }),
    );
  }

  void setData() {
    setState(() {
    });
  }

  Future<String> uploadPic(file) async {
    var random = DateTime.now();
    //Create a reference to the location you want to upload to in firebase
    firebase_storage.Reference reference =
    storage.ref().child("images/$random.JPG");
    //Upload the file to firebase
    firebase_storage.UploadTask uploadTask = reference.putFile(file);
    var downUrl = await (await uploadTask).ref.getDownloadURL();

    return downUrl;
  }


  Future<String> uploadPicWeb(PlatformFile file) async {
    var random = DateTime.now();
    firebase_storage.Reference reference =
    storage.ref().child("images/$random.JPG");
    //Upload the file to firebase
    var downUrl = "";
    if (GetPlatform.isWeb) {
      Uint8List fileBytes = file.bytes!;
      firebase_storage.UploadTask uploadTask = reference.putData(fileBytes);
      downUrl = await (await uploadTask).ref.getDownloadURL();
    }else {
      firebase_storage.UploadTask uploadTask = reference.putFile(File(file.path!));
      downUrl = await (await uploadTask).ref.getDownloadURL();
    }
    return downUrl;
  }


  void addProduct() async {
    EasyLoading.show(status: "Saving product...");
    ItemController productController = Get.find();
    var productName = addProductModel.name;
    if(Get.arguments == null) {
      var code = productController.lastItem == null ? 1 : int.parse(
          productController.lastItem!.code) + 1;
      var child = code < 10 ? "0000000$code" : code < 100
          ? "000000$code"
          : code < 1000 ? "00000$code" : code < 10000 ? "0000$code" : code <
          100000 ? "000$code" : code < 1000000 ? "00$code" : code < 10000000
          ? "0$code"
          : "$code";

      addProductModel.code = child;
      addProductModel.sizes = pSizes;
      var parentId = child;

      FirebaseDatabase database = FirebaseDatabase(databaseURL: databaseUrl);
      
      if(!GetPlatform.isWeb) {
        database.setPersistenceEnabled(true);
        database.setPersistenceCacheSizeBytes(10000000);
      }
      DatabaseReference reference = database.reference();
      await reference.child(itemRef).child("$child").set(addProductModel.toJson());
      productController.lastItem = addProductModel;

      for(var i = 0 ; i < addProductModel.sizes.length; i++){
        addProductModel.name = productName+"-"+addProductModel.sizes[i].size;
        addProductModel.salesRate = double.parse(addProductModel.sizes[i].price);
        addProductModel.wholeSale = double.parse(addProductModel.sizes[i].wPrice);
        addProductModel.parentId = parentId;

        var code = productController.lastItem == null ? 1 : int.parse(
            productController.lastItem!.code) + 1;
        var child = code < 10 ? "0000000$code" : code < 100
            ? "000000$code"
            : code < 1000 ? "00000$code" : code < 10000 ? "0000$code" : code <
            100000 ? "000$code" : code < 1000000 ? "00$code" : code < 10000000
            ? "0$code"
            : "$code";

        addProductModel.code = child;

        FirebaseDatabase database = FirebaseDatabase(databaseURL: databaseUrl);

        if(!GetPlatform.isWeb) {
          database.setPersistenceEnabled(true);
          database.setPersistenceCacheSizeBytes(10000000);
        }
        DatabaseReference reference = database.reference();
        await reference.child(itemRef).child("$child").set(addProductModel.toJson());
        productController.lastItem = addProductModel;
      }
      Get.back();
      EasyLoading.dismiss();
      Get.snackbar("Success", "Product Saved");
    }
    else{
      addProductModel.sizes.addAll(pSizes);
      
      var parentId = addProductModel.parentId == null ? addProductModel.code : addProductModel.parentId;

      FirebaseDatabase database = FirebaseDatabase(databaseURL: databaseUrl);

      if(!GetPlatform.isWeb) {
        database.setPersistenceEnabled(true);
        database.setPersistenceCacheSizeBytes(10000000);
      }

      DatabaseReference reference = database.reference();
      await reference.child(itemRef).child("${addProductModel.code}").update(
          addProductModel.toJson());

      for(var i = 0 ; i < pSizes.length; i++){
        addProductModel.name = productName+"-"+pSizes[i].size;
        addProductModel.salesRate = double.parse(pSizes[i].price);
        addProductModel.wholeSale = double.parse(pSizes[i].wPrice);
        addProductModel.parentId = parentId;

        var code = productController.lastItem == null ? 1 : int.parse(
            productController.lastItem!.code) + 1;

        var child = code < 10 ? "0000000$code" : code < 100
            ? "000000$code"
            : code < 1000 ? "00000$code" : code < 10000 ? "0000$code" : code <
            100000 ? "000$code" : code < 1000000 ? "00$code" : code < 10000000
            ? "0$code"
            : "$code";

        addProductModel.code = child;

        FirebaseDatabase database = FirebaseDatabase(databaseURL: databaseUrl);

        if(!GetPlatform.isWeb) {
          database.setPersistenceEnabled(true);
          database.setPersistenceCacheSizeBytes(10000000);
        }
        DatabaseReference reference = database.reference();
        await reference.child(itemRef).child("$child").set(addProductModel.toJson());
        productController.lastItem = addProductModel;
      }

      Get.back();
      EasyLoading.dismiss();
      Get.snackbar("Success", "Product Saved");

    }
    EasyLoading.dismiss();
  }

}
