import 'dart:io';

import 'package:connectsaleorder/AppConstants/Constants.dart';
import 'package:connectsaleorder/GetXController/BrandController.dart';
import 'package:connectsaleorder/GetXController/CheckAdminController.dart';
import 'package:connectsaleorder/Models/BrandModel.dart';

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

class AddBrandScreen extends StatefulWidget{
  bool fromBottom;
  AddBrandScreen({this.fromBottom = false});
  @override
  _AddBrandScreen createState() => _AddBrandScreen();

}

class _AddBrandScreen extends State<AddBrandScreen>{
  var utils = AppUtils();
  final cropKey = GlobalKey<CropState>();
  var searchController = TextEditingController();
  var nameController = TextEditingController();
  var nameTwoController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  File? _image;
  File? _simage;
  FirebaseStorage _storage = FirebaseStorage.instance;
  var selectedImage;
  BrandModel? selectedBrandModel = Get.arguments;
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
              aspectRatio: 1/1,
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



  Future<String> uploadPic(File file) async {
    var random = DateTime.now();
    print("NExt");
    //Create a reference to the location you want to upload to in firebase
    print("NExt");
    firebase_storage.Reference reference =
    _storage.ref().child("images/$random.JPG");
    print("NExt");
    //Upload the file to firebase
    var downUrl = "";
    print("NExt");
    if (GetPlatform.isWeb) {
      var rawBytes = file.readAsBytesSync();
      print("NExt");
      firebase_storage.UploadTask uploadTask = reference.putData(rawBytes);
      downUrl = await (await uploadTask).ref.getDownloadURL();
    }else {
      firebase_storage.UploadTask uploadTask = reference.putFile(file);
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
              if(!widget.fromBottom) Container(
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
                    Expanded(child: Text(selectedBrandModel == null ? "Add Brand" : "Update Brand" , style: utils.headingStyle(whiteColor),)),
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
                              child: _image == null ? selectedImage == null ? Icon(CupertinoIcons.add , color: whiteColor, size: 42,) : Image.network(selectedImage , fit: BoxFit.cover,): GetPlatform.isWeb ? Image.network(_image!.path):Image.file(_image! , fit: BoxFit.cover,),
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
                          Row(
                            children: [
                              Expanded(child: Container(
                                margin: EdgeInsets.only(left: 20 , right: selectedBrandModel == null ? 20 : 4),
                                child: utils.button(checkAdminController.system.mainColor, selectedBrandModel == null ? "Add" : "Update", whiteColor, checkAdminController.system.mainColor, 1.0, (){
                                  if(nameController.text.isEmpty){
                                    Get.snackbar("Error", "Name is required!");
                                    return;
                                  }else if(nameTwoController.text.isEmpty){
                                    Get.snackbar("Error", "Second Name is required!");
                                    return;
                                  }
                                  if(selectedBrandModel == null){
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
                                  if(selectedBrandModel == null)
                                    addBrand();
                                  else
                                    updateBrand();
                                }),
                              ),),
                              if(selectedBrandModel != null) Expanded(child: Container(
                                margin: EdgeInsets.only(left: 4 , right: 20),
                                child: utils.button(whiteColor, "Delete", checkAdminController.system.mainColor, checkAdminController.system.mainColor, 1.0, (){
                                    deleteBrand();
                                }),
                              ),),
                            ],
                          )
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


  void addBrand() async {
    BrandController brandController = Get.find();
    EasyLoading.show(status: "Loading...");
    if (_image != null) {
      selectedImage = await uploadPic(_image!);
    }
    var code = int.parse(brandController.brands.length > 0 ? brandController.brands[brandController.brands.length-1].code : "0")+1;
    var child = code < 10 ? "00$code" : code < 100 ? "0$code" : "$code";

    BrandModel brandModel = BrandModel(
        code: "$child",
        image: selectedImage,
        name: nameController.text.toString(),
        secondName: nameTwoController.text.toString(),isEnable: true);

    FirebaseDatabase database = FirebaseDatabase(databaseURL: databaseUrl);
    
    database.setPersistenceEnabled(true);
    database.setPersistenceCacheSizeBytes(10000000);
    DatabaseReference reference = database.reference();
    await reference.child(brandRef).child("$child").set(
        brandModel.toJson());
    EasyLoading.dismiss();
    Get.back();
    Get.snackbar("Success", "Brand Added!");
  }

  void updateBrand() async {
    BrandController brandController = Get.find();
    EasyLoading.show(status: "Loading...");
    if (_image != null) {
      selectedImage = await uploadPic(_image!);
    }

    BrandModel brandModel = BrandModel(
        code: "${selectedBrandModel!.code}",
        image: selectedImage,
        name: nameController.text.toString(),
        secondName: nameTwoController.text.toString(),isEnable: true);

    FirebaseDatabase database = FirebaseDatabase(databaseURL: databaseUrl);
    
    database.setPersistenceEnabled(true);
    database.setPersistenceCacheSizeBytes(10000000);
    DatabaseReference reference = database.reference();
    await reference.child(brandRef).child("${selectedBrandModel!.code}").set(
        brandModel.toJson());
    EasyLoading.dismiss();
    Get.back();
    Get.snackbar("Success", "Brand Updated!");
  }

  void deleteBrand() async {
    BrandController brandController = Get.find();
    EasyLoading.show(status: "Loading...");
    if (_image != null) {
      selectedImage = await uploadPic(_image!);
    }

    BrandModel brandModel = BrandModel(
        code: "${selectedBrandModel!.code}",
        image: selectedImage,
        name: nameController.text.toString(),
        secondName: nameTwoController.text.toString(),isEnable: false);

    FirebaseDatabase database = FirebaseDatabase(databaseURL: databaseUrl);

    database.setPersistenceEnabled(true);
    database.setPersistenceCacheSizeBytes(10000000);
    DatabaseReference reference = database.reference();
    await reference.child(brandRef).child("${selectedBrandModel!.code}").set(
        brandModel.toJson());
    EasyLoading.dismiss();
    Get.back();
    Get.snackbar("Success", "Brand deleted!");
  }

  void setData() {
    setState(() {
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(selectedBrandModel != null){
      nameController.text = selectedBrandModel!.name;
      nameTwoController.text = selectedBrandModel!.secondName != null ? selectedBrandModel!.secondName! : "";
      selectedImage = selectedBrandModel!.image;
    }
  }

}