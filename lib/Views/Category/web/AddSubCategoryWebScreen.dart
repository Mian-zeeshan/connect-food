import 'dart:io';
import 'dart:typed_data';

import 'package:connectsaleorder/AppConstants/Constants.dart';
import 'package:connectsaleorder/GetXController/CategoryController.dart';
import 'package:connectsaleorder/GetXController/CheckAdminController.dart';
import 'package:connectsaleorder/GetXController/SubCategoryController.dart';
import 'package:connectsaleorder/Models/CategoryModel.dart';
import 'package:connectsaleorder/Models/SubCategoryModel.dart';
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

class AddSubCategoryWebScreen extends StatefulWidget{
  @override
  _AddSubCategoryWebScreen createState() => _AddSubCategoryWebScreen();

}

class _AddSubCategoryWebScreen extends State<AddSubCategoryWebScreen>{
  var utils = AppUtils();
  var searchController = TextEditingController();
  var nameController = TextEditingController();
  var nameTwoController = TextEditingController();
  FirebaseStorage _storage = FirebaseStorage.instance;
  PlatformFile? _image;
  var selectedImage;
  CheckAdminController checkAdminController = Get.find();

  SubCategoryModel? subCategoryModel = Get.arguments;

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
                    Expanded(child: Text(subCategoryModel == null ? "Add Subcategory" : "Update Subcategory" , style: utils.headingStyle(whiteColor),)),
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
                              width: Get.width * 0.4,
                              height: Get.width * 0.4,
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: checkAdminController.system.mainColor
                              ),
                              child: _image == null ? selectedImage == null ? Icon(CupertinoIcons.add , color: whiteColor, size: 42,) : Image.network(selectedImage , fit: BoxFit.cover,): GetPlatform.isWeb ? Image.memory(_image!.bytes!):Image.file(File(_image!.path!) , fit: BoxFit.cover,),
                            ),
                          ),
                          SizedBox(height: 16,),
                          Container(
                            child: utils.textField(whiteColor, CupertinoIcons.tag, checkAdminController.system.mainColor, null, null, blackColor, "Name", blackColor.withOpacity(0.4), checkAdminController.system.mainColor, 1.0, Get.width-40, false, nameController),
                          ),
                          SizedBox(height: 10,),
                          Container(
                            child: utils.textField(whiteColor, CupertinoIcons.tag, checkAdminController.system.mainColor, null, null, blackColor, "Second Name", blackColor.withOpacity(0.4), checkAdminController.system.mainColor, 1.0, Get.width-40, false, nameTwoController),
                          ),
                          SizedBox(height: 20,),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 20),
                            child: utils.button(checkAdminController.system.mainColor, subCategoryModel == null ? "Add" : "Update", whiteColor, checkAdminController.system.mainColor, 1.0, (){
                              if(nameController.text.isEmpty){
                                Get.snackbar("Error", "Name is required!");
                                return;
                              }else if(nameTwoController.text.isEmpty){
                                Get.snackbar("Error", "Second Name is required!");
                                return;
                              }
                              if(subCategoryModel == null){
                                if(_image == null) {
                                  Get.snackbar("Error", "Image is required!");
                                  return;
                                }
                              }else{
                                if(selectedImage == null) {
                                  if(_image == null) {
                                    Get.snackbar("Error", "Image is required!");
                                    return;
                                  }
                                }
                              }
                              if(subCategoryModel == null)
                                addCategory();
                              else
                                updateCategory();
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


  void addCategory() async {
    CategoryController categoryController = Get.find();
    SubCategoryController subCategoryController = Get.find();
    EasyLoading.show(status: "Loading...");
    if (_image != null) {
      selectedImage = await uploadPic(_image!);
    }

    var code = int.parse(subCategoryController.subCategoriesAll.length > 0 ? subCategoryController.subCategoriesAll[subCategoryController.subCategoriesAll.length-1].code : "0")+1;
    var child = code < 10 ? "0000$code" : code < 100 ? "000$code" :code < 1000 ? "00$code" : code < 10000 ? "0$code": "$code";

    SubCategoryModel categoryModel = SubCategoryModel(
        type: categoryController.categories[categoryController.selectedCategory].code,
        code: "$child",
        image: selectedImage,
        name: nameController.text.toString(),
        secondName: nameTwoController.text.toString());

    print(categoryModel.toJson());
    print("${subCategoryController.subCategories.length}");

    FirebaseDatabase database = FirebaseDatabase(databaseURL: databaseUrl);
    database = FirebaseDatabase.instance;
    database.setPersistenceEnabled(true);
    database.setPersistenceCacheSizeBytes(10000000);
    DatabaseReference reference = database.reference();
    reference.child(subCategoryRef).child("$child").set(
        categoryModel.toJson());
    EasyLoading.dismiss();
    Get.back();
    Get.snackbar("Success", "Subcategory Added!");
  }

  void updateCategory() async {
    CategoryController categoryController = Get.find();
    EasyLoading.show(status: "Loading...");
    if (_image != null) {
      selectedImage = await uploadPic(_image!);
    }

    SubCategoryModel categoryModel = SubCategoryModel(
        type: categoryController.categories[categoryController.selectedCategory].code,
        code: "${subCategoryModel!.code}",
        image: selectedImage,
        name: nameController.text.toString(),
        secondName: nameTwoController.text.toString());

    FirebaseDatabase database = FirebaseDatabase(databaseURL: databaseUrl);
    database = FirebaseDatabase.instance;
    database.setPersistenceEnabled(true);
    database.setPersistenceCacheSizeBytes(10000000);
    DatabaseReference reference = database.reference();
    reference.child(subCategoryRef).child("${subCategoryModel!.code}").set(
        categoryModel.toJson());
    EasyLoading.dismiss();
    Get.back();
    Get.snackbar("Success", "Subcategory Updated!");
  }

  void setData() {
    setState(() {
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(subCategoryModel != null){
      nameController.text = subCategoryModel!.name;
      nameTwoController.text = subCategoryModel!.secondName != null ? subCategoryModel!.secondName! : "";
      selectedImage = subCategoryModel!.image;
    }
  }

}