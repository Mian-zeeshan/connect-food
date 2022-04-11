class CountriesModel {
  int id = 0;
  String name = "";
  String iso3 = "";
  String iso2 = "";
  String numericCode = "";
  String phoneCode = "";
  String capital = "";
  String currency = "";
  String currencyName = "";
  String currencySymbol = "";
  String? tld = "";
  String? native = "";
  String region = "";
  String subregion = "";
  List<Timezones> timezones = [];
  String latitude = "";
  String longitude = "";
  String emoji = "";
  String emojiU = "";
  List<States> states = [];

  CountriesModel(
      {required this.id,
        required this.name,
        required this.iso3,
        required this.iso2,
        required this.numericCode,
        required this.phoneCode,
        required this.currency,
        required this.capital,
        required this.currencyName,
        required this.currencySymbol,
        required this.tld,
        required this.native,
        required this.region,
        required this.subregion,
        required this.timezones,
        required this.latitude,
        required this.longitude,
        required this.emoji,
        required this.emojiU,
        required this.states});

  CountriesModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    iso3 = json['iso3'];
    iso2 = json['iso2'];
    numericCode = json['numeric_code'];
    phoneCode = json['phone_code'];
    capital = json['capital'];
    currency = json['currency'];
    currencyName = json['currency_name'];
    currencySymbol = json['currency_symbol'];
    tld = json['tld'];
    native = json['native'];
    region = json['region'];
    subregion = json['subregion'];
    if (json['timezones'] != null) {
      timezones = <Timezones>[];
      json['timezones'].forEach((v) {
        timezones.add(new Timezones.fromJson(v));
      });
    }
    latitude = json['latitude'];
    longitude = json['longitude'];
    emoji = json['emoji'];
    emojiU = json['emojiU'];
    if (json['states'] != null) {
      states = <States>[];
      json['states'].forEach((v) {
        states.add(new States.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['iso3'] = this.iso3;
    data['iso2'] = this.iso2;
    data['numeric_code'] = this.numericCode;
    data['phone_code'] = this.phoneCode;
    data['capital'] = this.capital;
    data['currency'] = this.currency;
    data['currency_name'] = this.currencyName;
    data['currency_symbol'] = this.currencySymbol;
    data['tld'] = this.tld;
    data['native'] = this.native;
    data['region'] = this.region;
    data['subregion'] = this.subregion;
    data['timezones'] = this.timezones.map((v) => v.toJson()).toList();
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['emoji'] = this.emoji;
    data['emojiU'] = this.emojiU;
    data['states'] = this.states.map((v) => v.toJson()).toList();
    return data;
  }
}

class Timezones {
  String zoneName = "";
  int gmtOffset = 0;
  String gmtOffsetName = "";
  String abbreviation = "";
  String tzName = "";

  Timezones(
      {required this.zoneName,
        required this.gmtOffset,
        required this.gmtOffsetName,
        required this.abbreviation,
        required this.tzName});

  Timezones.fromJson(Map<String, dynamic> json) {
    zoneName = json['zoneName'];
    gmtOffset = json['gmtOffset'];
    gmtOffsetName = json['gmtOffsetName'];
    abbreviation = json['abbreviation'];
    tzName = json['tzName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['zoneName'] = this.zoneName;
    data['gmtOffset'] = this.gmtOffset;
    data['gmtOffsetName'] = this.gmtOffsetName;
    data['abbreviation'] = this.abbreviation;
    data['tzName'] = this.tzName;
    return data;
  }
}

class States {
  int id = 0;
  String name = "";
  String stateCode = "";
  String? latitude = "";
  String? longitude = "";
  List<Cities> cities = [];

  States(
      {required this.id,
        required this.name,
        required this.stateCode,
        required this.latitude,
        required this.longitude,
        required this.cities});

  States.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    stateCode = json['state_code'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    if (json['cities'] != null) {
      cities = <Cities>[];
      json['cities'].forEach((v) {
        cities.add(new Cities.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['state_code'] = this.stateCode;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    if (this.cities != null) {
      data['cities'] = this.cities.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Cities {
  int id = 0;
  String name = "";
  String latitude = "";
  String longitude = "";
  List<AreaModel> areas = [];

  Cities({required this.id, required this.name, required this.latitude, required this.longitude});

  Cities.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    if (json['areas'] != null) {
      areas = [];
      json['areas'].forEach((v) {
        areas.add(new AreaModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['areas'] = this.areas.map((v) => v.toJson()).toList();
    return data;
  }
}

class AreaModel{
  String id = "";
  String name = "";

  AreaModel({required this.id, required this.name});

  AreaModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}