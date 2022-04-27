import 'dart:io';

import 'package:connectsaleorder/AppConstants/Constants.dart';
import 'package:connectsaleorder/GetXController/BrandController.dart';
import 'package:connectsaleorder/GetXController/CategoryController.dart';
import 'package:connectsaleorder/GetXController/CheckAdminController.dart';
import 'package:connectsaleorder/Models/BannerModel.dart';
import 'package:connectsaleorder/Models/BrandModel.dart';
import 'package:connectsaleorder/Models/CategoryModel.dart';

import 'package:connectsaleorder/Utils/AppUtils.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_crop/image_crop.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class AddBannerScreen extends StatefulWidget{
  @override
  _AddBannerScreen createState() => _AddBannerScreen();

}

class _AddBannerScreen extends State<AddBannerScreen>{
  final cropKey = GlobalKey<CropState>();
  var utils = AppUtils();
  final ImagePicker _picker = ImagePicker();
  File? _simage;
  File? _image;
  FirebaseStorage _storage = FirebaseStorage.instance;
  var selectedImage;

  CategoryModel? selectedCategory;
  CheckAdminController checkAdminController = Get.find();

  Future _getImage() async {
    var image =
    await _picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    if(image != null) {
      setState(() {
        _simage = File(image.path);
      });
      showCropDialog();
    }
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
                    Expanded(child: Text("Add Banner" , style: utils.headingStyle(whiteColor),)),
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
                          SizedBox(height: 12,),
                          GestureDetector(
                            onTap: (){
                              _getImage();
                            },
                            child: Container(
                              width: Get.width * 0.9,
                              height: Get.width * 0.4,
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: checkAdminController.system.mainColor
                              ),
                              child: _image == null ? selectedImage == null ? Icon(CupertinoIcons.add , color: whiteColor, size: 42,) : Image.network(selectedImage , fit: BoxFit.cover,): Image.file(_image! , fit: BoxFit.cover,),
                            ),
                          ),
                          SizedBox(height: 16,),
                          GestureDetector(
                            onTap : (){
                              _presentBottomSheet();
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
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 20),
                            child: utils.button(checkAdminController.system.mainColor,"Add", whiteColor, checkAdminController.system.mainColor, 1.0, (){
                                  if(_image == null) {
                                    Get.snackbar("Error", "Image is required!");
                                    return;
                                  }else if(selectedCategory == null){
                                    Get.snackbar("Error", "Category is required!");
                                    return;
                                  }
                                addBanner();
                            }),
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

  showCropDialog() async {
    await Get.dialog(
        _buildCroppingImage(),
        barrierDismissible: false);
  }

  Widget _buildCroppingImage() {
    return Container(
      width: Get.width,
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: whiteColor
      ),
      child: Column(
        children: [
          Expanded(
            child: Crop.file(
              File(_simage!.path),
              key: cropKey,
              aspectRatio: 16/9,
              scale: 1,
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 20.0, bottom: 20),
            alignment: AlignmentDirectional.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(width: 20,),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: checkAdminController.system.mainColor
                    ),
                    child: TextButton(
                      child: Text(
                        'Crop Image',
                        style: utils.boldLabelStyle(whiteColor),
                      ),
                      onPressed: () => _cropImage(),
                    ),
                  ),
                ),
                SizedBox(width: 20,),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: checkAdminController.system.mainColor
                    ),
                    child: TextButton(
                      child: Text(
                        'Cancel',
                        style: utils.boldLabelStyle(whiteColor),
                      ),
                      onPressed: (){
                        _simage = null;
                        setState(() {
                        });
                        Get.back();
                      },
                    ),
                  ),
                ),
                SizedBox(width: 20,),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _cropImage() async {
    final scale = cropKey.currentState!.scale;
    final area = cropKey.currentState!.area;
    if (area == null) {
      // cannot crop, widget is not setup
      return;
    }

    // scale up to use maximum possible number of pixels
    // this will sample image in higher resolution to make cropped image larger
    final sample = await ImageCrop.sampleImage(
      file: File(_simage!.path),
      preferredWidth: 1600,
      preferredHeight: 900
    );

    final file = await ImageCrop.cropImage(
      file: sample,
      area: area,
    );

    sample.delete();

    _image = file;
    setState(() {
    });
    Get.back();
  }

  void addBanner() async {
    EasyLoading.show(status: "Loading...");
    if (_image != null) {
      selectedImage = await uploadPic(_image);
    }

    FirebaseDatabase database = FirebaseDatabase(databaseURL: databaseUrl);
    
    database.setPersistenceEnabled(true);
    database.setPersistenceCacheSizeBytes(10000000);
    DatabaseReference reference = database.reference();
    reference = reference.child(bannerRef).push();
    BannerModel bannerModel = BannerModel(image: selectedImage, key: reference.key,categoryId: selectedCategory!.code);
    await reference.set(
        bannerModel.toJson());
    EasyLoading.dismiss();
    Get.back();
    Get.snackbar("Success", "Banner Added!");
  }

  void setData() {
    setState(() {
    });
  }

  void _presentBottomSheet() {
    var searchController = TextEditingController();
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
                               "Select Category",
                          style: utils.boldLabelStyle(blackColor),
                        ),
                      ),
                      Positioned(top: 10 ,right : 10,child: GestureDetector(onTap : (){Navigator.pop(context);},child: Icon(CupertinoIcons.xmark_circle_fill , color: checkAdminController.system.mainColor, size: 24,))),
                    ],
                  ),
                ),
                Container(
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
                        child: GetBuilder<CategoryController>(id: "0",builder: (categoryController){
                          return Wrap(
                            children:[
                              for(var  i = 0; i < categoryController.categories.length; i++)
                                categoryController.categories[i].name.toLowerCase().contains(searchController.text.toLowerCase())?
                                utils.selectionItem(categoryController.categories[i].name,categoryController.categories[i].code, selectedCategory == null ? false : selectedCategory!.code == categoryController.categories[i].code, (){
                                  selectedCategory = categoryController.categories[i];
                                  Navigator.pop(context);
                                  setData();
                                }) : Container()
                            ],
                          );
                        })
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