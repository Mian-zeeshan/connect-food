import 'dart:convert';

import 'package:connectsaleorder/AppConstants/Constants.dart';
import 'package:connectsaleorder/Models/BrandModel.dart';
import 'package:connectsaleorder/Models/CurrencyModel.dart';
import 'package:connectsaleorder/Models/ItemModel.dart';
import 'package:connectsaleorder/Models/RecentViewItemsModel.dart';
import 'package:connectsaleorder/Models/ReviewModel.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ItemController extends GetxController{
  List<ItemModel> itemModels = [];
  List<ItemModel> itemModelsSearch = [];
  List<ItemModel> itemModelsSearchFilter = [];
  List<ItemModel> itemModelsFilter = [];
  List<ItemModel> itemModelsAll = [];
  List<ReviewModel> reviews = [];

  List<ItemModel> itemModelsNewArrival = [];
  List<ItemModel> itemModelsTopDeals = [];
  List<ItemModel> itemModelsRecentView = [];
  List<ItemModel> sizedProducts = [];
  var isLoadingSearch = false;
  RecentViewItemsModel recentViewItemsModel = RecentViewItemsModel(recentItems: []);

  ItemModel? lastItem;
  int itemsLength = 0;
  var isLoading = false;
  var box = GetStorage();
  var isList = true;
  BrandModel? brandModel;
  CurrencyModel currencyModel = CurrencyModel(countryCode: "PK", countryName: "Pakistan", currencyCode: "PKR", population: "184404791", capital: "Islamabad", continentName: "Asia");

  @override
  void onInit(){
    super.onInit();
    getNewArrivals();
    getTopDeals();
    getCurrency();
    getRecentItems();
    getAllProducts(1);
  }

  changeView(){
    isList = !isList;
    update(["0"]);
    notifyChildrens();
  }

  getNewArrivals(){
    FirebaseDatabase database = FirebaseDatabase(databaseURL: databaseUrl);
    
    if(!GetPlatform.isWeb) {
      database.setPersistenceEnabled(true);
      database.setPersistenceCacheSizeBytes(10000000);
    }
    DatabaseReference reference = database.reference();

    reference
        .child(itemRef)
        .orderByChild("isNewArrival")
        .equalTo(true)
        .onValue
        .listen((event) {
      itemModelsNewArrival = [];
      if (event.snapshot.exists) {
        event.snapshot.value.forEach((key,value) async {
          ItemModel itemModel = ItemModel.fromJson(
              jsonDecode(jsonEncode(value)));
          if(itemModel.parentId == null) {
            int stock = itemModel.totalStock;
            for (var item in itemModel.stock) {
              stock += item.stock.toInt();
            }
            itemModel.totalStock = stock;
            double discountedPrice = 0;
            double discountedPriceW = 0;
            if (itemModel.discountType == "%") {
              discountedPrice = itemModel.salesRate -
                  ((itemModel.salesRate * itemModel.discountVal!) / 100);
              discountedPriceW = (itemModel.wholeSale) -
                  (((itemModel.wholeSale) * itemModel.discountVal!) / 100);
            } else {
              discountedPrice = itemModel.salesRate - itemModel.discountVal!;
              discountedPriceW = (itemModel.wholeSale) - itemModel.discountVal!;
            }
            itemModel.discountedPrice = discountedPrice;
            itemModel.discountedPriceW = discountedPriceW;
            itemModelsNewArrival.add(itemModel);
          }
        });
      }

      update(["0"]);
      notifyChildrens();
    });
  }

  getAllProducts(page){
    var startAtCode = "";
    if(page > 1){
      if(itemModelsAll.length > 0) {
        startAtCode = itemModelsAll[itemModelsAll.length-1].code;
      }
    }
    FirebaseDatabase database = FirebaseDatabase(databaseURL: databaseUrl);
    if(!GetPlatform.isWeb) {
      database.setPersistenceEnabled(true);
      database.setPersistenceCacheSizeBytes(10000000);
    }
    DatabaseReference reference = database.reference();
    reference
        .child(itemRef)
        .orderByChild("Code")
        .startAt(startAtCode)
        .limitToFirst(page == 1 ? 10 : 11)
        .once().then((event) {
          if(page <= 1) {
            itemModelsAll = [];
          }
      if (event.exists) {
        event.value.forEach((key,value) async {
          ItemModel itemModel = ItemModel.fromJson(
              jsonDecode(jsonEncode(value)));
          if(itemModel.parentId == null) {
            if (itemModel.code != startAtCode) {
              int stock = itemModel.totalStock;
              for (var item in itemModel.stock) {
                stock += item.stock.toInt();
              }
              itemModel.totalStock = stock;
              double discountedPrice = 0;
              double discountedPriceW = 0;
              if (itemModel.discountType == "%") {
                discountedPrice = itemModel.salesRate -
                    ((itemModel.salesRate * itemModel.discountVal!) / 100);
                discountedPriceW = (itemModel.wholeSale) -
                    (((itemModel.wholeSale) * itemModel.discountVal!) / 100);
              } else {
                discountedPrice = itemModel.salesRate - itemModel.discountVal!;
                discountedPriceW =
                    (itemModel.wholeSale) - itemModel.discountVal!;
              }
              itemModel.discountedPrice = discountedPrice;
              itemModel.discountedPriceW = discountedPriceW;
              itemModelsAll.add(itemModel);
            }
          }
        });
      }

      update(["0"]);
      notifyChildrens();
    });
  }

  getSearchProducts(mounted){
    isLoadingSearch = true;
    if(mounted){
      update(["0"]);
      notifyChildrens();
    }
    FirebaseDatabase database = FirebaseDatabase(databaseURL: databaseUrl);
    
    if(!GetPlatform.isWeb) {
      database.setPersistenceEnabled(true);
      database.setPersistenceCacheSizeBytes(10000000);
    }
    DatabaseReference reference = database.reference();
    reference
        .child(itemRef)
        .onValue
        .listen((event) {
      itemModelsSearch = [];
      if (event.snapshot.exists) {
        event.snapshot.value.forEach((key,value) async {
          ItemModel itemModel = ItemModel.fromJson(
              jsonDecode(jsonEncode(value)));
          if(itemModel.parentId == null) {
            int stock = itemModel.totalStock;
            for (var item in itemModel.stock) {
              stock += item.stock.toInt();
            }
            itemModel.totalStock = stock;
            double discountedPrice = 0;
            double discountedPriceW = 0;
            if (itemModel.discountType == "%") {
              discountedPrice = itemModel.salesRate -
                  ((itemModel.salesRate * itemModel.discountVal!) / 100);
              discountedPriceW = (itemModel.wholeSale) -
                  (((itemModel.wholeSale) * itemModel.discountVal!) / 100);
            } else {
              discountedPrice = itemModel.salesRate - itemModel.discountVal!;
              discountedPriceW = (itemModel.wholeSale) - itemModel.discountVal!;
            }
            itemModel.discountedPrice = discountedPrice;
            itemModel.discountedPriceW = discountedPriceW;
            itemModelsSearch.add(itemModel);
          }
        });
      }
      isLoadingSearch = false;
      update(["0"]);
      notifyChildrens();
    });
  }

  searchProducts(searchText){
    itemModelsSearchFilter = [];
    for(var  p in itemModelsSearch){
      if(p.name.toLowerCase().contains(searchText.toString().toLowerCase())){
        itemModelsSearchFilter.add(p);
      }
    }
    update(["0"]);
    notifyChildrens();
  }

  void getTopDeals() {
    FirebaseDatabase database = FirebaseDatabase(databaseURL: databaseUrl);
    
    if(!GetPlatform.isWeb) {
      database.setPersistenceEnabled(true);
      database.setPersistenceCacheSizeBytes(10000000);
    }
    DatabaseReference reference = database.reference();

    reference
        .child(itemRef)
        .orderByChild("isTopDeal")
        .equalTo(true)
        .onValue
        .listen((event) {
      itemModelsTopDeals = [];

      if (event.snapshot.exists) {
        event.snapshot.value.forEach((key,value) {
          ItemModel itemModel = ItemModel.fromJson(
              jsonDecode(jsonEncode(value)));
          if(itemModel.parentId == null) {
            int stock = itemModel.totalStock;
            for (var item in itemModel.stock) {
              stock += item.stock.toInt();
            }
            itemModel.totalStock = stock;
            double discountedPrice = 0;
            double discountedPriceW = 0;
            if (itemModel.discountType == "%") {
              discountedPrice = itemModel.salesRate -
                  ((itemModel.salesRate * itemModel.discountVal!) / 100);
              discountedPriceW = (itemModel.wholeSale) -
                  (((itemModel.wholeSale) * itemModel.discountVal!) / 100);
            } else {
              discountedPrice = itemModel.salesRate - itemModel.discountVal!;
              discountedPriceW = (itemModel.wholeSale) - itemModel.discountVal!;
            }
            itemModel.discountedPrice = discountedPrice;
            itemModel.discountedPriceW = discountedPriceW;
            itemModelsTopDeals.add(itemModel);
          }
        });
      }

      update(["0"]);
      notifyChildrens();
    });
  }


  getItems(String cid , isPaging , {mounted = true}) {
    isLoading = true;
    getLastItems();
    if(mounted) {
      update(["0"]);
      notifyChildrens();
    }
    FirebaseDatabase database = FirebaseDatabase(databaseURL: databaseUrl);
    
    if(!GetPlatform.isWeb) {
      database.setPersistenceEnabled(true);
      database.setPersistenceCacheSizeBytes(10000000);
    }
    DatabaseReference reference = database.reference();
    if (isPaging) {
      itemsLength = itemsLength + 10 > itemModels.length ? itemModels.length : itemsLength + 10;
      isLoading = false;
      update(["0"]);
      notifyChildrens();
    } else {
      itemsLength = 0;
      reference
          .child(itemRef)
          .orderByChild("type")
          .equalTo(cid)
          .onValue
          .listen((event) {
        itemModels = [];
        if (event.snapshot.exists) {
            event.snapshot.value.forEach((key,value) {
              ItemModel itemModel = ItemModel.fromJson(
                  jsonDecode(jsonEncode(value)));
              if(itemModel.parentId == null) {
                int stock = itemModel.totalStock;
                for (var item in itemModel.stock) {
                  stock += item.stock.toInt();
                }
                itemModel.totalStock = stock;
                double discountedPrice = 0;
                double discountedPriceW = 0;
                if (itemModel.discountType == "%") {
                  discountedPrice = itemModel.salesRate -
                      ((itemModel.salesRate * itemModel.discountVal!) / 100);
                  discountedPriceW = (itemModel.wholeSale) -
                      (((itemModel.wholeSale) * itemModel.discountVal!) / 100);
                } else {
                  discountedPrice =
                      itemModel.salesRate - itemModel.discountVal!;
                  discountedPriceW =
                      (itemModel.wholeSale) - itemModel.discountVal!;
                }
                itemModel.discountedPrice = discountedPrice;
                itemModel.discountedPriceW = discountedPriceW;
                itemModels.add(itemModel);
              }
            });
        }
        itemModelsFilter = itemModels;
        itemsLength = itemsLength + 10 > itemModels.length ? itemModels.length : itemsLength + 10;
        if(brandModel != null)
          updateProducts(brandModel!);
        isLoading = false;
        update(["0"]);
        notifyChildrens();
      });
    }
  }

  getLastItems() {
    FirebaseDatabase database = FirebaseDatabase(databaseURL: databaseUrl);
    
    if(!GetPlatform.isWeb) {
      database.setPersistenceEnabled(true);
      database.setPersistenceCacheSizeBytes(10000000);
    }
    DatabaseReference reference = database.reference();
      reference
          .child(itemRef)
          .limitToLast(1)
          .onValue
          .listen((event) {
        lastItem = null;
        if (event.snapshot.exists) {
          try{
            event.snapshot.value.forEach((key,value) {
              lastItem = ItemModel.fromJson(
                  jsonDecode(jsonEncode(value)));
            });
          }catch(e){
            event.snapshot.value.forEach((value) {
              lastItem = ItemModel.fromJson(
                  jsonDecode(jsonEncode(value)));
            });
          }
        }

        print("LAST ITEM ${lastItem!.code}");
        update(["0"]);
        notifyChildrens();
      });
  }

  void updateProducts(BrandModel brand) {
    this.brandModel = brandModel;
    itemModels = [];
    for(var item in itemModelsFilter){
      if(item.brandCode != null && item.brandCode! == brand.code){
        itemModels.add(item);
      }
    }
    itemsLength = itemsLength + 5 > itemModels.length ? itemModels.length : itemsLength + 5;
    update(["0"]);
    notifyChildrens();
  }

  void clearFilter() {
    this.brandModel = null;
    itemModels = itemModelsFilter;
    update(["0"]);
    notifyChildrens();
  }

  void getCurrency() {
    FirebaseDatabase database = FirebaseDatabase(databaseURL: databaseUrl);
    
    if(!GetPlatform.isWeb) {
      database.setPersistenceEnabled(true);
      database.setPersistenceCacheSizeBytes(10000000);
    }
    DatabaseReference reference = database.reference();
    reference
        .child(currencyRef)
        .onValue
        .listen((event) {
      if (event.snapshot.exists) {
        currencyModel = CurrencyModel.fromJson(
                jsonDecode(jsonEncode(event.snapshot.value)));
      }
      update(["0"]);
      notifyChildrens();
    });
  }

  void getRecentItems() async {
    var value = await box.read(recentItems);
    itemModelsRecentView = [];
    if(value != null) {
      recentViewItemsModel = RecentViewItemsModel.fromJson(value);
      for(var item in recentViewItemsModel.recentItems){
        FirebaseDatabase database = FirebaseDatabase(databaseURL: databaseUrl);
        
        if(!GetPlatform.isWeb) {
          database.setPersistenceEnabled(true);
          database.setPersistenceCacheSizeBytes(10000000);
        }
        DatabaseReference reference = database.reference();
        reference
            .child(itemRef)
            .child(item)
            .onValue
            .listen((event) {
          if (event.snapshot.exists) {
            var modelItem = ItemModel.fromJson(
                jsonDecode(jsonEncode(event.snapshot.value)));
            if(modelItem.parentId == null) {
              print("RECENT REVIEW ${modelItem.toJson().toString()}");
              int stock = modelItem.totalStock;
              for (var item in modelItem.stock) {
                stock += item.stock.toInt();
              }
              modelItem.totalStock = stock;
              double discountedPrice = 0;
              double discountedPriceW = 0;
              if (modelItem.discountType == "%") {
                discountedPrice = modelItem.salesRate -
                    ((modelItem.salesRate * modelItem.discountVal!) / 100);
                discountedPriceW = (modelItem.wholeSale) -
                    (((modelItem.wholeSale) * modelItem.discountVal!) / 100);
              } else {
                discountedPrice = modelItem.salesRate - modelItem.discountVal!;
                discountedPriceW =
                    (modelItem.wholeSale) - modelItem.discountVal!;
              }
              modelItem.discountedPrice = discountedPrice;
              modelItem.discountedPriceW = discountedPriceW;
              for (var i = 0; i < itemModelsRecentView.length; i++) {
                if (modelItem.code == itemModelsRecentView[i].code) {
                  itemModelsRecentView.removeAt(i);
                  break;
                }
              }
              itemModelsRecentView.add(modelItem);
            }
          }
          update(["0"]);
          notifyChildrens();
        });
      }
    }
  }

  void getItemReviews(ItemModel itemModel) async {
    FirebaseDatabase database = FirebaseDatabase(databaseURL: databaseUrl);
    
    if(!GetPlatform.isWeb) {
      database.setPersistenceEnabled(true);
      database.setPersistenceCacheSizeBytes(10000000);
    }
    DatabaseReference reference = database.reference();
    reference
        .child(reviewRef)
        .child(itemModel.code)
        .limitToLast(100)
        .onValue
        .listen((event) {
      reviews = [];
      if (event.snapshot.exists) {
        event.snapshot.value.forEach((key,value) {
            var reviewModel = ReviewModel.fromJson(
                jsonDecode(jsonEncode(value)));
            reviews.add(reviewModel);
          });
      }
      update(["0"]);
      notifyChildrens();
    });
  }

  addRecentItems(ItemModel item) async {
    var isExist = false;
    for(var i in recentViewItemsModel.recentItems){
      if(item.code == i){
        isExist = true;
        break;
      }
    }
    if(!isExist) {
      if (recentViewItemsModel.recentItems.length > 9) {
        recentViewItemsModel.recentItems.removeAt(
            recentViewItemsModel.recentItems.length - 1);
        recentViewItemsModel.recentItems.insert(0,item.code);
      } else {
        recentViewItemsModel.recentItems.add(item.code);
      }
      await box.write(recentItems, recentViewItemsModel.toJson());
      itemModelsRecentView.insert(0, item);
    }
    update(["0"]);
    notifyChildrens();
  }

  void emptyProductsSearch() {
    itemModelsSearchFilter = [];
    update(["0"]);
    notifyChildrens();
  }

  getRelatedProducts(code) async {
    sizedProducts = [];
    FirebaseDatabase database = FirebaseDatabase(databaseURL: databaseUrl);

    if(!GetPlatform.isWeb) {
      database.setPersistenceEnabled(true);
      database.setPersistenceCacheSizeBytes(10000000);
    }
    DatabaseReference reference = database.reference();

    reference
        .child(itemRef)
        .orderByChild("parentId")
        .equalTo(code)
        .onValue.listen((event) {
      sizedProducts = [];
      if (event.snapshot.exists) {
        event.snapshot.value.forEach((key,value) {
          print(key);
          ItemModel itemModel = ItemModel.fromJson(
              jsonDecode(jsonEncode(value)));
          int stock = itemModel.totalStock;
          for (var item in itemModel.stock) {
            stock += item.stock.toInt();
          }
          itemModel.totalStock = stock;
          double discountedPrice = 0;
          double discountedPriceW = 0;
          if (itemModel.discountType == "%") {
            discountedPrice = itemModel.salesRate -
                ((itemModel.salesRate * itemModel.discountVal!) / 100);
            discountedPriceW = (itemModel.wholeSale) -
                (((itemModel.wholeSale) * itemModel.discountVal!) / 100);
          } else {
            discountedPrice = itemModel.salesRate - itemModel.discountVal!;
            discountedPriceW = (itemModel.wholeSale) - itemModel.discountVal!;
          }
          itemModel.discountedPrice = discountedPrice;
          itemModel.discountedPriceW = discountedPriceW;
          sizedProducts.add(itemModel);
        });
      }
      update(["0"]);
      notifyChildrens();
    });
  }
}