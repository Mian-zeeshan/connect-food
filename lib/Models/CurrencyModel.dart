class CurrencyModel {
  String countryCode = "";
  String countryName = "";
  String currencyCode = "";
  String population = "";
  String capital = "";
  String continentName = "";

  CurrencyModel(
      {required this.countryCode,
      required this.countryName,
      required this.currencyCode,
      required this.population,
      required this.capital,
      required this.continentName});

  CurrencyModel.fromJson(Map<String, dynamic> json) {
    countryCode = json['countryCode'];
    countryName = json['countryName'];
    currencyCode = json['currencyCode'];
    population = json['population'];
    capital = json['capital'];
    continentName = json['continentName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['countryCode'] = this.countryCode;
    data['countryName'] = this.countryName;
    data['currencyCode'] = this.currencyCode;
    data['population'] = this.population;
    data['capital'] = this.capital;
    data['continentName'] = this.continentName;
    return data;
  }
}
