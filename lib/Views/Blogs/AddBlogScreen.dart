import 'dart:io';

import 'package:connectsaleorder/Models/BlogModel.dart';
import 'package:connectsaleorder/Views/Product/EditorPage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_crop/image_crop.dart';
import 'package:image_picker/image_picker.dart';
import '../../AppConstants/Constants.dart';
import '../../GetXController/CheckAdminController.dart';
import '../../Utils/AppUtils.dart';
import 'package:html/parser.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;


class AddBlogScreen extends StatefulWidget{
  @override
  _AddBlogScreen createState() => _AddBlogScreen();

}

class _AddBlogScreen extends State<AddBlogScreen>{
  var utils = AppUtils();
  final cropKey = GlobalKey<CropState>();
  var titleController = TextEditingController();
  var bodyController = TextEditingController();
  CheckAdminController checkAdminController = Get.find();

  final ImagePicker _picker = ImagePicker();
  File? _simage;
  var selectedImage;
  File? _image;
  FirebaseStorage _storage = FirebaseStorage.instance;

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
              aspectRatio: 16/7,
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
        preferredHeight: 700
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
  void initState() {
    htmlString = "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CheckAdminController>(id: "0", builder: (checkAdminController){
      checkAdminController = checkAdminController;
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
            color: whiteColor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: Get.width,
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12),),
                      color: checkAdminController.system.mainColor
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(onPressed: (){
                        Get.back();
                      }, icon: Icon(CupertinoIcons.arrow_left, color: whiteColor,)),
                      Text("Add Blog", style: utils.headingStyle(whiteColor),)
                    ],
                  ),
                ),
                Expanded(child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 12,),
                      SizedBox(height: 12,),
                      GestureDetector(
                        onTap: (){
                          _getImage();
                        },
                        child: Container(
                          width: Get.width,
                          height: Get.width * 0.4,
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: checkAdminController.system.mainColor
                          ),
                          child: _image == null ? Icon(CupertinoIcons.add , color: whiteColor, size: 42,) : Image.file(_image! , fit: BoxFit.cover,),
                        ),
                      ),
                      SizedBox(height: 16,),
                      utils.textField(whiteColor, null, null, null, null, blackColor, "Title", blackColor.withOpacity(0.5), blackColor.withOpacity(0.5), 1.0, Get.width, false, titleController),
                      SizedBox(height: 12,),
                      utils.textField(whiteColor, null, null, null, null, blackColor, "Description", blackColor.withOpacity(0.5), blackColor.withOpacity(0.5), 1.0, Get.width, false, bodyController, multiline: true, onClick: () async {
                        await Get.to(()=> EditorPage());
                        bodyController.text = _parseHtmlString(htmlString);
                      }),
                      SizedBox(height: 12,),
                      utils.button(checkAdminController.system.mainColor, "Add", whiteColor, checkAdminController.system.mainColor, 1.0, (){
                        if(titleController.text.isEmpty){
                          Get.snackbar("Error", "Please add title first");
                          return;
                        }else if(titleController.text.length < 4){
                          Get.snackbar("Error", "Title is too short");
                          return;
                        }else if(bodyController.text.isEmpty){
                          Get.snackbar("Error", "Please add description first");
                          return;
                        }else if(bodyController.text.length < 10){
                          Get.snackbar("Error", "Description is too short must be at least 10 characters.");
                          return;
                        }
                        addBlog();
                      })
                    ],
                  ),
                ))
              ],
            ),
          ),
        ),
      );
    });
  }

  setData(){
    if(mounted){
      setState(() {
      });
    }
  }

  String _parseHtmlString(String htmlS) {
    final document = parse(htmlS);
    final String parsedString = parse(document.body!.text).documentElement!.text;
    return parsedString;
  }

  void addBlog() async {
    EasyLoading.show(status: "Loading...");
    if (_image != null) {
      selectedImage = await uploadPic(_image);
    }
    FirebaseDatabase database = FirebaseDatabase(databaseURL: databaseUrl);
    BlogModel blogModel = BlogModel(image:selectedImage??"", title: titleController.text.toString(), bid: "", body: htmlString, timestamp: DateTime.now().millisecondsSinceEpoch, active: true);
    if(!GetPlatform.isWeb) {
      database.setPersistenceEnabled(true);
      database.setPersistenceCacheSizeBytes(10000000);
    }
    DatabaseReference reference = database.reference();
    reference = reference
          .child(blogRef)
          .push();
    blogModel.bid = reference.key;
    await reference.set(blogModel.toJson());
    EasyLoading.dismiss();
    titleController.clear();
    bodyController.clear();
    _image == null;
    _simage == null;
    setData();
  }
}