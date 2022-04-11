import 'dart:io';
import 'dart:typed_data';

import 'package:connectsaleorder/AppConstants/Constants.dart';
import 'package:connectsaleorder/GetXController/CategoryController.dart';
import 'package:connectsaleorder/GetXController/CheckAdminController.dart';
import 'package:connectsaleorder/Models/BannerModel.dart';
import 'package:connectsaleorder/Models/CategoryModel.dart';

import 'package:connectsaleorder/Utils/AppUtils.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class AddBannerWebScreen extends StatefulWidget{
  @override
  _AddBannerWebScreen createState() => _AddBannerWebScreen();
}

class _AddBannerWebScreen extends State<AddBannerWebScreen>{
  var utils = AppUtils();
  PlatformFile? _image;
  FirebaseStorage _storage = FirebaseStorage.instance;
  var selectedImage;

  CategoryModel? selectedCategory;
  CheckAdminController checkAdminController = Get.find();

  Future _getImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.image , allowMultiple: false);
    if (result != null) {
      _image = result.files.single;
      setData();
    } else {
      // User canceled the picker
    }
  }


  Future<String> uploadPic(PlatformFile file) async {
    var random = DateTime.now();
    firebase_storage.Reference reference =
    _storage.ref().child("images/$random.JPG");
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
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      width: Get.width,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: 12,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: (){
                                  _getImage();
                                },
                                child: Container(
                                  width: Get.width * 0.2,
                                  height: Get.width * 0.2,
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: checkAdminController.system.mainColor
                                  ),
                                  child: _image == null ? selectedImage == null ? Icon(CupertinoIcons.add , color: whiteColor, size: 42,) : Image.network(selectedImage , fit: BoxFit.cover,): GetPlatform.isWeb ? Image.memory(_image!.bytes!):Image.file(File(_image!.path!) , fit: BoxFit.cover,),
                                ),
                              ),
                              SizedBox(width: 12,),
                              Expanded(child: Column(
                                children: [
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
                              ))
                            ],
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


  void addBanner() async {
    EasyLoading.show(status: "Loading...");
    if (_image != null) {
      selectedImage = await uploadPic(_image!);
    }

    FirebaseDatabase database = FirebaseDatabase(databaseURL: databaseUrl);
    database = FirebaseDatabase.instance;
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