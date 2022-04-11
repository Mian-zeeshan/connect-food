class RecentViewItemsModel {
  List<String> recentItems = [];

  RecentViewItemsModel({required this.recentItems});

  RecentViewItemsModel.fromJson(Map<String, dynamic> json) {
    recentItems = json['recentItems'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['recentItems'] = this.recentItems;
    return data;
  }
}

