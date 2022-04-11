class CouponModel {
  String image = "";
  String name = "";
  String code = "";
  String description = "";
  String terms = "";
  int validFrom = 0;
  int validBefore = 0;
  int registerFrom = 0;
  int registerBefore = 0;
  int maxOrderPrice = 0;
  int createdAt = 0;
  int updatedAt = 0;
  String discountType = "%";
  int value = 0;
  String couponId = "";

  CouponModel(
      {required this.image,
        required this.name,
        required this.code,
        required this.description,
        required this.terms,
        required this.validFrom,
        required this.validBefore,
        required this.registerFrom,
        required this.registerBefore,
        required this.maxOrderPrice,
        required this.discountType,
        required this.createdAt,
        required this.updatedAt,
        required this.value,
        required this.couponId});

  CouponModel.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    name = json['name'];
    code = json['code'];
    description = json['description'];
    terms = json['terms'];
    validFrom = json['validFrom'];
    validBefore = json['validBefore'];
    registerFrom = json['registerFrom'];
    registerBefore = json['registerBefore'];
    maxOrderPrice = json['maxOrderPrice'];
    discountType = json['discountType'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    value = json['value'];
    couponId = json['couponId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = this.image;
    data['name'] = this.name;
    data['code'] = this.code;
    data['description'] = this.description;
    data['terms'] = this.terms;
    data['validFrom'] = this.validFrom;
    data['validBefore'] = this.validBefore;
    data['registerFrom'] = this.registerFrom;
    data['registerBefore'] = this.registerBefore;
    data['maxOrderPrice'] = this.maxOrderPrice;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['discountType'] = this.discountType;
    data['value'] = this.value;
    data['couponId'] = this.couponId;
    return data;
  }
}