import 'dart:convert';

import 'package:connectsaleorder/AppConstants/Constants.dart';
import 'package:connectsaleorder/Models/FavoriteModel.dart';
import 'package:connectsaleorder/Models/FavoriteModelList.dart';
import 'package:connectsaleorder/Models/ItemModel.dart';
import 'package:connectsaleorder/Models/UserModel.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class FavoriteController extends GetxController{
  FavoriteModelList favoriteModelList = FavoriteModelList(favoriteModelList: []);
  FavoriteModel myFav = FavoriteModel(userId: "",products: []);
  late UserModel user;
  var box = GetStorage();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getUser();
  }

  void getUser() async {
    var value = await box.read(currentUser);
    if(value != null) {
      user = UserModel.fromJson(value);
      getFavModelList();
    }
  }

  void getFavModelList() async {
    var value = await box.read(allFavorites);
    print("FAVORITES :::: $value");
    if(value != null){
      favoriteModelList = FavoriteModelList.fromJson(value);
      for(var fav in favoriteModelList.favoriteModelList){
        if(fav.userId == user.uid){
          myFav = fav;
          break;
        }
      }
    }
    if(myFav.userId != ""){
      getLatestItems();
    }
    update(["0"]);
    notifyChildrens();
  }

  addToFav(ItemModel item)async{
    var isExist = false;
    for(var fav in myFav.products){
      if(fav.code == item.code){
        isExist = true;
        break;
      }
    }
    if(!isExist) {
      myFav.products.add(item);
      myFav.userId = user.uid;
      var isFind = -1;
      for (var i = 0; i < favoriteModelList.favoriteModelList.length; i++) {
        if (favoriteModelList.favoriteModelList[i].userId == user.uid) {
          isFind = i;
          break;
        }
      }
      if (isFind == -1) {
        favoriteModelList.favoriteModelList.add(myFav);
      } else {
        favoriteModelList.favoriteModelList.removeAt(isFind);
        favoriteModelList.favoriteModelList.add(myFav);
      }
      await box.write(allFavorites, favoriteModelList.toJson());
      Get.snackbar("Success", "Items Add to your favorite list!");
      update(["0"]);
      notifyChildrens();
    }
    else{
      Get.snackbar("Success", "Items Already in your favorite list!");
    }
  }

  removeFavorite(int position) async {
    myFav.products.removeAt(position);
    myFav.userId = user.uid;
    var isFind = -1;
    for(var i = 0; i < favoriteModelList.favoriteModelList.length; i++){
      if(favoriteModelList.favoriteModelList[i].userId == user.uid){
        isFind = i;
        break;
      }
    }
    if(isFind == -1){
      favoriteModelList.favoriteModelList.add(myFav);
    }else{
      favoriteModelList.favoriteModelList.removeAt(isFind);
      favoriteModelList.favoriteModelList.add(myFav);
    }
    await box.write(allFavorites,favoriteModelList.toJson());
    Get.snackbar("Success", "Items removed from your favorite list!");
    update(["0"]);
    notifyChildrens();
  }

  removeFavoriteWithCode(String code) async {
    for(var i = 0; i < myFav.products.length; i++){
      if(myFav.products[i].code == code){
        myFav.products.removeAt(i);
      }
    }
    myFav.userId = user.uid;
    var isFind = -1;
    for(var i = 0; i < favoriteModelList.favoriteModelList.length; i++){
      if(favoriteModelList.favoriteModelList[i].userId == user.uid){
        isFind = i;
        break;
      }
    }
    if(isFind == -1){
      favoriteModelList.favoriteModelList.add(myFav);
    }else{
      favoriteModelList.favoriteModelList.removeAt(isFind);
      favoriteModelList.favoriteModelList.add(myFav);
    }
    await box.write(allFavorites,favoriteModelList.toJson());
    Get.snackbar("Success", "Items removed from your favorite list!");
    update(["0"]);
    notifyChildrens();
  }

  void getLatestItems() {
    FirebaseDatabase database = FirebaseDatabase(databaseURL: databaseUrl);
    
    if(!GetPlatform.isWeb) {
      database.setPersistenceEnabled(true);
      database.setPersistenceCacheSizeBytes(10000000);
    }
    DatabaseReference reference = database.reference();

    for(var i = 0; i < myFav.products.length; i++){
      reference
          .child(itemRef)
          .orderByChild("Code")
          .equalTo(myFav.products[i].code)
          .onValue.listen((event) {
        if (event.snapshot.exists) {
          event.snapshot.value.forEach((key, value) {
            ItemModel itemModel = ItemModel.fromJson(
                jsonDecode(jsonEncode(value)));
            int stock = 0;
            for(var item in itemModel.stock){
              stock += item.stock.toInt();
            }
            itemModel.totalStock = stock;
            double discountedPrice = 0;
            double discountedPriceW = 0;
            if(itemModel.discountType == "%"){
              discountedPrice = itemModel.salesRate - ((itemModel.salesRate * itemModel.discountVal!)/100);
              discountedPriceW = (itemModel.wholeSale) - (((itemModel.wholeSale) * itemModel.discountVal!)/100);
            }else{
              discountedPrice = itemModel.salesRate - itemModel.discountVal!;
              discountedPriceW = (itemModel.wholeSale) - itemModel.discountVal!;
            }
            itemModel.discountedPrice = discountedPrice;
            itemModel.discountedPriceW = discountedPriceW;
            myFav.products[i] = itemModel;
          });
        }
        update(["0"]);
        notifyChildrens();
      });
    }
  }

  bool checkFavorite(ItemModel itemModel) {
    var isExist = false;
    for(var p in myFav.products){
      if(p.code == itemModel.code){
        isExist = true;
        break;
      }
    }
    return isExist;
  }
}