import 'dart:convert';

import 'package:connectsaleorder/AppConstants/Constants.dart';
import 'package:connectsaleorder/GetXController/UserController.dart';
import 'package:connectsaleorder/Models/CartModel.dart';
import 'package:connectsaleorder/Models/CartModelList.dart';
import 'package:connectsaleorder/Models/CustomerModel.dart';
import 'package:connectsaleorder/Models/ItemModel.dart';
import 'package:connectsaleorder/Models/UserModel.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class CartController extends GetxController{
  CartModelList cartModelList = CartModelList(cartModelList: []);
  CartModel myCart = CartModel(userId: "", totalBill: 0, status: 0, totalItems: 0, products: [], createdAt: 0);
  List<CartModel> myAllCart = [];
  UserController userController = Get.find();
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
      getCartModelList();
    }
  }

  void getCartModelList() async {
    getAllCartModelList();
    var value = await box.read(allCarts);
    if(value != null){
      cartModelList = CartModelList.fromJson(value);
      for(var cart in cartModelList.cartModelList){
        if(cart.userId == user.uid){
          if(!cart.isDraft) {
            myCart = cart;
            break;
          }
        }
      }
    }
    /*if(myCart.userId != ""){
      getLatestItems();
    }*/
    update(["0"]);
    notifyChildrens();
  }

  void getCartModelListFromId(cartId) async {
    var value = await box.read(allCarts);
    if(value != null){
      cartModelList = CartModelList.fromJson(value);
      for(var cart in cartModelList.cartModelList){
        if(cart.userId == user.uid){
          if(cart.cartId == cartId) {
            myCart = cart;
            break;
          }
        }
      }
    }
    if(myCart.userId != ""){
      getLatestItems();
    }
    update(["0"]);
    notifyChildrens();
  }

  void getAllCartModelList() async {
    var value = await box.read(allCarts);
    myAllCart = [];
    if(value != null){
      cartModelList = CartModelList.fromJson(value);
      for(var cart in cartModelList.cartModelList){
        if(cart.userId == user.uid){
          if(cart.isDraft)
            myAllCart.add(cart);
        }
      }
    }
    print("MY CART LENGTH :::: ${myAllCart.length}");
    for(var car in myAllCart){
      print(car.toJson().toString());
      print("NEXT");
    }
    update(["0"]);
    notifyChildrens();
  }

  addToDraft(CustomerModel customer) async {
    if(myCart.products.length > 0) {
      myCart.isDraft = true;
      myCart.customer = customer;
      var isFind = -1;
      for(var i = 0; i < cartModelList.cartModelList.length; i++){
        if(cartModelList.cartModelList[i].cartId == myCart.cartId){
          isFind = i;
          break;
        }
      }
      if(isFind == -1){
        //cartModelList.cartModelList.add(myCart);
      }else{
        cartModelList.cartModelList.removeAt(isFind);
        cartModelList.cartModelList.add(myCart);
      }
      await box.write(allCarts, cartModelList.toJson());
      myCart = CartModel(userId: "",
          totalBill: 0,
          totalItems: 0,
          status: 0,
          products: [],
          createdAt: 0);
      getAllCartModelList();
      update(["0"]);
      notifyChildrens();
    }
  }

  addToCart(ItemModel item)async{
    myCart.products.add(item);
    myCart.userId = user.uid;
    myCart.createdAt = DateTime.now().millisecondsSinceEpoch;
    var isFind = -1;
    for(var i = 0; i < cartModelList.cartModelList.length; i++){
      if(cartModelList.cartModelList[i].cartId == myCart.cartId){
        isFind = i;
        break;
      }
    }
    if(isFind == -1){
      myCart.cartId = "${DateTime.now().millisecondsSinceEpoch}";
      cartModelList.cartModelList.add(myCart);
    }else{
      cartModelList.cartModelList.removeAt(isFind);
      cartModelList.cartModelList.add(myCart);
    }
    await box.write(allCarts,cartModelList.toJson());
    updateBill();
  }

  updateBill() async {
    var  isRetailer = userController.user != null ? userController.user!.isRetailer? userController.user!.retailerModel!.approved ? true : false :false : false;
    myCart.totalBill = 0;
    myCart.discountedBill = 0;
    myCart.totalItems = 0;
    for(var item in myCart.products) {
      var addonPrices = 0;
      for(var a in item.selectedAddons){
        addonPrices = addonPrices + (int.parse(a.adonPrice) * a.quantity);
      }
      myCart.totalBill = myCart.totalBill + ((isRetailer ? item.salesRate : item.wholeSale) * item.selectedQuantity) + addonPrices;
      myCart.discountedBill = myCart.discountedBill + ((isRetailer ? item.discountedPriceW??0 : item.discountedPrice??0) * item.selectedQuantity) + addonPrices;
      myCart.totalItems = myCart.totalItems + item.selectedQuantity;
    }
    update(["0"]);
    notifyChildrens();
  }

  void updateQuantity(int i, String quantity) async {
    myCart.createdAt = DateTime.now().millisecondsSinceEpoch;
    myCart.products[i].selectedQuantity = int.parse(quantity);

    for(var i = 0; i < cartModelList.cartModelList.length; i++){
      if(cartModelList.cartModelList[i].cartId == myCart.cartId){
        cartModelList.cartModelList.removeAt(i);
        cartModelList.cartModelList.add(myCart);
        break;
      }
    }
    await box.write(allCarts,cartModelList.toJson());
    updateBill();
  }

  void getLatestItems() {
    FirebaseDatabase database = FirebaseDatabase(databaseURL: databaseUrl);
    
    if(!GetPlatform.isWeb) {
      database.setPersistenceEnabled(true);
      database.setPersistenceCacheSizeBytes(10000000);
    }
    DatabaseReference reference = database.reference();

    for(var i = 0; i < myCart.products.length; i++){
      reference
          .child(itemRef)
          .orderByChild("Code")
          .equalTo(myCart.products[i].code)
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
            itemModel.selectedQuantity = myCart.products[i].selectedQuantity;
            myCart.products[i] = itemModel;
          });
        }
        update(["0"]);
        notifyChildrens();
      });
    }
  }

  setDiscount(int discount)async{
    myCart.discount = discount;
    myCart.discountedBill = myCart.totalBill - myCart.discount;
    var isFind = -1;
    for(var i = 0; i < cartModelList.cartModelList.length; i++){
      if(cartModelList.cartModelList[i].cartId == myCart.cartId){
        isFind = i;
        break;
      }
    }
    if(isFind == -1){
      //cartModelList.cartModelList.add(myCart);
    }else{
      cartModelList.cartModelList.removeAt(isFind);
      cartModelList.cartModelList.add(myCart);
    }
    await box.write(allCarts,cartModelList.toJson());
    update(["0"]);
    notifyChildrens();
  }

  void deleteItem(int i) async {
    myCart.products[i].selectedQuantity = 1;
    myCart.products.removeAt(i);
    var isFind = -1;
    for(var i = 0; i < cartModelList.cartModelList.length; i++){
      if(cartModelList.cartModelList[i].cartId == myCart.cartId){
        isFind = i;
        break;
      }
    }
    if(isFind == -1){
      //cartModelList.cartModelList.add(myCart);
    }else{
      cartModelList.cartModelList.removeAt(isFind);
      cartModelList.cartModelList.add(myCart);
    }
    await box.write(allCarts,cartModelList.toJson());
    update(["0"]);
    notifyChildrens();
    updateBill();
  }

  void retriveOrder(CartModel cart) async {
    print("Running");
    var isExist = false;
    for(var i = 0; i < cartModelList.cartModelList.length; i++){
      if(cartModelList.cartModelList[i].cartId == cart.cartId){
        cartModelList.cartModelList.removeAt(i);
        cart.isDraft = false;
        cart.isSync = false;
        cartModelList.cartModelList.add(cart);
        print("Running Exist");
        print(cartModelList.cartModelList[i].toJson().toString());
        await box.write(allCarts,cartModelList.toJson());
        getCartModelList();
        isExist = true;
        break;
      }
    }
    print("Running");
    if(!isExist){
      print("Running Not Exist");
      for(var i = 0; i < cartModelList.cartModelList.length; i++) {
        if (cartModelList.cartModelList[i].cartId == myCart.cartId) {
          cartModelList.cartModelList.removeAt(i);
          await box.write(allCarts, cartModelList.toJson());
          print("Running remove");
          isExist = false;
          break;
        }
      }
      print("Running adding");
      cart.createdAt = DateTime.now().millisecondsSinceEpoch;
      cart.cartId = "${DateTime.now().millisecondsSinceEpoch}";
      cart.isDraft = false;
      myCart = cart;
      cartModelList.cartModelList.add(myCart);
      await box.write(allCarts,cartModelList.toJson());
      getCartModelList();
      update(["0"]);
      notifyChildrens();
      updateBill();
    }
  }

  void emptyCart() async {
    for(var i = 0; i < cartModelList.cartModelList.length; i++) {
      if (cartModelList.cartModelList[i].cartId == myCart.cartId) {
        for(var j = 0 ; j < cartModelList.cartModelList[i].products.length; j++){
          cartModelList.cartModelList[i].products[j].selectedQuantity = 1;
        }
        cartModelList.cartModelList.removeAt(i);
        await box.write(allCarts, cartModelList.toJson());
        break;
      }
    }
    myCart = CartModel(userId: "", status: 0, totalBill: 0, totalItems: 0, products: [], createdAt: 0);
    update(["0"]);
    notifyChildrens();
    updateBill();
  }

  void updateDiscount(position,int discount, type) async {
    myCart.totalBill = myCart.totalBill - myCart.products[position].discountedPrice!;
    myCart.products[position].discountedPrice = myCart.products[position].salesRate - discount;
    myCart.products[position].discountType = type;
    myCart.products[position].discountVal = discount.toDouble();
    myCart.totalBill = myCart.totalBill + myCart.products[position].discountedPrice!;
    myCart.discountedBill = myCart.totalBill - myCart.discount;
    print(myCart.products[position].toJson().toString());
    var isFind = -1;
    for(var i = 0; i < cartModelList.cartModelList.length; i++){
      if(cartModelList.cartModelList[i].cartId == myCart.cartId){
        isFind = i;
        break;
      }
    }
    if(isFind == -1){
      //cartModelList.cartModelList.add(myCart);
    }else{
      cartModelList.cartModelList.removeAt(isFind);
      cartModelList.cartModelList.add(myCart);
    }
    await box.write(allCarts,cartModelList.toJson());
    update(["0"]);
    notifyChildrens();
  }

  Map<String,dynamic> checkInCart(ItemModel itemModel) {
    var isExist = false;
    var position = 0;
    ItemModel? cItem;
    for(var cartItem in myCart.products){
      if(cartItem.code == itemModel.code){
        isExist = true;
        cItem = cartItem;
        break;
      }
      position++;
    }
    var data = {
      "inCart" : isExist,
      "position" : position,
      "cartItem" : cItem
    };
    return data;
  }

  void updateAddons(i, j, quantity) async {
    myCart.createdAt = DateTime.now().millisecondsSinceEpoch;
    myCart.products[i].selectedAddons[j].quantity = quantity;

    if(quantity == 0){
      myCart.products[i].selectedAddons.removeAt(j);
    }

    for(var i = 0; i < cartModelList.cartModelList.length; i++){
      if(cartModelList.cartModelList[i].cartId == myCart.cartId){
        cartModelList.cartModelList.removeAt(i);
        cartModelList.cartModelList.add(myCart);
        break;
      }
    }
    await box.write(allCarts,cartModelList.toJson());
    updateBill();
  }
}