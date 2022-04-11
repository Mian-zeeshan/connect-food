import 'package:get/get.dart';

class DrawerCustomController extends GetxController{
  String title = "home";
  int selectedTab = 0;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    title = "home";
    selectedTab = 0;
  }

  setDrawer(title,selectedTab){
    this.title = title;
    this.selectedTab = selectedTab;
    update(["0"]);
    notifyChildrens();
  }

}