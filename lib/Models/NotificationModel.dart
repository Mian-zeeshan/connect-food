class NotificationModel {
  String title = "";
  String nid = "";
  String body = "";
  int timestamp = DateTime.now().millisecondsSinceEpoch;
  bool isRead = true;
  String uid = "";

  NotificationModel(
      {required this.title, required this.nid, required this.body, required this.timestamp, required this.isRead, required this.uid});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    nid = json['nid'];
    body = json['body'];
    timestamp = json['timestamp'];
    isRead = json['isRead'];
    uid = json['uid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['nid'] = this.nid;
    data['body'] = this.body;
    data['timestamp'] = this.timestamp;
    data['isRead'] = this.isRead;
    data['uid'] = this.uid;
    return data;
  }
}
