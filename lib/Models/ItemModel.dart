class ItemModel {
  String code = "";
  String name = "";
  String type = "";
  String style = "";
  double salesRate = 0;
  String mUnit = "";
  String? description = "";
  String? shortDescription = "";
  List<String> images = [];
  String? color;
  String? sSize;
  String? oldCode;
  double purchaseRate = 0;
  String? discountType;
  double? discountVal;
  bool? disCont;
  double? gSTTax;
  String? brandCode;
  String? ingredients;
  String? brandName;
  String? typeName;
  String? styleName;
  double? sMRate;
  double wholeSale = 0;
  double? groupFix;
  double? companyFix;
  double? lockRate;
  double? commission;
  int totalStock = 0;
  double? discountedPrice = 0;
  double? discountedPriceW = 0;
  int selectedQuantity = 1;
  List<Stock> stock = [];
  List<Specs> specs = [];
  List<PColors> colors = [];
  List<PSizes> sizes = [];
  List<ProductAdons> addons = [];
  PColors? selectedColors;
  PSizes? selectedSizes;
  List<ProductAdons> selectedAddons = [];
  bool isNewArrival = false;
  bool isTopDeal = false;
  double rating = 0;
  bool isFav = false;
  double deliveryPrice = 0;
  int deliveryApplyItem = 0;
  int freeDeliveryItems = -1;
  int minDeliveryTime = 0;
  int maxDeliveryTime = 0;

  ItemModel(
      {required this.code,
        required this.name,
        required this.type,
        required this.salesRate,
        required this.style,
        required this.mUnit,
        this.color,
        this.sSize,
        this.oldCode,
        required this.images,
        required this.purchaseRate,
        this.discountType,
        this.discountVal,
        this.disCont,
        this.gSTTax,
        this.brandCode,
        this.brandName,
        this.typeName,
        this.styleName,
        this.sMRate,
        this.wholeSale = 0,
        this.groupFix,
        this.companyFix,
        this.lockRate,
        this.commission,
        required this.deliveryPrice,
        required this.deliveryApplyItem,
        required this.freeDeliveryItems,
        required this.minDeliveryTime,
        required this.maxDeliveryTime,
        required this.stock});

  ItemModel.fromJson(Map<String, dynamic> json) {
    code = json['Code'];
    name = json['name'];
    type = json['type'];
    style = json['style'];
    if(json['images'] != null){
      images = json['images'].cast<String>();
    }
    if(json['deliveryPrice'] != null){
      deliveryPrice = json['deliveryPrice'].toDouble();
    }

    if(json['deliveryApplyItem'] != null){
      deliveryApplyItem = json['deliveryApplyItem'];
    }

    if(json['freeDeliveryItems'] != null){
      freeDeliveryItems = json['freeDeliveryItems'];
    }

    if(json['minDeliveryTime'] != null){
      minDeliveryTime = json['minDeliveryTime'];
    }


    if(json['maxDeliveryTime'] != null){
      maxDeliveryTime = json['maxDeliveryTime'];
    }

    if(json['rating'] != null){
      rating = json['rating'].toDouble();
    }

    if(json['ingredients'] != null){
      ingredients = json['ingredients'];
    }

    if(json['shortDescription'] != null){
      shortDescription = json['shortDescription'];
    }

    salesRate = double.parse(json['sales_rate'].toString());
    mUnit = json['m_unit'];
    color = json['color'];
    sSize = json['s_size'];
    oldCode = json['old_code'];
    purchaseRate = double.parse(json['purchase_rate'].toString());
    discountType = json['discount_type'];
    if(json['discount_val'] != null)
    discountVal = double.parse(json['discount_val'].toString());
    disCont = json['dis_cont'];
    if(json['GST_Tax'] != null)
      gSTTax = double.parse(json['GST_Tax'].toString());
    brandCode = json['BrandCode'];
    brandName = json['BrandName'];
    typeName = json['TypeName'];
    styleName = json['StyleName'];
    description = json['description'];
    selectedSizes = json['selectedSizes'];
    selectedColors = json['selectedColors'];
    if(json['discountedPrice'] != null)
      discountedPrice = double.parse(json['discountedPrice'].toString());

    if(json['discountedPriceW'] != null)
      discountedPriceW = double.parse(json['discountedPriceW'].toString());

    selectedQuantity = 1;
    if(json['quantity'] != null){
      selectedQuantity = json['quantity'];
    }
    if(json['totalStock'] != null){
      totalStock = json['totalStock'];
    }
    if(json['isNewArrival'] != null){
      isNewArrival = json['isNewArrival'];
    }
    if(json['isTopDeal'] != null){
      isTopDeal = json['isTopDeal'];
    }
    if(json['SMRate'] != null)
      sMRate = double.parse(json['SMRate'].toString());
    if(json['WholeSale'] != null)
      wholeSale = double.parse(json['WholeSale'].toString());
    if(json['GroupFix'] != null)
      groupFix = double.parse(json['GroupFix'].toString());
    if(json['CompanyFix'] != null)
      companyFix = double.parse(json['CompanyFix'].toString());
    if(json['LockRate'] != null)
      lockRate = double.parse(json['LockRate'].toString());
    if(json['Commission'] != null)
      commission = double.parse(json['Commission'].toString());

    if(json['isNewArrival'] != null)
      isNewArrival = json['isNewArrival'];

    if(json['isTopDeal'] != null)
      isTopDeal = json['isTopDeal'];

    if (json['Stock'] != null) {
      stock = [];
      json['Stock'].forEach((v) {
        stock.add(new Stock.fromJson(v));
      });
    }

    if (json['specs'] != null) {
      specs = [];
      json['specs'].forEach((v) {
        specs.add(new Specs.fromJson(v));
      });
    }

    if (json['colors'] != null) {
      colors = [];
      json['colors'].forEach((v) {
        colors.add(new PColors.fromJson(v));
      });
    }

    if (json['sizes'] != null) {
      sizes = [];
      json['sizes'].forEach((v) {
        sizes.add(new PSizes.fromJson(v));
      });
    }

    if (json['addons'] != null) {
      addons = [];
      json['addons'].forEach((v) {
        addons.add(new ProductAdons.fromJson(v));
      });
    }

    if (json['selectedAddons'] != null) {
      selectedAddons = [];
      json['selectedAddons'].forEach((v) {
        selectedAddons.add(new ProductAdons.fromJson(v));
      });
    }

    double discountedP = 0;
    double discountedPW = 0;
    if(disCont! && discountType == "%"){
      discountedP = salesRate - ((salesRate * discountVal!)/100);
      discountedPW = (wholeSale) - (((wholeSale) * discountVal!)/100);
    }else{
      discountedP = salesRate - discountVal!;
      discountedPW = (wholeSale) - discountVal!;
    }
    discountedPrice = discountedP;
    discountedPriceW = discountedPW;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Code'] = this.code;
    data['name'] = this.name;
    data['type'] = this.type;
    data['shortDescription'] = this.shortDescription;
    data['ingredients'] = this.ingredients;
    data['images'] = this.images;
    data['style'] = this.style;
    data['rating'] = this.rating;
    data['sales_rate'] = this.salesRate;
    data['description'] = this.description;
    data['m_unit'] = this.mUnit;
    data['color'] = this.color;
    data['s_size'] = this.sSize;
    data['old_code'] = this.oldCode;
    data['purchase_rate'] = this.purchaseRate;
    data['discount_type'] = this.discountType;
    data['discount_val'] = this.discountVal;
    data['dis_cont'] = this.disCont;
    data['GST_Tax'] = this.gSTTax;
    data['BrandCode'] = this.brandCode;
    data['BrandName'] = this.brandName;
    data['TypeName'] = this.typeName;
    data['StyleName'] = this.styleName;
    data['discountedPrice'] = this.discountedPrice;
    data['discountedPrice'] = this.discountedPriceW;
    data['SMRate'] = this.sMRate;
    data['WholeSale'] = this.wholeSale;
    data['GroupFix'] = this.groupFix;
    data['CompanyFix'] = this.companyFix;
    data['LockRate'] = this.lockRate;
    data['Commission'] = this.commission;
    data['quantity'] = this.selectedQuantity;
    data['isTopDeal'] = this.isTopDeal;
    data['isNewArrival'] = this.isNewArrival;
    data['totalStock'] = this.totalStock;
    data['selectedColors'] = this.selectedColors;
    data['selectedSizes'] = this.selectedSizes;
    data['Stock'] = this.stock.map((v) => v.toJson()).toList();
    data['specs'] = this.specs.map((v) => v.toJson()).toList();
    data['colors'] = this.colors.map((v) => v.toJson()).toList();
    data['sizes'] = this.sizes.map((v) => v.toJson()).toList();
    data['addons'] = this.addons.map((v) => v.toJson()).toList();
    data['selectedAddons'] = this.selectedAddons.map((v) => v.toJson()).toList();
    data['deliveryPrice'] = this.deliveryPrice;
    data['deliveryApplyItem'] = this.deliveryApplyItem;
    data['freeDeliveryItems'] = this.freeDeliveryItems;
    data['minDeliveryTime'] = this.minDeliveryTime;
    data['maxDeliveryTime'] = this.maxDeliveryTime;

    return data;
  }
}

class Stock {
  String? location;
  String? locationName;
  String? itemCode;
  double stock = 0;
  String? fyear;

  Stock(
      {this.location,
        this.locationName,
        this.itemCode,
        required this.stock,
        this.fyear});

  Stock.fromJson(Map<String, dynamic> json) {
    location = json['Location'];
    locationName = json['LocationName'];
    itemCode = json['ItemCode'];
    stock = double.parse(json['Stock'].toString());
    fyear = json['Fyear'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Location'] = this.location;
    data['LocationName'] = this.locationName;
    data['ItemCode'] = this.itemCode;
    data['Stock'] = this.stock;
    data['Fyear'] = this.fyear;
    return data;
  }
}



class Specs {
  String specTitle = "";
  String specDescription = "";

  Specs({required this.specTitle, required this.specDescription});

  Specs.fromJson(Map<String, dynamic> json) {
    specTitle = json['spec_title'];
    specDescription = json['spec_description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['spec_title'] = this.specTitle;
    data['spec_description'] = this.specDescription;
    return data;
  }
}


class PSizes {
  String size = "";
  String sizeId = "";

  PSizes({required this.size, required this.sizeId});

  PSizes.fromJson(Map<String, dynamic> json) {
    size = json['size'];
    sizeId = json['size_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['size'] = this.size;
    data['size_id'] = this.sizeId;
    return data;
  }
}


class PColors {
  String color = "";
  String colorId = "";

  PColors({required this.color, required this.colorId});

  PColors.fromJson(Map<String, dynamic> json) {
    color = json['color'];
    colorId = json['color_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['color'] = this.color;
    data['color_id'] = this.colorId;
    return data;
  }
}

class ProductAdons {
  String adonDescription =  "";
  String adonPrice = "";
  int quantity = 1;

  ProductAdons({required this.adonDescription, required this.adonPrice});

  ProductAdons.fromJson(Map<String, dynamic> json) {
    adonDescription = json['adon_description'];
    adonPrice = json['adon_price'];
    if(json["quantity"] != null)
      quantity = json['quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['adon_description'] = this.adonDescription;
    data['adon_price'] = this.adonPrice;
    data['quantity'] = this.quantity;
    return data;
  }
}
