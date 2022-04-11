import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ImageGalleryScreen  extends StatefulWidget{
  @override
 _ImageGalleryScreen createState() => _ImageGalleryScreen();

}

class _ImageGalleryScreen  extends State<ImageGalleryScreen>{

  List<String> listOfUrls = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
        height: Get.height,
        child: Center(

        )
    );
  }

}