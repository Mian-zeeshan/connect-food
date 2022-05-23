import 'dart:io';

import 'package:connectsaleorder/AppConstants/Constants.dart';
import 'package:connectsaleorder/GetXController/BrandController.dart';
import 'package:connectsaleorder/GetXController/CheckAdminController.dart';
import 'package:connectsaleorder/Models/BrandModel.dart';
import 'package:connectsaleorder/Models/ItemModel.dart';

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

class AddAddonScreen extends StatefulWidget{
  bool fromBottom;
  AddAddonScreen({this.fromBottom = false});
  @override
  _AddAddonScreen createState() => _AddAddonScreen();

}

class _AddAddonScreen extends State<AddAddonScreen>{
  var utils = AppUtils();
  final cropKey = GlobalKey<CropState>();
  final ImagePicker _picker = ImagePicker();
  var aNameController = TextEditingController();
  var aPriceController = TextEditingController();
  File? _simage;
  File? addonImage;
  FirebaseStorage _storage = FirebaseStorage.instance;
  var selectedImage;
  ProductAdons? selectedAddon = Get.arguments;
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

    addonImage = file;
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
                    Expanded(child: Text(selectedAddon == null ? "Add Addon" : "Update Addon" , style: utils.headingStyle(whiteColor),)),
                  ],
                ),
              ),
              Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      width: Get.width,
                      padding: !widget.fromBottom ? EdgeInsets.symmetric(horizontal: 16) : null,
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
                              child: addonImage == null ? selectedImage == null ? Icon(CupertinoIcons.add , color: whiteColor, size: 42,) : Image.network(selectedImage , fit: BoxFit.cover,): GetPlatform.isWeb ? Image.network(addonImage!.path):Image.file(addonImage! , fit: BoxFit.cover,),
                            ),
                          ),
                          SizedBox(height: 16,),
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

                            var addon = ProductAdons(adonDescription: aNameController.text.toString(), adonPrice: aPriceController.text.toString(), key: selectedAddon == null ? '' : selectedAddon!.key);

                            aNameController.clear();
                            aPriceController.clear();
                            if(selectedAddon == null) {
                              addAddon(addon);
                            }else{
                              updateAddon(addon);
                            }

                          }),
                          SizedBox(height: 12,),
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


  void addAddon(ProductAdons adon) async {
    EasyLoading.show(status: "Loading...");
    if (addonImage != null) {
      selectedImage = await uploadPic(addonImage!);
    }

    adon.image = selectedImage;

    FirebaseDatabase database = FirebaseDatabase(databaseURL: databaseUrl);

    database.setPersistenceEnabled(true);
    database.setPersistenceCacheSizeBytes(10000000);
    DatabaseReference reference = database.reference();
    reference = reference.child(addonRef).push();
    adon.key = reference.key;
    await reference.set(adon.toJson());
    EasyLoading.dismiss();
    Get.back();
    Get.snackbar("Success", "Addon added!");
  }

  void updateAddon(ProductAdons adon) async {
    EasyLoading.show(status: "Loading...");

    if (addonImage != null) {
      selectedImage = await uploadPic(addonImage!);
    }

    adon.image = selectedImage;

    FirebaseDatabase database = FirebaseDatabase(databaseURL: databaseUrl);

    database.setPersistenceEnabled(true);
    database.setPersistenceCacheSizeBytes(10000000);
    DatabaseReference reference = database.reference();
    await reference.child(addonRef).child("${selectedAddon!.key}").update(
        adon.toJson());
    EasyLoading.dismiss();
    Get.back();
    Get.snackbar("Success", "Addon updated!");
  }

 /* void deleteAddon() async {
    EasyLoading.show(status: "Loading...");
    if (addonImage != null) {
      selectedImage = await uploadPic(addonImage!);
    }

    BrandModel brandModel = BrandModel(
        code: "${selectedAddon!.code}",
        image: selectedImage,
        name: nameController.text.toString(),
        secondName: nameTwoController.text.toString(),isEnable: false);

    FirebaseDatabase database = FirebaseDatabase(databaseURL: databaseUrl);

    database.setPersistenceEnabled(true);
    database.setPersistenceCacheSizeBytes(10000000);
    DatabaseReference reference = database.reference();
    await reference.child(brandRef).child("${selectedAddon!.code}").set(
        brandModel.toJson());
    EasyLoading.dismiss();
    Get.back();
    Get.snackbar("Success", "Brand deleted!");
  }*/

  void setData() {
    setState(() {
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(selectedAddon != null){
      aNameController.text = selectedAddon!.adonDescription;
      aPriceController.text = selectedAddon!.adonPrice;
      selectedImage = selectedAddon!.image;
    }
  }

}